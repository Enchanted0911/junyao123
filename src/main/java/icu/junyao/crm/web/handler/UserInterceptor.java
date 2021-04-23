package icu.junyao.crm.web.handler;

import org.springframework.web.servlet.HandlerInterceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * @author wu
 */
public class UserInterceptor implements HandlerInterceptor {
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        String userSession = "user";
        if (request.getSession().getAttribute(userSession) == null) {
            response.sendRedirect(request.getContextPath()+"/static/crm/login.jsp");
            return false;
        }
        return true;
    }
}
