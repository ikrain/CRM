package cn.krain.crm.workbench.service;

import cn.krain.crm.workbench.entity.ActivityRemark;

import java.util.List;
import java.util.Map;

/**
 * @author CC
 * @data 2020/7/30 - 16:58
 */
public interface ActivityRemarkService {
    int queryActivityRemark(String[] id);

    int delActivityRemark(String[] id);

    List<ActivityRemark> getAllActRemark(String activityId);

    int editActivityRemark(Map<String, Object> map);

    int delOneActRemark(String id);

    int addActivityRemark(Map<String, Object> map);
}
