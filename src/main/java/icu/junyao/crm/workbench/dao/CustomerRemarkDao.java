package icu.junyao.crm.workbench.dao;

import icu.junyao.crm.workbench.domain.CustomerRemark;

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
}
