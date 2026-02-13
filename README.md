# 💰 가계부 웹앱 v2 (JSP + Spring MVC + MyBatis + MySQL)

---

## ✅ v2에서 수정된 핵심 사항

### 문제: `javax.el.ELException: Unable to convert ... to java.util.Date`

| 항목 | v1 (오류) | v2 (수정) |
|------|-----------|-----------|
| 날짜 타입 | `java.time.LocalDate` | **`java.util.Date`** |
| MyBatis jdbcType | 미지정 | `jdbcType="DATE"` 명시 |
| 컨트롤러 바인딩 | `@ModelAttribute` (LocalDate) | `@RequestParam @DateTimeFormat(pattern="yyyy-MM-dd")` |
| 수정 폼 날짜 값 | EL 직접 출력 → 오류 | `SimpleDateFormat`으로 `String`(txDateStr) 변환 후 전달 |
| 테이블명 | `transaction` (MySQL 예약어 주의) | `transaction_history` 로 변경 |
| 금액 타입 | `BigDecimal` | `Long` (BIGINT 직접 매핑, 간결) |

---

## 📁 프로젝트 구조

```
household-budget/
├── pom.xml
├── sql/schema.sql
└── src/main/
    ├── java/com/budget/
    │   ├── controller/
    │   │   ├── DashboardController.java    ← 대시보드 + 차트 JSON API
    │   │   └── TransactionController.java  ← CRUD (@DateTimeFormat 바인딩)
    │   ├── service/
    │   │   └── TransactionService.java
    │   ├── dao/
    │   │   ├── TransactionDao.java         ← MyBatis Mapper 인터페이스
    │   │   └── CategoryDao.java
    │   └── model/
    │       ├── Transaction.java            ← Date txDate (java.util.Date)
    │       ├── Category.java
    │       ├── MonthlySummary.java
    │       └── SearchCondition.java
    ├── resources/
    │   ├── mybatis-config.xml
    │   └── mapper/
    │       ├── TransactionMapper.xml       ← jdbcType="DATE" 명시
    │       └── CategoryMapper.xml
    └── webapp/
        ├── WEB-INF/
        │   ├── web.xml
        │   ├── spring/
        │   │   ├── root-context.xml        ← HikariCP + MyBatis 설정
        │   │   ├── servlet-context.xml
        │   │   └── db.properties           ← ★ DB 접속 정보 수정 필요
        │   └── views/
        │       ├── layout/
        │       │   ├── header.jsp
        │       │   └── footer.jsp          ← 모바일 탭바
        │       ├── dashboard/index.jsp     ← fmt:formatDate 정상 사용
        │       └── transaction/
        │           ├── list.jsp
        │           └── form.jsp            ← txDateStr(String) value 사용
        ├── css/main.css
        ├── js/main.js
        └── index.jsp
```

---

## ⚙️ 설치 및 실행

### 1. DB 생성
```sql
-- MySQL 실행
source /경로/sql/schema.sql
```

### 2. DB 접속 정보 수정
`src/main/webapp/WEB-INF/spring/db.properties`
```properties
db.url=jdbc:mysql://localhost:3306/household_budget?useSSL=false&serverTimezone=Asia/Seoul&characterEncoding=UTF-8
db.username=root
db.password=★여기에_비밀번호★
```

### 3. STS에서 실행
1. `File → Import → Existing Maven Projects`
2. 프로젝트 우클릭 → `Run As → Run on Server`
3. Tomcat 9 선택
4. `http://localhost:8080/household-budget/`

---

## 🛠️ 기술 스택

| 영역 | 기술 |
|------|------|
| Backend | Spring MVC 5.3 |
| ORM | **MyBatis 3.5** + mybatis-spring 2.1 |
| DB | MySQL 8.0 |
| Pool | HikariCP 5.0 |
| View | JSP 2.3 + JSTL 1.2 |
| Frontend | Bootstrap 5.3 + Bootstrap Icons + Chart.js 4.4 |

---

## 📱 화면 구성

| URL | 화면 |
|-----|------|
| `/dashboard` | 월별 요약 카드 + 도넛/바 차트 + 최근 거래 |
| `/transaction/list` | 목록 조회 (검색/필터/페이징) |
| `/transaction/form` | 거래 등록 |
| `/transaction/form/{id}` | 거래 수정 |

---

## 🔑 ELException 해결 핵심 코드

### `Transaction.java`
```java
// ★ LocalDate 아닌 java.util.Date
private Date txDate;   // java.util.Date
```

### `TransactionMapper.xml`
```xml
<!-- jdbcType="DATE" 로 명시 -->
<result property="txDate" column="tx_date"
        javaType="java.util.Date" jdbcType="DATE"/>
```

### `TransactionController.java`
```java
// @DateTimeFormat 으로 "yyyy-MM-dd" 문자열 → Date 자동 변환
@RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") Date txDate
```

### `form.jsp` (수정 모드)
```java
// 컨트롤러에서 미리 String으로 변환하여 전달
model.addAttribute("txDateStr",
    new SimpleDateFormat("yyyy-MM-dd").format(tx.getTxDate()));
```
```jsp
<%-- input value에는 String(txDateStr) 사용 --%>
<input type="date" name="txDate" value="${txDateStr}">
```

### `list.jsp` / `dashboard/index.jsp`
```jsp
<%-- fmt:formatDate 는 java.util.Date 완전 호환 --%>
<fmt:formatDate value="${item.txDate}" pattern="yyyy.MM.dd"/>
```
