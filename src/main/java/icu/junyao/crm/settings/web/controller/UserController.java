package icu.junyao.crm.settings.web.controller;

import icu.junyao.crm.exception.LoginException;
import icu.junyao.crm.settings.domain.User;
import icu.junyao.crm.settings.service.UserService;
import icu.junyao.crm.utils.MD5Util;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.Map;

/**
 * @author wu
 */
@Controller
@RequestMapping("/settings")
public class UserController {
    @Resource
    private UserService userService;

    @ResponseBody
    @RequestMapping("/login.do")
    public Map login(HttpServletRequest request, String loginAct, String loginPwd) throws LoginException {
        Map<String, Object> map = new HashMap<>(2);
        loginPwd = MD5Util.getMD5(loginPwd);
        String ip = request.getRemoteAddr();
        User user = userService.login(loginAct, loginPwd, ip);
        request.getSession().setAttribute("user", user);
        map.put("success", true);
        map.put("view", "settings/workbenchIndex.do");
        return map;
    }
    @RequestMapping("/activityIndex.do")
    public String activityIndex() {
        return "activity/index";
    }
    @RequestMapping("/workbenchIndex.do")
    public String workbenchIndex() {
        return "workbench/index";
    }
    @RequestMapping("/mainIndex.do")
    public String mainIndex() {
        return "main/index";
    }
}
