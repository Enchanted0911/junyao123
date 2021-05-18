package icu.junyao.crm.workbench.dao;

import icu.junyao.crm.workbench.domain.Tran;

import java.util.List;
import java.util.Map;

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

    /**
     * 返回当前指定页所有交易的信息
     * @param map 包含当前页码, 每页的条数, 以及模糊查询信息
     * @return 返回所有符合条件的交易的信息
     */
    List<Tran> tranPageList(Map<String, Object> map);

    /**
     * 获得符合模糊查询规则的记录总条数
     * @param map 包含模糊查询规则
     * @return 总条数
     */
    int tranPageListTotalNum(Map<String, Object> map);

    /**
     * 根据id返回一条交易的详细信息
     * @param id 交易id
     * @return 对应的交易
     */
    Tran tranDetail(String id);

    /**
     * 改变一条交易的阶段
     * @param tran 要改变的交易
     * @return 返回修改成功的条数
     */
    int changeStage(Tran tran);

    /**
     * 获取所有的交易记录
     * @return 所有的交易记录条数
     */
    int getTotal();

    /**
     * 获取分组查询后的阶段 数量 的map 组成的list集合
     * @return 返回一个List包含map map包含阶段 数量的键值对
     */
    List<Map<String, Object>> getCharts();

    /**
     * 通过联系人id获取该联系人的所有交易
     * @param contactsId 联系人id
     * @return 返回属于该联系人的所有交易组成的集合
     */
    List<Tran> getTransactionListByContactsId(String contactsId);

    /**
     * 删除交易
     * @param ids 交易id
     * @return 返回修改成功的条数
     */
    int delete(String[] ids);
}
