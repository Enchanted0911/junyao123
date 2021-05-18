package icu.junyao.crm.workbench.service.impl;

import icu.junyao.crm.utils.UUIDUtil;
import icu.junyao.crm.vo.PaginationVO;
import icu.junyao.crm.workbench.dao.CustomerDao;
import icu.junyao.crm.workbench.dao.TranDao;
import icu.junyao.crm.workbench.dao.TranHistoryDao;
import icu.junyao.crm.workbench.dao.TranRemarkDao;
import icu.junyao.crm.workbench.domain.Customer;
import icu.junyao.crm.workbench.domain.Tran;
import icu.junyao.crm.workbench.domain.TranHistory;
import icu.junyao.crm.workbench.service.TranService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
    @Resource
    private TranRemarkDao tranRemarkDao;

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

    @Override
    public PaginationVO<Tran> tranPageList(Map<String, Object> map) {
        List<Tran> contactsList = tranDao.tranPageList(map);
        int total = tranDao.tranPageListTotalNum(map);
        PaginationVO<Tran> vo = new PaginationVO<>();
        vo.setTotal(total);
        vo.setDataList(contactsList);
        return vo;
    }

    @Override
    public Tran tranDetail(String id) {
        return tranDao.tranDetail(id);
    }

    @Override
    public List<TranHistory> getHistoryListByTranId(String tranId) {
        return tranHistoryDao.getHistoryListByTranId(tranId);
    }

    @Override
    public boolean doChangeStage(Tran tran) {
        TranHistory tranHistory = new TranHistory();
        tranHistory.setId(UUIDUtil.getUUID());
        tranHistory.setCreateBy(tran.getEditBy());
        tranHistory.setCreateTime(tran.getEditTime());
        tranHistory.setMoney(tran.getMoney());
        tranHistory.setExpectedDate(tran.getExpectedDate());
        tranHistory.setTranId(tran.getId());
        tranHistory.setStage(tran.getStage());
        return tranDao.changeStage(tran) == 1 && tranHistoryDao.save(tranHistory) == 1;
    }

    @Override
    public Map<String, Object> getCharts() {
        Map<String, Object> map = new HashMap<>(8);
        map.put("total", tranDao.getTotal());
        map.put("dataList", tranDao.getCharts());
        return map;
    }

    @Override
    public List<Tran> getTransactionListByContactsId(String contactsId) {
        return tranDao.getTransactionListByContactsId(contactsId);
    }

    @Override
    public String delete(String[] ids) {
        boolean flag = true;
        if (tranRemarkDao.getCountByTranIds(ids) != tranRemarkDao.deleteByTranIds(ids)) {
            flag = false;
        }
        if (tranHistoryDao.getCountByTranIds(ids) != tranHistoryDao.delete(ids)) {
            flag = false;
        }
        if (tranDao.delete(ids) != ids.length) {
            flag = false;
        }
        return flag ? "true" : "false";
    }
}
