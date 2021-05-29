package icu.junyao.crm.workbench.service.impl;

import icu.junyao.crm.settings.domain.User;
import icu.junyao.crm.utils.UUIDUtil;
import icu.junyao.crm.vo.PaginationVO;
import icu.junyao.crm.workbench.dao.CustomerDao;
import icu.junyao.crm.workbench.dao.CustomerRemarkDao;
import icu.junyao.crm.workbench.domain.Activity;
import icu.junyao.crm.workbench.domain.Contacts;
import icu.junyao.crm.workbench.domain.Customer;
import icu.junyao.crm.workbench.domain.CustomerRemark;
import icu.junyao.crm.workbench.service.CustomerService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author wu
 */
@Service
public class CustomerServiceImpl implements CustomerService {
    @Resource
    private CustomerDao customerDao;
    @Resource
    private CustomerRemarkDao customerRemarkDao;

    @Override
    public List<String> getCustomerName(String name) {
        return customerDao.getCustomerNameLike(name);
    }

    @Override
    public PaginationVO<Customer> customerPageList(Map<String, Object> map) {
        var customerList = customerDao.customerPageList(map);
        int total = customerDao.customerPageListTotalNum(map);
        PaginationVO<Customer> vo = new PaginationVO<>();
        vo.setTotal(total);
        vo.setDataList(customerList);
        return vo;
    }

    @Override
    public List<User> customerGetUserList() {
        return customerDao.getUserList();
    }

    @Override
    public String customerSave(Customer customer) {
        return customerDao.save(customer) == 1 ? "true" : "false";
    }

    @Override
    public Map<String, Object> getUserListAndCustomer(String id) {
        List<User> uList = customerDao.getUserList();
        Customer customer = customerDao.getCustomerById(id);
        Map<String, Object> map = new HashMap<>(8);
        map.put("uList", uList);
        map.put("customer", customer);
        return map;
    }

    @Override
    public String customerUpdate(Customer customer) {
        return customerDao.customerUpdate(customer) == 1 ? "true" : "false";
    }

    @Override
    public boolean customerDelete(String[] ids) {
        boolean flag = true;
        int count01 = customerRemarkDao.getCountByCustomerIds(ids);
        int count02 = customerRemarkDao.deleteByCustomerIds(ids);
        if (count01 != count02) {
            flag = false;
        }
        int count03 = customerDao.customerDelete(ids);
        if (count03 != ids.length) {
            flag = false;
        }
        return flag;
    }

    @Override
    public Customer customerDetail(String id) {
        return customerDao.customerDetail(id);
    }

    @Override
    public List<CustomerRemark> getRemarkListByCustomerId(String customerId) {
        return customerRemarkDao.getRemarkListByCustomerId(customerId);
    }

    @Override
    public Map<String, Object> customerRemarkSave(CustomerRemark customerRemark) {
        Map<String, Object> map = new HashMap<>(8);
        map.put("flag", customerRemarkDao.remarkSave(customerRemark) == 1);
        map.put("customerRemark", customerRemark);
        return map;
    }

    @Override
    public String customerRemoveRemark(String id) {
        return customerRemarkDao.removeRemarkById(id) == 1 ? "true" : "false";
    }

    @Override
    public Map<String, Object> customerUpdateRemark(CustomerRemark customerRemark) {
        Map<String, Object> map = new HashMap<>(8);
        map.put("flag", customerRemarkDao.remarkUpdate(customerRemark) == 1);
        map.put("customerRemark", customerRemark);
        return map;
    }
}
