package icu.junyao.crm.workbench.service.impl;

import icu.junyao.crm.settings.domain.User;
import icu.junyao.crm.utils.DateTimeUtil;
import icu.junyao.crm.vo.PaginationVO;
import icu.junyao.crm.workbench.dao.ActivityDao;
import icu.junyao.crm.workbench.dao.ActivityRemarkDao;
import icu.junyao.crm.workbench.domain.Activity;
import icu.junyao.crm.workbench.domain.ActivityRemark;
import icu.junyao.crm.workbench.service.ActivityService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author wu
 */
@Service
public class ActivityServiceImpl implements ActivityService {
    @Resource
    private ActivityDao activityDao;
    @Resource
    private ActivityRemarkDao activityRemarkDao;

    @Override
    public List<User> activityGetUserList() {
        return activityDao.activityGetUserList();
    }

    @Override
    public String activitySave(Activity activity) {
        int num = activityDao.activitySave(activity);
        return num == 1 ? "true" : "false";
    }

    @Override
    public PaginationVO<Activity> activityPageList(Map<String, Object> map) {
        var activityList = activityDao.activityPageList(map);
        int total = activityDao.activityPageListTotalNum(map);
        PaginationVO<Activity> vo = new PaginationVO<>();
        vo.setTotal(total);
        vo.setDataList(activityList);
        return vo;
    }

    @Override
    public boolean activityDelete(String[] ids) {
        boolean flag = true;
        int count01 = activityRemarkDao.getCountByActivityIds(ids);
        int count02 = activityRemarkDao.deleteByActivityIds(ids);
        if (count01 != count02) {
            flag = false;
        }
        int count03 = activityDao.activityDelete(ids);
        if (count03 != ids.length) {
            flag = false;
        }
        return flag;
    }

    @Override
    public Map<String, Object> activityRemarkSave(ActivityRemark activityRemark) {
        Map<String, Object> map = new HashMap<>(8);
        map.put("flag", activityRemarkDao.remarkSave(activityRemark) == 1);
        map.put("activityRemark", activityRemark);
        return map;
    }

    @Override
    public Map<String, Object> getUserListAndActivity(String id) {
        List<User> uList = activityDao.activityGetUserList();
        Activity activity = activityDao.getActivityById(id);
        Map<String, Object> map = new HashMap<>(2);
        map.put("uList", uList);
        map.put("activity", activity);
        return map;
    }

    @Override
    public String activityUpdate(Activity activity) {
        int num = activityDao.activityUpdate(activity);
        return num == 1 ? "true" : "false";
    }

    @Override
    public Activity activityDetail(String id) {
        return activityDao.activityDetail(id);
    }

    @Override
    public List<ActivityRemark> getRemarkListByActivityId(String activityId) {
        return activityRemarkDao.getRemarkListByActivityId(activityId);
    }

    @Override
    public String activityRemoveRemark(String id) {
        return activityRemarkDao.removeRemarkById(id) == 1 ? "true" : "false";
    }

    @Override
    public Map<String, Object> activityUpdateRemark(HttpServletRequest request, String id, String noteContent) {
        Map<String, Object> map = new HashMap<>(8);
        ActivityRemark activityRemark = new ActivityRemark();
        activityRemark.setId(id);
        activityRemark.setNoteContent(noteContent);
        activityRemark.setEditTime(DateTimeUtil.getSysTime());
        activityRemark.setEditBy(((User)request.getSession().getAttribute("user")).getName());
        activityRemark.setEditFlag("1");
        map.put("flag", activityRemarkDao.remarkUpdate(activityRemark) == 1);
        map.put("activityRemark", activityRemark);
        return map;
    }

    @Override
    public List<Activity> getActivityListByClueId(String clueId) {
        return activityDao.getActivityListByClueId(clueId);
    }

    @Override
    public List<Activity> getActivityListByNameAndNotRelation(String clueId, String activityName) {
        return activityDao.getActivityListByNameAndNotRelation(clueId, activityName);
    }
}
