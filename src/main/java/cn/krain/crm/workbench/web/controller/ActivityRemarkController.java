package cn.krain.crm.workbench.web.controller;

import cn.krain.crm.settings.entity.User;
import cn.krain.crm.util.DataTimeUtil;
import cn.krain.crm.util.PrintJson;
import cn.krain.crm.util.UUIDUtil;
import cn.krain.crm.workbench.service.ActivityRemarkService;
import org.springframework.http.HttpRequest;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.HashMap;
import java.util.Map;

/**
 * @author CC
 * @data 2020/7/31 - 15:59
 */
@Controller
@RequestMapping("/activityRemark")
public class ActivityRemarkController {

    @Resource
    private ActivityRemarkService remarkService;

    @RequestMapping("/getActivityRemark.do")
    public void doGetActivityRemark(HttpServletResponse response, String activityId) {
        PrintJson.printJsonObj(response, remarkService.getAllActRemark(activityId));
    }

    @RequestMapping("editActivityRemark.do")
    public void doEditActivityRemark(HttpServletResponse response, HttpServletRequest request,
                                     String id, String noteContent) {
        Map<String, Object> map = new HashMap<>();
        String currentTime = DataTimeUtil.getSysTime();
        User user = (User) request.getSession().getAttribute("user");
        map.put("id", id);
        map.put("noteContent", noteContent);
        map.put("currentTime", currentTime);
        map.put("editBy", user.getName());
        int nums = remarkService.editActivityRemark(map);
        if (nums == 1) map.put("success", true);
        else map.put("success", false);
        PrintJson.printJsonFlag(response, map);
    }

    @RequestMapping("/delActivityRemark.do")
    public void doDelActivityRemark(HttpServletResponse response, String id) {
        int num = remarkService.delOneActRemark(id);
        if (num == 1) PrintJson.printJsonBoolean(response, true);
        else PrintJson.printJsonBoolean(response, false);
    }

    @RequestMapping("/addActivityRemark.do")
    public void doAddActivityRemark(HttpServletResponse response, HttpServletRequest request,
                                    String activityId, String remark) {
        String id = UUIDUtil.getUUID();
        String currentTime = DataTimeUtil.getSysTime();
        User user = (User) (request.getSession().getAttribute("user"));
        Map<String, Object> map = new HashMap<>();
        map.put("id", id);
        map.put("noteContent", remark);
        map.put("createTime", currentTime);
        map.put("createBy", user.getName());
        map.put("activityId", activityId);
        int num = remarkService.addActivityRemark(map);
        if (num == 1) map.put("success", true);
        else map.put("success", false);
        PrintJson.printJsonFlag(response, map);
    }
}
