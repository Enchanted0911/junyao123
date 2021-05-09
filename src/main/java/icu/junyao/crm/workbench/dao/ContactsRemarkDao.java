package icu.junyao.crm.workbench.dao;

import icu.junyao.crm.workbench.domain.ContactsRemark;

/**
 * @author wu
 */
public interface ContactsRemarkDao {

    /**
     * 新增一条联系人备注信息
     * @param contactsRemark 联系人备注
     * @return 返回修改成功的条数
     */
    int save(ContactsRemark contactsRemark);
}
