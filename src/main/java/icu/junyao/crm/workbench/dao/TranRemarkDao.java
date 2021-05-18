package icu.junyao.crm.workbench.dao;

/**
 * @author wu
 */
public interface TranRemarkDao {
    /**
     * 根据交易的id数组获取所有这些交易的备注条数
     * @param ids 交易id数组
     * @return 所有属于这些交易的备注条数
     */
    int getCountByTranIds(String[] ids);

    /**
     * 根据交易的id数组删除所有这些交易的备注
     * @param ids 交易id数组
     * @return 删除成功的条数
     */
    int deleteByTranIds(String[] ids);
}
