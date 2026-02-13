package com.budget.model;

import lombok.Data;

/**
 * 거래 내역 검색 조건
 */
@Data
public class SearchCondition {

    private Integer year;
    private Integer month;
    private String  txType;         // null=전체, "I"=수입, "E"=지출
    private Integer categoryId;
    private String  keyword;

    // 페이징
    private int page = 1;
    private int size = 20;

    public int getOffset() {
        return (page - 1) * size;
    }
}
