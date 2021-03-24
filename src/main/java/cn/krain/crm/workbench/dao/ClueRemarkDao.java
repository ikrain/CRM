package cn.krain.crm.workbench.dao;

import cn.krain.crm.workbench.entity.ClueRemark;

import java.util.List;

/**
 * @author CC
 * @data 2020/8/4 - 18:22
 */
public interface ClueRemarkDao {
    int deleteClueRemark(String clueId);

    List<ClueRemark> selectClueRemark(String clueId);
}
