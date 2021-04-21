package icu.junyao.crm.settings.service.impl;

import icu.junyao.crm.settings.dao.UserDao;
import icu.junyao.crm.settings.service.UserService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;

/**
 * @author wu
 */
@Service
public class UserServiceImpl implements UserService {
    @Resource
    private UserDao userDao;
}
