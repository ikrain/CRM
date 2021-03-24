package cn.krain.crm.vo;

import cn.krain.crm.workbench.entity.Activity;

import java.util.List;

/**
 * @author CC
 * @data 2020/7/29 - 22:37
 */
public class PaginationVO<T> {

    private int total;

    private List<T> activityList;

    public int getTotal() {
        return total;
    }

    public void setTotal(int total) {
        this.total = total;
    }

    public List<T> getActivityList() {
        return activityList;
    }

    public void setActivityList(List<T> activityList) {
        this.activityList = activityList;
    }
}
