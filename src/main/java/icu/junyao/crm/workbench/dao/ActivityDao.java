package icu.junyao.crm.workbench.dao;

import icu.junyao.crm.settings.domain.User;
import icu.junyao.crm.workbench.domain.Activity;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

/**
 * @author wu
 */
public interface ActivityDao {
    /**
     * 查询所有的user为市场活动创建操作提供数据
     * @return 所有user的集合
     */
    List<User> activityGetUserList();

    /**
     * 新增一条市场活动并保存
     * @param activity 新增的市场活动
     * @return 是否插入数据成功
     */
    int activitySave(Activity activity);

    /**
     * 返回条件查询后的列表指定页内容给前端界面
     * @param map 查询条件
     * @return 结果集合
     */
    List<Activity> activityPageList(Map<String, Object> map);

    /**
     * 查询记录的总条数 不可用size因为size得出的是分页后当前页的记录数
     * @param map 查询条件
     * @return 总记录数
     */
    int activityPageListTotalNum(Map<String, Object> map);

    /**
     * 删除市场活动信息，不包括备注表中的，备注表中的在另一个接口删除
     * @param ids 需要删除市场活动的id
     * @return 删除成功的数量
     */
    int activityDelete(String[] ids);

    /**
     * 通过ID获得单个市场活动对象
     * @param id 被获取的市场活动的ID
     * @return 需要的市场活动对象
     */
    Activity getActivityById(String id);

    /**
     * 更新某个市场活动的信息
     * @param activity 被修改的市场活动
     * @return 修改记录条数 1 为成功 0 为失败
     */
    int activityUpdate(Activity activity);

    /**
     * 根据id查询单个市场活动返回给市场活动详情页
     * @param id 要查询的id
     * @return 被查询的市场活动
     */
    Activity activityDetail(String id);

    /**
     * 根据线索的id 返回所有与该线索关联的市场活动
     * @param clueId 线索id
     * @return 所有符合条件的市场活动的集合
     */
    List<Activity> getActivityListByClueId(String clueId);

    /**
     * 根据线索id以及查询条件查询所有符合条件的市场活动 ， 注意应当去除那些已经关联过的市场活动
     * @param clueId 线索id
     * @param activityName 查询条件
     * @return  返回所有满足条件的市场活动的集合
     */
    List<Activity> getActivityListByNameAndNotRelation(@Param("clueId") String clueId, @Param("activityName") String activityName);
}
