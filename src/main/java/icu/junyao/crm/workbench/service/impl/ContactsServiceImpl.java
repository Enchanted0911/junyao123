package icu.junyao.crm.workbench.service.impl;

import icu.junyao.crm.settings.domain.User;
import icu.junyao.crm.utils.DateTimeUtil;
import icu.junyao.crm.utils.UUIDUtil;
import icu.junyao.crm.vo.PaginationVO;
import icu.junyao.crm.workbench.dao.ContactsActivityRelationDao;
import icu.junyao.crm.workbench.dao.ContactsDao;
import icu.junyao.crm.workbench.dao.ContactsRemarkDao;
import icu.junyao.crm.workbench.dao.CustomerDao;
import icu.junyao.crm.workbench.domain.*;
import icu.junyao.crm.workbench.service.ContactsService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author wu
 */
@Service
public class ContactsServiceImpl implements ContactsService {
    @Resource
    private ContactsDao contactsDao;
    @Resource
    private ContactsRemarkDao contactsRemarkDao;
    @Resource
    private CustomerDao customerDao;
    @Resource
    private ContactsActivityRelationDao contactsActivityRelationDao;

    @Override
    public List<Contacts> getContactsListByName(String contactsName) {
        return contactsDao.getContactsListByName(contactsName);
    }

    @Override
    public PaginationVO<Contacts> contactsPageList(Map<String, Object> map) {
        var contactsList = contactsDao.contactsPageList(map);
        int total = contactsDao.contactsPageListTotalNum(map);
        PaginationVO<Contacts> vo = new PaginationVO<>();
        vo.setTotal(total);
        vo.setDataList(contactsList);
        return vo;
    }

    @Override
    public List<User> contactsGetUserList() {
        return contactsDao.contactsGetUserList();
    }

    @Override
    public String contactsSave(Contacts contacts, String customerName) {
        String flag = "true";
        Customer customer = customerDao.getCustomerByName(customerName);
        if (customer == null) {
            customer = new Customer();
            customer.setId(UUIDUtil.getUUID());
            customer.setName(customerName);
            customer.setCreateBy(contacts.getCreateBy());
            customer.setCreateTime(contacts.getCreateTime());
            customer.setContactSummary(contacts.getContactSummary());
            customer.setNextContactTime(contacts.getNextContactTime());
            customer.setOwner(contacts.getOwner());
            if (customerDao.save(customer) != 1) {
                flag = "false";
            }
        }
        contacts.setCustomerId(customer.getId());
        return contactsDao.save(contacts) == 1 ? flag : "false";
    }

    @Override
    public Map<String, Object> getUserListAndContacts(String id) {
        List<User> uList = contactsDao.contactsGetUserList();
        Contacts contacts = contactsDao.getContactsById(id);
        Map<String, Object> map = new HashMap<>(2);
        map.put("uList", uList);
        map.put("contacts", contacts);
        return map;
    }

    @Override
    public String contactsUpdate(Contacts contacts, String customerName) {
        String flag = "true";
        Customer customer = customerDao.getCustomerByName(customerName);
        contacts.setCreateBy(contactsDao.getCreateById(contacts.getId()));
        if (customer == null) {
            customer = new Customer();
            customer.setId(UUIDUtil.getUUID());
            customer.setName(customerName);
            customer.setCreateBy(contacts.getCreateBy());
            customer.setCreateTime(DateTimeUtil.getSysTime());
            customer.setContactSummary(contacts.getContactSummary());
            customer.setNextContactTime(contacts.getNextContactTime());
            customer.setOwner(contacts.getOwner());
            if (customerDao.save(customer) != 1) {
                flag = "false";
            }
        }
        contacts.setCustomerId(customer.getId());
        return contactsDao.update(contacts) == 1 ? flag : "false";
    }

    @Override
    public boolean contactsDelete(String[] ids) {
        boolean flag = true;
        int count01 = contactsRemarkDao.getCountByContactsIds(ids);
        int count02 = contactsRemarkDao.deleteByContactsIds(ids);
        if (count01 != count02) {
            flag = false;
        }
        int count03 = contactsDao.contactsDelete(ids);
        if (count03 != ids.length) {
            flag = false;
        }
        return flag;
    }

    @Override
    public Contacts contactsDetail(String id) {
        return contactsDao.contactsDetail(id);
    }

    @Override
    public List<ContactsRemark> getRemarkListByContactsId(String contactsId) {
        return contactsRemarkDao.getRemarkListByContactsId(contactsId);
    }

    @Override
    public Map<String, Object> contactsRemarkSave(ContactsRemark contactsRemark) {
        Map<String, Object> map = new HashMap<>(8);
        map.put("flag", contactsRemarkDao.remarkSave(contactsRemark) == 1);
        map.put("contactsRemark", contactsRemark);
        return map;
    }

    @Override
    public Map<String, Object> contactsUpdateRemark(ContactsRemark contactsRemark) {
        Map<String, Object> map = new HashMap<>(8);
        map.put("flag", contactsRemarkDao.remarkUpdate(contactsRemark) == 1);
        map.put("contactsRemark", contactsRemark);
        return map;
    }

    @Override
    public String contactsRemoveRemark(String id) {
        return contactsRemarkDao.removeRemarkById(id) == 1 ? "true" : "false";
    }

    @Override
    public String bind(String contactsId, String[] activityIds) {
        String flag = "true";
        for (String activityId : activityIds) {
            ContactsActivityRelation car = new ContactsActivityRelation();
            car.setId(UUIDUtil.getUUID());
            car.setContactsId(contactsId);
            car.setActivityId(activityId);
            if (contactsActivityRelationDao.save(car) != 1) {
                flag = "false";
            }
        }
        return flag;
    }

    @Override
    public String unbind(String id) {
        return contactsActivityRelationDao.unbind(id) == 1 ? "true" : "false";
    }
}
