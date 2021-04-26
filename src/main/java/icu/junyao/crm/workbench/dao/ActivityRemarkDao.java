package icu.junyao.crm.workbench.dao;

import icu.junyao.crm.workbench.domain.Activity;
import icu.junyao.crm.workbench.domain.ActivityRemark;

import java.util.List;

/**
 * @author wu
 */
public interface ActivityRemarkDao {
    /**
     * 通过外键市场活动的ID查询关联的备注条数
     * @param ids 市场活动的ID
     * @return 备注数量
     */
    int getCountByActivityIds(String[] ids);

    /**
     * 通过外键删除备注表中的备注记录
     * @param ids 市场活动ID
     * @return 被删除的记录数
     */
    int deleteByActivityIds(String[] ids);

    /**
     * 通过市场活动ID取得所有备注信息
     * @param activityId 市场活动ID
     * @return 所有备注信息
     */
    List<ActivityRemark> getRemarkListByActivityId(String activityId);

    /**
     * 根据备注的id删除备注信息
     * @param id 备注的id
     * @return 返回操作成功的数量 1 表示成功
     */
    int removeRemarkById(String id);

    /**
     * 添加一条备注信息给指定的市场活动
     * @param activityRemark 添加的备注信息
     * @return 返回 1 代表成功
     */
    int remarkSave(ActivityRemark activityRemark);

    /**
     * 修改某条备注信息
     * @param activityRemark 要修改的备注, 这个实际上是修改后的备注, 现在要用这个备注更新数据库中的记录
     * @return 返回 1 表示修改成功
     */
    int remarkUpdate(ActivityRemark activityRemark);
}
