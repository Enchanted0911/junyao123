package icu.junyao.crm.settings.dao;

import icu.junyao.crm.settings.domain.DicValue;

import java.util.List;

/**
 * @author wu
 */
public interface DicValueDao {
    /**
     * 通过外键typeCode获取所有满足条件的字典值
     * @param code 外键typeCode
     * @return 所有字典值集合
     */
    List<DicValue> getListByCode(String code);
}
