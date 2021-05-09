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
}
