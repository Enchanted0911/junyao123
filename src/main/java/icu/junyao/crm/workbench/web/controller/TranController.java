package icu.junyao.crm.workbench.web.controller;

import icu.junyao.crm.settings.domain.User;
import icu.junyao.crm.utils.DateTimeUtil;
import icu.junyao.crm.utils.UUIDUtil;
import icu.junyao.crm.vo.PaginationVO;
import icu.junyao.crm.workbench.domain.Contacts;
import icu.junyao.crm.workbench.domain.Tran;
import icu.junyao.crm.workbench.domain.TranHistory;
import icu.junyao.crm.workbench.service.ActivityService;
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

    @ResponseBody
    @RequestMapping("/pageList.do")
    public PaginationVO<Tran> doTranPageList(int pageNo, int pageSize, String name, String owner, String contactsName, String source, String customerName, String stage, String type) {
        int skipCount = (pageNo - 1) * pageSize;
        Map<String, Object> map = new HashMap<>(8);
        map.put("name", name);
        map.put("owner", owner);
        map.put("contactsName", contactsName);
        map.put("source", source);
        map.put("stage", stage);
        map.put("type", type);
        map.put("customerName", customerName);
        map.put("skipCount", skipCount);
        map.put("pageSize", pageSize);
        return tranService.tranPageList(map);
    }

    @ResponseBody
    @RequestMapping("/detail.do")
    public ModelAndView doTranDetail(HttpServletRequest request, String id) {
        ModelAndView modelAndView = new ModelAndView();
        Tran tran = tranService.tranDetail(id);
        String possibility = ((Map<String, String>) request.getSession().getServletContext().getAttribute("pMap")).get(tran.getStage());
        tran.setPossibility(possibility);
        modelAndView.addObject("tran", tran);
        modelAndView.setViewName("transaction/detail");
        return modelAndView;
    }

    @ResponseBody
    @RequestMapping("/getHistoryListByTranId.do")
    public List<TranHistory> doGetHistoryListByTranId(HttpServletRequest request, String tranId) {
        List<TranHistory> tranHistoryList = tranService.getHistoryListByTranId(tranId);
        Map<String, String> pMap = (Map<String, String>) request.getSession().getServletContext().getAttribute("pMap");
        tranHistoryList.forEach(th -> {
            th.setPossibility(pMap.get(th.getStage()));
        });
        return tranHistoryList;
    }

    @ResponseBody
    @RequestMapping("/changeStage.do")
    public Map<String, Object> doChangeStage(HttpServletRequest request, Tran tran) {
        tran.setEditBy(((User) request.getSession().getAttribute("user")).getName());
        tran.setEditTime(DateTimeUtil.getSysTime());
        Map<String, Object> map = new HashMap<>(8);
        Map<String, String> pMap = (Map<String, String>) request.getSession().getServletContext().getAttribute("pMap");
        tran.setPossibility(pMap.get(tran.getStage()));
        map.put("success", tranService.doChangeStage(tran));
        map.put("tran", tran);
        return map;
    }

    @ResponseBody
    @RequestMapping("/getCharts.do")
    public Map<String, Object> doGetCharts() {
        return tranService.getCharts();
    }
}
