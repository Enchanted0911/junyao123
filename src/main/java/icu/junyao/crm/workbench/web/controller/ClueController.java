package icu.junyao.crm.workbench.web.controller;

import icu.junyao.crm.settings.domain.User;
import icu.junyao.crm.workbench.service.ClueService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import java.util.List;

/**
 * @author wu
 */
@Controller
@RequestMapping("/workbench/clue")
public class ClueController {
    @Resource
    private ClueService clueService;
    @ResponseBody
    @RequestMapping("/getUserList.do")
    public List<User> doClueGetUserList() {
        return clueService.clueGetUserList();
    }
}
