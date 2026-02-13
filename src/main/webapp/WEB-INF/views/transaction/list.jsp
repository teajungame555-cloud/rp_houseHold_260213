<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
    request.setAttribute("pageTitle",   "거래내역");
    request.setAttribute("currentMenu", "list");
%>
<jsp:include page="/WEB-INF/views/layout/header.jsp"/>

<div class="container-fluid px-3 py-4 page-bottom-pad">

    <!-- ── 헤더 ── -->
    <div class="d-flex align-items-center justify-content-between mb-3">
        <h5 class="fw-bold mb-0">
            <i class="bi bi-list-ul me-2 text-primary"></i>거래내역
        </h5>
        <a href="${pageContext.request.contextPath}/transaction/form"
           class="btn btn-primary btn-sm">
            <i class="bi bi-plus-lg me-1"></i>추가
        </a>
    </div>

    <!-- ── 검색 필터 ── -->
    <div class="card border-0 shadow-sm mb-3">
        <div class="card-body p-3">
            <form action="" method="get" id="searchForm">
                <div class="row g-2">

                    <div class="col-6 col-sm-3">
                        <select class="form-select form-select-sm" name="year">
                            <c:forEach var="y" begin="${cond.year-2}" end="${cond.year+1}">
                                <option value="${y}" ${y==cond.year?'selected':''}>${y}년</option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="col-6 col-sm-3">
                        <select class="form-select form-select-sm" name="month">
                            <option value="">전체 월</option>
                            <c:forEach var="m" begin="1" end="12">
                                <option value="${m}" ${m==cond.month?'selected':''}>${m}월</option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="col-6 col-sm-2">
                        <select class="form-select form-select-sm" name="txType">
                            <option value=""  ${empty cond.txType?'selected':''}>전체</option>
                            <option value="I" ${'I'==cond.txType?'selected':''}>수입</option>
                            <option value="E" ${'E'==cond.txType?'selected':''}>지출</option>
                        </select>
                    </div>

                    <div class="col-6 col-sm-2">
                        <select class="form-select form-select-sm" name="categoryId">
                            <option value="">카테고리</option>
                            <c:forEach var="cat" items="${categories}">
                                <option value="${cat.categoryId}"
                                    ${cat.categoryId==cond.categoryId?'selected':''}>
                                    ${'I'==cat.categoryType?'▲':'▼'} ${cat.categoryName}
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="col-12 col-sm-2 d-flex gap-1">
                        <input class="form-control form-control-sm"
                               type="text" name="keyword"
                               placeholder="검색어"
                               value="${cond.keyword}">
                        <button class="btn btn-primary btn-sm px-3" type="submit">
                            <i class="bi bi-search"></i>
                        </button>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <!-- ── 결과 카운트 ── -->
    <div class="d-flex justify-content-between mb-2 px-1">
        <small class="text-muted">총 <strong>${total}</strong>건</small>
        <small class="text-muted">${cond.page} / ${totalPages} 페이지</small>
    </div>

    <!-- ── 목록 ── -->
    <div class="card border-0 shadow-sm mb-3">
        <c:choose>
            <c:when test="${empty list}">
                <div class="text-center py-5 text-muted">
                    <i class="bi bi-inbox display-4 d-block mb-3 opacity-50"></i>
                    <p class="mb-0">조회된 거래 내역이 없습니다.</p>
                    <a href="${pageContext.request.contextPath}/transaction/form"
                       class="btn btn-primary btn-sm mt-3">
                        <i class="bi bi-plus-circle me-1"></i>첫 거래 추가하기
                    </a>
                </div>
            </c:when>
            <c:otherwise>

                <!-- 데스크탑: 테이블 -->
                <div class="d-none d-md-block table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th class="ps-3">날짜</th>
                                <th>유형</th>
                                <th>카테고리</th>
                                <th>제목</th>
                                <th class="text-end">금액</th>
                                <th class="text-center pe-3">관리</th>
                            </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="item" items="${list}">
                            <tr>
                                <td class="ps-3 text-muted small">
                                    <%-- ★ fmt:formatDate : java.util.Date 완전 호환 --%>
                                    <fmt:formatDate value="${item.txDate}" pattern="yyyy.MM.dd"/>
                                </td>
                                <td>
                                    <span class="${item.typeBadgeClass} rounded-pill px-2">
                                        ${item.typeLabel}
                                    </span>
                                </td>
                                <td>
                                    <span style="color:${item.color}" class="fw-semibold small">
                                        <i class="bi ${item.icon} me-1"></i>${item.categoryName}
                                    </span>
                                </td>
                                <td class="fw-semibold">${item.title}</td>
                                <td class="text-end fw-bold ${item.txType=='I'?'text-success':'text-danger'}">
                                    <c:choose>
                                        <c:when test="${item.txType=='I'}">+</c:when>
                                        <c:otherwise>-</c:otherwise>
                                    </c:choose>${item.amountFormatted}원
                                </td>
                                <td class="text-center pe-3">
                                    <div class="btn-group btn-group-sm">
                                        <a href="${pageContext.request.contextPath}/transaction/form/${item.txId}"
                                           class="btn btn-outline-secondary" title="수정">
                                            <i class="bi bi-pencil"></i>
                                        </a>
                                        <button type="button"
                                                class="btn btn-outline-danger btn-del"
                                                data-id="${item.txId}"
                                                data-title="${item.title}"
                                                title="삭제">
                                            <i class="bi bi-trash3"></i>
                                        </button>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>

                <!-- 모바일: 카드 리스트 -->
                <ul class="d-md-none list-group list-group-flush tx-list">
                    <c:forEach var="item" items="${list}">
                        <li class="list-group-item list-group-item-action tx-item px-3 py-3">
                            <div class="d-flex align-items-center gap-3">
                                <div class="tx-cat-icon rounded-circle flex-shrink-0"
                                     style="background:${item.color}22; color:${item.color};">
                                    <i class="bi ${item.icon}"></i>
                                </div>
                                <div class="flex-grow-1 min-w-0">
                                    <div class="d-flex justify-content-between align-items-start">
                                        <div class="fw-semibold text-truncate me-2">${item.title}</div>
                                        <div class="fw-bold flex-shrink-0
                                            ${item.txType=='I'?'text-success':'text-danger'}">
                                            <c:choose>
                                                <c:when test="${item.txType=='I'}">+</c:when>
                                                <c:otherwise>-</c:otherwise>
                                            </c:choose>${item.amountFormatted}원
                                        </div>
                                    </div>
                                    <div class="d-flex justify-content-between mt-1">
                                        <span class="small text-muted">
                                            ${item.categoryName} &bull;
                                            <fmt:formatDate value="${item.txDate}" pattern="MM.dd"/>
                                        </span>
                                        <span class="d-flex gap-2">
                                            <a href="${pageContext.request.contextPath}/transaction/form/${item.txId}"
                                               class="text-secondary small"><i class="bi bi-pencil"></i></a>
                                            <button type="button"
                                                    class="btn p-0 text-danger small btn-del"
                                                    data-id="${item.txId}"
                                                    data-title="${item.title}">
                                                <i class="bi bi-trash3"></i>
                                            </button>
                                        </span>
                                    </div>
                                </div>
                            </div>
                        </li>
                    </c:forEach>
                </ul>

            </c:otherwise>
        </c:choose>
    </div>

    <!-- ── 페이징 ── -->
    <c:if test="${totalPages > 1}">
        <nav>
            <ul class="pagination pagination-sm justify-content-center">
                <c:if test="${cond.page > 1}">
                    <li class="page-item">
                        <a class="page-link"
                           href="?page=${cond.page-1}&year=${cond.year}&month=${cond.month}&txType=${cond.txType}&keyword=${cond.keyword}">
                            <i class="bi bi-chevron-left"></i>
                        </a>
                    </li>
                </c:if>
                <c:forEach var="p" begin="1" end="${totalPages}">
                    <li class="page-item ${p==cond.page?'active':''}">
                        <a class="page-link"
                           href="?page=${p}&year=${cond.year}&month=${cond.month}&txType=${cond.txType}&keyword=${cond.keyword}">
                            ${p}
                        </a>
                    </li>
                </c:forEach>
                <c:if test="${cond.page < totalPages}">
                    <li class="page-item">
                        <a class="page-link"
                           href="?page=${cond.page+1}&year=${cond.year}&month=${cond.month}&txType=${cond.txType}&keyword=${cond.keyword}">
                            <i class="bi bi-chevron-right"></i>
                        </a>
                    </li>
                </c:if>
            </ul>
        </nav>
    </c:if>

</div>

<!-- ── 삭제 확인 모달 ── -->
<div class="modal fade" id="deleteModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow">
            <div class="modal-header border-0 pb-0">
                <h6 class="modal-title fw-bold">
                    <i class="bi bi-exclamation-triangle-fill text-warning me-2"></i>삭제 확인
                </h6>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body py-3">
                <p class="mb-1 fw-semibold" id="delTitle"></p>
                <p class="text-muted small mb-0">이 거래를 삭제하시겠습니까? 복구할 수 없습니다.</p>
            </div>
            <div class="modal-footer border-0 pt-0">
                <button type="button" class="btn btn-outline-secondary btn-sm" data-bs-dismiss="modal">취소</button>
                <form id="delForm" method="post">
                    <button type="submit" class="btn btn-danger btn-sm">
                        <i class="bi bi-trash3 me-1"></i>삭제
                    </button>
                </form>
            </div>
        </div>
    </div>
</div>

<script>
    document.querySelectorAll('.btn-del').forEach(function(btn) {
        btn.addEventListener('click', function() {
            document.getElementById('delTitle').textContent = this.dataset.title;
            document.getElementById('delForm').action =
                '${pageContext.request.contextPath}/transaction/delete/' + this.dataset.id;
            new bootstrap.Modal(document.getElementById('deleteModal')).show();
        });
    });
</script>

<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
