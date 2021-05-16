package icu.junyao.crm.workbench.dao;

import icu.junyao.crm.workbench.domain.ContactsRemark;

import java.util.List;

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

    /**
     * 根据联系人id数组获取所有属于这些联系人的备注条数
     * @param ids 联系人数组
     * @return 返回所有符合条件的备注条数
     */
    int getCountByContactsIds(String[] ids);

    /**
     * 根据联系人id数组 删除所有属于这些联系人的备注
     * @param ids 联系人id数组
     * @return 返回删除成功的记录数
     */
    int deleteByContactsIds(String[] ids);

    /**
     * 根据联系人id展示所有该联系人备注条数
     * @param contactsId 联系人id
     * @return 返回联系人备注条数集合
     */
    List<ContactsRemark> getRemarkListByContactsId(String contactsId);

    /**
     * 添加一条联系人备注
     * @param contactsRemark 被添加的备注
     * @return 返回修改成功的记录数
     */
    int remarkSave(ContactsRemark contactsRemark);

    /**
     * 修改一条联系人备注信息
     * @param contactsRemark 联系人备注
     * @return 返回修改成功的记录数
     */
    int remarkUpdate(ContactsRemark contactsRemark);

    /**
     * 根据联系人备注的id删除该条联系人备注
     * @param id 联系人备注id
     * @return 返回修改成功的记录数
     */
    int removeRemarkById(String id);
}
