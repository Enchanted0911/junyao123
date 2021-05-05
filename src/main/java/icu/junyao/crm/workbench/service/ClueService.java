package icu.junyao.crm.workbench.service;

import icu.junyao.crm.settings.domain.User;

import java.util.List;

/**
 * @author wu
 */
public interface ClueService {
    /**
     * 获取所有用户的列表
     * @return 返回包含所有用户的list集合
     */
    List<User> clueGetUserList();
}
