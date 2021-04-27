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
     * @param loginAct
     * @param loginPwd
     * @param ip
     * @return
     * @throws LoginException
     */
    User login(String loginAct, String loginPwd, String ip) throws LoginException;

    /**
     * 注册用户
     * @param user 需要注册的用户
     * @throws RegisterException 可能会抛出账号已纯在异常
     */
    void register(User user) throws RegisterException;
}
