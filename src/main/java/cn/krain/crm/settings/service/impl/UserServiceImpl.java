package cn.krain.crm.settings.service.impl;

import cn.krain.crm.settings.dao.UserDao;
import cn.krain.crm.settings.entity.User;
import cn.krain.crm.settings.service.UserService;
import cn.krain.crm.util.DataTimeUtil;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import javax.security.auth.login.LoginException;
import java.util.List;
import java.util.Map;

/**
 * @author CC
 * @data 2020/7/27 - 18:26
 */
@Service
public class UserServiceImpl implements UserService {

    //自动注入
    @Resource
    private UserDao userDao;

    @Override
    public User userLogin(Map<String, String> map) throws LoginException {
        User user = userDao.userSelectLogin(map);

        //验证账号密码
        if (user == null) {
            throw new LoginException("用户名或密码错误");
        }

        //验证失效时间
        String expireTime = user.getExpireTime();
        String currentTime = DataTimeUtil.getSysTime();
        if (expireTime.compareTo(currentTime) < 0) {
            System.out.println(currentTime);
            throw new LoginException("账号已失效");
        }

        //验证锁定状态
        String lockState = user.getLockState();
        if ("0".equals(lockState)) {
            throw new LoginException("账号已锁定");
        }

        //验证ip是否允许
        String allowIP = user.getAllowIps();
        if (!allowIP.contains(map.get("ip"))) {
            System.out.println(map.get("ip"));
            throw new LoginException("不允许的ip地址");
        }

        return user;
    }

    @Override
    public List<User> queryUser() {
        return userDao.selectUser();
    }

}
