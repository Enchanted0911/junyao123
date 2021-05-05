package icu.junyao.crm.settings.service.impl;

import icu.junyao.crm.settings.dao.DicTypeDao;
import icu.junyao.crm.settings.dao.DicValueDao;
import icu.junyao.crm.settings.domain.DicType;
import icu.junyao.crm.settings.domain.DicValue;
import icu.junyao.crm.settings.service.DicService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author wu
 */
@Service
public class DicServiceImpl implements DicService {
    @Resource
    private DicTypeDao dicTypeDao;
    @Resource
    private DicValueDao dicValueDao;

    @Override
    public Map<String, List<DicValue>> getAll() {
        Map<String, List<DicValue>> map = new HashMap<>(16);
        List<DicType> dicTypeList = dicTypeDao.getTypeList();
        for (var dicType : dicTypeList) {
            var dicValueList = dicValueDao.getListByCode(dicType.getCode());
            map.put(dicType.getCode() + "List", dicValueList);
        }
        return map;
    }
}
