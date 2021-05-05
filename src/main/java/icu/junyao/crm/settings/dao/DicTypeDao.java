package icu.junyao.crm.settings.dao;

import icu.junyao.crm.settings.domain.DicType;

import java.util.List;

/**
 * @author wu
 */
public interface DicTypeDao {
    /**
     * 获取数据字典的所有类型
     * @return
     */
    List<DicType> getTypeList();
}
