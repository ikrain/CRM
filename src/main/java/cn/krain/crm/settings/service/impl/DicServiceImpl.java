package cn.krain.crm.settings.service.impl;

import cn.krain.crm.settings.dao.DicTypeDao;
import cn.krain.crm.settings.dao.DicValueDao;
import cn.krain.crm.settings.entity.DicType;
import cn.krain.crm.settings.entity.DicValue;
import cn.krain.crm.settings.service.DicService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author CC
 * @data 2020/8/2 - 16:33
 */
@Service
public class DicServiceImpl implements DicService {

    @Resource
    private DicTypeDao typeDao;

    @Resource
    private DicValueDao valueDao;

    @Override
    public Map<String, List<DicValue>> getDicValueList() {
        List<DicType> typeList = typeDao.selectDicTypeList();
        Map<String, List<DicValue>> map = new HashMap<>();
        for (DicType dt : typeList) {
            String typeCode = dt.getCode();
            List<DicValue> valueList = valueDao.selectDicValueList(typeCode);
            map.put(typeCode, valueList);
        }
        return map;
    }
}
