package icu.junyao.crm.workbench.web.controller;

import icu.junyao.crm.settings.domain.User;
import icu.junyao.crm.utils.DateTimeUtil;
import icu.junyao.crm.utils.UUIDUtil;
import icu.junyao.crm.vo.PaginationVO;
import icu.junyao.crm.workbench.domain.Activity;
import icu.junyao.crm.workbench.service.ActivityService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author wu
 */
@Controller
@RequestMapping("/workbench")
public class ActivityController {
    @Resource
    private ActivityService activityService;

    @ResponseBody
    @RequestMapping("/activity/getUserList.do")
    public List<User> doActivityGetUserList() {
        return activityService.activityGetUserList();
    }
    @ResponseBody
    @RequestMapping("/activity/save.do")
    public String doActivitySave(HttpServletRequest request, Activity activity) {
        activity.setId(UUIDUtil.getUUID());
        activity.setCreateTime(DateTimeUtil.getSysTime());
        activity.setCreateBy(((User)request.getSession().getAttribute("user")).getName());
        return activityService.activitySave(activity);
    }
    @ResponseBody
    @RequestMapping("/activity/delete.do")
    public String doActivityDelete(HttpServletRequest request) {
        String[] ids = request.getParameterValues("id");
        boolean flag = activityService.activityDelete(ids);
        return flag ? "true" : "false";
    }
    @ResponseBody
    @RequestMapping("/activity/pageList.do")
    public PaginationVO<Activity> doActivityPageList(int pageNo, int pageSize, String name, String owner, String startDate, String endDate) {
        int skipCount = (pageNo - 1) * pageSize;
        Map<String, Object> map = new HashMap<>(8);
        map.put("name", name);
        map.put("owner", owner);
        map.put("startDate", startDate);
        map.put("endDate", endDate);
        map.put("skipCount", skipCount);
        map.put("pageSize", pageSize);
        return activityService.activityPageList(map);
    }
    @ResponseBody
    @RequestMapping("/activity/getUserListAndActivity.do")
    public Map<String, Object> doGetUserListAndActivity(HttpServletRequest request, String id) {
        // 这种情况复用率不高, 使用map打包
        return activityService.getUserListAndActivity(id);
    }

    @ResponseBody
    @RequestMapping("/activity/update.do")
    public String doActivityUpdate(HttpServletRequest request, Activity activity) {
        activity.setEditTime(DateTimeUtil.getSysTime());
        activity.setEditBy(((User)request.getSession().getAttribute("user")).getName());
        return activityService.activityUpdate(activity);
    }
}
