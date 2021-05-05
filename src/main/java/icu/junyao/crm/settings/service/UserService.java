package icu.junyao.crm.settings.service;

import icu.junyao.crm.exception.LoginException;
import icu.junyao.crm.exception.RegisterException;
import icu.junyao.crm.settings.domain.User;

/**
 * @author wu
 */
public interface UserService {
    /**
     * 用户登录
     * @param loginAct 登录账号
     * @param loginPwd 登录密码(已加密)
     * @param ip 登录ip
     * @return 返回登录的用户
     * @throws LoginException 登录可能有多种异常产生 比如ip限制 账号冻结 密码错误 账号过期等
     */
    User login(String loginAct, String loginPwd, String ip) throws LoginException;

    /**
     * 注册用户
     * @param user 需要注册的用户
     * @throws RegisterException 可能会抛出账号已存在异常
     */
    void register(User user) throws RegisterException;
}
