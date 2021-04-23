package icu.junyao.crm.settings.service.impl;

import icu.junyao.crm.exception.LoginException;
import icu.junyao.crm.settings.dao.UserDao;
import icu.junyao.crm.settings.domain.User;
import icu.junyao.crm.settings.service.UserService;
import icu.junyao.crm.utils.DateTimeUtil;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;

/**
 * @author wu
 */
@Service
public class UserServiceImpl implements UserService {
    @Resource
    private UserDao userDao;

    @Override
    public User login(String loginAct, String loginPwd, String ip) throws LoginException {
        User user = userDao.login(loginAct, loginPwd);
        String lock = "0";
        if (user == null) {
            throw new LoginException("账号密码错误!");
        }
        String expireTime = user.getExpireTime();
        String currentTime = DateTimeUtil.getSysTime();
        if (expireTime.compareTo(currentTime) < 0) {
            throw new LoginException("账号已失效");
        }
        String lockState = user.getLockState();
        if (lock.equals(lockState)) {
            throw new LoginException("账号已锁定");
        }
        String allowIps = user.getAllowIps();
        if (allowIps != null && !"".equals(allowIps) && !allowIps.contains(ip)) {
            throw new LoginException("您的ip地址被限制登录");
        }
        return user;
    }
}
