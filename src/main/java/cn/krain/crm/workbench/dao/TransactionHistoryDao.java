package cn.krain.crm.workbench.dao;

import cn.krain.crm.workbench.entity.TransactionHistory;

import java.util.List;

/**
 * @author CC
 * @data 2020/8/7 - 17:07
 */
public interface TransactionHistoryDao {
    List<TransactionHistory> selectTransactionHistoryList(String tranId);

    int insertOneTranHis(TransactionHistory transactionHistory);
}
