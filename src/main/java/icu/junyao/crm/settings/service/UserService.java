package icu.junyao.crm.settings.service;

import icu.junyao.crm.exception.LoginException;
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
}
