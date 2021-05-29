package icu.junyao.crm.workbench.service.impl;

import icu.junyao.crm.vo.PaginationVO;
import icu.junyao.crm.workbench.dao.TaskDao;
import icu.junyao.crm.workbench.dao.TaskRemarkDao;
import icu.junyao.crm.workbench.domain.Task;
import icu.junyao.crm.workbench.domain.TaskRemark;
import icu.junyao.crm.workbench.service.TaskService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author wu
 */
@Service
public class TaskServiceImpl implements TaskService {
    @Resource
    private TaskDao taskDao;
    @Resource
    private TaskRemarkDao taskRemarkDao;
    @Override
    public PaginationVO<Task> taskPageList(Map<String, Object> map) {
        List<Task> taskList = taskDao.taskPageList(map);
        int total = taskDao.taskPageListTotalNum(map);
        PaginationVO<Task> vo = new PaginationVO<>();
        vo.setTotal(total);
        vo.setDataList(taskList);
        return vo;
    }

    @Override
    public boolean taskSave(Task task) {
        return taskDao.save(task) == 1;
    }


    @Override
    public Task taskDetail(String id) {
        return taskDao.taskDetail(id);
    }

    @Override
    public boolean taskUpdate(Task task) {
        return taskDao.update(task) == 1;
    }

    @Override
    public String delete(String[] ids) {
        boolean flag = true;
        if (taskRemarkDao.getCountByTaskIds(ids) != taskRemarkDao.deleteByTaskIds(ids)) {
            flag = false;
        }
        if (taskDao.delete(ids) != ids.length) {
            flag = false;
        }
        return flag ? "true" : "false";
    }

    @Override
    public List<TaskRemark> getRemarkListByTaskId(String taskId) {
        return taskRemarkDao.getRemarkListByTaskId(taskId);
    }

    @Override
    public Map<String, Object> taskRemarkSave(TaskRemark taskRemark) {
        Map<String, Object> map = new HashMap<>(8);
        map.put("flag", taskRemarkDao.remarkSave(taskRemark) == 1);
        map.put("taskRemark", taskRemark);
        return map;
    }

    @Override
    public String taskRemoveRemark(String id) {
        return taskRemarkDao.removeRemarkById(id) == 1 ? "true" : "false";
    }

    @Override
    public Map<String, Object> taskUpdateRemark(TaskRemark taskRemark) {
        Map<String, Object> map = new HashMap<>(8);
        map.put("flag", taskRemarkDao.remarkUpdate(taskRemark) == 1);
        map.put("taskRemark", taskRemark);
        return map;
    }
}
