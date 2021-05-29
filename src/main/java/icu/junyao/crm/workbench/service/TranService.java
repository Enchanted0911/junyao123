package icu.junyao.crm.workbench.service;

import icu.junyao.crm.settings.domain.User;
import icu.junyao.crm.vo.PaginationVO;
import icu.junyao.crm.workbench.domain.Tran;
import icu.junyao.crm.workbench.domain.TranHistory;
import icu.junyao.crm.workbench.domain.TranRemark;

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

    /**
     * 根据联系人的id查询相关联的交易 为联系人详情页的交易列表提供
     * @param contactsId 联系人ID
     * @return 返回属于该联系人的交易的集合
     */
    List<Tran> getTransactionListByContactsId(String contactsId);

    /**
     * 删除交易
     * @param ids 交易id
     * @return 返回"true"表示成功
     */
    String delete(String[] ids);

    /**
     * 得到用户列表
     * @return 所有用户列表
     */
    List<User> getUserList();

    /**
     * 更新一条交易信息
     * @param tran 交易
     * @param customerName 客户名称, 如果不存在则创建
     * @return 返回true表示成功
     */
    boolean transactionUpdate(Tran tran, String customerName);

    /**
     * 通过交易id获取交易备注
     * @param tranId 交易id
     * @return 返回交易备注集合
     */
    List<TranRemark> getRemarkListByTranId(String tranId);

    /**
     * 保存一条交易的备注信息
     * @param tranRemark 交易备注信息
     * @return map包含flag成功标记和保存的备注信息
     */
    Map<String, Object> tranRemarkSave(TranRemark tranRemark);

    /**
     * 删除一条交易备注信息
     * @param id 备注id
     * @return 返回"true"表示成功
     */
    String tranRemoveRemark(String id);

    /**
     * 更新一条交易备注
     * @param tranRemark 交易备注
     * @return 包含一个flag标记和修改后的交易备注
     */
    Map<String, Object> tranUpdateRemark(TranRemark tranRemark);

    /**
     * 根据客户的id查询相关联的交易 为客户详情页的交易列表提供
     * @param customerId 客户ID
     * @return 返回属于该客户的交易的集合
     */
    List<Tran> getTransactionListByCustomerId(String customerId);
}
