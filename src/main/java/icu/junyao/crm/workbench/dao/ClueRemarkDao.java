package icu.junyao.crm.workbench.dao;

import icu.junyao.crm.workbench.domain.ClueRemark;

import java.util.List;

/**
 * @author wu
 */
public interface ClueRemarkDao {

    /**
     * 根据线索id获取该线索的所有备注
     * @param clueId 线索id
     * @return 所有属于该线索的线索备注
     */
    List<ClueRemark> getClueRemarksByClueId(String clueId);

    /**
     * 根据线索备注id删除线索备注
     * @param clueRemarkId 线索备注id
     * @return 修改成功的条数
     */
    int delete(String clueRemarkId);

    /**
     * 删除指定线索的所有备注, 删除线索时应该把备注也同时删除
     * @param ids 线索的id组成的数组
     * @return 修改成功的条数
     */
    int deleteByClueIds(String[] ids);

    /**
     * 获取所有备注条数, 通过线索的id数组
     * @param ids 线索的id数组
     * @return 返回修改成功的记录
     */
    int getCountByClueIds(String[] ids);

    /**
     * 保存一条新建的线索备注
     * @param clueRemark 线索备注
     * @return 修改成功的条数
     */
    int remarkSave(ClueRemark clueRemark);

    /**
     * 更新一条线索备注
     * @param clueRemark 线索备注
     * @return 返回修改成功的条数
     */
    int remarkUpdate(ClueRemark clueRemark);

    /**
     * 删除一条线索备注信息
     * @param id 被删除线索备注的id
     * @return 修改成功的记录数
     */
    int removeRemarkById(String id);
}
