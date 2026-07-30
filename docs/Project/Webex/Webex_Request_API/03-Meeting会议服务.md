# 03 - Meeting 会议服务

> 会议升级、邮件邀请、入会前信息。这类接口走 `wbxappapi`（Webex 会议后端），
> **host 取决于会议所属站点**（如 `alpha` / `engsandbox` / `customer1-test`），测试时换成目标站点域名即可。

---

## 一、升级为会议（escalateCallToMeeting）

把当前呼叫升级成一个即时会议。

`POST https://alpha.webex.com/wbxappapi/v1/meetings/instant?siteurl=alpha`

```bash
curl -X POST \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "escalatedMeeting": true,
    "deviceCanStartMeeting": true,
    "allowCohost": true,
    "autoDeleteAfterMeetingEnd": true,
    "invitees": [
      { "email": "user@example.com", "ciUserUuid": "<uuid>", "cohost": false, "guest": false }
    ]
  }' \
  "https://alpha.webex.com/wbxappapi/v1/meetings/instant?siteurl=alpha"
```

| 字段 | 说明 |
|------|------|
| `escalatedMeeting` | 是否由呼叫升级而来 |
| `deviceCanStartMeeting` | 设备能否发起会议 |
| `allowCohost` | 是否允许联席主持人 |
| `autoDeleteAfterMeetingEnd` | 结束后自动删除 |
| `invitees[]` | 受邀人：`email` / `ciUserUuid` / `cohost` / `guest` |
| `siteurl`（query） | 会议站点标识，如 `alpha` |

---

## 二、邮件邀请（inviteByEmail）

给已有会议发送邀请邮件。

`POST https://alpha.webex.com/wbxappapi/v2/meetings/<meetingId>/sendMails`

```bash
curl -X POST \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{ "emails": ["user@example.com"] }' \
  "https://alpha.webex.com/wbxappapi/v2/meetings/$MEETING_ID/sendMails"
```

---

## 三、入会前信息（Unified Space Meeting）

入会前拿会议信息、做预入会校验，多为**访客 / 免鉴权**场景。

### 获取会议信息（meetingInfo，免鉴权）
`POST https://engsandbox.webex.com/wbxappapi/v1/meetingInfo`

```bash
curl -X POST \
  -H "Content-Type: application/json" \
  -d '{
    "clientEnvironment": "PRODUCTION",
    "clientVersion": "44.x",
    "guestEmail": "guest@example.com",
    "guestName": "Guest",
    "locale": "en_US",
    "meetingUrl": "https://engsandbox.webex.com/meet/xxx",
    "supportCountryList": true,
    "supportHostKey": true,
    "webinarNativeCap": true
  }' \
  "https://engsandbox.webex.com/wbxappapi/v1/meetingInfo"
```

| 字段 | 说明 |
|------|------|
| `meetingUrl` | 会议链接（必填） |
| `guestName` / `guestEmail` | 访客身份 |
| `clientEnvironment` / `clientVersion` | 客户端环境与版本 |
| `locale` | 语言 |
| `supportHostKey` / `supportCountryList` / `webinarNativeCap` | 客户端能力声明 |

### 预入会（preJoin，需鉴权）
`POST https://engsandbox.webex.com/wbxappapi/v1/preJoin`

```bash
curl -X POST \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "clientVersion": "44.x",
    "containCCPSetting": true,
    "locale": "en_US",
    "meetingUrl": "https://engsandbox.webex.com/meet/xxx",
    "supportCheckRequireLogin": true,
    "supportCountryList": true,
    "supportGuestCheckCaptcha": true,
    "supportHostKey": true,
    "supportU2CV2": true,
    "webinarNativeCap": true
  }' \
  "https://engsandbox.webex.com/wbxappapi/v1/preJoin"
```

> 换站点只需替换 host，如 `https://customer1-test.webex.com/wbxappapi/v1/meetingInfo`。
