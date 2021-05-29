package icu.junyao.crm.workbench.dao;

import icu.junyao.crm.workbench.domain.TaskRemark;

import java.util.List;

/**
 * @author wu
 */
public interface TaskRemarkDao {
    /**
     * 根据任务的id数组获取所有这些任务的备注条数
     * @param ids 任务id数组
     * @return 所有属于这些任务的备注条数
     */
    int getCountByTaskIds(String[] ids);

    /**
     * 根据任务的id数组删除所有这些任务的备注
     * @param ids 任务id数组
     * @return 删除成功的条数
     */
    int deleteByTaskIds(String[] ids);

    /**
     * 通过任务ID取得所有备注信息
     * @param taskId 任务ID
     * @return 所有备注信息
     */
    List<TaskRemark> getRemarkListByTaskId(String taskId);

    /**
     * 添加一条备注信息给指定的任务
     * @param taskRemark 添加的备注信息
     * @return 返回 1 代表成功
     */
    int remarkSave(TaskRemark taskRemark);

    /**
     * 删除一条备注信息
     * @param id 备注 id
     * @return 修改成功的条数
     */
    int removeRemarkById(String id);

    /**
     * 更新一条任务备注
     * @param taskRemark 任务备注
     * @return 修改成功的条数
     */
    int remarkUpdate(TaskRemark taskRemark);
}
