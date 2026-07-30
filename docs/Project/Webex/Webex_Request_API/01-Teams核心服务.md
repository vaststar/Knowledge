# 01 - Teams 核心服务

> Webex 客户端最核心的一组微服务接口：服务发现、开关、用户、设备、状态、会议、搜索等。
> 各服务域名见 [00-鉴权与主机](00-环境变量与鉴权.md)。

**通用 Header**（下文 curl 默认都带，不再重复）：
```
Authorization: Bearer <AccessToken>
TrackingID: VDI_<uuid>_1
```

---

## 一、服务发现（U2C）

查当前用户各微服务的真实域名。

`GET https://u2c.wbx2.com/u2c/api/v1/user/catalog?types=TEAM,IDENTITY`

```bash
curl -H "Authorization: Bearer $ACCESS_TOKEN" \
     -H "TrackingID: VDI_$(uuidgen)_1" \
     "https://u2c.wbx2.com/u2c/api/v1/user/catalog?types=TEAM,IDENTITY"
```

| 参数 | 位置 | 说明 |
|------|------|------|
| `types` | query | 服务类型过滤，如 `TEAM,IDENTITY` |

---

## 二、灰度开关（Feature Toggle）

| 操作 | 方法与 URL |
|------|-----------|
| 查用户开关 | `GET https://feature-a.wbx2.com/feature/api/v1/features/users/<userId>` |
| 设置开关 | `POST https://feature-a.wbx2.com/feature/api/v1/features/users/<userId>/toggles` |
| 删除开关 | `DELETE https://feature-a.wbx2.com/feature/api/v1/features/users/<userId>/developer/<toggleName>` |

**设置开关**：

```bash
curl -X POST \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "type": "DEV",
    "mutable": true,
    "key": "dev-mode-desktop-webex-cross-launch",
    "val": "false"
  }' \
  "https://feature-a.wbx2.com/feature/api/v1/features/users/$USER_ID/toggles"
```

| 字段 | 说明 |
|------|------|
| `type` | 开关类型：`DEV` / `USER` / `ORG` |
| `key` | 开关名 |
| `val` | 值，字符串 `"true"` / `"false"` |
| `mutable` | 是否可变 |

---

## 三、用户信息（UserInfo）

### 用邮箱查用户 ID  → 返回 `_user_id`
后续很多接口都要用这个 UUID，通常第一步先调它。

`GET https://conv-a.wbx2.com/conversation/api/v1/users/<email>`

```bash
curl -H "Authorization: Bearer $ACCESS_TOKEN" \
     "https://conv-a.wbx2.com/conversation/api/v1/users/$USER_EMAIL"
```
响应里的 `id` 即该用户 UUID（后文记作 `$USER_ID`）。

### 其他查询方式

| 目标 | 方法与 URL |
|------|-----------|
| 从 CI 查他人 | `GET https://identity.webex.com/identity/scim/<orgId>/v1/Users/<userId>` |
| 从 CI 查自己 | `GET https://identity.webex.com/identity/scim/v1/Users/me` |
| 从 conv 查自己 | `GET https://conv-a.wbx2.com/conversation/api/v1/users/` |
| 查组织 | `GET https://conv-a.wbx2.com/conversation/api/v1/users/organization` |
| 公开 API 按邮箱查 | `GET https://api.ciscospark.com/v1/people?email=<email>` |
| 公开 API 按 UUID 查 | `GET https://api.ciscospark.com/v1/people/<userId>` |

```bash
curl -H "Authorization: Bearer $ACCESS_TOKEN" \
     "https://api.ciscospark.com/v1/people?email=$USER_EMAIL"
```

---

## 四、设备管理（WDM）

依赖链：**创建**返回 `url` → 后续 **查 / 改 / 删** 都用这个 URL。

### 创建设备  → 返回 `_wdm_url`
`POST https://wdm-a.wbx2.com/wdm/api/v1/devices`

```bash
curl -X POST \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "deviceType": "MAC",
    "localizedModel": "DESKTOP",
    "model": "DESKTOP",
    "name": "DESKTOP",
    "systemName": "DESKTOP",
    "systemVersion": "42"
  }' \
  "https://wdm-a.wbx2.com/wdm/api/v1/devices"
```
响应里的 `url` 即设备地址（后文记作 `$WDM_URL`）。

### 查 / 改 / 删设备

| 操作 | 请求 | 备注 |
|------|------|------|
| 获取 | `GET $WDM_URL` | 额外 Header `x-catalog-version2: true` |
| 更新 | `PUT $WDM_URL` | body 同创建 |
| 删除 | `DELETE $WDM_URL` | |
| 查 Region | `GET https://ds.ciscospark.com/v1/region` | |

```bash
curl -X DELETE \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -H "x-catalog-version2: true" \
  "$WDM_URL"
```

---

## 五、空间成员（Space）

向空间添加参会者：

`POST https://api.ciscospark.com/v1/memberships`（表单）

```bash
curl -X POST \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  --data-urlencode "personEmail=$EMAIL" \
  --data-urlencode "roomId=$ROOM_ID" \
  "https://api.ciscospark.com/v1/memberships"
```

---

## 六、在线状态（Presence / Apheleia）

| 操作 | 方法与 URL |
|------|-----------|
| 查状态 | `GET https://apheleia-a.wbx2.com/apheleia/api/v1/compositions`（表单参数 `userId`） |
| 设状态 | `POST https://apheleia-a.wbx2.com/apheleia/api/v1/events` |

```bash
curl -X POST \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{ "subject": "'"$USER_ID"'", "eventType": "ooo", "ttl": 10 }' \
  "https://apheleia-a.wbx2.com/apheleia/api/v1/events"
```

| 字段 | 说明 |
|------|------|
| `subject` | 目标用户 UUID |
| `eventType` | 状态类型，如 `ooo`（离开） |
| `ttl` | 有效期（秒） |

---

## 七、会议 / 呼叫核心（Locus）

| 操作 | 方法与 URL |
|------|-----------|
| 查媒体集群 | `GET https://calliope-a.wbx2.com/calliope/api/discovery/v1/clusters` |
| 查活动会议列表 | `GET https://locus-a.wbx2.com/locus/api/v1/loci` |
| 加入会议 | `POST https://locus-a.wbx2.com/locus/api/v1/loci/call` |

**加入会议**：需要一个临时 SIP URI 和一个关联 ID，二者都是随机 UUID：

```bash
CORR=$(uuidgen)
SIP="sipDialin:///$(uuidgen)"
curl -X POST \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -H "TrackingID: VDI_$(uuidgen)_1" \
  -H "Content-Type: application/json" \
  -d '{
    "device": { "url": "'"$WDM_URL"'", "deviceType": "WEB" },
    "invitee": { "address": "'"$SIP"'" },
    "sipDialInUrl": "'"$SIP"'",
    "correlationId": "'"$CORR"'"
  }' \
  "https://locus-a.wbx2.com/locus/api/v1/loci/call"
```
> 按会议号加入：把 `invitee.address` 换成 `wbxmn:<会议号>`。

**查会议信息**（三种方式）：

| 方式 | 请求 |
|------|------|
| 按 SIP URI | `GET .../loci/meetingInfo/<sipuri>?type=SIP_URI` |
| 按 Locus URL | `PUT .../loci/<locusId>/meetingInfo` |
| 按会议号 | `GET .../loci/meetingInfo/<number>?type=MEETING_ID` |

```bash
curl -H "Authorization: Bearer $ACCESS_TOKEN" \
     "https://locus-a.wbx2.com/locus/api/v1/loci/meetingInfo/208742176?type=MEETING_ID"
```

**会中控制**：

| 操作 | 请求 | body |
|------|------|------|
| 全球拨入号码 | `POST https://hecate-a.wbx2.com/hecate/api/v1/cmrmeetings/phonedirectory` | `{ "meetingUri": "erima@cisco.webex.com" }` |
| 移除设备 | `PUT .../loci/<locusId>/participant/<participantId>/leave` | `{ "deviceUrl": "..." }` |
| 踢人 | 同上 | `{ "reason": "FORCED" }` |
| 全体静音 | `PUT https://locus-a.wbx2.com/locus/api/v1/loci/<locusId>/controls` | `{ "audio": { "muted": true } }` |

---

## 八、目录搜索（Argonaut）

`POST https://argonaut-a.wbx2.com/argonaut/api/v1/directory`

```bash
curl -X POST \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "queryString": "SHN7-12",
    "includeMyBots": true,
    "includeRooms": true,
    "includePeople": true,
    "includeRobots": true,
    "searchEmailField": true,
    "size": 10
  }' \
  "https://argonaut-a.wbx2.com/argonaut/api/v1/directory"
```

---

## 九、云设备管理（CSDM）

| 操作 | 方法与 URL |
|------|-----------|
| 查设备在线状态 | `GET https://csdm-a.wbx2.com/csdm/api/v1/organization/<orgId>/accounts/<roomDeviceUuid>/presence` |
| 查我的设备 | `GET https://csdm-a.wbx2.com/csdm/api/v1/organization/<orgId>/devices?cisUuid=<userId>` |

```bash
curl -H "Authorization: Bearer $ACCESS_TOKEN" \
     "https://csdm-a.wbx2.com/csdm/api/v1/organization/$ORG_ID/devices?cisUuid=$USER_ID"
```

---

## 十、会议室系统（Lyra）

| 操作 | 方法与 URL |
|------|-----------|
| 查询 Lyra 空间 | `GET https://lyra-a.wbx2.com/lyra/api/v1/spaces/<roomDeviceUuid>` |
| 附近空间 | `GET https://lyra-a.wbx2.com/lyra/api/v1/spaces/<roomDeviceUuid>/nearby-spaces` |

---

## 十一、其他

| 操作 | 方法与 URL |
|------|-----------|
| 升级清单 | `GET https://client-upgrade-a.wbx2.com/client-upgrade/api/v1/WebexTeamsDesktop/upgrade/@me?channel=Gold&model=osx` |
| 服务健康检查 | `GET https://conv-a.wbx2.com/conversation/api/v1/ping/` |
| 头像 | `POST https://avatar-prod-us-east-2.webexcontent.com/avatar/api/v1/profiles/urls` |

**头像** body 为数组：

```bash
curl -X POST \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d '[{ "uuid": "'"$USER_ID"'", "sizes": ["80"] }]' \
  "https://avatar-prod-us-east-2.webexcontent.com/avatar/api/v1/profiles/urls"
```
