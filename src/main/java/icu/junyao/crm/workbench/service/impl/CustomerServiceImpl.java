package icu.junyao.crm.workbench.service.impl;

import icu.junyao.crm.workbench.dao.CustomerDao;
import icu.junyao.crm.workbench.service.CustomerService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

/**
 * @author wu
 */
@Service
public class CustomerServiceImpl implements CustomerService {
    @Resource
    private CustomerDao customerDao;

    @Override
    public List<String> getCustomerName(String name) {
        return customerDao.getCustomerNameLike(name);
    }
}
