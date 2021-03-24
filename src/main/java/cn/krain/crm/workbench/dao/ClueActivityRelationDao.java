package cn.krain.crm.workbench.dao;

import cn.krain.crm.workbench.entity.ClueActivityRelation;

import java.util.List;

/**
 * @author CC
 * @data 2020/8/4 - 18:19
 */
public interface ClueActivityRelationDao {
    int deleteCAR(String clueId);

    List<ClueActivityRelation> selectCAR(String clueId);
}
