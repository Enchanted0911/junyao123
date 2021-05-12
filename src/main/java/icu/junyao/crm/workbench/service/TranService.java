package icu.junyao.crm.workbench.service;

import icu.junyao.crm.workbench.domain.Tran;

/**
 * @author wu
 */
public interface TranService {
    /**
     * 添加一条交易记录 这里需要把客户名称转为id 如果不存在这个客户就新建一个客户
     * 此外还要新增一条交易历史记录
     * @param tran 交易
     * @param customerName 客户名
     * @return true表示成功
     */
    boolean transactionSave(Tran tran, String customerName);
}
