# Webex Request API 文档

> Webex 内部 HTTP 接口速查。每个接口都给出：**用途 → 方法与 URL → 关键参数 → 可直接运行的 curl**。

## 目录

| 文档 | 内容 |
|------|------|
| [00-鉴权与主机](00-环境变量与鉴权.md) | 如何拿 Token、Webex 各微服务的真实域名、如何用 U2C 动态查 host |
| [01-Teams核心服务](01-Teams核心服务.md) | 服务发现、灰度开关、用户信息、设备、在线状态、会议/呼叫、搜索、设备管理、头像等 |
| [02-Contacts联系人服务](02-Contacts联系人服务.md) | OAuth2 鉴权链路、联系人与分组的增删改查 |
| [03-Meeting会议服务](03-Meeting会议服务.md) | 升级会议、邮件邀请、入会前信息（meetingInfo / preJoin） |
| [04-Voicemail语音信箱](04-Voicemail语音信箱.md) | Cisco Unity Connection（CUC）vmrest 接口 |
| [05-其他Misc](05-其他Misc.md) | 客户端升级检查、FedRAMP 开关、本地测试服务 |

## 三条通用约定

1. **鉴权**：绝大多数接口需在 Header 带上你的 Token：
   ```
   Authorization: Bearer <AccessToken>
   ```
   如何获取见 [00-鉴权与主机](00-环境变量与鉴权.md)。

2. **TrackingID**（可选但推荐）：用于全链路日志追踪，值可随意，格式 `VDI_<uuid>_1`：
   ```
   TrackingID: VDI_<uuid>_1
   ```
   curl 里用 `$(uuidgen)` 生成。

3. **接口间的依赖**：有些接口的响应会返回后续接口需要的 ID（如 `_user_id`、`_wdm_url`、`contact_id`）。文中用 `→ 返回 X` 标注，先调它拿到值再调下一个。

> **占位符约定**：URL 里的 `<xxx>` 表示要替换的值；curl 示例里用 `$SHELL_VAR`（如 `$ACCESS_TOKEN`、`$USER_ID`）表示同一个值。

## 安全提示

请勿在文档或提交到 Git 的文件中保存任何真实 Token、密码、Client Secret。示例中的凭据一律为占位符。
