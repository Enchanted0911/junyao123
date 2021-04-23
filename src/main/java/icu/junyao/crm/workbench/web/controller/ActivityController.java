package icu.junyao.crm.workbench.web.controller;

import icu.junyao.crm.workbench.service.ActivityService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.annotation.Resource;

/**
 * @author wu
 */
@Controller
@RequestMapping("/workbench")
public class ActivityController {
    @Resource
    private ActivityService activityService;
}
