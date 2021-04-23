package icu.junyao.crm.settings.dao;

import icu.junyao.crm.settings.domain.User;
import org.apache.ibatis.annotations.Param;

/**
 * @author wu
 */
public interface UserDao {
    /**
     * 查询登录的用户
     * @param loginAct 登录账号
     * @param loginPwd 登录密码
     * @return 返回查询到的用户
     */
    User login(@Param("loginAct") String loginAct, @Param("loginPwd") String loginPwd);
}
