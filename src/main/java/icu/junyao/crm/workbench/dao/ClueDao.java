package icu.junyao.crm.workbench.dao;

import icu.junyao.crm.settings.domain.User;

import java.util.List;

/**
 * @author wu
 */
public interface ClueDao {

    /**
     * 查询所有用户
     * @return 返回包含所有用户的集合
     */
    List<User> clueGetUserList();
}
