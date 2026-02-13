package com.budget.service;

import com.budget.dao.CategoryDao;
import com.budget.dao.TransactionDao;
import com.budget.model.Category;
import com.budget.model.MonthlySummary;
import com.budget.model.SearchCondition;
import com.budget.model.Transaction;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 가계부 비즈니스 로직 서비스
 */
@Service
@Transactional(readOnly = true)
public class TransactionService {

    @Autowired
    private TransactionDao transactionDao;

    @Autowired
    private CategoryDao categoryDao;

    // ── 조회 ─────────────────────────────────────────

    public Map<String, Object> getList(SearchCondition cond) {
        List<Transaction> list = transactionDao.selectList(cond);
        int total      = transactionDao.countList(cond);
        int totalPages = (total == 0) ? 1 : (int) Math.ceil((double) total / cond.getSize());

        Map<String, Object> result = new HashMap<>();
        result.put("list",       list);
        result.put("total",      total);
        result.put("totalPages", totalPages);
        return result;
    }

    public Transaction getOne(int txId) {
        return transactionDao.selectOne(txId);
    }

    public MonthlySummary getMonthlySummary(int year, int month) {
        return transactionDao.selectMonthlySummary(year, month);
    }

    public List<Map<String, Object>> getExpenseByCategory(int year, int month) {
        return transactionDao.selectExpenseByCategory(year, month);
    }

    public List<Map<String, Object>> getMonthlyTrend() {
        return transactionDao.selectMonthlyTrend();
    }

    // ── 카테고리 ──────────────────────────────────────

    public List<Category> getAllCategories() {
        return categoryDao.selectAll();
    }

    public List<Category> getCategoriesByType(String type) {
        return categoryDao.selectByType(type);
    }

    // ── 등록 / 수정 / 삭제 ──────────────────────────

    @Transactional
    public int add(Transaction tx) {
        validate(tx);
        return transactionDao.insert(tx);
    }

    @Transactional
    public int edit(Transaction tx) {
        if (transactionDao.selectOne(tx.getTxId()) == null) {
            throw new IllegalArgumentException("존재하지 않는 거래입니다: " + tx.getTxId());
        }
        validate(tx);
        return transactionDao.update(tx);
    }

    @Transactional
    public int remove(int txId) {
        if (transactionDao.selectOne(txId) == null) {
            throw new IllegalArgumentException("존재하지 않는 거래입니다: " + txId);
        }
        return transactionDao.delete(txId);
    }

    // ── 유효성 검증 ───────────────────────────────────

    private void validate(Transaction tx) {
        if (tx.getTitle() == null || tx.getTitle().trim().isEmpty())
            throw new IllegalArgumentException("거래 제목은 필수입니다.");
        if (tx.getAmount() == null || tx.getAmount() <= 0)
            throw new IllegalArgumentException("금액은 0보다 커야 합니다.");
        if (tx.getTxDate() == null)
            throw new IllegalArgumentException("거래 날짜는 필수입니다.");
        if (tx.getCategoryId() == null)
            throw new IllegalArgumentException("카테고리는 필수입니다.");
        if (!"I".equals(tx.getTxType()) && !"E".equals(tx.getTxType()))
            throw new IllegalArgumentException("거래 유형이 올바르지 않습니다.");
    }
}
