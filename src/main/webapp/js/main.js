/**
 * 가계부 - 공통 스크립트
 */
document.addEventListener('DOMContentLoaded', function () {
    // Bootstrap 툴팁 초기화
    document.querySelectorAll('[data-bs-toggle="tooltip"]').forEach(function (el) {
        new bootstrap.Tooltip(el, { trigger: 'hover' });
    });
});

/** 숫자 콤마 포맷 */
function numFormat(n) {
    return Number(String(n).replace(/[^0-9]/g, '')).toLocaleString('ko-KR');
}
