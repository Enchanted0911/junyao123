package icu.junyao.crm.workbench.service;

import icu.junyao.crm.settings.domain.User;
import icu.junyao.crm.vo.PaginationVO;
import icu.junyao.crm.workbench.domain.Activity;
import icu.junyao.crm.workbench.domain.Clue;
import icu.junyao.crm.workbench.domain.Tran;

import java.util.List;
import java.util.Map;

/**
 * @author wu
 */
public interface ClueService {
    /**
     * 获取所有用户的列表
     * @return 返回包含所有用户的list集合
     */
    List<User> clueGetUserList();

    /**
     * 添加一条新建的线索
     * @param clue 线索
     * @return 返回字符串"true"表示成功
     */
    String clueSave(Clue clue);

    /**
     * 线索详情页列表功能, 提供分页等
     * @param map 包含查询的模糊条件以及要查询的页码
     * @return 返回一个包含总条数和线索集合的VO类
     */
    PaginationVO<Clue> cluePageList(Map<String, Object> map);

    /**
     * 根据id查询出单条线索记录
     * @param id id
     * @return 返回查询出的线索
     */
    Clue clueDetail(String id);

    /**
     * 根据关联关系表的id删除单条关联关系
     * @param id 关联关系的id
     * @return 返回"true" 表示成功
     */
    String unbind(String id);

    /**
     * 通过线索id以及需要绑定的市场活动id给线索新关联市场活动
     * @param clueId 线索id
     * @param activityIds 市场活动id 可能有多个
     * @return 返回"true" 表示成功
     */
    String bind(String clueId, String[] activityIds);

    /**
     * 线索转换
     * @param clueId 要转换的线索的id
     * @param tran 可能有新添加的交易
     * @param createBy 创建人
     * @return true时会返回到线索的index界面
     */
    boolean convert(String clueId, Tran tran, String createBy);

    /**
     * 通过线索id查询出该线索, 以及把用户表返回给修改线索的模态窗口
     * @param id 线索id
     * @return 返回的map包含一个线索和一个用户列表
     */
    Map<String, Object> getUserListAndClue(String id);

    /**
     * 提交对线索的修改操作
     * @param clue 被修改的线索
     * @return 返回"true"表示成功
     */
    String clueUpdate(Clue clue);
}
