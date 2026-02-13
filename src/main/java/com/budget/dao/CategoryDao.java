package com.budget.dao;

import com.budget.model.Category;
import java.util.List;

/**
 * 카테고리 MyBatis Mapper 인터페이스
 */
public interface CategoryDao {
    List<Category> selectAll();
    List<Category> selectByType(String categoryType);
    Category       selectOne(int categoryId);
}
