package cn.krain.crm.workbench.service;

import cn.krain.crm.workbench.entity.Activity;
import cn.krain.crm.workbench.entity.Clue;
import cn.krain.crm.workbench.entity.ClueActivityRelation;
import cn.krain.crm.workbench.entity.Transaction;

import javax.servlet.http.HttpServletRequest;
import java.util.List;
import java.util.Map;

/**
 * @author CC
 * @data 2020/8/3 - 14:31
 */
public interface ClueService {
    int addClue(Clue clue);

    List<Clue> queryClueList();

    Clue queryDetailClue(String id);

    List<Activity> queryClueActivity(String clueId);

    int delClueActivity(String id);

    List<Activity> queryActivityByName(Map<String, String> map);

    int addActivityClueRelation(String[] activityId);

    List<Activity> queryAllActivityByName(String name);

    int convertClue(HttpServletRequest request, String clueId, String flag, Transaction transaction);
}
