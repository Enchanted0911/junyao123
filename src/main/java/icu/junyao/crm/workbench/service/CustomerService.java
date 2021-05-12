package icu.junyao.crm.workbench.service;

import java.util.List;

/**
 * @author wu
 */
public interface CustomerService {
    /**
     * 自动补全功能使用 根据name模糊查询所有客服名称
     * @param name 模糊查询name
     * @return 返回所有符合条件的客户名称
     */
    List<String> getCustomerName(String name);
}
