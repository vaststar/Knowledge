# 05 - 其他（Misc）

> 一些零散但常用的接口：客户端升级检查、政府云开关、本地测试服务。

---

## 一、客户端升级检查（AppTastic）

检查桌面客户端是否有可升级版本。**无需鉴权**。

`GET https://client-upgrade-a.wbx2.com/client-upgrade/api/v1/webexteamsdesktop/upgrade/@me?channel=gold&model=<platform>`

```bash
# Windows
curl "https://client-upgrade-a.wbx2.com/client-upgrade/api/v1/webexteamsdesktop/upgrade/@me?channel=gold&model=win-64"

# macOS：把 model 换成 osx
curl "https://client-upgrade-a.wbx2.com/client-upgrade/api/v1/webexteamsdesktop/upgrade/@me?channel=gold&model=osx"
```

| 参数 | 说明 |
|------|------|
| `channel` | 发布通道：`gold`（正式）/ `beta` 等 |
| `model` | 平台：`win-64` / `osx` |

---

## 二、FedRAMP 灰度开关（政府云）

给指定用户设置 FedRAMP 相关开关，与 [01](01-Teams核心服务.md) 的 Feature Toggle 是同一套接口，
只是 host 换成政府云 `feature.gov.ciscospark.com`。

`POST https://feature.gov.ciscospark.com/feature/api/v1/features/users/<userId>/toggles`

```bash
curl -X POST \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "type": "USER",
    "key": "desktop-fedramp-launch-browser-join-commercial-meeting-enabled",
    "val": "true",
    "mutable": true
  }' \
  "https://feature.gov.ciscospark.com/feature/api/v1/features/users/$USER_ID/toggles"
```

---

## 三、本地鉴权测试服务（Test_Service）

一个本地跑的鉴权 demo（非 Webex 官方接口），用于测试登录 / 注册 / JWT。

| 请求 | 方法 | URL | Body |
|------|------|-----|------|
| 登录 | POST | `https://localhost:8443/api/auth/login` | `{ "email", "password" }` |
| 注册 | POST | `https://localhost:8443/api/auth/register` | `{ "email", "password", "name" }` |
| 当前用户 | GET | `http://localhost:8080/api/auth/me` | Bearer JWT |
| 刷新 token | GET | `/api/auth/refreshtoken` | — |

**登录**：

```bash
curl -k -X POST \
  -H "Content-Type: application/json" \
  -d '{ "email": "user@example.com", "password": "<password>" }' \
  "https://localhost:8443/api/auth/login"
```

**获取当前用户**：

```bash
curl -H "Authorization: Bearer $JWT_TOKEN" \
  "http://localhost:8080/api/auth/me"
```
