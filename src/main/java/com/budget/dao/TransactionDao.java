package com.budget.dao;

import com.budget.model.MonthlySummary;
import com.budget.model.SearchCondition;
import com.budget.model.Transaction;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

/**
 * 거래 내역 MyBatis Mapper 인터페이스
 */
public interface TransactionDao {

    /** 목록 조회 (동적 검색 + 페이징) */
    List<Transaction> selectList(SearchCondition cond);

    /** 전체 건수 */
    int countList(SearchCondition cond);

    /** 단건 조회 */
    Transaction selectOne(int txId);

    /** 월별 수입/지출 합계 */
    MonthlySummary selectMonthlySummary(@Param("year")  int year,
                                        @Param("month") int month);

    /** 카테고리별 지출 집계 (차트용) */
    List<Map<String, Object>> selectExpenseByCategory(@Param("year")  int year,
                                                      @Param("month") int month);

    /** 최근 6개월 수입/지출 추이 (차트용) */
    List<Map<String, Object>> selectMonthlyTrend();

    /** 등록 */
    int insert(Transaction tx);

    /** 수정 */
    int update(Transaction tx);

    /** 삭제 */
    int delete(int txId);
}
