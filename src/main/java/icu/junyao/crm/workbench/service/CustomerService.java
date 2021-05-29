package icu.junyao.crm.workbench.service;

import icu.junyao.crm.settings.domain.User;
import icu.junyao.crm.vo.PaginationVO;
import icu.junyao.crm.workbench.domain.Customer;
import icu.junyao.crm.workbench.domain.CustomerRemark;

import java.util.List;
import java.util.Map;

/**
 * @author wu
 */
public interface CustomerService {
    /**
     * 自动补全功能使用 根据name模糊查询所有客户名称
     * @param name 模糊查询name
     * @return 返回所有符合条件的客户名称
     */
    List<String> getCustomerName(String name);

    /**
     * 展示数据列表和分页信息给客户主页面
     * @param map 包含查询条件和记录总条数以及当前页的条数信息
     * @return 返回当前页面信息以及记录总条数
     */
    PaginationVO<Customer> customerPageList(Map<String, Object> map);

    /**
     * 查询出所有用户
     * @return 返回所有用户的集合
     */
    List<User> customerGetUserList();

    /**
     * 保存一条联系人记录
     * @param customer 联系人
     * @return 返回"true" 表示成功
     */
    String customerSave(Customer customer);

    /**
     * 通过ID获取所有者的集合 和 一个Customer对象 用来操作修改模态窗口中的内容
     * @param id 需要检查的客户的id
     * @return 返回的map包括两个值一个是所有者的list集合 另一个是客户对象
     */
    Map<String, Object> getUserListAndCustomer(String id);

    /**
     * 修改某个客户信息
     * @param customer 被修改的客户
     * @return 返回字符串"true" 表示成功 否则表示失败 ， 为什么不用布尔值是因为布尔值没有字符串传给ajax方便
     */
    String customerUpdate(Customer customer);

    /**
     * 根据客户的id来删除相对应的数据
     * @param ids 客户id的数组，可能要删除的客户不止一个
     * @return 是否删除成功的标记
     */
    boolean customerDelete(String[] ids);

    /**
     * 根据id查询出单个客户
     * @param id 要查询客户的ID
     * @return 返回查询的结果客户
     */
    Customer customerDetail(String id);

    /**
     * 通过客户的ID取得该客户的所有备注信息
     * @param customerId 该客户的ID
     * @return 返回所有备注信息的集合
     */
    List<CustomerRemark> getRemarkListByCustomerId(String customerId);

    /**
     * 添加一条客户备注
     * @param customerRemark 要添加的客户备注
     * @return 返回的map包括结果标记 和 被添加的客户备注
     */
    Map<String, Object> customerRemarkSave(CustomerRemark customerRemark);

    /**
     * 删除一条客户备注信息
     * @param id 联系人备注id
     * @return 返回"true"表示成功
     */
    String customerRemoveRemark(String id);

    /**
     * 更新一条客户备注信息
     * @param customerRemark 客户备注
     * @return 返回map包括修改结果编辑 和 修改后的客户备注
     */
    Map<String, Object> customerUpdateRemark(CustomerRemark customerRemark);
}
