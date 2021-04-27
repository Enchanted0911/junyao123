package icu.junyao.crm.workbench.service.impl;

import icu.junyao.crm.workbench.dao.ClueDao;
import icu.junyao.crm.workbench.service.ClueService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;

/**
 * @author wu
 */
@Service
public class ClueServiceImpl implements ClueService {
    @Resource
    private ClueDao clueDao;
}
