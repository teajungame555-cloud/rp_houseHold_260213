package com.budget.model;

import lombok.Data;

/**
 * 월별 수입/지출 요약 Model
 */
@Data
public class MonthlySummary {
    private Integer year;
    private Integer month;
    private Long totalIncome   = 0L;
    private Long totalExpense  = 0L;

    public long getBalance() {
        long i = (totalIncome  != null) ? totalIncome  : 0L;
        long e = (totalExpense != null) ? totalExpense : 0L;
        return i - e;
    }

    public String getTotalIncomeFormatted() {
        return String.format("%,d", totalIncome  != null ? totalIncome  : 0L);
    }

    public String getTotalExpenseFormatted() {
        return String.format("%,d", totalExpense != null ? totalExpense : 0L);
    }

    public String getBalanceFormatted() {
        return String.format("%,d", getBalance());
    }
}
