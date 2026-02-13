package com.budget.controller;

import com.budget.model.SearchCondition;
import com.budget.model.Transaction;
import com.budget.service.TransactionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Map;

/**
 * 거래 내역 CRUD 컨트롤러
 *
 * ※ txDate 는 java.util.Date 로 바인딩합니다.
 *   HTML input[type=date] 가 "yyyy-MM-dd" 형식을 전송하므로
 *   @DateTimeFormat(pattern = "yyyy-MM-dd") 을 사용합니다.
 */
@Controller
@RequestMapping("/transaction")
public class TransactionController {

    @Autowired
    private TransactionService txService;

    // ── 목록 ────────────────────────────────────────

    @GetMapping("/list")
    public String list(@ModelAttribute SearchCondition cond, Model model) {

        Calendar now = Calendar.getInstance();
        if (cond.getYear()  == null) cond.setYear(now.get(Calendar.YEAR));
        if (cond.getMonth() == null) cond.setMonth(now.get(Calendar.MONTH) + 1);

        Map<String, Object> result = txService.getList(cond);
        model.addAttribute("cond",       cond);
        model.addAttribute("list",       result.get("list"));
        model.addAttribute("total",      result.get("total"));
        model.addAttribute("totalPages", result.get("totalPages"));
        model.addAttribute("categories", txService.getAllCategories());
        return "transaction/list";
    }

    // ── 등록 폼 ────────────────────────────────────

    @GetMapping("/form")
    public String addForm(Model model) {
        model.addAttribute("tx",             new Transaction());
        model.addAttribute("incomeList",     txService.getCategoriesByType("I"));
        model.addAttribute("expenseList",    txService.getCategoriesByType("E"));
        model.addAttribute("today",          new SimpleDateFormat("yyyy-MM-dd").format(new Date()));
        model.addAttribute("mode",           "add");
        return "transaction/form";
    }

    @PostMapping("/form")
    public String insert(
            @RequestParam String title,
            @RequestParam Long   amount,
            @RequestParam String txType,
            @RequestParam Integer categoryId,
            @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") Date txDate,
            @RequestParam(required = false) String memo,
            RedirectAttributes ra) {

        Transaction tx = new Transaction();
        tx.setTitle(title);
        tx.setAmount(amount);
        tx.setTxType(txType);
        tx.setCategoryId(categoryId);
        tx.setTxDate(txDate);
        tx.setMemo(memo);

        try {
            txService.add(tx);
            ra.addFlashAttribute("successMsg", "거래 내역이 등록되었습니다.");
        } catch (IllegalArgumentException e) {
            ra.addFlashAttribute("errorMsg", e.getMessage());
            return "redirect:/transaction/form";
        }
        return "redirect:/transaction/list";
    }

    // ── 수정 폼 ────────────────────────────────────

    @GetMapping("/form/{id}")
    public String editForm(@PathVariable int id, Model model) {
        Transaction tx = txService.getOne(id);
        if (tx == null) return "redirect:/transaction/list";

        model.addAttribute("tx",          tx);
        model.addAttribute("incomeList",  txService.getCategoriesByType("I"));
        model.addAttribute("expenseList", txService.getCategoriesByType("E"));
        // txDate(java.util.Date) → "yyyy-MM-dd" 문자열 (input[type=date] value용)
        model.addAttribute("txDateStr",
                new SimpleDateFormat("yyyy-MM-dd").format(tx.getTxDate()));
        model.addAttribute("mode",        "edit");
        return "transaction/form";
    }

    @PostMapping("/form/{id}")
    public String update(
            @PathVariable int id,
            @RequestParam String  title,
            @RequestParam Long    amount,
            @RequestParam String  txType,
            @RequestParam Integer categoryId,
            @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") Date txDate,
            @RequestParam(required = false) String memo,
            RedirectAttributes ra) {

        Transaction tx = new Transaction();
        tx.setTxId(id);
        tx.setTitle(title);
        tx.setAmount(amount);
        tx.setTxType(txType);
        tx.setCategoryId(categoryId);
        tx.setTxDate(txDate);
        tx.setMemo(memo);

        try {
            txService.edit(tx);
            ra.addFlashAttribute("successMsg", "수정되었습니다.");
        } catch (IllegalArgumentException e) {
            ra.addFlashAttribute("errorMsg", e.getMessage());
        }
        return "redirect:/transaction/list";
    }

    // ── 삭제 ────────────────────────────────────────

    @PostMapping("/delete/{id}")
    public String delete(@PathVariable int id, RedirectAttributes ra) {
        try {
            txService.remove(id);
            ra.addFlashAttribute("successMsg", "삭제되었습니다.");
        } catch (IllegalArgumentException e) {
            ra.addFlashAttribute("errorMsg", e.getMessage());
        }
        return "redirect:/transaction/list";
    }
}
