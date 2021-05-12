package icu.junyao.crm.workbench.web.controller;

import icu.junyao.crm.settings.domain.User;
import icu.junyao.crm.utils.DateTimeUtil;
import icu.junyao.crm.utils.UUIDUtil;
import icu.junyao.crm.workbench.domain.Contacts;
import icu.junyao.crm.workbench.domain.Tran;
import icu.junyao.crm.workbench.service.ActivityService;
import icu.junyao.crm.workbench.service.ContactsService;
import icu.junyao.crm.workbench.service.CustomerService;
import icu.junyao.crm.workbench.service.TranService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.View;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.List;

/**
 * @author wu
 */
@Controller
@RequestMapping("/workbench/transaction")
public class TranController {
    @Resource
    private TranService tranService;
    @Resource
    private ActivityService activityService;
    @Resource
    private CustomerService customerService;
    @Resource
    private ContactsService contactsService;

    @ResponseBody
    @RequestMapping("/add.do")
    public ModelAndView gotoAddPage() {
        ModelAndView modelAndView = new ModelAndView();
        List<User> userList = activityService.activityGetUserList();
        modelAndView.addObject("userList", userList);
        modelAndView.setViewName("transaction/save");
        return modelAndView;
    }

    @ResponseBody
    @RequestMapping("/getCustomerName.do")
    public List<String> doGetCustomerName(String name) {
        return customerService.getCustomerName(name);
    }

    @ResponseBody
    @RequestMapping("/getContactsListByName.do")
    public List<Contacts> doGetContactsListByName(String contactsName) {
        return contactsService.getContactsListByName(contactsName);
    }


    @RequestMapping("/save.do")
    public String doSave(HttpServletRequest request, Tran tran, String customerName) {
        tran.setId(UUIDUtil.getUUID());
        tran.setCreateTime(DateTimeUtil.getSysTime());
        tran.setCreateBy(((User) request.getSession().getAttribute("user")).getName());
        return tranService.transactionSave(tran, customerName) ? "transaction/index" : null;
    }

}
