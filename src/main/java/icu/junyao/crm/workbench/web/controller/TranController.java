package icu.junyao.crm.workbench.web.controller;

import icu.junyao.crm.settings.domain.User;
import icu.junyao.crm.utils.DateTimeUtil;
import icu.junyao.crm.utils.UUIDUtil;
import icu.junyao.crm.vo.PaginationVO;
import icu.junyao.crm.workbench.domain.*;
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
    public ModelAndView gotoAddPage(HttpServletRequest request, Boolean flag) {
        ModelAndView modelAndView = new ModelAndView();
        List<User> userList = activityService.activityGetUserList();
        modelAndView.addObject("userList", userList);
        // flag为是否是联系人业务中的添加交易标记 true表示是
        modelAndView.addObject("flag", flag);
        // 如果是联系人业务中需要为特定联系人添加交易 则添加该联系人的id和名称
        if (flag) {
            modelAndView.addObject("id", request.getParameter("id"));
            modelAndView.addObject("fullname", request.getParameter("fullname"));
        }
        modelAndView.setViewName("transaction/save");
        return modelAndView;
    }

    @ResponseBody
    @RequestMapping("/cusAdd.do")
    public ModelAndView gotoAddPageForCus(HttpServletRequest request, Boolean flagCus) {
        ModelAndView modelAndView = new ModelAndView();
        List<User> userList = activityService.activityGetUserList();
        modelAndView.addObject("userList", userList);
        modelAndView.addObject("flagCus", true);
        modelAndView.addObject("flag", false);
        modelAndView.addObject("name", request.getParameter("name"));
        modelAndView.addObject("id", request.getParameter("id"));
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
    public String doSave(HttpServletRequest request, Tran tran, String customerName, Boolean flag, Boolean flagCus, String customerId) {
        tran.setId(UUIDUtil.getUUID());
        tran.setCreateTime(DateTimeUtil.getSysTime());
        tran.setCreateBy(((User) request.getSession().getAttribute("user")).getName());
        // 如果是联系人业务添加交易, 创建成功后返回联系人详情页
        if (flag && tranService.transactionSave(tran, customerName)) {
            return "redirect:/workbench/contacts/detail.do?id=" + tran.getContactsId() + "";
        }
        return tranService.transactionSave(tran, customerName) ? flagCus ? "redirect:/workbench/customer/detail.do?id=" + customerId + "" : "transaction/index" : null;
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
        tranHistoryList.forEach(th ->
                th.setPossibility(pMap.get(th.getStage()))
        );
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

    @ResponseBody
    @RequestMapping("/delete.do")
    public String doDelete(HttpServletRequest request) {
        String[] ids = request.getParameterValues("id");
        return tranService.delete(ids);
    }

    @ResponseBody
    @RequestMapping("/getUserListAndTran.do")
    public ModelAndView getUserListAndTran(HttpServletRequest request, ModelAndView mv, String id) {
        Tran tran = tranService.tranDetail(id);
        String possibility = ((Map<String, String>) request.getSession().getServletContext().getAttribute("pMap")).get(tran.getStage());
        tran.setPossibility(possibility);
        mv.addObject("tran", tran);
        mv.addObject("uList", tranService.getUserList());
        mv.setViewName("transaction/edit");
        return mv;
    }

    @RequestMapping("/update.do")
    public String doUpdate(HttpServletRequest request, Tran tran, String customerName) {
        tran.setEditTime(DateTimeUtil.getSysTime());
        tran.setEditBy(((User) request.getSession().getAttribute("user")).getName());
        return tranService.transactionUpdate(tran, customerName) ? "transaction/index" : null;
    }

    @ResponseBody
    @RequestMapping("/getRemarkListByTranId.do")
    public List<TranRemark> doGetRemarkListByTranId(String tranId) {
        return tranService.getRemarkListByTranId(tranId);
    }

    @ResponseBody
    @RequestMapping("/remarkSave.do")
    public Map<String, Object> doTranRemarkSave(HttpServletRequest request, String noteContent, String tranId) {
        TranRemark tranRemark = new TranRemark();
        tranRemark.setTranId(tranId);
        tranRemark.setNoteContent(noteContent);
        tranRemark.setCreateBy(((User) request.getSession().getAttribute("user")).getName());
        tranRemark.setCreateTime(DateTimeUtil.getSysTime());
        tranRemark.setId(UUIDUtil.getUUID());
        tranRemark.setEditFlag("0");
        return tranService.tranRemarkSave(tranRemark);
    }

    @ResponseBody
    @RequestMapping("/removeRemark.do")
    public String doTranRemoveRemark(String id) {
        return tranService.tranRemoveRemark(id);
    }

    @ResponseBody
    @RequestMapping("/updateRemark.do")
    public Map<String, Object> doTranUpdateRemark(HttpServletRequest request, String id, String noteContent) {
        TranRemark tranRemark = new TranRemark();
        tranRemark.setId(id);
        tranRemark.setNoteContent(noteContent);
        tranRemark.setEditTime(DateTimeUtil.getSysTime());
        tranRemark.setEditBy(((User) request.getSession().getAttribute("user")).getName());
        tranRemark.setEditFlag("1");
        return tranService.tranUpdateRemark(tranRemark);
    }
}
