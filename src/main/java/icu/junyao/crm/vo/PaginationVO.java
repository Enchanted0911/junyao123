package icu.junyao.crm.vo;

import java.util.List;

/**
 * VO类提供页查询功能
 * @author wu
 * @param <T>
 */
public class PaginationVO<T> {
    private Integer total;
    private List<T> dataList;

    public Integer getTotal() {
        return total;
    }

    public void setTotal(Integer total) {
        this.total = total;
    }

    public List<T> getDataList() {
        return dataList;
    }

    @Override
    public String toString() {
        return "PaginationVO{" +
                "total=" + total +
                ", dataList=" + dataList +
                '}';
    }

    public void setDataList(List<T> dataList) {
        this.dataList = dataList;
    }
}
