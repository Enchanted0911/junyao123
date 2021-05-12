package icu.junyao.crm.workbench.service.impl;

import icu.junyao.crm.settings.domain.User;
import icu.junyao.crm.utils.DateTimeUtil;
import icu.junyao.crm.utils.UUIDUtil;
import icu.junyao.crm.vo.PaginationVO;
import icu.junyao.crm.workbench.dao.*;
import icu.junyao.crm.workbench.domain.*;
import icu.junyao.crm.workbench.service.ClueService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author wu
 */
@Service
public class ClueServiceImpl implements ClueService {
    @Resource
    private ClueDao clueDao;
    @Resource
    private ClueActivityRelationDao clueActivityRelationDao;
    @Resource
    private ClueRemarkDao clueRemarkDao;
    @Resource
    private CustomerDao customerDao;
    @Resource
    private CustomerRemarkDao customerRemarkDao;
    @Resource
    private ContactsDao contactsDao;
    @Resource
    private ContactsRemarkDao contactsRemarkDao;
    @Resource
    private ContactsActivityRelationDao contactsActivityRelationDao;
    @Resource
    private TranDao tranDao;
    @Resource
    private TranHistoryDao tranHistoryDao;

    @Override
    public List<User> clueGetUserList() {
        return clueDao.clueGetUserList();
    }

    @Override
    public String clueSave(Clue clue) {
        return clueDao.clueSave(clue) == 1 ? "true" : "false";
    }

    @Override
    public PaginationVO<Clue> cluePageList(Map<String, Object> map) {
        var clueList = clueDao.cluePageList(map);
        int total = clueDao.cluePageListTotalNum(map);
        PaginationVO<Clue> vo = new PaginationVO<>();
        vo.setTotal(total);
        vo.setDataList(clueList);
        return vo;
    }

    @Override
    public Clue clueDetail(String id) {
        return clueDao.clueDetail(id);
    }

    @Override
    public String unbind(String id) {
        return clueActivityRelationDao.unbind(id) == 1 ? "true" : "false";
    }

    @Override
    public String bind(String clueId, String[] activityIds) {
        String flag = "true";
        for (String activityId : activityIds) {
            ClueActivityRelation car = new ClueActivityRelation();
            car.setId(UUIDUtil.getUUID());
            car.setClueId(clueId);
            car.setActivityId(activityId);
            if (clueActivityRelationDao.bind(car) != 1) {
                flag = "false";
            }
        }
        return flag;
    }

    @Override
    public boolean convert(String clueId, Tran tran, String createBy) {
        boolean flag = true;
        String createTime = DateTimeUtil.getSysTime();
        Clue clue = clueDao.getClueById(clueId);
        String company = clue.getCompany();
        Customer customer = customerDao.getCustomerByName(company);
        if (customer == null) {
            customer = new Customer();
            customer.setId(UUIDUtil.getUUID());
            customer.setCreateBy(createBy);
            customer.setCreateTime(createTime);
            customer.setAddress(clue.getAddress());
            customer.setWebsite(clue.getWebsite());
            customer.setPhone(clue.getPhone());
            customer.setOwner(clue.getOwner());
            customer.setName(company);
            customer.setNextContactTime(clue.getNextContactTime());
            customer.setDescription(clue.getDescription());
            customer.setContactSummary(clue.getContactSummary());
            if (customerDao.save(customer) != 1) {
                flag = false;
            }
        }
        Contacts contacts = new Contacts();
        contacts.setId(UUIDUtil.getUUID());
        contacts.setSource(clue.getSource());
        contacts.setOwner(clue.getOwner());
        contacts.setNextContactTime(clue.getNextContactTime());
        contacts.setMphone(clue.getMphone());
        contacts.setJob(clue.getJob());
        contacts.setFullname(clue.getFullname());
        contacts.setEmail(clue.getEmail());
        contacts.setDescription(clue.getDescription());
        contacts.setCustomerId(customer.getId());
        contacts.setCreateBy(createBy);
        contacts.setCreateTime(createTime);
        contacts.setContactSummary(clue.getContactSummary());
        contacts.setAppellation(clue.getAppellation());
        contacts.setAddress(clue.getAddress());
        if (contactsDao.save(contacts) != 1) {
            flag = false;
        }
        List<ClueRemark> clueRemarkList = clueRemarkDao.getClueRemarksByClueId(clueId);
        for (ClueRemark clueRemark : clueRemarkList) {
            CustomerRemark customerRemark = new CustomerRemark();
            customerRemark.setId(UUIDUtil.getUUID());
            customerRemark.setCreateBy(createBy);
            customerRemark.setCreateTime(createTime);
            customerRemark.setCustomerId(customer.getId());
            customerRemark.setEditFlag("0");
            customerRemark.setNoteContent(clueRemark.getNoteContent());
            if (customerRemarkDao.save(customerRemark) != 1) {
                flag = false;
            }

            ContactsRemark contactsRemark = new ContactsRemark();
            contactsRemark.setId(UUIDUtil.getUUID());
            contactsRemark.setCreateBy(createBy);
            contactsRemark.setCreateTime(createTime);
            contactsRemark.setContactsId(contacts.getId());
            contactsRemark.setEditFlag("0");
            contactsRemark.setNoteContent(clueRemark.getNoteContent());
            if (contactsRemarkDao.save(contactsRemark) != 1) {
                flag = false;
            }
        }
        List<ClueActivityRelation> clueActivityRelationList = clueActivityRelationDao.getListByClueId(clueId);
        for (ClueActivityRelation clueActivityRelation : clueActivityRelationList) {
            ContactsActivityRelation contactsActivityRelation = new ContactsActivityRelation();
            contactsActivityRelation.setContactsId(contacts.getId());
            contactsActivityRelation.setId(UUIDUtil.getUUID());
            contactsActivityRelation.setActivityId(clueActivityRelation.getActivityId());
            if (contactsActivityRelationDao.save(contactsActivityRelation) != 1) {
                flag = false;
            }
        }
        if (tran.getId() != null) {
            tran.setSource(clue.getSource());
            tran.setOwner(clue.getOwner());
            tran.setNextContactTime(clue.getNextContactTime());
            tran.setDescription(clue.getDescription());
            tran.setCustomerId(customer.getId());
            tran.setContactSummary(clue.getContactSummary());
            tran.setContactsId(contacts.getId());
            if (tranDao.save(tran) != 1) {
                flag = false;
            }
            TranHistory tranHistory = new TranHistory();
            tranHistory.setId(UUIDUtil.getUUID());
            tranHistory.setCreateBy(createBy);
            tranHistory.setCreateTime(createTime);
            tranHistory.setMoney(tran.getMoney());
            tranHistory.setStage(tran.getStage());
            tranHistory.setTranId(tran.getId());
            tranHistory.setExpectedDate(tran.getExpectedDate());
            if (tranHistoryDao.save(tranHistory) != 1) {
                flag = false;
            }
        }
        for (ClueRemark clueRemark : clueRemarkList) {
            if (clueRemarkDao.delete(clueRemark.getId()) != 1) {
                flag = false;
            }
        }
        for (ClueActivityRelation clueActivityRelation : clueActivityRelationList) {
            if (clueActivityRelationDao.delete(clueActivityRelation) != 1) {
                flag = false;
            }
        }
        if (clueDao.delete(clueId) != 1) {
            flag = false;
        }
        return flag;
    }

    @Override
    public Map<String, Object> getUserListAndClue(String id) {
        List<User> uList = clueDao.clueGetUserList();
        Clue clue = clueDao.getClueById(id);
        Map<String, Object> map = new HashMap<>(8);
        map.put("uList", uList);
        map.put("clue", clue);
        return map;
    }

    @Override
    public String clueUpdate(Clue clue) {
        int num = clueDao.clueUpdate(clue);
        return num == 1 ? "true" : "false";
    }

    @Override
    public boolean clueDelete(String[] ids) {
        boolean flag = true;
        int count01 = clueRemarkDao.getCountByClueIds(ids);
        int count02 = clueRemarkDao.deleteByClueIds(ids);
        if (count01 != count02) {
            flag = false;
        }
        int count03 = clueDao.clueDelete(ids);
        if (count03 != ids.length) {
            flag = false;
        }
        return flag;
    }

    @Override
    public List<ClueRemark> getClueRemarksByClueId(String clueId) {
        return clueRemarkDao.getClueRemarksByClueId(clueId);
    }

    @Override
    public Map<String, Object> clueRemarkSave(ClueRemark clueRemark) {
        Map<String, Object> map = new HashMap<>(8);
        map.put("flag", clueRemarkDao.remarkSave(clueRemark) == 1);
        map.put("clueRemark", clueRemark);
        return map;
    }

    @Override
    public Map<String, Object> clueUpdateRemark(HttpServletRequest request, String id, String noteContent) {
        Map<String, Object> map = new HashMap<>(8);
        ClueRemark clueRemark = new ClueRemark();
        clueRemark.setId(id);
        clueRemark.setNoteContent(noteContent);
        clueRemark.setEditTime(DateTimeUtil.getSysTime());
        clueRemark.setEditBy(((User)request.getSession().getAttribute("user")).getName());
        clueRemark.setEditFlag("1");
        map.put("flag", clueRemarkDao.remarkUpdate(clueRemark) == 1);
        map.put("clueRemark", clueRemark);
        return map;
    }

    @Override
    public String clueRemoveRemark(String id) {
        return clueRemarkDao.removeRemarkById(id) == 1 ? "true" : "false";
    }
}
