package icu.junyao.crm.workbench.dao;

import icu.junyao.crm.workbench.domain.Task;

import java.util.List;
import java.util.Map;

/**
 * @author wu
 */
public interface TaskDao {
    /**
     * 返回当前指定页所有任务的信息
     * @param map 包含当前页码, 每页的条数, 以及模糊查询信息
     * @return 返回所有符合条件的任务的信息
     */
    List<Task> taskPageList(Map<String, Object> map);

    /**
     * 获得符合模糊查询规则的记录总条数
     * @param map 包含模糊查询规则
     * @return 总条数
     */
    int taskPageListTotalNum(Map<String, Object> map);

    /**
     * 保存一条任务记录
     * @param task 任务
     * @return 但会保存成功的条数
     */
    int save(Task task);

    /**
     * 通过id得到一个任务的详细信息 此处把联系人id转换成联系人名称
     * @param id 任务id
     * @return 任务
     */
    Task taskDetail(String id);

    /**
     * 更新一条任务
     * @param task 被更新的任务
     * @return 返回更新成功的条数
     */
    int update(Task task);

    /**
     * 删除任务
     * @param ids 任务id
     * @return 返回修改成功的条数
     */
    int delete(String[] ids);
}
