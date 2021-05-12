package icu.junyao.crm.web.handler;

import icu.junyao.crm.settings.domain.DicValue;
import icu.junyao.crm.settings.service.DicService;
import org.springframework.web.context.support.WebApplicationContextUtils;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import java.util.*;

/**
 * @author wu
 */
public class MyListener implements ServletContextListener {
    private DicService dicService;
    @Override
    public void contextInitialized(ServletContextEvent sce) {
        // 注意不能使用注解, 因为此时spring配置还没有生效
        dicService = Objects.requireNonNull(WebApplicationContextUtils.getWebApplicationContext(sce.getServletContext())).getBean(DicService.class);
        // 数据字典处理
        var applicationContext = sce.getServletContext();
        Map<String, List<DicValue>> map = dicService.getAll();
        for (var entry : map.entrySet()) {
            applicationContext.setAttribute(entry.getKey(), entry.getValue());
        }
        // 阶段可能性处理
        // 解析属性配置文件
        ResourceBundle resourceBundle = ResourceBundle.getBundle("Stage2Possibility");
        Map<String, String> pMap = new HashMap<>(16);
        Enumeration<String> keys = resourceBundle.getKeys();
        while (keys.hasMoreElements()) {
            String key = keys.nextElement();
            pMap.put(key, resourceBundle.getString(key));
        }
        applicationContext.setAttribute("pMap", pMap);
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        ServletContextListener.super.contextDestroyed(sce);
    }
}
