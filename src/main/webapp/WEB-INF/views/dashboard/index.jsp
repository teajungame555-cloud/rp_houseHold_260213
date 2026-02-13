<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
    request.setAttribute("pageTitle",   "대시보드");
    request.setAttribute("currentMenu", "dashboard");
%>
<jsp:include page="/WEB-INF/views/layout/header.jsp"/>

<div class="container-fluid px-3 py-4 page-bottom-pad">

    <!-- ── 월 네비게이터 ── -->
    <div class="d-flex align-items-center justify-content-between mb-4">
        <a class="btn btn-outline-secondary btn-sm"
           href="?year=${prevYear}&amp;month=${prevMonth}">
            <i class="bi bi-chevron-left"></i>
        </a>
        <h5 class="mb-0 fw-bold">${year}년 ${month}월</h5>
        <a class="btn btn-outline-secondary btn-sm"
           href="?year=${nextYear}&amp;month=${nextMonth}">
            <i class="bi bi-chevron-right"></i>
        </a>
    </div>

    <!-- ── 요약 카드 3개 ── -->
    <div class="row g-3 mb-4">
        <!-- 수입 -->
        <div class="col-4">
            <div class="card card-summary border-0 shadow-sm h-100">
                <div class="card-body text-center p-3">
                    <div class="summary-icon summary-icon--in mx-auto mb-2">
                        <i class="bi bi-arrow-up-circle-fill"></i>
                    </div>
                    <div class="text-muted small mb-1">수입</div>
                    <div class="summary-amount fw-bold text-success">
                        ${summary.totalIncomeFormatted}
                    </div>
                </div>
            </div>
        </div>
        <!-- 지출 -->
        <div class="col-4">
            <div class="card card-summary border-0 shadow-sm h-100">
                <div class="card-body text-center p-3">
                    <div class="summary-icon summary-icon--out mx-auto mb-2">
                        <i class="bi bi-arrow-down-circle-fill"></i>
                    </div>
                    <div class="text-muted small mb-1">지출</div>
                    <div class="summary-amount fw-bold text-danger">
                        ${summary.totalExpenseFormatted}
                    </div>
                </div>
            </div>
        </div>
        <!-- 잔액 -->
        <div class="col-4">
            <div class="card card-summary border-0 shadow-sm h-100">
                <div class="card-body text-center p-3">
                    <div class="summary-icon summary-icon--bal mx-auto mb-2">
                        <i class="bi bi-piggy-bank-fill"></i>
                    </div>
                    <div class="text-muted small mb-1">잔액</div>
                    <div class="summary-amount fw-bold
                        ${summary.balance >= 0 ? 'text-primary' : 'text-danger'}">
                        ${summary.balanceFormatted}
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- ── 차트 영역 ── -->
    <div class="row g-3 mb-4">

        <!-- 카테고리별 지출 도넛 -->
        <div class="col-12 col-lg-5">
            <div class="card border-0 shadow-sm">
                <div class="card-header bg-white border-0 pt-3 pb-0">
                    <h6 class="fw-bold mb-0">
                        <i class="bi bi-pie-chart-fill text-danger me-2"></i>카테고리별 지출
                    </h6>
                </div>
                <div class="card-body">
                    <div class="chart-wrap">
                        <canvas id="chartCategory"></canvas>
                    </div>
                    <div id="categoryLegend" class="legend-wrap mt-3"></div>
                </div>
            </div>
        </div>

        <!-- 월별 추이 바 -->
        <div class="col-12 col-lg-7">
            <div class="card border-0 shadow-sm">
                <div class="card-header bg-white border-0 pt-3 pb-0">
                    <h6 class="fw-bold mb-0">
                        <i class="bi bi-bar-chart-fill text-primary me-2"></i>월별 수입/지출 추이
                    </h6>
                </div>
                <div class="card-body">
                    <div class="chart-wrap">
                        <canvas id="chartTrend"></canvas>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- ── 최근 거래 ── -->
    <div class="card border-0 shadow-sm">
        <div class="card-header bg-white border-0 pt-3 d-flex align-items-center justify-content-between">
            <h6 class="fw-bold mb-0">
                <i class="bi bi-clock-history text-secondary me-2"></i>최근 거래 내역
            </h6>
            <a href="${pageContext.request.contextPath}/transaction/list?year=${year}&amp;month=${month}"
               class="btn btn-outline-primary btn-sm">
                전체 보기 <i class="bi bi-arrow-right ms-1"></i>
            </a>
        </div>
        <div class="card-body p-0">
            <c:choose>
                <c:when test="${empty recentList}">
                    <div class="text-center py-5 text-muted">
                        <i class="bi bi-inbox display-4 d-block mb-2 opacity-50"></i>
                        이번 달 거래 내역이 없습니다.
                    </div>
                </c:when>
                <c:otherwise>
                    <ul class="list-group list-group-flush tx-list">
                        <c:forEach var="item" items="${recentList}">
                            <li class="list-group-item list-group-item-action tx-item px-3 py-3">
                                <div class="d-flex align-items-center gap-3">
                                    <!-- 아이콘 -->
                                    <div class="tx-cat-icon rounded-circle d-flex align-items-center justify-content-center flex-shrink-0"
                                         style="background:${item.color}22; color:${item.color};">
                                        <i class="bi ${item.icon}"></i>
                                    </div>
                                    <!-- 내용 -->
                                    <div class="flex-grow-1 min-w-0">
                                        <div class="fw-semibold text-truncate">${item.title}</div>
                                        <div class="small text-muted">
                                            ${item.categoryName} &bull;
                                            <%-- ★ java.util.Date → fmt:formatDate 정상 동작 --%>
                                            <fmt:formatDate value="${item.txDate}" pattern="MM.dd"/>
                                        </div>
                                    </div>
                                    <!-- 금액 -->
                                    <div class="fw-bold flex-shrink-0
                                        ${item.txType=='I'?'text-success':'text-danger'}">
                                        <c:choose>
                                            <c:when test="${item.txType=='I'}">+</c:when>
                                            <c:otherwise>-</c:otherwise>
                                        </c:choose>${item.amountFormatted}원
                                    </div>
                                </div>
                            </li>
                        </c:forEach>
                    </ul>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

</div>

<!-- ── 차트 스크립트 ── -->
<script>
const CHART_YEAR  = ${year};
const CHART_MONTH = ${month};
const APP_CTX     = '${pageContext.request.contextPath}';

document.addEventListener('DOMContentLoaded', function() {
    loadCategoryChart();
    loadTrendChart();
});

async function loadCategoryChart() {
    const res  = await fetch(APP_CTX + '/api/chart/category?year=' + CHART_YEAR + '&month=' + CHART_MONTH);
    const data = await res.json();
    const canvas = document.getElementById('chartCategory');

    if (!data || data.length === 0) {
        canvas.parentElement.innerHTML =
            '<div class="text-center py-4 text-muted opacity-50"><i class="bi bi-bar-chart fs-1 d-block"></i>데이터 없음</div>';
        return;
    }

    const labels = data.map(function(d){ return d.categoryName; });
    const values = data.map(function(d){ return Number(d.total); });
    const colors = data.map(function(d){ return d.color; });

    new Chart(canvas, {
        type: 'doughnut',
        data: {
            labels: labels,
            datasets: [{ data: values, backgroundColor: colors, borderWidth: 2, borderColor: '#fff' }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            cutout: '60%',
            plugins: {
                legend: { display: false },
                tooltip: { callbacks: { label: function(c){ return ' ' + c.label + ': ' + Number(c.raw).toLocaleString() + '원'; }}}
            }
        }
    });

    var legend = document.getElementById('categoryLegend');
    legend.innerHTML = data.map(function(d){
        return '<span class="legend-chip">'
             + '<span class="legend-dot" style="background:' + d.color + '"></span>'
             + '<span class="legend-name">' + d.categoryName + '</span>'
             + '<span class="legend-val">' + Number(d.total).toLocaleString() + '원</span>'
             + '</span>';
    }).join('');
}

async function loadTrendChart() {
    const res  = await fetch(APP_CTX + '/api/chart/trend');
    const data = await res.json();
    const canvas = document.getElementById('chartTrend');

    new Chart(canvas, {
        type: 'bar',
        data: {
            labels: data.map(function(d){ return d.ym; }),
            datasets: [
                { label: '수입',  data: data.map(function(d){ return Number(d.income);  }), backgroundColor: 'rgba(22,163,74,0.75)',  borderRadius: 5 },
                { label: '지출',  data: data.map(function(d){ return Number(d.expense); }), backgroundColor: 'rgba(220,38,38,0.75)',   borderRadius: 5 }
            ]
        },
        options: {
            responsive: true, maintainAspectRatio: false,
            plugins: {
                legend: { position: 'top' },
                tooltip: { callbacks: { label: function(c){ return ' ' + c.dataset.label + ': ' + Number(c.raw).toLocaleString() + '원'; }}}
            },
            scales: { y: { beginAtZero: true, ticks: { callback: function(v){ return (v/10000).toFixed(0) + '만'; }}}}
        }
    });
}
</script>

<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
