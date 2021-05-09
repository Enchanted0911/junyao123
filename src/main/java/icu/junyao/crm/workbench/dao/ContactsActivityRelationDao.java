package icu.junyao.crm.workbench.dao;

import icu.junyao.crm.workbench.domain.ContactsActivityRelation;

/**
 * @author wu
 */
public interface ContactsActivityRelationDao {

    /**
     * 新增一条联系人和市场活动之间的关系
     * @param contactsActivityRelation 联系人市场活动关系
     * @return 返回修改成功的记录条数
     */
    int save(ContactsActivityRelation contactsActivityRelation);
}
