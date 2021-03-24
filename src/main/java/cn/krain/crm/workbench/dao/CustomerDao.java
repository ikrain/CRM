package cn.krain.crm.workbench.dao;

import cn.krain.crm.workbench.entity.Customer;

import java.util.List;

/**
 * @author CC
 * @data 2020/8/4 - 17:58
 */
public interface CustomerDao {
    int insertCustomer(Customer customer);

    List<Customer> selectCustomerByName(String name);

    Customer selectOneCustomer(String name);
}
