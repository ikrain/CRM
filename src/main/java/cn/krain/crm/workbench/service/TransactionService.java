package cn.krain.crm.workbench.service;

import cn.krain.crm.workbench.entity.Transaction;
import cn.krain.crm.workbench.entity.TransactionHistory;

import javax.servlet.http.HttpServletRequest;
import java.util.List;
import java.util.Map;

/**
 * @author CC
 * @data 2020/8/7 - 12:13
 */
public interface TransactionService {

    List<Transaction> queryTransactionList();

    Transaction queryDetailTransaction(HttpServletRequest request, String id);

    int addTransaction(HttpServletRequest request, Transaction transaction);

    List<TransactionHistory> queryTransactionHistoryList(String tranId);

    int changeTran(HttpServletRequest request, Transaction transaction);

    int getTranTotal();

    List<Map<String, Object>> getStageByGroup();
}
