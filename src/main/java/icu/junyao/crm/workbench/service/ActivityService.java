package icu.junyao.crm.workbench.service;

import icu.junyao.crm.settings.domain.User;
import icu.junyao.crm.vo.PaginationVO;
import icu.junyao.crm.workbench.domain.Activity;
import icu.junyao.crm.workbench.domain.ActivityRemark;

import javax.servlet.http.HttpServletRequest;
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

    /**
     * 根据id查询出单条市场活动
     * @param id 要查询市场活动的ID
     * @return 返回查询的结果市场活动
     */
    Activity activityDetail(String id);

    /**
     * 通过市场活动的ID取得该市场活动的所有备注信息
     * @param activityId 该市场活动的ID
     * @return 返回所有备注信息的集合
     */
    List<ActivityRemark> getRemarkListByActivityId(String activityId);

    /**
     * 根据备注的id删除该条备注
     * @param id 备注的ID
     * @return "true"表示成功
     */
    String activityRemoveRemark(String id);

    /**
     * 添加一条备注信息
     * @param activityRemark 需要添加的备注信息
     * @return 返回 大小为2的集合 第一个元素是判断是否成功 第二个是该备注
     */
    Map<String, Object> activityRemarkSave(ActivityRemark activityRemark);

    /**
     * 通过备注的id修改单条备注信息
     * @param id 被修改备注的id
     * @param noteContent 被修改备注的内容
     * @param request 用请求参数获得session对象
     * @return 返回的map大小为2 包括修改结果标记 和 修改后的备注
     */
    Map<String, Object> activityUpdateRemark(HttpServletRequest request, String id, String noteContent);
}
