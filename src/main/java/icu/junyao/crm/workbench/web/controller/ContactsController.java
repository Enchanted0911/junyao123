package icu.junyao.crm.workbench.web.controller;


import icu.junyao.crm.settings.domain.User;
import icu.junyao.crm.utils.DateTimeUtil;
import icu.junyao.crm.utils.UUIDUtil;
import icu.junyao.crm.vo.PaginationVO;
import icu.junyao.crm.workbench.domain.Activity;
import icu.junyao.crm.workbench.domain.Contacts;
import icu.junyao.crm.workbench.service.ContactsService;
import icu.junyao.crm.workbench.service.CustomerService;
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
@RequestMapping("/workbench/contacts")
public class ContactsController {
    @Resource
    private ContactsService contactsService;
    @Resource
    private CustomerService customerService;

    @ResponseBody
    @RequestMapping("/pageList.do")
    public PaginationVO<Contacts> doContactsPageList(int pageNo, int pageSize, String fullname, String owner, String birth, String source, String customerName) {
        int skipCount = (pageNo - 1) * pageSize;
        Map<String, Object> map = new HashMap<>(8);
        map.put("fullname", fullname);
        map.put("owner", owner);
        map.put("birth", birth);
        map.put("source", source);
        map.put("customerName", customerName);
        map.put("skipCount", skipCount);
        map.put("pageSize", pageSize);
        return contactsService.contactsPageList(map);
    }

    @ResponseBody
    @RequestMapping("/getUserList.do")
    public List<User> doContactsGetUserList() {
        return contactsService.contactsGetUserList();
    }

    @ResponseBody
    @RequestMapping("/save.do")
    public String doContactsSave(HttpServletRequest request, Contacts contacts, String customerName) {
        contacts.setId(UUIDUtil.getUUID());
        contacts.setCreateTime(DateTimeUtil.getSysTime());
        contacts.setCreateBy(((User)request.getSession().getAttribute("user")).getName());
        return contactsService.contactsSave(contacts, customerName);
    }

    @ResponseBody
    @RequestMapping("/getCustomerName.do")
    public List<String> doGetCustomerName(String name) {
        return customerService.getCustomerName(name);
    }

    @ResponseBody
    @RequestMapping("/getUserListAndContacts.do")
    public Map<String, Object> doGetUserListAndContacts(String id) {
        // 这种情况复用率不高, 使用map打包
        return contactsService.getUserListAndContacts(id);
    }

    @ResponseBody
    @RequestMapping("/update.do")
    public String doContactsUpdate(HttpServletRequest request, Contacts contacts, String customerName) {
        contacts.setEditTime(DateTimeUtil.getSysTime());
        contacts.setEditBy(((User)request.getSession().getAttribute("user")).getName());
        return contactsService.contactsUpdate(contacts, customerName);
    }

    @ResponseBody
    @RequestMapping("/delete.do")
    public String doContactsDelete(HttpServletRequest request) {
        String[] ids = request.getParameterValues("id");
        return contactsService.contactsDelete(ids) ? "true" : "false";
    }

    @ResponseBody
    @RequestMapping("/detail.do")
    public ModelAndView doActivityDetail(String id) {
        ModelAndView modelAndView = new ModelAndView();
        Contacts contacts = contactsService.contactsDetail(id);
        modelAndView.addObject("contacts", contacts);
        modelAndView.setViewName("contacts/detail");
        return modelAndView;
    }
}
