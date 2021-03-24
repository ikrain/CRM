package cn.krain.crm.settings.dao;

import cn.krain.crm.settings.entity.DicValue;

import java.util.List;
import java.util.Map;

/**
 * @author CC
 * @data 2020/8/2 - 16:29
 */
public interface DicValueDao {
    List<DicValue> selectDicValueList(String typeCode);
}
