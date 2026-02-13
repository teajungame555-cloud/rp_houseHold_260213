<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String ctx = request.getContextPath();
%>
</main>

<!-- ── 모바일 하단 탭바 (lg 미만에서만 표시) ── -->
<nav class="tabbar d-lg-none fixed-bottom bg-white border-top">
    <div class="row g-0 text-center">
        <div class="col">
            <a href="<%=ctx%>/dashboard"
               class="tabbar-btn ${currentMenu=='dashboard'?'active':''}">
                <i class="bi bi-speedometer2"></i>
                <span>대시보드</span>
            </a>
        </div>
        <div class="col">
            <a href="<%=ctx%>/transaction/list"
               class="tabbar-btn ${currentMenu=='list'?'active':''}">
                <i class="bi bi-list-ul"></i>
                <span>거래내역</span>
            </a>
        </div>
        <div class="col">
            <a href="<%=ctx%>/transaction/form"
               class="tabbar-btn tabbar-btn--add">
                <span class="tabbar-add-circle">
                    <i class="bi bi-plus-lg"></i>
                </span>
                <span>추가</span>
            </a>
        </div>
    </div>
</nav>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="<%=ctx%>/js/main.js"></script>

<script>
    /* 알림 3.5초 자동 닫기 */
    document.querySelectorAll('.alert-flash').forEach(function(el) {
        setTimeout(function() {
            bootstrap.Alert.getOrCreateInstance(el).close();
        }, 3500);
    });
</script>
</body>
</html>
