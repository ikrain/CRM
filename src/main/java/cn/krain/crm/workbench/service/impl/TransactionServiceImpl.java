package cn.krain.crm.workbench.service.impl;

import cn.krain.crm.settings.dao.UserDao;
import cn.krain.crm.settings.entity.User;
import cn.krain.crm.util.DataTimeUtil;
import cn.krain.crm.util.UUIDUtil;
import cn.krain.crm.workbench.dao.*;
import cn.krain.crm.workbench.entity.*;
import cn.krain.crm.workbench.service.TransactionService;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.annotation.Resource;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import java.util.List;
import java.util.Map;

/**
 * @author CC
 * @data 2020/8/7 - 12:13
 */
@Service
public class TransactionServiceImpl implements TransactionService {

    @Resource
    private TransactionDao transactionDao;

    @Resource
    private CustomerDao customerDao;

    @Resource
    private ActivityDao activityDao;

    @Resource
    private ContactsDao contactsDao;

    @Resource
    private UserDao userDao;

    @Resource
    private TransactionHistoryDao transactionHistoryDao;

    @Override
    public List<Transaction> queryTransactionList() {
        return transactionDao.selectTransactionList();
    }

    @Override
    public Transaction queryDetailTransaction(HttpServletRequest request, String id) {
        Transaction transaction = transactionDao.selectDetailTransaction(id);
        String stage = transaction.getStage();
        Map<String, String> map = (Map<String, String>) request.getServletContext().getAttribute("pMap");
        transaction.setPossibility(map.get(stage));
        return transaction;
    }

    @Override
    public int addTransaction(HttpServletRequest request, Transaction transaction) {
        transaction.setId(UUIDUtil.getUUID());

        //将customer、contacts、activity名字转换为对应的id
        User owner = userDao.selectUserById(transaction.getOwner());
        transaction.setOwner(owner.getName());

        Customer customer = customerDao.selectOneCustomer(transaction.getCustomerId());
        transaction.setCustomerId(customer.getId());

        Activity activity = activityDao.selectOneActivityByName(transaction.getActivityId());
        transaction.setActivityId(activity.getId());

        Contacts contacts = contactsDao.selectOneContactsByName(transaction.getContactsId());
        transaction.setContactsId(contacts.getId());

        transaction.setCreateTime(DataTimeUtil.getSysTime());

        User user = (User) request.getSession().getAttribute("user");

        transaction.setCreateBy(user.getName());

        int nums = transactionDao.insertDetailTransaction(transaction);
        return nums;
    }

    @Override
    public List<TransactionHistory> queryTransactionHistoryList(String tranId) {
        return transactionHistoryDao.selectTransactionHistoryList(tranId);
    }

    @Override
    public int changeTran(HttpServletRequest request, Transaction transaction) {

        //更新交易状态
        int nums = transactionDao.updateTransactionStage(transaction);

        //添加交易历史
        TransactionHistory transactionHistory = new TransactionHistory();
        transactionHistory.setId(UUIDUtil.getUUID());
        transactionHistory.setCreateTime(DataTimeUtil.getSysTime());
        User user = (User) (request.getSession().getAttribute("user"));
        transactionHistory.setCreateBy(user.getName());
        transactionHistory.setTranId(transaction.getId());
        transactionHistory.setMoney(transaction.getMoney());
        transactionHistory.setExpectedDate(transaction.getExpectedDate());
        transactionHistory.setStage(transaction.getStage());
        transactionHistoryDao.insertOneTranHis(transactionHistory);
        return nums;
    }

    @Override
    public int getTranTotal() {
        return transactionDao.selectTotal();
    }

    @Override
    public List<Map<String, Object>> getStageByGroup() {
        return transactionDao.selectTranByGroup();
    }


}
