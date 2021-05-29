package icu.junyao.crm.workbench.dao;

import icu.junyao.crm.workbench.domain.CustomerRemark;

import java.util.List;

/**
 * @author wu
 */
public interface CustomerRemarkDao {

    /**
     * 新增一条客户备注信息
     * @param customerRemark 客户备注
     * @return 返回修改成功的数据条数
     */
    int save(CustomerRemark customerRemark);

    /**
     * 通过外键客户的ID查询关联的备注条数
     * @param ids 客户的ID
     * @return 备注数量
     */
    int getCountByCustomerIds(String[] ids);

    /**
     * 通过外键删除备注表中的备注记录
     * @param ids 客户ID
     * @return 被删除的记录数
     */
    int deleteByCustomerIds(String[] ids);

    /**
     * 根据客户id展示所有该客户备注条数
     * @param customerId 客户id
     * @return 返回客户备注条数集合
     */
    List<CustomerRemark> getRemarkListByCustomerId(String customerId);

    /**
     * 添加一条客户备注
     * @param customerRemark 被添加的备注
     * @return 返回修改成功的记录数
     */
    int remarkSave(CustomerRemark customerRemark);

    /**
     * 根据客户备注的id删除该条客户备注
     * @param id 联系人备注id
     * @return 返回修改成功的记录数
     */
    int removeRemarkById(String id);

    /**
     * 修改一条客户备注信息
     * @param customerRemark 客户备注
     * @return 返回修改成功的记录数
     */
    int remarkUpdate(CustomerRemark customerRemark);
}
