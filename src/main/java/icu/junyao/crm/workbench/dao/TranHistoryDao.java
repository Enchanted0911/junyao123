package icu.junyao.crm.workbench.dao;

import icu.junyao.crm.workbench.domain.TranHistory;

/**
 * @author wu
 */
public interface TranHistoryDao {

    /**
     * 新增一条交易历史, 一条交易可以对应多个交易历史, 一个交易历史只能对应一个交易
     * @param tranHistory 交易历史
     * @return 修改成功的条数
     */
    int save(TranHistory tranHistory);
}
