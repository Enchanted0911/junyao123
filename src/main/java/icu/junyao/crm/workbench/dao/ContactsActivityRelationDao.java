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

    /**
     * 根据关联关系表的id删除单条记录
     * @param id 关联关系表id
     * @return 返回修改成功的数据
     */
    int unbind(String id);
}
