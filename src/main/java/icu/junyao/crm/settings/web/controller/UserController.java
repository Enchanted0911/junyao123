package icu.junyao.crm.settings.web.controller;

import com.fasterxml.jackson.databind.ext.SqlBlobSerializer;
import icu.junyao.crm.exception.LoginException;
import icu.junyao.crm.exception.RegisterException;
import icu.junyao.crm.settings.domain.User;
import icu.junyao.crm.settings.service.UserService;
import icu.junyao.crm.utils.DateTimeUtil;
import icu.junyao.crm.utils.MD5Util;
import icu.junyao.crm.utils.UUIDUtil;
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

    @ResponseBody
    @RequestMapping("/register.do")
    public Map register(HttpServletRequest request, String registerAct, String registerName, String registerPwd) throws RegisterException {
        Map<String, Object> map = new HashMap<>(2);
        String ip = request.getRemoteAddr();
        User user = new User();
        user.setId(UUIDUtil.getUUID());
        user.setAllowIps(ip + ", vanessa");
        user.setCreateBy(registerName);
        user.setCreateTime(DateTimeUtil.getSysTime());
        user.setEmail(registerAct);
        user.setLoginPwd(MD5Util.getMD5(registerPwd));
        user.setLoginAct(registerAct);
        user.setName(registerName);
        user.setExpireTime("2099-01-01 00:00:00");
        user.setLockState("1");
        user.setDeptno("A001");
        userService.register(user);
        request.getSession().setAttribute("user", user);
        map.put("success", true);
        map.put("view", "settings/workbenchIndex.do");
        return map;
    }

    @RequestMapping("/updatePwd.do")
    @ResponseBody
    public Map<String, Boolean> updatePwd(String oldPwd, String newPwd, String id) {
        Map<String, Boolean> map = new HashMap<>(8);
        oldPwd = MD5Util.getMD5(oldPwd);
        newPwd = MD5Util.getMD5(newPwd);
        if (oldPwd.equals(userService.getPwdById(id))) {
            map.put("flag", true);
            map.put("flag1", userService.updatePwd(newPwd, id) == 1);
        } else {
            map.put("flag", false);
        }
        return map;
    }

    @RequestMapping("/qxIndex.do")
    public String qxIndex() {
        return "qx/index";
    }
    @RequestMapping("/deptIndex.do")
    public String deptIndex() {
        return "dept/index";
    }
    @RequestMapping("/index.do")
    public String index() {
        return "settings/index";
    }


    @RequestMapping("/changeToRegister.do")
    public String changeToRegister() {
        return "register";
    }


    @RequestMapping("/activityIndex.do")
    public String activityIndex() {
        return "activity/index";
    }
    @RequestMapping("/activityDetail.do")
    public String activityDetail() {
        return "activity/detail";
    }


    @RequestMapping("/workbenchIndex.do")
    public String workbenchIndex() {
        return "workbench/index";
    }


    @RequestMapping("/mainIndex.do")
    public String mainIndex() {
        return "main/index";
    }


    @RequestMapping("/clueIndex.do")
    public String clueIndex() {
        return "clue/index";
    }
    @RequestMapping("/clueDetail.do")
    public String clueDetail() {
        return "clue/detail";
    }
    @RequestMapping("/clueConvert.do")
    public String clueConvert() {
        return "clue/convert";
    }


    @RequestMapping("/customerIndex.do")
    public String customerIndex() {
        return "customer/index";
    }


    @RequestMapping("/contactsDetail.do")
    public String contactsDetail() {
        return "contacts/detail";
    }
    @RequestMapping("/contactsIndex.do")
    public String contactsIndex() {
        return "contacts/index";
    }


    @RequestMapping("/transactionIndex.do")
    public String transactionIndex() {
        return "transaction/index";
    }
    @RequestMapping("/transactionDetail.do")
    public String transactionDetail() {
        return "transaction/detail";
    }
    @RequestMapping("/transactionSave.do")
    public String transactionSave() {
        return "transaction/save";
    }
    @RequestMapping("/transactionEdit.do")
    public String transactionEdit() {
        return "transaction/edit";
    }


    @RequestMapping("/visitIndex.do")
    public String visitIndex() {
        return "visit/index";
    }
    @RequestMapping("/visitEditTask.do")
    public String visitEditTask() {
        return "visit/editTask";
    }
    @RequestMapping("/visitSaveTask.do")
    public String visitSaveTask() {
        return "visit/saveTask";
    }
    @RequestMapping("/visitDetail.do")
    public String visitDetail() {
        return "visit/detail";
    }


    @RequestMapping("/chartActivity.do")
    public String chartActivity() {
        return "chart/activity/index";
    }
    @RequestMapping("/chartTransaction.do")
    public String chartTransaction() {
        return "chart/transaction/index";
    }
    @RequestMapping("/chartClue.do")
    public String chartClue() {
        return "chart/clue/index";
    }
    @RequestMapping("/chartCustomerAndContacts.do")
    public String chartCustomerAndContacts() {
        return "chart/customerAndContacts/index";
    }
}
