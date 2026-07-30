# Webex 启动器

> 原始页面：[Webex Launcher](https://confluence-eng-gpk2.cisco.com/conf/spaces/UC/pages/747939105/Webex+Launcher)

- TOI 原始文档：WBXT 空间 ›《Webex launcher》

## Jenkins 发布任务

| 平台 | 任务 |
|------|------|
| Windows 64 | [webex_publish_official_win_64_app_launcher](https://engci-private-sjc.cisco.com/jenkins/webex_teams/job/native/job/Desktop_Promotions/view/Publish%20Official%20Links/job/webex_publish_official_win_64_app_launcher/) |
| macOS | [webex_publish_official_macos_app_launcher](https://engci-private-sjc.cisco.com/jenkins/webex_teams/job/native/job/Desktop_Promotions/view/Publish%20Official%20Links/job/webex_publish_official_macos_app_launcher/) |
| macOS ARM | [webex_publish_official_macos_arm_app_launcher](https://engci-private-sjc.cisco.com/jenkins/webex_teams/job/native/job/Desktop_Promotions/view/Publish%20Official%20Links/job/webex_publish_official_macos_arm_app_launcher/) |

## 已知问题

1. **升级时直接杀进程**：遇到升级场景时，Launcher 会直接终止正在运行的应用。
2. **忽略应用配置直接升级**：Launcher 会把应用直接升级到会议要求的版本，而不检查应用自身的配置（例如是否为 slow channel）。
   - 该问题发生在应用由管理员安装（MSI 安装，注册表键写入 LocalMachine）的情况下。

## 相关代码

```cpp
const auto [isAllowUpgrade, reason] = isAllowUpgradeWebexApp();
if (!isAllowUpgrade)
{
    SPARK_LOG_INFO("not allow upgrade webex app, reason:" << reason);
    mWebInstallerTelemetry->updateContext(InstallContext{ .appupgrade_hint = reason });
    callback(PriorInstallationState::AlreadyInstalled);
    return;
}
```
