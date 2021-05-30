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

    /**
     * 通过  登录/注册  账号查询是否存在该账号, 为注册功能提供
     * @param loginAct 要注册的账号
     * @return 返回查询的结果数量
     */
    int selectUserByAct(String loginAct);

    /**
     * 注册用户 添加一条用户信息
     * @param user 注册的用户
     * @return 返回 1 表示添加成功
     */
    int register(User user);

    /**
     * 通过用户id获取用户加密后的密码
     * @param id 用户id
     * @return 密码
     */
    String getPwdById(String id);

    /**
     * 更新用户密码
     * @param newPwd 加密后的新密码
     * @param id 用户id
     * @return 更新成功的条数
     */
    int updatePwd(@Param("newPwd") String newPwd, @Param("id") String id);
}
