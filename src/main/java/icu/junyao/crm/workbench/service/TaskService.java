package icu.junyao.crm.workbench.service;

import icu.junyao.crm.vo.PaginationVO;
import icu.junyao.crm.workbench.domain.Task;
import icu.junyao.crm.workbench.domain.TaskRemark;

import java.util.List;
import java.util.Map;

/**
 * @author wu
 */
public interface TaskService {
    /**
     * 根据条件展示任务列表
     * @param map 包含需要展现的页码和每页条数
     * @return 符合条件的总条数以及需要展示在当前页的交易信息
     */
    PaginationVO<Task> taskPageList(Map<String, Object> map);

    /**
     * 添加一条任务记录
     * @param task 任务
     * @return true表示成功
     */
    boolean taskSave(Task task);

    /**
     * 通过任务id获取该任务的详细信息 此处把联系人id转成名称
     * @param id 任务id
     * @return 返回该任务
     */
    Task taskDetail(String id);

    /**
     * 更新一条任务
     * @param task 被更新的任务
     * @return true表示成功
     */
    boolean taskUpdate(Task task);

    /**
     * 删除任务
     * @param ids 任务id
     * @return 返回"true"表示成功
     */
    String delete(String[] ids);

    /**
     * 通过任务的ID取得该任务的所有备注信息
     * @param taskId 该任务的ID
     * @return 返回所有备注信息的集合
     */
    List<TaskRemark> getRemarkListByTaskId(String taskId);

    /**
     * 添加一条备注信息
     * @param taskRemark 需要添加的备注信息
     * @return 返回 大小为2的集合 第一个元素是判断是否成功 第二个是该备注
     */
    Map<String, Object> taskRemarkSave(TaskRemark taskRemark);

    /**
     * 删除一条任务备注信息
     * @param id 备注id
     * @return 返回"true"表示成功
     */
    String taskRemoveRemark(String id);

    /**
     * 更新一条任务备注
     * @param taskRemark 任务备注
     * @return 包含一个flag标记和修改后的任务备注
     */
    Map<String, Object> taskUpdateRemark(TaskRemark taskRemark);
}
