package cn.krain.crm.workbench.web.controller;

import cn.krain.crm.settings.entity.User;
import cn.krain.crm.util.DataTimeUtil;
import cn.krain.crm.util.PrintJson;
import cn.krain.crm.util.UUIDUtil;
import cn.krain.crm.vo.PaginationVO;
import cn.krain.crm.workbench.entity.Activity;
import cn.krain.crm.workbench.service.ActivityRemarkService;
import cn.krain.crm.workbench.service.ActivityService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.HashMap;
import java.util.Map;

/**
 * @author CC
 * @data 2020/7/29 - 16:56
 */
@Controller
@RequestMapping("/activity")
public class ActivityController {

    @Resource
    private ActivityService activityService;

    @Resource
    private ActivityRemarkService remarkService;

    //创建市场活动
    @RequestMapping(value = "/addActivity.do")
    public void doAddActivity(HttpServletRequest request, HttpServletResponse response,
                              Activity activity) {
        //设置id
        activity.setId(UUIDUtil.getUUID());

        //设置创建时间
        activity.setCreateTime(DataTimeUtil.getSysTime());

        //设置创建者(从session中获取当前用户)
        User user = (User) (request.getSession().getAttribute("user"));
        activity.setCreateBy(user.getName());

        System.out.println("endTime:" + activity.getEndDate());

        activityService.addActivity(activity);
        PrintJson.printJsonBoolean(response, true);
    }


    //显示所有市场活动
    @RequestMapping(value = "/queryActivity.do")
    public void doQueryActivity(HttpServletRequest request, HttpServletResponse response,
                                String pageNo, String pageSize, Activity activity) {
        int pNo = Integer.valueOf(pageNo);
        int pSize = Integer.valueOf(pageSize);
        System.out.println("pageNo:" + pageNo);
        System.out.println("pageSize:" + pageSize);
        //更具pNo和pSize来计算跳跃的数字  (limit 0,3)
        int skipCount = (pNo - 1) * pSize;
        Map<String, Object> map = new HashMap<>();
        map.put("skipCount", skipCount);
        map.put("pSize", pSize);
        map.put("activity", activity);
        //使用VO对象，专门用来显示信息
        PaginationVO paginationVO = activityService.queryActivity(map);
        PrintJson.printJsonObj(response, paginationVO);
    }

    // 删除市场活动
    @RequestMapping("/delActivity.do")
    public void doDelActivity(HttpServletResponse response, HttpServletRequest request,
                              String[] id) {
        boolean flag = true;

        int rNums = remarkService.queryActivityRemark(id);  //将要删除活动的备注数量

        int dRNums = remarkService.delActivityRemark(id);   //所删除的备注数量

        if (rNums != dRNums) flag = false;     //如果需要删除的活动备注数量与实际删除的数量不同

        int nums = activityService.delActivity(id);     //删除的活动数量

        if (nums != id.length) flag = false; //如果需要删除的活动数量与实际删除的数量不同

        PrintJson.printJsonBoolean(response, flag);
    }

    @RequestMapping("/editActivity.do")
    public void doEditActivity(HttpServletResponse response, String id) {
        Map<String, Object> map = activityService.editActivity(id);
        PrintJson.printJsonFlag(response, map);
    }

    //修改市场活动信息
    @RequestMapping("/modifyActivity.do")
    public void doModifyActivity(HttpServletResponse response, Activity activity) {
        boolean flag = true;
        int num = activityService.modifyActivity(activity);
        if (num != 1) flag = false;
        PrintJson.printJsonBoolean(response, flag);
    }

    //显示市场活动详细信息
    @RequestMapping("/activityDetail.do")
    public ModelAndView doActivityDetail(String id) {
        Activity activity = activityService.getActivityDetail(id);
        ModelAndView mv = new ModelAndView();
        mv.addObject("activity", activity);
        mv.setViewName("activityDetail");
        return mv;
    }
}
