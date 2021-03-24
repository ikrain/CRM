package cn.krain.crm.workbench.web.controller;

import cn.krain.crm.settings.entity.User;
import cn.krain.crm.settings.service.UserService;
import cn.krain.crm.util.DataTimeUtil;
import cn.krain.crm.util.PrintJson;
import cn.krain.crm.util.UUIDUtil;
import cn.krain.crm.workbench.entity.Clue;
import cn.krain.crm.workbench.entity.Contacts;
import cn.krain.crm.workbench.entity.Transaction;
import cn.krain.crm.workbench.service.ClueService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author CC
 * @data 2020/8/2 - 23:31
 */
@Controller
@RequestMapping("/clue")
public class ClueController {

    @Resource
    private UserService userService;

    @Resource
    private ClueService clueService;

    @RequestMapping("/selectUser.do")
    public void doSelectUser(HttpServletResponse response) {
        PrintJson.printJsonObj(response, userService.queryUser());
    }

    @RequestMapping("/addClue.do")
    @ResponseBody
    public void doAddClue(HttpServletResponse response, HttpServletRequest request,
                          Clue clue) {
        //设置id、创建时间、创建人
        clue.setId(UUIDUtil.getUUID());
        User user = (User) request.getSession().getAttribute("user");
        clue.setCreateBy(user.getName());
        clue.setCreateTime(DataTimeUtil.getSysTime());
        int num = clueService.addClue(clue);
        if (num == 1) PrintJson.printJsonBoolean(response, true);
        else PrintJson.printJsonBoolean(response, false);
    }

    @RequestMapping("/queryClue.do")
    public void doQueryClue(HttpServletResponse response, HttpServletRequest request) {
        PrintJson.printJsonObj(response, clueService.queryClueList());
    }

    @RequestMapping("/queryDetailClue.do")
    public ModelAndView doQueryDetailClue(HttpServletResponse response, HttpServletRequest request) {
        String id = request.getParameter("id");
        Clue clue = clueService.queryDetailClue(id);
        ModelAndView mv = new ModelAndView();
        mv.addObject("clue", clue);
        mv.setViewName("clue/detail");
        return mv;
    }

    @RequestMapping("/queryClueActivity.do")
    public void doQueryClueActivityList(HttpServletResponse response, String clueId) {

        PrintJson.printJsonObj(response, clueService.queryClueActivity(clueId));
    }

    @RequestMapping("/delClueActivity.do")
    public void doDelClueActivity(HttpServletResponse response, String id) {
        if (clueService.delClueActivity(id) == 1) PrintJson.printJsonBoolean(response, true);
        else PrintJson.printJsonBoolean(response, false);
    }

    @RequestMapping("/queryActivityByName.do")
    public void doQueryActivityByName(HttpServletResponse response, String name, String clueId) {
        Map<String, String> map = new HashMap<>();
        map.put("name", name);
        map.put("clueId", clueId);
        PrintJson.printJsonObj(response, clueService.queryActivityByName(map));
    }

    @RequestMapping("/addClueActivity.do")
    public void doAddClueActivity(HttpServletResponse response,
                                  String[] activityId) {
        int num = clueService.addActivityClueRelation(activityId);
        if (num == activityId.length - 1) PrintJson.printJsonBoolean(response, true);
        else PrintJson.printJsonBoolean(response, false);
    }

    //将线索转换为客户和联系人
    @RequestMapping("/convertClue.do")
    public ModelAndView doConvertClue(HttpServletResponse response, HttpServletRequest request,
                                      String clueId, Transaction transaction) {
        String flag = request.getParameter("flag");
        clueService.convertClue(request, clueId, flag, transaction);
        ModelAndView mv = new ModelAndView();
        mv.setViewName("clue/index");
        return mv;
    }

    //绑定市场活动前查询市场活动
    @RequestMapping("/queryAllActivityByName")
    public void doQueryActivityByName(HttpServletResponse response, String name) {
        PrintJson.printJsonObj(response, clueService.queryAllActivityByName(name));
    }
}
