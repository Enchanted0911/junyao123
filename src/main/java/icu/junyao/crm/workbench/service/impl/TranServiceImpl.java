package icu.junyao.crm.workbench.service.impl;

import icu.junyao.crm.utils.UUIDUtil;
import icu.junyao.crm.workbench.dao.CustomerDao;
import icu.junyao.crm.workbench.dao.TranDao;
import icu.junyao.crm.workbench.dao.TranHistoryDao;
import icu.junyao.crm.workbench.domain.Customer;
import icu.junyao.crm.workbench.domain.Tran;
import icu.junyao.crm.workbench.domain.TranHistory;
import icu.junyao.crm.workbench.service.TranService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;

/**
 * @author wu
 */
@Service
public class TranServiceImpl implements TranService {
    @Resource
    private TranDao tranDao;
    @Resource
    private TranHistoryDao tranHistoryDao;
    @Resource
    private CustomerDao customerDao;

    @Override
    public boolean transactionSave(Tran tran, String customerName) {
        boolean flag = true;
        Customer customer = customerDao.getCustomerByName(customerName);
        if (customer == null) {
            customer = new Customer();
            customer.setId(UUIDUtil.getUUID());
            customer.setName(customerName);
            customer.setCreateBy(tran.getCreateBy());
            customer.setCreateTime(tran.getCreateTime());
            customer.setContactSummary(tran.getContactSummary());
            customer.setNextContactTime(tran.getNextContactTime());
            customer.setOwner(tran.getOwner());
            if (customerDao.save(customer) != 1) {
                flag = false;
            }
        }
        tran.setCustomerId(customer.getId());
        if (tranDao.save(tran) != 1) {
            flag = false;
        }
        TranHistory tranHistory = new TranHistory();
        tranHistory.setId(UUIDUtil.getUUID());
        tranHistory.setCreateBy(tran.getCreateBy());
        tranHistory.setCreateTime(tran.getCreateTime());
        tranHistory.setMoney(tran.getMoney());
        tranHistory.setStage(tran.getStage());
        tranHistory.setTranId(tran.getId());
        tranHistory.setExpectedDate(tran.getExpectedDate());
        if (tranHistoryDao.save(tranHistory) != 1) {
            flag = false;
        }
        return flag;
    }
}
