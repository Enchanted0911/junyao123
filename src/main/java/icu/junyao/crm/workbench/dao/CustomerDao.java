package icu.junyao.crm.workbench.dao;

import icu.junyao.crm.workbench.domain.Customer;

import java.util.List;

/**
 * @author wu
 */
public interface CustomerDao {

    /**
     * 根据公司名称查询是否存在该公司(客户)
     * @param company 公司名称
     * @return 返回一个公司 如果没有则为空 会在service层判断
     */
    Customer getCustomerByName(String company);

    /**
     * 新添加一个客户
     * @param customer 被添加的客户
     * @return 返回修改成功的条数
     */
    int save(Customer customer);

    /**
     * 根据name模糊查询所有符合条件的公司名称
     * @param name 模糊名称
     * @return 返回所有符合条件的客户名称
     */
    List<String> getCustomerNameLike(String name);
}
