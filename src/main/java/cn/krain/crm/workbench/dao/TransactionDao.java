package cn.krain.crm.workbench.dao;

import cn.krain.crm.workbench.entity.Transaction;

import java.util.List;
import java.util.Map;

/**
 * @author CC
 * @data 2020/8/6 - 17:16
 */
public interface TransactionDao {
    int insertTransaction(Transaction transaction);

    List<Transaction> selectTransactionList();

    Transaction selectDetailTransaction(String id);

    int insertDetailTransaction(Transaction transaction);

    int updateTransactionStage(Transaction transaction);

    int selectTotal();

    List<Map<String, Object>> selectTranByGroup();
}
