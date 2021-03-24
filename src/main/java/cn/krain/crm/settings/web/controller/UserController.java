package cn.krain.crm.settings.web.controller;

import cn.krain.crm.settings.entity.User;
import cn.krain.crm.settings.service.UserService;
import cn.krain.crm.util.MD5Util;
import cn.krain.crm.util.PrintJson;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.HashMap;
import java.util.Map;

/**
 * @author CC
 * @data 2020/7/27 - 17:47
 */
@Controller
@RequestMapping("/user")
public class UserController {

    @Resource
    private UserService userService;

    @RequestMapping("/login.do")
    public void doLogin(HttpServletRequest request,
                        HttpServletResponse response, String user, String pwd) {
        System.out.println("user:" + user);
        System.out.println("pwd:" + pwd);
        //将密码用md5加密
        String md5Pwd = MD5Util.getMD5(pwd);
        //获取ip地址
        String ip = request.getRemoteAddr();
        //封装前端数据
        Map<String, String> map = new HashMap<>();
        map.put("user", user);
        map.put("md5Pwd", md5Pwd);
        map.put("ip", ip);
        Map<String, Object> map1;
        try {
            User resUser = userService.userLogin(map);
            map1 = new HashMap<>();
            map1.put("success", true);
            //将登陆的用户放入session域中
            request.getSession().setAttribute("user", resUser);
            PrintJson.printJsonObj(response, map1);
        } catch (Exception e) {
            e.printStackTrace();
            //获取登录异常信息
            String msg = e.getMessage();
            map1 = new HashMap<>();
            map1.put("success", false);
            map1.put("msg", msg);
            PrintJson.printJsonFlag(response, map1);
        }
    }

    @RequestMapping(value = "/selectUser.do")
    public void doSelectUser(HttpServletResponse response) {
        PrintJson.printJsonObj(response, userService.queryUser());
    }
}
