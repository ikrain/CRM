package cn.krain.crm.settings.dao;

import cn.krain.crm.settings.entity.DicType;

import java.util.List;

/**
 * @author CC
 * @data 2020/8/2 - 16:27
 */
public interface DicTypeDao {
    List<DicType> selectDicTypeList();
}
