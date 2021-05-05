package icu.junyao.crm.web.handler;

import icu.junyao.crm.settings.domain.DicValue;
import icu.junyao.crm.settings.service.DicService;
import org.springframework.web.context.support.WebApplicationContextUtils;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import java.util.List;
import java.util.Map;
import java.util.Objects;

/**
 * @author wu
 */
public class MyListener implements ServletContextListener {
    private DicService dicService;
    @Override
    public void contextInitialized(ServletContextEvent sce) {
        dicService = Objects.requireNonNull(WebApplicationContextUtils.getWebApplicationContext(sce.getServletContext())).getBean(DicService.class);
        var applicationContext = sce.getServletContext();
        Map<String, List<DicValue>> map = dicService.getAll();
        for (var entry : map.entrySet()) {
            applicationContext.setAttribute(entry.getKey(), entry.getValue());
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        ServletContextListener.super.contextDestroyed(sce);
    }
}
