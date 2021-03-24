package cn.krain.crm.workbench.service.impl;

import cn.krain.crm.workbench.dao.CustomerDao;
import cn.krain.crm.workbench.entity.Customer;
import cn.krain.crm.workbench.service.CustomerService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

/**
 * @author CC
 * @data 2020/8/4 - 18:03
 */
@Service
public class CustomerServiceImpl implements CustomerService {

    @Resource
    private CustomerDao customerDao;

    @Override
    public int addCustomer(Customer customer) {
        return customerDao.insertCustomer(customer);
    }

    @Override
    public List<Customer> queryCustomerByName(String name) {
        return customerDao.selectCustomerByName(name);
    }
}
