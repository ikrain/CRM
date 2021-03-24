package cn.krain.crm.settings.dao;

import cn.krain.crm.settings.entity.User;

import java.util.List;
import java.util.Map;

/**
 * @author CC
 * @data 2020/7/27 - 18:21
 */
public interface UserDao {

    User userSelectLogin(Map<String, String> map);   //用户登录

    List<User> selectUser();    //返回所有用户

    User selectUserById(String id);
}
