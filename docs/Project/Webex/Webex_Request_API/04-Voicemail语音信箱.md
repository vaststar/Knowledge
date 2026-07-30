# 04 - Voicemail 语音信箱

> Cisco Unity Connection（CUC）的 `vmrest` 接口，直连 CUC 服务器，走 Basic Auth。
> CUC 多为自签证书，curl 一般加 `-k` 忽略证书校验。host 记作 `<cuc-host>`（用你的 CUC 地址替换）。

---

## CUC vmrest 接口

| 操作 | 方法与 URL |
|------|-----------|
| 收件箱消息 | `GET https://<cuc-host>/vmrest/mailbox/folders/inbox/messages` |
| 单条消息 | `GET https://<cuc-host>/vmrest/messages/<messageId>` |
| 问候语音频 | `GET https://<cuc-host>/vmrest/user/greetings/Standard/greetingstreamfiles/1033` |
| 版本 | `GET https://<cuc-host>/vmrest/version` |

**获取收件箱消息**：

```bash
curl -k -u "<user>:<password>" \
  "https://<cuc-host>/vmrest/mailbox/folders/inbox/messages"
```

**获取问候语音频**：

```bash
curl -k "https://<cuc-host>/vmrest/user/greetings/Standard/greetingstreamfiles/1033"
```

| 路径片段 | 说明 |
|---------|------|
| `Standard` | 问候语类型：`Standard` / `Busy` / `Alternate` 等 |
| `1033` | 语言代码（1033 = en-US） |

> 💡 CUC 地址常是内网 IP。放进文档时用占位符替代，避免泄露内网拓扑；账号密码也不要明文入库。
