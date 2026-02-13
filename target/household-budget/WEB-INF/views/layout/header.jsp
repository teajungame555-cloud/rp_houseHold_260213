<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="theme-color" content="#1e3a5f">
    <title>${pageTitle} | 가계부</title>

    <!-- Bootstrap 5 CSS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <!-- Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
    <!-- 공통 CSS -->
    <link rel="stylesheet" href="<%=ctx%>/css/main.css">
</head>
<body class="bg-body-tertiary">

<!-- ── 상단 네비게이션 ── -->
<nav class="navbar navbar-expand-lg navbar-dark nav-custom sticky-top shadow-sm">
    <div class="container-fluid px-3">

        <a class="navbar-brand d-flex align-items-center gap-2 fw-bold" href="<%=ctx%>/">
            <span class="brand-icon"><i class="bi bi-wallet2"></i></span>
            <span class="d-none d-sm-inline">가계부</span>
        </a>

        <button class="navbar-toggler border-0" type="button"
                data-bs-toggle="collapse" data-bs-target="#mainNav">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="mainNav">
            <ul class="navbar-nav me-auto ms-3 mb-2 mb-lg-0">
                <li class="nav-item">
                    <a class="nav-link nav-menu-link ${currentMenu=='dashboard'?'active':''}"
                       href="<%=ctx%>/dashboard">
                        <i class="bi bi-speedometer2 me-1"></i>대시보드
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link nav-menu-link ${currentMenu=='list'?'active':''}"
                       href="<%=ctx%>/transaction/list">
                        <i class="bi bi-list-ul me-1"></i>거래내역
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link nav-menu-link ${currentMenu=='form'?'active':''}"
                       href="<%=ctx%>/transaction/form">
                        <i class="bi bi-plus-circle me-1"></i>내역추가
                    </a>
                </li>
            </ul>
            <div class="d-none d-lg-block">
                <a href="<%=ctx%>/transaction/form" class="btn btn-outline-light btn-sm">
                    <i class="bi bi-plus-lg me-1"></i>새 거래
                </a>
            </div>
        </div>
    </div>
</nav>

<!-- ── 알림 메시지 ── -->
<c:if test="${not empty successMsg}">
    <div class="alert alert-success alert-dismissible fade show alert-flash mx-3 mt-3" role="alert">
        <i class="bi bi-check-circle-fill me-2"></i>${successMsg}
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
</c:if>
<c:if test="${not empty errorMsg}">
    <div class="alert alert-danger alert-dismissible fade show alert-flash mx-3 mt-3" role="alert">
        <i class="bi bi-exclamation-triangle-fill me-2"></i>${errorMsg}
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
</c:if>

<main class="main-wrap">
