package cn.krain.crm.workbench.service.impl;

import cn.krain.crm.workbench.dao.ContactsDao;
import cn.krain.crm.workbench.entity.Contacts;
import cn.krain.crm.workbench.service.ContactsService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;

/**
 * @author CC
 * @data 2020/8/4 - 18:02
 */
@Service
public class ContactsServiceImpl implements ContactsService {

    @Resource
    private ContactsDao contactsDao;

    @Override
    public int addContacts(Contacts contacts) {
        return contactsDao.insertContacts(contacts);
    }
}
