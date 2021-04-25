package icu.junyao.crm.workbench.service.impl;

import icu.junyao.crm.settings.dao.UserDao;
import icu.junyao.crm.settings.domain.User;
import icu.junyao.crm.vo.PaginationVO;
import icu.junyao.crm.workbench.dao.ActivityDao;
import icu.junyao.crm.workbench.dao.ActivityRemarkDao;
import icu.junyao.crm.workbench.domain.Activity;
import icu.junyao.crm.workbench.service.ActivityService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
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
}
