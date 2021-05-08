package icu.junyao.crm.workbench.dao;

import icu.junyao.crm.workbench.domain.ClueActivityRelation;

/**
 * @author wu
 */
public interface ClueActivityRelationDao {

    /**
     * 根据关联关系表的id删除单条记录
     * @param id 关联关系表id
     * @return 返回修改成功的数据
     */
    int unbind(String id);

    /**
     * 新增一条关联的市场活动
     * @param car 该关联信息添加到关联关系表中
     * @return 返回修改成功的数量
     */
    int bind(ClueActivityRelation car);
}
