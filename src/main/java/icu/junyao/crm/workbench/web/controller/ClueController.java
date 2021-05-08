package icu.junyao.crm.workbench.web.controller;

import icu.junyao.crm.settings.domain.User;
import icu.junyao.crm.utils.DateTimeUtil;
import icu.junyao.crm.utils.UUIDUtil;
import icu.junyao.crm.vo.PaginationVO;
import icu.junyao.crm.workbench.domain.Activity;
import icu.junyao.crm.workbench.domain.ActivityRemark;
import icu.junyao.crm.workbench.domain.Clue;
import icu.junyao.crm.workbench.service.ActivityService;
import icu.junyao.crm.workbench.service.ClueService;
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
@RequestMapping("/workbench/clue")
public class ClueController {
    @Resource
    private ClueService clueService;
    @Resource
    private ActivityService activityService;

    @ResponseBody
    @RequestMapping("/getUserList.do")
    public List<User> doClueGetUserList() {
        return clueService.clueGetUserList();
    }

    @ResponseBody
    @RequestMapping("/save.do")
    public String doSave(HttpServletRequest request, Clue clue) {
        clue.setId(UUIDUtil.getUUID());
        clue.setCreateTime(DateTimeUtil.getSysTime());
        clue.setCreateBy(((User) request.getSession().getAttribute("user")).getName());
        return clueService.clueSave(clue);
    }

    @ResponseBody
    @RequestMapping("/pageList.do")
    public PaginationVO<Clue> doCluePageList(int pageNo, int pageSize, String fullname, String company, String phone, String owner, String mphone, String state, String source) {
        int skipCount = (pageNo - 1) * pageSize;
        Map<String, Object> map = new HashMap<>(8);
        map.put("fullname", fullname);
        map.put("company", company);
        map.put("phone", phone);
        map.put("owner", owner);
        map.put("mphone", mphone);
        map.put("state", state);
        map.put("source", source);
        map.put("skipCount", skipCount);
        map.put("pageSize", pageSize);
        return clueService.cluePageList(map);
    }

    @ResponseBody
    @RequestMapping("/detail.do")
    public ModelAndView doClueDetail(String id) {
        ModelAndView modelAndView = new ModelAndView();
        Clue clue = clueService.clueDetail(id);
        modelAndView.addObject("clue", clue);
        modelAndView.setViewName("clue/detail");
        return modelAndView;
    }

    @ResponseBody
    @RequestMapping("/getActivityListByClueId.do")
    public List<Activity> doGetActivityListByClueId(String clueId) {
        return activityService.getActivityListByClueId(clueId);
    }

    @ResponseBody
    @RequestMapping("/unbind.do")
    public String doUnbind(String id) {
        return clueService.unbind(id);
    }

    @ResponseBody
    @RequestMapping("/getActivityListByNameAndNotRelation.do")
    public List<Activity> doGetActivityListByNameAndNotRelation(String clueId, String activityName) {
        return activityService.getActivityListByNameAndNotRelation(clueId, activityName);
    }

    @ResponseBody
    @RequestMapping("/bind.do")
    public String doBind(HttpServletRequest request) {
        String clueId = request.getParameter("clueId");
        String[] activityIds = request.getParameterValues("activityId");
        return clueService.bind(clueId, activityIds);
    }
}
