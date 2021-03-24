package cn.krain.crm.workbench.service;

import cn.krain.crm.workbench.entity.Customer;

import java.util.List;

/**
 * @author CC
 * @data 2020/8/4 - 18:03
 */
public interface CustomerService {
    int addCustomer(Customer customer);

    List<Customer> queryCustomerByName(String name);
}
