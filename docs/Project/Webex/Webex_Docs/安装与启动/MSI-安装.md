# MSI 安装

> 原始页面：[MSI Installation](https://confluence-eng-gpk2.cisco.com/conf/spaces/UC/pages/776080669/MSI+Installation)

## 说明

- TOI 原始文档：WBXT 空间 ›《Install/Uninstall》
- `ALLUSERS=1` 用于管理员安装（写入 LocalMachine），不加则为当前用户安装。

## 静默安装命令

```bat
msiexec /i WebexBundle_12.msi ALLUSERS=1 ENABLEVDI=1 ROAMINGENABLED=1 AUTOUPGRADEENABLED=0 FORCELOCKDOWN=LockWhenCompatible
```

| 参数 | 说明 |
|------|------|
| `ALLUSERS=1` | 管理员安装（所有用户） |
| `ENABLEVDI=1` | 启用 VDI 模式 |
| `ROAMINGENABLED=1` | 启用漫游 |
| `AUTOUPGRADEENABLED=0` | 关闭自动升级 |
| `FORCELOCKDOWN=LockWhenCompatible` | 兼容时锁定版本 |
