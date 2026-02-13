package com.budget.controller;

import com.budget.model.MonthlySummary;
import com.budget.model.SearchCondition;
import com.budget.service.TransactionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.Calendar;
import java.util.List;
import java.util.Map;

/**
 * 대시보드 컨트롤러
 */
@Controller
public class DashboardController {

    @Autowired
    private TransactionService txService;

    @GetMapping(value = {"/", "/dashboard"})
    public String dashboard(@RequestParam(defaultValue = "0") int year,
                            @RequestParam(defaultValue = "0") int month,
                            Model model) {

        Calendar now = Calendar.getInstance();
        int targetYear  = (year  == 0) ? now.get(Calendar.YEAR)         : year;
        int targetMonth = (month == 0) ? now.get(Calendar.MONTH) + 1    : month;

        // 이전/다음 월 계산
        int prevYear  = (targetMonth == 1)  ? targetYear - 1 : targetYear;
        int prevMonth = (targetMonth == 1)  ? 12             : targetMonth - 1;
        int nextYear  = (targetMonth == 12) ? targetYear + 1 : targetYear;
        int nextMonth = (targetMonth == 12) ? 1              : targetMonth + 1;

        // 월별 요약
        MonthlySummary summary = txService.getMonthlySummary(targetYear, targetMonth);

        // 최근 거래 5건
        SearchCondition cond = new SearchCondition();
        cond.setYear(targetYear);
        cond.setMonth(targetMonth);
        cond.setPage(1);
        cond.setSize(5);
        Map<String, Object> recent = txService.getList(cond);

        model.addAttribute("summary",    summary);
        model.addAttribute("recentList", recent.get("list"));
        model.addAttribute("year",       targetYear);
        model.addAttribute("month",      targetMonth);
        model.addAttribute("prevYear",   prevYear);
        model.addAttribute("prevMonth",  prevMonth);
        model.addAttribute("nextYear",   nextYear);
        model.addAttribute("nextMonth",  nextMonth);

        return "dashboard/index";
    }

    /** 카테고리별 지출 - JSON API */
    @GetMapping("/api/chart/category")
    @ResponseBody
    public List<Map<String, Object>> categoryChart(
            @RequestParam int year,
            @RequestParam int month) {
        return txService.getExpenseByCategory(year, month);
    }

    /** 월별 추이 - JSON API */
    @GetMapping("/api/chart/trend")
    @ResponseBody
    public List<Map<String, Object>> trendChart() {
        return txService.getMonthlyTrend();
    }
}
