package icu.junyao.crm.workbench.dao;

import icu.junyao.crm.settings.domain.User;
import icu.junyao.crm.workbench.domain.Contacts;

import java.util.List;
import java.util.Map;

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

    /**
     * 返回当前指定页所有联系人的信息
     * @param map 包含当前页码, 每页的条数, 以及模糊查询信息
     * @return 返回所有符合条件的联系人的信息
     */
    List<Contacts> contactsPageList(Map<String, Object> map);

    /**
     * 获得符合模糊查询规则的记录总条数
     * @param map 包含模糊查询规则
     * @return 总条数
     */
    int contactsPageListTotalNum(Map<String, Object> map);

    /**
     * 查询出所有用户
     * @return 返回所有用户组成的集合
     */
    List<User> contactsGetUserList();

    /**
     * 根据联系人的id获取一条联系人信息 所有者名称还是id 客户名称不是客户id而是客户表中的名字
     * @param id 联系人id
     * @return 返回该条联系人
     */
    Contacts getContactsById(String id);

    /**
     * 修改一条联系人信息
     * @param contacts 被修改的联系人
     * @return 返回修改成功的记录数
     */
    int update(Contacts contacts);

    /**
     * 根据联系人id获取这个联系人的创建者
     * @param id 联系人id
     * @return 返回联系人的创建者
     */
    String getCreateById(String id);

    /**
     * 根据id数组删除联系人
     * @param ids 联系人id数组
     * @return 删除成功的条数
     */
    int contactsDelete(String[] ids);

    /**
     * 根据联系人id获取联系人的详细信息 所有者名称以及客户名称都不是相应id而是对应表中的名字
     * @param id 联系人id
     * @return 联系人
     */
    Contacts contactsDetail(String id);
}
