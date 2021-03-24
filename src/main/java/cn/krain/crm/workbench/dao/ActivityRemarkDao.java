package cn.krain.crm.workbench.dao;

import cn.krain.crm.workbench.entity.ActivityRemark;

import java.util.List;
import java.util.Map;

/**
 * @author CC
 * @data 2020/7/30 - 17:04
 */
public interface ActivityRemarkDao {
    int selectActivityRemark(String[] id);

    int deleteActivityRemark(String[] id);

    List<ActivityRemark> selectAllActRemark(String activityId);

    int updateActivityRemark(Map<String, Object> map);

    int deleteOneActRemark(String id);

    int insertActivityRemark(Map<String, Object> map);
}
