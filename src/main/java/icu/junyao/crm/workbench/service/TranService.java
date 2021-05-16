package icu.junyao.crm.workbench.service;

import icu.junyao.crm.vo.PaginationVO;
import icu.junyao.crm.workbench.domain.Tran;
import icu.junyao.crm.workbench.domain.TranHistory;

import java.util.List;
import java.util.Map;

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

    /**
     * 根据条件展示交易列表
     * @param map 包含需要展现的页码和每页条数
     * @return 符合条件的总条数以及需要展示在当前页的交易信息
     */
    PaginationVO<Tran> tranPageList(Map<String, Object> map);

    /**
     * 根据交易id获取一条交易的详细信息
     * @param id 交易id
     * @return 返回该交易
     */
    Tran tranDetail(String id);

    /**
     * 根据交易id获取所有该交易的交易历史
     * @param tranId 交易id
     * @return 返回交易历史列表
     */
    List<TranHistory> getHistoryListByTranId(String tranId);

    /**
     * 改变阶段操作
     * @param tran 需要改变阶段的交易
     * @return 返回true表示改变成功
     */
    boolean doChangeStage(Tran tran);

    /**
     * 交易统计图标获取数据
     * @return 返回map包含一个数据总条数以及分组查询后的每个阶段对应的总条数
     */
    Map<String, Object> getCharts();
}
