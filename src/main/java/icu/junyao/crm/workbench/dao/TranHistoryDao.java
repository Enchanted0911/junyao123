package icu.junyao.crm.workbench.dao;

import icu.junyao.crm.workbench.domain.TranHistory;

import java.util.List;

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

    /**
     * 根据交易id返回所有该交易的交易历史
     * @param tranId 交易id
     * @return 交易历史列表
     */
    List<TranHistory> getHistoryListByTranId(String tranId);

    /**
     * 根据交易id删除所有这些交易的交易历史
     * @param ids 交易id数组
     * @return 返回删除成功的条数
     */
    int delete(String[] ids);

    /**
     * 根据交易的id数组返回所有这些交易的交易历史
     * @param ids 交易的id数组
     * @return 返回所有这些id的交易历史条数
     */
    int getCountByTranIds(String[] ids);
}
