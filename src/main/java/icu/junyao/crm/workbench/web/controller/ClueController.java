package icu.junyao.crm.workbench.web.controller;

import icu.junyao.crm.settings.domain.User;
import icu.junyao.crm.utils.DateTimeUtil;
import icu.junyao.crm.utils.UUIDUtil;
import icu.junyao.crm.vo.PaginationVO;
import icu.junyao.crm.workbench.domain.*;
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
    @RequestMapping("/getActivityListByName.do")
    public List<Activity> getActivityListByName(String activityName) {
        return activityService.getActivityListByName(activityName);
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

    @ResponseBody
    @RequestMapping("/goConvert.do")
    public ModelAndView doGoConvert(Clue clue) {
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("clue", clue);
        modelAndView.setViewName("clue/convert");
        return modelAndView;
    }

    @ResponseBody
    @RequestMapping("/convert.do")
    public ModelAndView doConvert(HttpServletRequest request, String clueId, String flag, Tran tran) {
        // 当没有参数给tran接收时 tran对象仍然被创建 只不过它的属性值都为null
        ModelAndView modelAndView = new ModelAndView();
        String flag01 = "true";
        String createBy = ((User)request.getSession().getAttribute("user")).getName();
        if (flag01.equals(flag)) {
            tran.setId(UUIDUtil.getUUID());
            tran.setCreateTime(DateTimeUtil.getSysTime());
            tran.setCreateBy(createBy);
        }
        if (clueService.convert(clueId, tran, createBy)) {
            modelAndView.setViewName("clue/index");
        }
        return modelAndView;
    }

    @ResponseBody
    @RequestMapping("/getUserListAndClue.do")
    public Map<String, Object> doGetUserListAndActivity(String id) {
        // 这种情况复用率不高, 使用map打包
        return clueService.getUserListAndClue(id);
    }

    @ResponseBody
    @RequestMapping("/update.do")
    public String doClueUpdate(HttpServletRequest request, Clue clue) {
        clue.setEditTime(DateTimeUtil.getSysTime());
        clue.setEditBy(((User)request.getSession().getAttribute("user")).getName());
        return clueService.clueUpdate(clue);
    }

    @ResponseBody
    @RequestMapping("/delete.do")
    public String doClueDelete(HttpServletRequest request) {
        String[] ids = request.getParameterValues("id");
        boolean flag = clueService.clueDelete(ids);
        return flag ? "true" : "false";
    }

    @ResponseBody
    @RequestMapping("/getRemarkListByClueId.do")
    public List<ClueRemark> doGetRemarkListByClueId(String clueId) {
        return clueService.getClueRemarksByClueId(clueId);
    }

    @ResponseBody
    @RequestMapping("/remarkSave.do")
    public Map<String, Object> doClueRemarkSave(HttpServletRequest request, String noteContent, String clueId) {
        ClueRemark clueRemark = new ClueRemark();
        clueRemark.setClueId(clueId);
        clueRemark.setNoteContent(noteContent);
        clueRemark.setCreateBy(((User)request.getSession().getAttribute("user")).getName());
        clueRemark.setCreateTime(DateTimeUtil.getSysTime());
        clueRemark.setId(UUIDUtil.getUUID());
        clueRemark.setEditFlag("0");
        return clueService.clueRemarkSave(clueRemark);
    }

    @ResponseBody
    @RequestMapping("/updateRemark.do")
    public Map<String, Object> doClueUpdateRemark(HttpServletRequest request, String id, String noteContent) {
        return clueService.clueUpdateRemark(request, id, noteContent);
    }

    @ResponseBody
    @RequestMapping("/removeRemark.do")
    public String doClueRemoveRemark(String id) {
        return clueService.clueRemoveRemark(id);
    }
}
