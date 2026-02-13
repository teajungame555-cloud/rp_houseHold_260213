<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
    String isEdit = "edit".equals(request.getAttribute("mode")) ? "true" : "false";
    request.setAttribute("pageTitle",   "edit".equals(request.getAttribute("mode")) ? "거래수정" : "거래추가");
    request.setAttribute("currentMenu", "form");
%>
<jsp:include page="/WEB-INF/views/layout/header.jsp"/>

<div class="container py-4 page-bottom-pad" style="max-width:600px;">

    <!-- ── 페이지 헤더 ── -->
    <div class="d-flex align-items-center gap-2 mb-4">
        <a href="${pageContext.request.contextPath}/transaction/list"
           class="btn btn-outline-secondary btn-sm">
            <i class="bi bi-arrow-left"></i>
        </a>
        <h5 class="fw-bold mb-0">
            <c:choose>
                <c:when test="${mode=='edit'}">
                    <i class="bi bi-pencil-square me-2 text-primary"></i>거래 수정
                </c:when>
                <c:otherwise>
                    <i class="bi bi-plus-circle me-2 text-primary"></i>새 거래 추가
                </c:otherwise>
            </c:choose>
        </h5>
    </div>

    <!-- ── 수입/지출 토글 ── -->
    <div class="mb-4">
        <div class="type-toggle d-flex rounded-3 overflow-hidden border bg-light">
            <input type="radio" class="btn-check" id="typeI" name="typeToggle" value="I"
                   ${tx.txType!='E'?'checked':''}>
            <label class="type-label flex-fill text-center py-3 fw-semibold" for="typeI">
                <i class="bi bi-arrow-up-circle me-1"></i>수입
            </label>
            <input type="radio" class="btn-check" id="typeE" name="typeToggle" value="E"
                   ${'E'==tx.txType?'checked':''}>
            <label class="type-label type-label--e flex-fill text-center py-3 fw-semibold" for="typeE">
                <i class="bi bi-arrow-down-circle me-1"></i>지출
            </label>
        </div>
    </div>

    <!-- ── 폼 ── -->
    <div class="card border-0 shadow-sm">
        <div class="card-body p-4">
            <%--
                ★ txDate 는 java.util.Date 타입이므로
                  컨트롤러에서 "yyyy-MM-dd" 문자열(txDateStr)로 미리 변환하여 전달합니다.
                  Spring @DateTimeFormat(pattern="yyyy-MM-dd") 으로 다시 Date로 바인딩됩니다.
            --%>
<!--             <form id="txForm" -->
<%--                   action="${pageContext.request.contextPath}/transaction/form${mode=='edit'?'/'+tx.txId:''}" --%>
<!--                   method="post" -->
<!--                   novalidate> -->
				<c:choose>
				    <c:when test="${mode eq 'edit'}">
				        <form id="txForm"
				              action="${pageContext.request.contextPath}/transaction/form/${tx.txId}"
				              method="post"
				              novalidate>
				    </c:when>
				    <c:otherwise>
				        <form id="txForm"
				              action="${pageContext.request.contextPath}/transaction/form"
				              method="post"
				              novalidate>
				    </c:otherwise>
				</c:choose>
				

                <!-- 숨김: 거래유형 -->
                <input type="hidden" name="txType"  id="txType"
                       value="${empty tx.txType ? 'I' : tx.txType}">

                <!-- 금액 -->
                <div class="mb-4">
                    <label class="form-label fw-semibold" for="amount">
                        금액 <span class="text-danger">*</span>
                    </label>
                    <div class="input-group input-group-lg">
                        <span class="input-group-text fw-bold bg-white">₩</span>
                        <input type="text"
                               class="form-control form-control-lg text-end fw-bold"
                               id="amount"
                               name="amount"
                               placeholder="0"
                               value="${tx.amount!=null?tx.amount:''}"
                               autocomplete="off"
                               required>
                    </div>
                    <div class="invalid-feedback">금액을 입력해주세요.</div>
                </div>

                <!-- 제목 -->
                <div class="mb-3">
                    <label class="form-label fw-semibold" for="title">
                        제목 <span class="text-danger">*</span>
                    </label>
                    <input type="text" class="form-control" id="title" name="title"
                           placeholder="예: 마트 장보기"
                           value="${tx.title}" maxlength="100" required>
                    <div class="invalid-feedback">제목을 입력해주세요.</div>
                </div>

                <!-- 카테고리 칩 -->
                <div class="mb-3">
                    <label class="form-label fw-semibold">
                        카테고리 <span class="text-danger">*</span>
                    </label>
                    <input type="hidden" name="categoryId" id="categoryId"
                           value="${tx.categoryId}">
                    <div id="chipWrap" class="d-flex flex-wrap gap-2 mt-1"></div>
                    <div id="catMsg" class="text-danger small mt-1" style="display:none;">
                        카테고리를 선택해주세요.
                    </div>
                </div>

                <!-- 날짜 -->
                <div class="mb-3">
                    <label class="form-label fw-semibold" for="txDate">
                        날짜 <span class="text-danger">*</span>
                    </label>
                    <%--
                        ★ input[type=date] 의 value 는 "yyyy-MM-dd" 문자열이어야 합니다.
                          수정 모드에서는 컨트롤러가 txDateStr(String)을 Model에 담아 전달합니다.
                          등록 모드에서는 today(String) 를 사용합니다.
                    --%>
                    <input type="date" class="form-control" id="txDate" name="txDate"
                           value="${mode=='edit' ? txDateStr : today}"
                           required>
                    <div class="invalid-feedback">날짜를 선택해주세요.</div>
                </div>

                <!-- 메모 -->
                <div class="mb-4">
                    <label class="form-label fw-semibold" for="memo">메모</label>
                    <textarea class="form-control" id="memo" name="memo"
                              rows="3" placeholder="메모 (선택사항)"
                              maxlength="500">${tx.memo}</textarea>
                </div>

                <!-- 제출 버튼 -->
                <div class="d-grid gap-2">
                    <button type="submit" class="btn btn-primary btn-lg fw-semibold" id="submitBtn">
                        <i class="bi bi-check-circle me-2"></i>
                        <c:choose>
                            <c:when test="${mode=='edit'}">수정 완료</c:when>
                            <c:otherwise>등록하기</c:otherwise>
                        </c:choose>
                    </button>
                    <a href="${pageContext.request.contextPath}/transaction/list"
                       class="btn btn-outline-secondary">취소</a>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
/* ── 카테고리 데이터 ── */
var INCOME_CATS = [
    <c:forEach var="c" items="${incomeList}" varStatus="s">
    {id:${c.categoryId},name:'${c.categoryName}',icon:'${c.icon}',color:'${c.color}'}${!s.last?',':''}
    </c:forEach>
];
var EXPENSE_CATS = [
    <c:forEach var="c" items="${expenseList}" varStatus="s">
    {id:${c.categoryId},name:'${c.categoryName}',icon:'${c.icon}',color:'${c.color}'}${!s.last?',':''}
    </c:forEach>
];

var currentType = document.getElementById('txType').value || 'I';
var selectedCatId = ${not empty tx.categoryId ? tx.categoryId : 'null'};

document.addEventListener('DOMContentLoaded', function() {
    setToggle(currentType);
    renderChips(currentType);
    initAmountFormat();
    initValidation();
});

/* ── 수입/지출 토글 ── */
document.querySelectorAll('input[name="typeToggle"]').forEach(function(r) {
    r.addEventListener('change', function() {
        currentType = this.value;
        document.getElementById('txType').value = currentType;
        selectedCatId = null;
        document.getElementById('categoryId').value = '';
        setToggle(currentType);
        renderChips(currentType);
    });
});

function setToggle(type) {
    var btn = document.getElementById('submitBtn');
    btn.className = 'btn btn-lg fw-semibold ' + (type==='I' ? 'btn-success' : 'btn-danger');
}

/* ── 카테고리 칩 렌더링 ── */
function renderChips(type) {
    var cats = (type === 'I') ? INCOME_CATS : EXPENSE_CATS;
    var wrap = document.getElementById('chipWrap');
    wrap.innerHTML = cats.map(function(cat) {
        var active = (cat.id === selectedCatId);
        var style  = active
            ? 'border-color:' + cat.color + ';background:' + cat.color + ';color:#fff;'
            : '';
        return '<button type="button" class="btn btn-sm btn-outline-secondary cat-chip"'
             + ' data-id="' + cat.id + '" data-color="' + cat.color + '"'
             + ' style="' + style + '" onclick="pickCat(' + cat.id + ',\'' + cat.color + '\',this)">'
             + '<i class="bi ' + cat.icon + ' me-1"></i>' + cat.name
             + '</button>';
    }).join('');
}

function pickCat(id, color, el) {
    selectedCatId = id;
    document.getElementById('categoryId').value = id;
    document.querySelectorAll('.cat-chip').forEach(function(b) {
        b.style = ''; b.className = 'btn btn-sm btn-outline-secondary cat-chip';
    });
    el.style = 'border-color:' + color + ';background:' + color + ';color:#fff;';
    document.getElementById('catMsg').style.display = 'none';
}

/* ── 금액 자동 콤마 ── */
function initAmountFormat() {
    var inp = document.getElementById('amount');
    // 초기값 콤마 표시 (수정 모드)
    if (inp.value) inp.value = Number(inp.value).toLocaleString();
    inp.addEventListener('input', function() {
        var raw = this.value.replace(/[^0-9]/g, '');
        this.value = raw ? Number(raw).toLocaleString() : '';
    });
    // 제출 전 콤마 제거
    document.getElementById('txForm').addEventListener('submit', function() {
        inp.value = inp.value.replace(/,/g, '');
    }, true);
}

/* ── 유효성 검증 ── */
function initValidation() {
    document.getElementById('txForm').addEventListener('submit', function(e) {
        var ok = true;

        var amt = document.getElementById('amount');
        var rawAmt = amt.value.replace(/,/g, '');
        if (!rawAmt || isNaN(rawAmt) || Number(rawAmt) <= 0) {
            amt.classList.add('is-invalid'); ok = false;
        } else { amt.classList.remove('is-invalid'); }

        var ttl = document.getElementById('title');
        if (!ttl.value.trim()) {
            ttl.classList.add('is-invalid'); ok = false;
        } else { ttl.classList.remove('is-invalid'); }

        if (!document.getElementById('categoryId').value) {
            document.getElementById('catMsg').style.display = 'block'; ok = false;
        } else { document.getElementById('catMsg').style.display = 'none'; }

        if (!ok) { e.preventDefault(); e.stopPropagation(); }
    });
}
</script>

<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
