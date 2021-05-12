package icu.junyao.crm.workbench.service.impl;

import icu.junyao.crm.workbench.dao.ContactsDao;
import icu.junyao.crm.workbench.domain.Contacts;
import icu.junyao.crm.workbench.service.ContactsService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

/**
 * @author wu
 */
@Service
public class ContactsServiceImpl implements ContactsService {
    @Resource
    private ContactsDao contactsDao;

    @Override
    public List<Contacts> getContactsListByName(String contactsName) {
        return contactsDao.getContactsListByName(contactsName);
    }
}
