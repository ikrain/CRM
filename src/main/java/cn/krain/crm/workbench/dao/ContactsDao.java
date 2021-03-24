package cn.krain.crm.workbench.dao;

import cn.krain.crm.workbench.entity.Contacts;

/**
 * @author CC
 * @data 2020/8/4 - 17:53
 */
public interface ContactsDao {
    int insertContacts(Contacts contacts);

    Contacts selectOneContactsByName(String fullname);
}
