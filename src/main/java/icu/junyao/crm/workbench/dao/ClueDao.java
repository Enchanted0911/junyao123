package icu.junyao.crm.workbench.dao;

import icu.junyao.crm.settings.domain.User;
import icu.junyao.crm.workbench.domain.Clue;

import java.util.List;
import java.util.Map;

/**
 * @author wu
 */
public interface ClueDao {

    /**
     * 查询所有用户
     * @return 返回包含所有用户的集合
     */
    List<User> clueGetUserList();

    /**
     * 添加一条线索
     * @param clue 线索
     * @return 返回修改成功记录的条数
     */
    int clueSave(Clue clue);

    /**
     * 根据查询条件查询出指定页满足条件的线索
     * @param map 包含了查询条件
     * @return 返回指定页的线索集合
     */
    List<Clue> cluePageList(Map<String, Object> map);

    /**
     * 查询满足条件的线索记录的总条数
     * @param map 包含了查询条件
     * @return 返回查询到的条数
     */
    int cluePageListTotalNum(Map<String, Object> map);

    /**
     * 根据id查询出单条线索
     * @param id 被查询的线索的id
     * @return 返回查询出的线索
     */
    Clue clueDetail(String id);
}
