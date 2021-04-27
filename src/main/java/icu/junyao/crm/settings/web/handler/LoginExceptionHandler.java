package icu.junyao.crm.settings.web.handler;

import icu.junyao.crm.exception.LoginException;
import icu.junyao.crm.exception.RegisterException;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.Map;

/**
 * @author wu
 */
@ControllerAdvice
public class LoginExceptionHandler {
    @ResponseBody
    @ExceptionHandler(LoginException.class)
    public Map doLoginException(Exception e) {
        Map<String, Object> map = new HashMap<>(8);
        map.put("success", false);
        map.put("msg", e.getMessage());
        return map;
    }

    @ResponseBody
    @ExceptionHandler(RegisterException.class)
    public Map doRegisterException(Exception e) {
        Map<String, Object> map = new HashMap<>(8);
        map.put("success", false);
        map.put("msg", e.getMessage());
        return map;
    }
}
