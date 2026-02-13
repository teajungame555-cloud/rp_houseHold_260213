package com.budget.model;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import lombok.Builder;

import java.util.Date;   // ★ LocalDate 대신 java.util.Date 사용 → fmt:formatDate 호환

/**
 * 거래 내역 Model
 *
 * ※ EL 엔진(javax.el)과 JSTL fmt:formatDate 는 java.util.Date 를 기준으로 동작합니다.
 *   LocalDate 를 사용하면 javax.el.ELException 이 발생하므로
 *   모든 날짜 필드를 java.util.Date 로 선언합니다.
 *   MyBatis 는 DATE 컬럼 → java.util.Date(java.sql.Date) 로 자동 매핑합니다.
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Transaction {

    private Integer txId;
    private Integer categoryId;
    private String  title;
    private Long    amount;         // BIGINT → long/Long
    private String  txType;         // "I":수입, "E":지출
    private Date    txDate;         // DATE 컬럼 → java.util.Date (JSTL 호환)
    private String  memo;
    private Date    createdAt;      // DATETIME → java.util.Date
    private Date    updatedAt;      // DATETIME → java.util.Date

    // ── JOIN 필드 (category 테이블) ──────────────────
    private String categoryName;
    private String icon;
    private String color;

    // ── 편의 메서드 ──────────────────────────────────

    /** 수입/지출 한글 라벨 */
    public String getTypeLabel() {
        return "I".equals(txType) ? "수입" : "지출";
    }

    /** Bootstrap 뱃지 클래스 */
    public String getTypeBadgeClass() {
        return "I".equals(txType) ? "badge bg-success" : "badge bg-danger";
    }

    /** 금액 콤마 포맷 (View 에서 사용) */
    public String getAmountFormatted() {
        return amount != null ? String.format("%,d", amount) : "0";
    }
}
