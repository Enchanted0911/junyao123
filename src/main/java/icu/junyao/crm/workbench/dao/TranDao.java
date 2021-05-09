package icu.junyao.crm.workbench.dao;

import icu.junyao.crm.workbench.domain.Tran;

/**
 * @author wu
 */
public interface TranDao {

    /**
     * 添加一条交易信息
     * @param tran 交易
     * @return 返回操作成功的条数
     */
    int save(Tran tran);
}
