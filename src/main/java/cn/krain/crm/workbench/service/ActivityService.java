package cn.krain.crm.workbench.service;

import cn.krain.crm.vo.PaginationVO;
import cn.krain.crm.workbench.entity.Activity;

import java.util.Map;

/**
 * @author CC
 * @data 2020/7/29 - 17:07
 */
public interface ActivityService {
    int addActivity(Activity activity);

    PaginationVO queryActivity(Map<String, Object> map);

    int delActivity(String[] id);

    Map<String, Object> editActivity(String id);

    int modifyActivity(Activity activity);

    Activity getActivityDetail(String id);
}
