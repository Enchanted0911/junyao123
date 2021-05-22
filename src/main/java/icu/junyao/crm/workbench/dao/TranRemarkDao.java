package icu.junyao.crm.workbench.dao;

import icu.junyao.crm.workbench.domain.TranRemark;

import java.util.List;

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

    /**
     * 获取交易备注
     * @param tranId 交易id
     * @return 交易备注集合
     */
    List<TranRemark> getRemarkListByTranId(String tranId);

    /**
     * 保存一条交易备注
     * @param tranRemark 交易备注
     * @return 操作成功条数
     */
    int remarkSave(TranRemark tranRemark);

    /**
     * 删除一条备注信息
     * @param id 备注 id
     * @return 修改成功的条数
     */
    int removeRemarkById(String id);

    /**
     * 更新一条交易备注
     * @param tranRemark 交易备注
     * @return 修改成功的条数
     */
    int remarkUpdate(TranRemark tranRemark);
}
