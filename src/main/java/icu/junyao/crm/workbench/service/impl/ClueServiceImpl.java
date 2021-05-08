package icu.junyao.crm.workbench.service.impl;

import icu.junyao.crm.settings.domain.User;
import icu.junyao.crm.utils.UUIDUtil;
import icu.junyao.crm.vo.PaginationVO;
import icu.junyao.crm.workbench.dao.ClueActivityRelationDao;
import icu.junyao.crm.workbench.dao.ClueDao;
import icu.junyao.crm.workbench.domain.Clue;
import icu.junyao.crm.workbench.domain.ClueActivityRelation;
import icu.junyao.crm.workbench.service.ClueService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;

/**
 * @author wu
 */
@Service
public class ClueServiceImpl implements ClueService {
    @Resource
    private ClueDao clueDao;
    @Resource
    private ClueActivityRelationDao clueActivityRelationDao;

    @Override
    public List<User> clueGetUserList() {
        return clueDao.clueGetUserList();
    }

    @Override
    public String clueSave(Clue clue) {
        return clueDao.clueSave(clue) == 1 ? "true" : "false";
    }

    @Override
    public PaginationVO<Clue> cluePageList(Map<String, Object> map) {
        var clueList = clueDao.cluePageList(map);
        int total = clueDao.cluePageListTotalNum(map);
        PaginationVO<Clue> vo = new PaginationVO<>();
        vo.setTotal(total);
        vo.setDataList(clueList);
        return vo;
    }

    @Override
    public Clue clueDetail(String id) {
        return clueDao.clueDetail(id);
    }

    @Override
    public String unbind(String id) {
        return clueActivityRelationDao.unbind(id) == 1 ? "true" : "false";
    }

    @Override
    public String bind(String clueId, String[] activityIds) {
        String flag = "true";
        for (String activityId : activityIds) {
            ClueActivityRelation car = new ClueActivityRelation();
            car.setId(UUIDUtil.getUUID());
            car.setClueId(clueId);
            car.setActivityId(activityId);
            if (clueActivityRelationDao.bind(car) != 1) {
                flag = "false";
            }
        }
        return flag;
    }
}
