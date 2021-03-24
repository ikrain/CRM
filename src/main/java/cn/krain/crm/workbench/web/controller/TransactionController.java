package cn.krain.crm.workbench.web.controller;

import cn.krain.crm.settings.entity.User;
import cn.krain.crm.settings.service.UserService;
import cn.krain.crm.util.DataTimeUtil;
import cn.krain.crm.util.PrintJson;
import cn.krain.crm.util.UUIDUtil;
import cn.krain.crm.workbench.dao.CustomerDao;
import cn.krain.crm.workbench.entity.Transaction;
import cn.krain.crm.workbench.entity.TransactionHistory;
import cn.krain.crm.workbench.service.CustomerService;
import cn.krain.crm.workbench.service.TransactionService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author CC
 * @data 2020/8/7 - 12:11
 */
@Controller
@RequestMapping("/transaction")
public class TransactionController {

    @Resource
    private TransactionService transactionService;

    @Resource
    private UserService userService;

    @Resource
    private CustomerService customerService;

    @RequestMapping("queryTransactionList.do")
    public void doQueryTransactionList(HttpServletResponse response) {
        PrintJson.printJsonObj(response, transactionService.queryTransactionList());
    }

    @RequestMapping("/detailTransaction.do")
    public ModelAndView doDetailTransaction(HttpServletRequest request, String id) {
        ModelAndView mv = new ModelAndView();
        Transaction transaction = transactionService.queryDetailTransaction(request, id);
        mv.addObject("transaction", transaction);
        mv.setViewName("transaction/detail");
        return mv;
    }

    @RequestMapping("/selectUser.do")
    public void doSelectUser(HttpServletResponse response) {
        PrintJson.printJsonObj(response, userService.queryUser());
    }

    @RequestMapping("/getCustomerName.do")
    public void doGetCustomerName(HttpServletResponse response, String name) {
        PrintJson.printJsonObj(response, customerService.queryCustomerByName(name));
    }

    @RequestMapping("/addOneTransaction.do")
    public ModelAndView doAddOneTransaction(HttpServletResponse response, HttpServletRequest request,
                                            Transaction transaction) {
        int nums = transactionService.addTransaction(request, transaction);
        ModelAndView mv = new ModelAndView();
        mv.setViewName("transaction/index");
        return mv;
    }

    @RequestMapping("/queryHistoryTranList.do")
    public void doQueryHistoryTranList(HttpServletResponse response, HttpServletRequest request,
                                       String tranId) {

        List<TransactionHistory> transactionHistory = transactionService.queryTransactionHistoryList(tranId);
        Map<String, String> pMap = (Map<String, String>) request.getServletContext().getAttribute("pMap");
        for (int i = 0; i < transactionHistory.size(); i++) {
            String stage = transactionHistory.get(i).getStage();
            transactionHistory.get(i).setPossibility(pMap.get(stage));
        }
        PrintJson.printJsonObj(response, transactionHistory);
    }

    @RequestMapping("/changeTran.do")
    public void doAddHistoryTran(HttpServletResponse response, HttpServletRequest request,
                                 Transaction transaction) {

        transactionService.changeTran(request, transaction);
        Map<String, String> pMap = (Map<String, String>) request.getServletContext().getAttribute("pMap");
        transaction.setPossibility(pMap.get(transaction.getStage()));
        User user = (User) request.getSession().getAttribute("user");
        transaction.setEditBy(user.getName());
        transaction.setEditTime(DataTimeUtil.getSysTime());
        Map<String, Object> map = new HashMap<>();
        map.put("success", true);
        map.put("transaction", transaction);
        PrintJson.printJsonObj(response, map);
    }

    @RequestMapping("/queryTranByGroup.do")
    public void doQueryTranByGroup(HttpServletResponse response) {
        int total = transactionService.getTranTotal();
        List<Map<String, Object>> dataList = transactionService.getStageByGroup();
        Map<String, Object> map = new HashMap<>();
        map.put("total", total);
        map.put("dataList", dataList);
        PrintJson.printJsonObj(response, map);
    }
}
