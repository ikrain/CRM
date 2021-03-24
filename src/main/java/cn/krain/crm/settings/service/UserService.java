package cn.krain.crm.settings.service;

import cn.krain.crm.settings.entity.User;

import javax.security.auth.login.LoginException;
import java.util.List;
import java.util.Map;

/**
 * @author CC
 * @data 2020/7/27 - 18:25
 */
public interface UserService {

    User userLogin(Map<String, String> map) throws LoginException;

    List<User> queryUser();

}
