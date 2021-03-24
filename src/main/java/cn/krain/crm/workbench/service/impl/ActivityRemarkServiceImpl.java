package cn.krain.crm.workbench.service.impl;

import cn.krain.crm.workbench.dao.ActivityRemarkDao;
import cn.krain.crm.workbench.entity.ActivityRemark;
import cn.krain.crm.workbench.service.ActivityRemarkService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;

/**
 * @author CC
 * @data 2020/7/30 - 17:03
 */
@Service
public class ActivityRemarkServiceImpl implements ActivityRemarkService {

    @Resource
    private ActivityRemarkDao remarkDao;

    @Override
    public int queryActivityRemark(String[] id) {
        return remarkDao.selectActivityRemark(id);
    }

    @Override
    public int delActivityRemark(String[] id) {
        return remarkDao.deleteActivityRemark(id);
    }

    @Override
    public List<ActivityRemark> getAllActRemark(String id) {
        return remarkDao.selectAllActRemark(id);
    }

    @Override
    public int editActivityRemark(Map<String, Object> map) {
        return remarkDao.updateActivityRemark(map);
    }

    @Override
    public int delOneActRemark(String id) {
        return remarkDao.deleteOneActRemark(id);
    }

    @Override
    public int addActivityRemark(Map<String, Object> map) {
        return remarkDao.insertActivityRemark(map);
    }
}
