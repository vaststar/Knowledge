# 安装与启动

> Webex 桌面客户端的安装、启动、升级相关文档。
> 原始页面：[App Launch && Installation](https://confluence-eng-gpk2.cisco.com/conf/spaces/UC/pages/739050371/App+Launch+Installation)

## 本板块文档

| 文档 | 内容 |
|------|------|
| [应用启动流程](应用启动流程.md) | Windows 端两阶段启动（Launcher Mode → Loader Mode）流程图 |
| [MSI 安装](MSI-安装.md) | MSI 静默安装命令与参数 |
| [Web 安装器](Web-安装器.md) | Web Installer 的 Jenkins 发布任务与 CDN |
| [Webex 启动器](Webex-启动器.md) | Launcher 的发布任务、已知问题与升级逻辑 |
| [应用内升级](应用内升级.md) | In-App Upgrade（待补充） |
| [WebexApp DT](WebexApp-DT.md) | WebexApp DT 的 CDN、Artifactory 与访问方式 |

## 通用信息

### CDN 路径（Windows）

```
https://engci-maven-master.cisco.com/artifactory/webex-client-builds-cdn/webex-apps/windows/
```

### MSI 安装要点

- TOI 原始文档：WBXT 空间 ›《Install/Uninstall》
- `ALLUSERS=1` 用于管理员安装（写入 LocalMachine）；不加则为当前用户安装。
- 详细命令见 [MSI 安装](MSI-安装.md)。
