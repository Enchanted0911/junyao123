package icu.junyao.crm.workbench.dao;

import icu.junyao.crm.workbench.domain.Contacts;

import java.util.List;

/**
 * @author wu
 */
public interface ContactsDao {

    /**
     * 新增一条联系人记录
     * @param contacts 一条联系人
     * @return 返回修改成功的条数
     */
    int save(Contacts contacts);

    /**
     * 通过联系人的名称模糊查询出所有联系人
     * @param contactsName 联系人模糊名
     * @return
     */
    List<Contacts> getContactsListByName(String contactsName);
}
