package icu.junyao.crm.workbench.dao;

/**
 * @author wu
 */
public interface ActivityRemarkDao {
    /**
     * 通过外键市场活动的ID查询关联的备注条数
     * @param ids 市场活动的ID
     * @return 备注数量
     */
    int getCountByActivityIds(String[] ids);

    /**
     * 通过外键删除备注表中的备注记录
     * @param ids 市场活动ID
     * @return 被删除的记录数
     */
    int deleteByActivityIds(String[] ids);
}
