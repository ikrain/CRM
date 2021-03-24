package cn.krain.crm.web.listener;

import cn.krain.crm.settings.dao.DicTypeDao;
import cn.krain.crm.settings.dao.DicValueDao;
import cn.krain.crm.settings.entity.DicType;
import cn.krain.crm.settings.entity.DicValue;
import org.springframework.context.ApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import java.util.*;

/**
 * @author CC
 * @data 2020/8/1 - 22:28
 */
public class SysInitLisenter implements ServletContextListener {

    private DicTypeDao typeDao;

    private DicValueDao valueDao;

//    private DicService dicService;

    @Override
    public void contextInitialized(ServletContextEvent event) {
        System.out.println("--------------------------------------start initServlet--------------------------------------");

        ApplicationContext context =
                WebApplicationContextUtils.getWebApplicationContext(event.getServletContext());
        //获取bean
        typeDao = context.getBean(DicTypeDao.class);
        valueDao = context.getBean(DicValueDao.class);

        List<DicType> typeList = typeDao.selectDicTypeList();
        Map<String, List<DicValue>> map = new HashMap<>();
        for (DicType dt : typeList) {
            String typeCode = dt.getCode();
            List<DicValue> valueList = valueDao.selectDicValueList(typeCode);
            map.put(typeCode, valueList);
        }

        /*
            应该管业务层要
            7个list

            可以打包成为一个map
            业务层应该是这样来保存数据的：
                map.put("appellationList",dvList1);
                map.put("clueStateList",dvList2);
                map.put("stageList",dvList3);
                ....
                ...
         */

        ServletContext application = event.getServletContext();
        Set<String> set = map.keySet();
        //将获取到的数据字典信息放入到application域中
        for (String key : set) {
            application.setAttribute(key, map.get(key));
        }
        System.out.println("--------------------------------------end initServlet--------------------------------------");

        //处理可能性
        Map<String, String> pMap = new HashMap<>();
        ResourceBundle rb = ResourceBundle.getBundle("Stage2Possibility");
        Enumeration<String> e = rb.getKeys();
        while (e.hasMoreElements()) {
            String stage = e.nextElement();     //阶段
            String value = rb.getString(stage);  //可能性值
            pMap.put(stage, value);
        }
        application.setAttribute("pMap", pMap);
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {

    }
}
