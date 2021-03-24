package cn.krain.crm.settings.service;

import cn.krain.crm.settings.entity.DicValue;

import java.util.List;
import java.util.Map;

/**
 * @author CC
 * @data 2020/8/2 - 16:32
 */
public interface DicService {
    Map<String, List<DicValue>> getDicValueList();
}
