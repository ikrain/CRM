package cn.krain.crm.util;

import com.fasterxml.jackson.core.JsonGenerationException;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

/**
 * @author CC
 * @data 2020/7/27 - 18:45
 */
public class PrintJson {

    //将boolean值解析为json串
    public static void printJsonBoolean(HttpServletResponse response, boolean flag) {

        Map<String, Boolean> map = new HashMap<String, Boolean>();
        map.put("success", flag);

        ObjectMapper om = new ObjectMapper();
        try {
            //{"success":true}
            String json = om.writeValueAsString(map);
            response.getWriter().print(json);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    //新增
    public static void printJsonFlag(HttpServletResponse response, Map<String, Object> map) {
        ObjectMapper om = new ObjectMapper();
        try {
            String json = om.writeValueAsString(map);
            response.getWriter().print(json);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    //将对象类型数据转化为json串
    public static void printJsonObj(HttpServletResponse response, Object object) {
        ObjectMapper om = new ObjectMapper();
        try {
            String json = om.writeValueAsString(object);
            response.getWriter().print(json);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}
