package icu.junyao.crm.workbench.service;

import icu.junyao.crm.settings.domain.User;
import icu.junyao.crm.vo.PaginationVO;
import icu.junyao.crm.workbench.domain.Activity;

import java.util.List;
import java.util.Map;

/**
 * @author wu
 */
public interface ActivityService {
    /**
     * 模态窗口创建操作前的查用户表操作
     * @return 所有用户的集合
     */
    List<User> activityGetUserList();

    /**
     * 市场活动保存功能
     * @param activity 市场活动
     * @return 返回字符串true给ajax判断
     */
    String activitySave(Activity activity);

    /**
     * 市场活动查询页
     * @param map 里面有页码和页大小 还可能有 其他的查询内容
     * @return
     */
    PaginationVO<Activity> activityPageList(Map<String, Object> map);

    /**
     * 根据市场活动的id来删除相对应的数据
     * @param ids 市场活动id的数组，可能要删除的市场活动不止一个
     * @return 是否删除成功的标记
     */
    boolean activityDelete(String[] ids);

    /**
     * 通过ID获取所有者的集合 和 一个Activity对象 用来操作修改模态窗口中的内容
     * @param id 需要检查的市场活动的id
     * @return 返回的map包括两个值一个是所有者的list集合 另一个是市场活动对象
     */
    Map<String, Object> getUserListAndActivity(String id);

    /**
     * 修改某个市场活动信息
     * @param activity 被修改的市场活动
     * @return 返回字符串"true" 表示成功 否则表示失败 ， 为什么不用布尔值是因为布尔值没有字符串传给ajax方便
     */
    String activityUpdate(Activity activity);
}
