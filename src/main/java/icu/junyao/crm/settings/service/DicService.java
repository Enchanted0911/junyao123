package icu.junyao.crm.settings.service;

import icu.junyao.crm.settings.domain.DicValue;

import java.util.List;
import java.util.Map;

/**
 * @author wu
 */
public interface DicService {
    /**
     * 在上下文创建的时候给上下文添加一个数据字典
     * @return
     */
    Map<String, List<DicValue>> getAll();
}
