package icu.junyao.crm.workbench.dao;

import icu.junyao.crm.workbench.domain.ClueActivityRelation;

import java.util.List;

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

    /**
     * 根据线索id查询所有线索市场活动关联关系表
     * @param clueId 线索id
     * @return 符合条件的关联关系集合
     */
    List<ClueActivityRelation> getListByClueId(String clueId);

    /**
     * 通过线索市场活动关系对象删除一条线索市场活动关系
     * @param clueActivityRelation 线索市场活动关系对象 可以通过 #{属性值} 的方式获取属性值
     * @return 修改成功的条数
     */
    int delete(ClueActivityRelation clueActivityRelation);
}
