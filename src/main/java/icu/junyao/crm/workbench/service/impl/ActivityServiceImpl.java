package icu.junyao.crm.workbench.service.impl;

import icu.junyao.crm.workbench.dao.ActivityDao;
import icu.junyao.crm.workbench.service.ActivityService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;

/**
 * @author wu
 */
@Service
public class ActivityServiceImpl implements ActivityService {
    @Resource
    private ActivityDao activityDao;
}
