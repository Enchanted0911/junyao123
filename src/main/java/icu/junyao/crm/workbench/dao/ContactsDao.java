package icu.junyao.crm.workbench.dao;

import icu.junyao.crm.workbench.domain.Contacts;

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
}
