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

    /**
     * 根据联系人id 获取所有该联系人关联市场活动条数
     * @param ids 联系人id数组
     * @return 返回该联系人关联的市场活动总条数
     */
    int getCountByContactsIds(String[] ids);

    /**
     * 根据联系人id数组删除所有和这些联系人关联的市场活动关联关系
     * @param ids 联系人id数组
     * @return 删除成功的记录数
     */
    int deleteByContactsIds(String[] ids);
}
