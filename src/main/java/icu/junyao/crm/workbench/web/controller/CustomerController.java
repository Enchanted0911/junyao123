package icu.junyao.crm.workbench.web.controller;

import icu.junyao.crm.settings.domain.User;
import icu.junyao.crm.utils.DateTimeUtil;
import icu.junyao.crm.utils.UUIDUtil;
import icu.junyao.crm.vo.PaginationVO;
import icu.junyao.crm.workbench.dao.CustomerRemarkDao;
import icu.junyao.crm.workbench.domain.*;
import icu.junyao.crm.workbench.service.ContactsService;
import icu.junyao.crm.workbench.service.CustomerService;
import icu.junyao.crm.workbench.service.TranService;
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
@RequestMapping("/workbench/customer")
public class CustomerController {
    @Resource
    private CustomerService customerService;
    @Resource
    private TranService tranService;
    @Resource
    private ContactsService contactsService;

    @ResponseBody
    @RequestMapping("/pageList.do")
    public PaginationVO<Customer> doCustomerPageList(int pageNo, int pageSize, String name, String owner, String website, String phone) {
        int skipCount = (pageNo - 1) * pageSize;
        Map<String, Object> map = new HashMap<>(8);
        map.put("name", name);
        map.put("owner", owner);
        map.put("website", website);
        map.put("phone", phone);
        map.put("skipCount", skipCount);
        map.put("pageSize", pageSize);
        return customerService.customerPageList(map);
    }

    @ResponseBody
    @RequestMapping("/getUserList.do")
    public List<User> doCustomerGetUserList() {
        return customerService.customerGetUserList();
    }

    @ResponseBody
    @RequestMapping("/save.do")
    public String doCustomerSave(HttpServletRequest request, Customer customer) {
        customer.setId(UUIDUtil.getUUID());
        customer.setCreateTime(DateTimeUtil.getSysTime());
        customer.setCreateBy(((User)request.getSession().getAttribute("user")).getName());
        return customerService.customerSave(customer);
    }

    @ResponseBody
    @RequestMapping("/getUserListAndCustomer.do")
    public Map<String, Object> doGetUserListAndCustomer(String id) {
        // 这种情况复用率不高, 使用map打包
        return customerService.getUserListAndCustomer(id);
    }

    @ResponseBody
    @RequestMapping("/update.do")
    public String doCustomerUpdate(HttpServletRequest request, Customer customer) {
        customer.setEditTime(DateTimeUtil.getSysTime());
        customer.setEditBy(((User)request.getSession().getAttribute("user")).getName());
        return customerService.customerUpdate(customer);
    }

    @ResponseBody
    @RequestMapping("/delete.do")
    public String doCustomerDelete(HttpServletRequest request) {
        String[] ids = request.getParameterValues("id");
        boolean flag = customerService.customerDelete(ids);
        return flag ? "true" : "false";
    }

    @ResponseBody
    @RequestMapping("/detail.do")
    public ModelAndView doCustomerDetail(String id) {
        ModelAndView modelAndView = new ModelAndView();
        Customer customer = customerService.customerDetail(id);
        modelAndView.addObject("customer", customer);
        modelAndView.setViewName("customer/detail");
        return modelAndView;
    }

    @ResponseBody
    @RequestMapping("/getRemarkListByCustomerId.do")
    public List<CustomerRemark> doGetRemarkListByCustomerId(String customerId) {
        return customerService.getRemarkListByCustomerId(customerId);
    }

    @ResponseBody
    @RequestMapping("/remarkSave.do")
    public Map<String, Object> doCustomerRemarkSave(HttpServletRequest request, String noteContent, String customerId) {
        CustomerRemark customerRemark = new CustomerRemark();
        customerRemark.setCustomerId(customerId);
        customerRemark.setNoteContent(noteContent);
        customerRemark.setCreateBy(((User)request.getSession().getAttribute("user")).getName());
        customerRemark.setCreateTime(DateTimeUtil.getSysTime());
        customerRemark.setId(UUIDUtil.getUUID());
        customerRemark.setEditFlag("0");
        return customerService.customerRemarkSave(customerRemark);
    }

    @ResponseBody
    @RequestMapping("/removeRemark.do")
    public String doCustomerRemoveRemark(String id) {
        return customerService.customerRemoveRemark(id);
    }

    @ResponseBody
    @RequestMapping("/updateRemark.do")
    public Map<String, Object> doCustomerUpdateRemark(HttpServletRequest request, String id, String noteContent) {
        CustomerRemark customerRemark = new CustomerRemark();
        customerRemark.setId(id);
        customerRemark.setNoteContent(noteContent);
        customerRemark.setEditTime(DateTimeUtil.getSysTime());
        customerRemark.setEditBy(((User)request.getSession().getAttribute("user")).getName());
        customerRemark.setEditFlag("1");
        return customerService.customerUpdateRemark(customerRemark);
    }

    @ResponseBody
    @RequestMapping("/getTransactionListByCustomerId.do")
    public List<Tran> doGetTransactionListByCustomerId(HttpServletRequest request, String customerId) {
        Map<String, String> pMap = (Map<String, String>) request.getSession().getServletContext().getAttribute("pMap");
        List<Tran> tranList = tranService.getTransactionListByCustomerId(customerId);
        tranList.forEach(tran -> tran.setPossibility(pMap.get(tran.getStage())));
        return tranList;
    }

    @ResponseBody
    @RequestMapping("/getContactsListByCustomerId.do")
    public List<Contacts> doGetContactsListByCustomerId(String customerId) {
        return contactsService.getContactsListByCustomerId(customerId);
    }
}
