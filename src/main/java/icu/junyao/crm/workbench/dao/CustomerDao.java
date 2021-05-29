package icu.junyao.crm.workbench.dao;

import icu.junyao.crm.settings.domain.User;
import icu.junyao.crm.workbench.domain.Customer;

import java.util.List;
import java.util.Map;

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

    /**
     * 返回当前指定页所有客户的信息
     * @param map 包含当前页码, 每页的条数, 以及模糊查询信息
     * @return 返回所有符合条件的客户的信息
     */
    List<Customer> customerPageList(Map<String, Object> map);

    /**
     * 获得符合模糊查询规则的记录总条数
     * @param map 包含模糊查询规则
     * @return 总条数
     */
    int customerPageListTotalNum(Map<String, Object> map);

    /**
     * 查询出所有用户
     * @return 返回所有用户组成的集合
     */
    List<User> getUserList();

    /**
     * 通过ID获得单个客户对象
     * @param id 被获取的客户的ID
     * @return 需要的客户对象
     */
    Customer getCustomerById(String id);

    /**
     * 更新某个客户的信息
     * @param customer 被修改的客户
     * @return 修改记录条数 1 为成功 0 为失败
     */
    int customerUpdate(Customer customer);

    /**
     * 删除客户信息，不包括备注表中的，备注表中的在另一个接口删除
     * @param ids 需要删除客户的id
     * @return 删除成功的数量
     */
    int customerDelete(String[] ids);

    /**
     * 根据id查询单个客户返回给客户详情页
     * @param id 要查询的id
     * @return 被查询的客户
     */
    Customer customerDetail(String id);
}
