package cn.krain.crm.workbench.dao;

import cn.krain.crm.workbench.entity.Clue;
import cn.krain.crm.workbench.entity.ClueActivityRelation;

import java.util.List;

/**
 * @author CC
 * @data 2020/8/3 - 14:28
 */
public interface ClueDao {
    int insertClue(Clue clue);

    List<Clue> selectClueList();

    Clue selectOneClue(String id);

    int deleteClueActivity(String id);

    int insertClueActivityRelation(ClueActivityRelation relation);

    int deleteClue(String id);
}
