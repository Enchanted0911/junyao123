package icu.junyao.crm.settings.service.impl;

import icu.junyao.crm.settings.dao.DicTypeDao;
import icu.junyao.crm.settings.dao.DicValueDao;
import icu.junyao.crm.settings.service.DicService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;

/**
 * @author wu
 */
@Service
public class DicServiceImpl implements DicService {
    @Resource
    private DicTypeDao dicTypeDao;
    @Resource
    private DicValueDao dicValueDao;
}
