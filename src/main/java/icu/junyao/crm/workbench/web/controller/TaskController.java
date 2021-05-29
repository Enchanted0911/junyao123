package icu.junyao.crm.workbench.web.controller;

import icu.junyao.crm.settings.domain.User;
import icu.junyao.crm.utils.DateTimeUtil;
import icu.junyao.crm.utils.UUIDUtil;
import icu.junyao.crm.vo.PaginationVO;
import icu.junyao.crm.workbench.domain.*;
import icu.junyao.crm.workbench.service.ActivityService;
import icu.junyao.crm.workbench.service.TaskService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author wu
 */
@Controller
@RequestMapping("/workbench/visit")
public class TaskController {
    @Resource
    private TaskService taskService;
    @Resource
    private ActivityService activityService;
    @ResponseBody
    @RequestMapping("/pageList.do")
    public PaginationVO<Task> doTranPageList(int pageNo, int pageSize, String theme, String owner, String contactsName, String status, String expectedDate, String priority) {
        int skipCount = (pageNo - 1) * pageSize;
        Map<String, Object> map = new HashMap<>(16);
        map.put("theme", theme);
        map.put("owner", owner);
        map.put("contactsName", contactsName);
        map.put("status", status);
        map.put("expectedDate", expectedDate);
        map.put("priority", priority);
        map.put("skipCount", skipCount);
        map.put("pageSize", pageSize);
        return taskService.taskPageList(map);
    }

    @ResponseBody
    @RequestMapping("/add.do")
    public ModelAndView gotoAddPage() {
        ModelAndView modelAndView = new ModelAndView();
        List<User> userList = activityService.activityGetUserList();
        modelAndView.addObject("userList", userList);
        modelAndView.setViewName("visit/saveTask");
        return modelAndView;
    }

    @RequestMapping("/save.do")
    public String doSave(HttpServletRequest request, Task task) {
        task.setId(UUIDUtil.getUUID());
        task.setCreateTime(DateTimeUtil.getSysTime());
        task.setCreateBy(((User) request.getSession().getAttribute("user")).getName());
        return taskService.taskSave(task) ? "visit/index" : null;
    }

    @ResponseBody
    @RequestMapping("/getUserListAndTask.do")
    public ModelAndView getUserListAndTask(ModelAndView mv, String id) {
        Task task = taskService.taskDetail(id);
        mv.addObject("task", task);
        mv.addObject("uList", activityService.activityGetUserList());
        mv.setViewName("visit/editTask");
        return mv;
    }

    @RequestMapping("/update.do")
    public String doUpdate(HttpServletRequest request, Task task) {
        task.setEditTime(DateTimeUtil.getSysTime());
        task.setEditBy(((User) request.getSession().getAttribute("user")).getName());
        return taskService.taskUpdate(task) ? "visit/index" : null;
    }

    @ResponseBody
    @RequestMapping("/delete.do")
    public String doDelete(HttpServletRequest request) {
        String[] ids = request.getParameterValues("id");
        return taskService.delete(ids);
    }

    @ResponseBody
    @RequestMapping("/detail.do")
    public ModelAndView doTranDetail(String id) {
        ModelAndView modelAndView = new ModelAndView();
        Task task = taskService.taskDetail(id);
        modelAndView.addObject("task", task);
        modelAndView.setViewName("visit/detail");
        return modelAndView;
    }

    @ResponseBody
    @RequestMapping("/getRemarkListByTaskId.do")
    public List<TaskRemark> doGetRemarkListByTaskId(String taskId) {
        return taskService.getRemarkListByTaskId(taskId);
    }

    @ResponseBody
    @RequestMapping("/remarkSave.do")
    public Map<String, Object> doTaskRemarkSave(HttpServletRequest request, TaskRemark taskRemark) {
        taskRemark.setCreateBy(((User)request.getSession().getAttribute("user")).getName());
        taskRemark.setCreateTime(DateTimeUtil.getSysTime());
        taskRemark.setId(UUIDUtil.getUUID());
        taskRemark.setEditFlag("0");
        return taskService.taskRemarkSave(taskRemark);
    }

    @ResponseBody
    @RequestMapping("/removeRemark.do")
    public String doTaskRemoveRemark(String id) {
        return taskService.taskRemoveRemark(id);
    }

    @ResponseBody
    @RequestMapping("/updateRemark.do")
    public Map<String, Object> doTaskUpdateRemark(HttpServletRequest request, TaskRemark taskRemark) {
        taskRemark.setEditTime(DateTimeUtil.getSysTime());
        taskRemark.setEditBy(((User) request.getSession().getAttribute("user")).getName());
        taskRemark.setEditFlag("1");
        return taskService.taskUpdateRemark(taskRemark);
    }
}
