package icu.junyao.crm.workbench.service;

import icu.junyao.crm.workbench.domain.Contacts;

import java.util.List;

/**
 * @author wu
 */
public interface ContactsService {
    /**
     * 通过联系人名称模糊查询所有联系人
     * @param contactsName 联系人模糊名称
     * @return 返回所有符合条件的联系人的集合
     */
    List<Contacts> getContactsListByName(String contactsName);
}
