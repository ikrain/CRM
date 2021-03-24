package cn.krain.crm.workbench.dao;

import cn.krain.crm.workbench.entity.Activity;

import java.util.List;
import java.util.Map;

/**
 * @author CC
 * @data 2020/7/29 - 11:10
 */
public interface ActivityDao {

    //创建市场活动
    int insertActivity(Activity activity);

    //查询所有市场活动
    List<Activity> selectActivity(Map<String, Object> map);

    //查询市场活动的总个数
    int selectActivityTotal(Map<String, Object> map);

    //删除指定市场互动
    int deleteActivity(String[] id);

    //修改指定的市场活动时，现显示指定的市场活动信息
    Activity selectOneActivity(String id);

    //修改市场活动信息
    int updateActivity(Activity activity);

    //获取市场活动的详细信息（owner需要转换为user表中的name）
    Activity selectDetailActivity(String id);

    //查找线索对应的市场活动
    List<Activity> selectClueActivity(String clueId);

    List<Activity> selectActivityByName(Map<String, String> map);

    List<Activity> selectAllActivityByName(String name);

    Activity selectOneActivityByName(String name);
}
