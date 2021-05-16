package icu.junyao.crm.workbench.service;

import icu.junyao.crm.settings.domain.User;
import icu.junyao.crm.vo.PaginationVO;
import icu.junyao.crm.workbench.domain.Contacts;
import icu.junyao.crm.workbench.domain.ContactsRemark;

import java.util.List;
import java.util.Map;

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

    /**
     * 联系人列表页展现
     * @param map 包含需要展现联系人的模糊字段规则以及展现的页数和每页展示的数量
     * @return 返回一个联系人视图包含符合记录的总条数以及当前页面的联系人信息
     */
    PaginationVO<Contacts> contactsPageList(Map<String, Object> map);

    /**
     * 查询出所有用户
     * @return 返回所有用户的集合
     */
    List<User> contactsGetUserList();

    /**
     * 保存一条联系人记录
     * @param contacts 联系人
     * @param customerName 客户名称在此转换成客户id再保存
     * @return 返回"true" 表示成功
     */
    String contactsSave(Contacts contacts, String customerName);

    /**
     * 获得用户列表以及一条联系人信息 做修改联系人操作
     * @param id 联系人id
     * @return map包括一个用户列表集合以及一个联系人信息
     */
    Map<String, Object> getUserListAndContacts(String id);

    /**
     * 修改一个联系人信息
     * @param contacts 联系人
     * @param customerName 客户名称
     * @return 返回"true" 表示成功
     */
    String contactsUpdate(Contacts contacts, String customerName);

    /**
     * 删除复选框选中的联系人
     * @param ids 联系人id数组
     * @return 返回 true 表示成功
     */
    boolean contactsDelete(String[] ids);

    /**
     * 根据联系人id获取联系人的详细信息
     * @param id 联系人id
     * @return 联系人
     */
    Contacts contactsDetail(String id);

    /**
     * 通过联系人的ID取得该联系人的所有备注信息
     * @param contactsId 该联系人的ID
     * @return 返回所有备注信息的集合
     */
    List<ContactsRemark> getRemarkListByContactsId(String contactsId);

    /**
     * 添加一条联系人备注
     * @param contactsRemark 要添加的联系人
     * @return 返回的map包括结果标记 和 被添加的联系人
     */
    Map<String, Object> contactsRemarkSave(ContactsRemark contactsRemark);

    /**
     * 更新一条联系人备注信息
     * @param contactsRemark 联系人备注
     * @return 返回map包括修改结果编辑 和 修改后的联系人备注
     */
    Map<String, Object> contactsUpdateRemark(ContactsRemark contactsRemark);

    /**
     * 删除一条联系人备注信息
     * @param id 联系人备注id
     * @return 返回"true"表示成功
     */
    String contactsRemoveRemark(String id);

    /**
     * 通过联系人id以及需要绑定的市场活动id给联系人新关联市场活动
     * @param contactsId 线索id
     * @param activityIds 市场活动id 可能有多个
     * @return 返回"true" 表示成功
     */
    String bind(String contactsId, String[] activityIds);

    /**
     * 根据关联关系表的id删除单条关联关系
     * @param id 关联关系的id
     * @return 返回"true" 表示成功
     */
    String unbind(String id);
}
