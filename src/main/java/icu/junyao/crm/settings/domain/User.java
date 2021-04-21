package icu.junyao.crm.settings.domain;

/**
 * @author wu
 */
@SuppressWarnings("all")
public class User {
    // yyyy-MM-dd 10位
    // yyyy-MM-dd HH:mm:ss 19位
    // 编号, 主键
    private String id;
    // 登录账号
    private String loginAct;
    // 真实姓名
    private String name;
    // 登录密码
    private String loginPwd;
    // 邮箱
    private String email;
    // 失效时间
    private String expireTime;
    // 锁定状态 0 ： 锁定,  1 : 启动
    private String lockState;
    // 部门编号
    private String deptno;
    // 允许访问的IP地址
    private String allowIps;
    // 创建时间
    private String createTime;
    // 创建人
    private String createBy;
    // 修改时间
    private String editTime;
    // 修改人
    private String editBy;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getLoginAct() {
        return loginAct;
    }

    public void setLoginAct(String loginAct) {
        this.loginAct = loginAct;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getLoginPwd() {
        return loginPwd;
    }

    public void setLoginPwd(String loginPwd) {
        this.loginPwd = loginPwd;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getExpireTime() {
        return expireTime;
    }

    public void setExpireTime(String expireTime) {
        this.expireTime = expireTime;
    }

    public String getLockState() {
        return lockState;
    }

    public void setLockState(String lockState) {
        this.lockState = lockState;
    }

    public String getDeptno() {
        return deptno;
    }

    public void setDeptno(String deptno) {
        this.deptno = deptno;
    }

    public String getAllowIps() {
        return allowIps;
    }

    public void setAllowIps(String allowIps) {
        this.allowIps = allowIps;
    }

    public String getCreateTime() {
        return createTime;
    }

    public void setCreateTime(String createTime) {
        this.createTime = createTime;
    }

    public String getCreateBy() {
        return createBy;
    }

    public void setCreateBy(String createBy) {
        this.createBy = createBy;
    }

    public String getEditTime() {
        return editTime;
    }

    public void setEditTime(String editTime) {
        this.editTime = editTime;
    }

    public String getEditBy() {
        return editBy;
    }

    public void setEditBy(String editBy) {
        this.editBy = editBy;
    }
}
