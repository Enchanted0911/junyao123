package icu.junyao.crm.settings.web.controller;

import icu.junyao.crm.settings.service.UserService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.annotation.Resource;

/**
 * @author wu
 */
@Controller
@RequestMapping("/settings")
public class UserController {
    @Resource
    private UserService userService;
}
