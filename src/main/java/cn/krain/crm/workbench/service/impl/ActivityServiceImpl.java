package cn.krain.crm.workbench.service.impl;

import cn.krain.crm.settings.dao.UserDao;
import cn.krain.crm.settings.entity.User;
import cn.krain.crm.vo.PaginationVO;
import cn.krain.crm.workbench.dao.ActivityDao;
import cn.krain.crm.workbench.entity.Activity;
import cn.krain.crm.workbench.service.ActivityService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author CC
 * @data 2020/7/29 - 17:08
 */
@Service
public class ActivityServiceImpl implements ActivityService {

    @Resource
    private ActivityDao activityDao;

    @Resource
    private UserDao userDao;

    @Override
    public int addActivity(Activity activity) {
        return activityDao.insertActivity(activity);
    }

    @Override
    public PaginationVO queryActivity(Map<String, Object> map) {

        List<Activity> activityList = activityDao.selectActivity(map);  //获取市场活动列表

        int total = activityDao.selectActivityTotal(map);   //获取市场活动总数

        PaginationVO paginationVO = new PaginationVO();     //封装数据，方便发送到前端
        paginationVO.setTotal(total);
        paginationVO.setActivityList(activityList);

        return paginationVO;    //返回VO
    }

    @Override
    public int delActivity(String[] id) {
        return activityDao.deleteActivity(id);
    }

    @Override
    public Map<String, Object> editActivity(String id) {
        List<User> list = userDao.selectUser();
        Activity activity = activityDao.selectOneActivity(id);
        Map<String, Object> map = new HashMap<>();
        map.put("userList", list);
        map.put("activity", activity);
        return map;
    }

    @Override
    public int modifyActivity(Activity activity) {
        return activityDao.updateActivity(activity);
    }

    @Override
    public Activity getActivityDetail(String id) {
        return activityDao.selectDetailActivity(id);
    }
}
