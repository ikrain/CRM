package cn.krain.crm.workbench.service.impl;

import cn.krain.crm.settings.entity.User;
import cn.krain.crm.util.DataTimeUtil;
import cn.krain.crm.util.UUIDUtil;
import cn.krain.crm.workbench.dao.*;
import cn.krain.crm.workbench.entity.*;
import cn.krain.crm.workbench.service.ClueService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.List;
import java.util.Map;

/**
 * @author CC
 * @data 2020/8/3 - 14:31
 */
@Service
public class ClueServiceImpl implements ClueService {

    @Resource
    private ClueDao clueDao;

    @Resource
    private ClueRemarkDao clueRemarkDao;

    @Resource
    private ClueActivityRelationDao clueActivityRelationDao;

    @Resource
    private ActivityDao activityDao;

    @Resource
    private CustomerDao customerDao;

    @Resource
    private CustomerRemarkDao customerRemarkDao;

    @Resource
    private ContactsDao contactsDao;

    @Resource
    private ContactsRemarkDao contactsRemarkDao;

    @Resource
    private ContactsActivityRelationDao contactsActivityRelationDao;

    @Resource
    private TransactionDao transactionDao;

    @Resource
    private TransactionHistoryDao transactionHistoryDao;

    @Override
    public int addClue(Clue clue) {
        return clueDao.insertClue(clue);
    }

    @Override
    public List<Clue> queryClueList() {
        return clueDao.selectClueList();
    }

    @Override
    public Clue queryDetailClue(String id) {
        return clueDao.selectOneClue(id);
    }

    @Override
    public List<Activity> queryClueActivity(String clueId) {
        return activityDao.selectClueActivity(clueId);
    }

    @Override
    public int delClueActivity(String id) {
        return clueDao.deleteClueActivity(id);
    }

    @Override
    public List<Activity> queryActivityByName(Map<String, String> map) {
        return activityDao.selectActivityByName(map);
    }


    @Override
    public int addActivityClueRelation(String[] activityId) {
        ClueActivityRelation car = new ClueActivityRelation();
        int num = 0;
        String clueId = activityId[0];
        for (int i = 1; i < activityId.length; i++) {
            car.setId(UUIDUtil.getUUID());

            car.setClueId(clueId);

            car.setActivityId(activityId[i]);

            num += clueDao.insertClueActivityRelation(car);
        }
        return num;
    }

    @Override
    public List<Activity> queryAllActivityByName(String name) {
        return activityDao.selectAllActivityByName(name);
    }


    //执行转换操作
    @Override
    public int convertClue(HttpServletRequest request,
                           String clueId, String flag, Transaction transaction) {
        //1、根据clueId获取clue信息
        Clue clue = clueDao.selectOneClue(clueId);

        //2、提取客户信息
        Customer customer = new Customer();
        customer.setId(UUIDUtil.getUUID());
        customer.setOwner(clue.getOwner());
        customer.setName(clue.getCompany());
        customer.setWebsite(clue.getWebsite());
        customer.setPhone(clue.getPhone());
        customer.setCreateBy(clue.getCreateBy());
        customer.setCreateTime(clue.getCreateTime());
        customer.setEditBy(clue.getEditBy());
        customer.setEditTime(clue.getEditTime());
        customer.setContactSummary(clue.getContactSummary());
        customer.setNextContactTime(clue.getNextContactTime());
        customer.setDescription(clue.getDescription());
        customer.setAddress(clue.getAddress());
//        System.out.println("customer："+customer.toString());
        customerDao.insertCustomer(customer);

        //3、提取联系人信息
        Contacts contacts = new Contacts();
        contacts.setId(UUIDUtil.getUUID());
        contacts.setOwner(clue.getOwner());
        contacts.setSource(clue.getSource());
        contacts.setCustomerId(customer.getId());
        contacts.setFullname(clue.getFullname());
        contacts.setAppellation(clue.getAppellation());
        contacts.setEmail(clue.getEmail());
        contacts.setMphone(clue.getMphone());
        contacts.setJob(clue.getJob());
        contacts.setBirth("");
        contacts.setCreateBy(clue.getCreateBy());
        contacts.setCreateTime(clue.getCreateTime());
        contacts.setEditBy(clue.getEditBy());
        contacts.setEditTime(clue.getEditTime());
        contacts.setDescription(clue.getDescription());
        contacts.setContactSummary(clue.getContactSummary());
        contacts.setNextContactTime(clue.getNextContactTime());
        contacts.setAddress(clue.getAddress());
//        System.out.println("contacts: "+contacts.toString());
        contactsDao.insertContacts(contacts);

        //4、线索备注转换到客户和联系人备注
        //获取线索备注
        List<ClueRemark> clueRemarkList = clueRemarkDao.selectClueRemark(clueId);
        //封装客户备注
        CustomerRemark customerRemark;
        for (int i = 0; i < clueRemarkList.size(); i++) {
            customerRemark = new CustomerRemark();
            customerRemark.setId(UUIDUtil.getUUID());
            customerRemark.setNoteContent(clueRemarkList.get(i).getNoteContent());
            customerRemark.setCreateBy(clueRemarkList.get(i).getCreateBy());
            customerRemark.setCreateTime(clueRemarkList.get(i).getCreateTime());
            customerRemark.setEditBy(clueRemarkList.get(i).getEditBy());
            customerRemark.setEditTime(clueRemarkList.get(i).getEditTime());
            customerRemark.setEditFlag(clueRemarkList.get(i).getEditFlag());
            customerRemark.setCustomerId(customer.getId());
            //System.out.println("customerRemark"+i+"："+customerRemark.toString());
            customerRemarkDao.insertCustomerRemark(customerRemark);
        }

        //封装联系人备注
        ContactsRemark contactsRemark;
        for (int i = 0; i < clueRemarkList.size(); i++) {
            contactsRemark = new ContactsRemark();
            contactsRemark.setId(UUIDUtil.getUUID());
            contactsRemark.setNoteContent(clueRemarkList.get(i).getNoteContent());
            contactsRemark.setCreateBy(clueRemarkList.get(i).getCreateBy());
            contactsRemark.setCreateTime(clueRemarkList.get(i).getCreateTime());
            contactsRemark.setEditBy(clueRemarkList.get(i).getEditBy());
            contactsRemark.setEditTime(clueRemarkList.get(i).getEditTime());
            contactsRemark.setEditFlag(clueRemarkList.get(i).getEditFlag());
            contactsRemark.setContactsId(contacts.getId());
            //System.out.println("contactsRemark"+i+"："+contactsRemark.toString());
            contactsRemarkDao.insertContactsRemark(contactsRemark);
        }

        //5、线索与市场活动的联系转换到联系人与市场活动
        List<ClueActivityRelation> carList = clueActivityRelationDao.selectCAR(clueId);
        ContactsActivityRelation contactsActivityRelation;
        for (int i = 0; i < carList.size(); i++) {
            contactsActivityRelation = new ContactsActivityRelation();
            contactsActivityRelation.setId(UUIDUtil.getUUID());
            contactsActivityRelation.setContactsId(contacts.getId());
            contactsActivityRelation.setActivityId(carList.get(i).getActivityId());
            //System.out.println("contactsActivityRelation："+contactsActivityRelation.toString());
            contactsActivityRelationDao.insertContactsActivityRelation(contactsActivityRelation);
        }

        //6、根据条件进行交易的创建（以及历史交易）
        if ("t".equals(flag)) {
            transaction.setId(UUIDUtil.getUUID());
            transaction.setOwner(clue.getOwner());
            transaction.setContactsId(contacts.getId());
            transaction.setCustomerId(customer.getId());
            User user = (User) request.getSession().getAttribute("user");
            transaction.setCreateBy(user.getName());
            transaction.setCreateTime(DataTimeUtil.getSysTime());
            //System.out.println("新建交易："+transaction.toString());
            transactionDao.insertTransaction(transaction);

            //添加一条该该交易下的历史交易
            TransactionHistory tranHis = new TransactionHistory();
            tranHis.setId(UUIDUtil.getUUID());
            tranHis.setStage(transaction.getStage());
            tranHis.setExpectedDate(transaction.getExpectedDate());
            tranHis.setMoney(transaction.getMoney());
            tranHis.setCreateBy(((User) request.getSession().getAttribute("user")).getName());
            tranHis.setCreateTime(DataTimeUtil.getSysTime());
            tranHis.setTranId(transaction.getId());
            transactionHistoryDao.insertOneTranHis(tranHis);
        }

        //7、删除线索备注（根据clueId删除）
        clueRemarkDao.deleteClueRemark(clueId);

        //8、删除市场活动关联
        clueActivityRelationDao.deleteCAR(clueId);

        //9、删除线索
        clueDao.deleteClue(clueId);

        return 0;
    }
}
