package com.budget.model;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

/**
 * 카테고리 Model
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Category {
    private Integer categoryId;
    private String  categoryName;
    private String  categoryType;  // "I":수입, "E":지출
    private String  icon;
    private String  color;
}
