package cn.krain.crm.settings.web.interceptor;

import cn.krain.crm.settings.entity.User;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * @author CC
 * @data 2020/7/28 - 10:10
 */
public class LoginInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        //获取请求的uri
        String uri = request.getRequestURI();
        System.out.println(uri);
        //如果是登陆页面直接放行
        if (uri.indexOf("/login") >= 0) {
            System.out.println("登录请求");
            return true;
        }
        //获取session
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user != null) {    //用户已经登陆，放行
            System.out.println("用户已登录");
            return true;
        } else {     //用户未登录，提示其登陆
            System.out.println("用户未登录");
            response.sendRedirect(request.getContextPath() + "/login.jsp");
        }
        return false;
    }

    @Override
    public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception {

    }

    @Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) throws Exception {

    }
}
