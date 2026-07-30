# 02 - Contacts 联系人服务

> 联系人与分组的增删改查。特点是需要一条 **OAuth2（SAML2-bearer）鉴权链路**先换到 token。
> 私密凭据（`org_id`、`machine_account` 等）见 [00-鉴权与主机](00-环境变量与鉴权.md)，**切勿明文入库**。

## 一、鉴权链路（三步换取 access_token）

依次执行，前一步的输出作为后一步的输入。

### 步骤 1：换 assertion
`POST https://idbroker.webex.com/idb/token/<orgId>/v2/actions/GetBearerToken/invoke`

```bash
curl -X POST \
  -H "Content-Type: application/json" \
  -d '{ "name": "<machine_account>", "password": "<machine_account_pwd>" }' \
  "https://idbroker.webex.com/idb/token/$ORG_ID/v2/actions/GetBearerToken/invoke"
```
响应的 `BearerToken` 即 `assertion`（后文 `$ASSERTION`）。

### 步骤 2：换 access_token
`POST https://idbroker.webex.com/idb/oauth2/v1/access_token`（Basic Auth：client_id / client_secret）

```bash
curl -X POST \
  -u "$CLIENT_ID:$CLIENT_SECRET" \
  --data-urlencode "grant_type=urn:ietf:params:oauth:grant-type:saml2-bearer" \
  --data-urlencode "assertion=$ASSERTION" \
  --data-urlencode "scope=webex-squared:scheduler_use Identity:contact" \
  "https://idbroker.webex.com/idb/oauth2/v1/access_token"
```
响应里拿到 `access_token`（后文调联系人接口时作为 `$SELF_TOKEN`）和 `refresh_token`。

### 步骤 3：校验 token（可选）
`POST https://idbroker.webex.com/idb/oauth2/v1/tokeninfo`（表单 `token=<access_token>`、`return_user_role=true`）

---

## 二、联系人 CRUD

**通用**：Header `Authorization: Bearer $SELF_TOKEN`、`Content-Type: application/json`；host 为联系人服务地址（记作 `$CONTACT_HOST`）。

| 操作 | 方法与路径 |
|------|-----------|
| 创建 → 返回 `contact_id` / `contact_version` | `POST $CONTACT_HOST/api/v1/Users/contacts` |
| 批量创建 | `POST $CONTACT_HOST/api/v1/Users/contacts/bulk` |
| 查询全部 | `GET $CONTACT_HOST/api/v1/Users/contacts` |
| 修改 | `PATCH $CONTACT_HOST/api/v1/Users/contacts/<contactId>` |
| 删除单个 | `DELETE $CONTACT_HOST/api/v1/Users/contacts/<contactId>`（Header 带 `If-Match: <version>`） |
| 批量删除 | `POST $CONTACT_HOST/api/v1/Users/contacts/bulk/delete`（body 为 `objectIds` 数组） |

**创建联系人**：

```bash
curl -X POST \
  -H "Authorization: Bearer $SELF_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "contactType": "CLOUD",
    "displayName": "Test Contact",
    "emails": [{ "value": "test@example.com", "type": "work" }]
  }' \
  "$CONTACT_HOST/api/v1/Users/contacts"
```
响应返回 `contactId`，`ETag` 头里是版本号（后文 `$CONTACT_ID` / `$CONTACT_VERSION`）。

**删除联系人**（需带版本做乐观锁）：

```bash
curl -X DELETE \
  -H "Authorization: Bearer $SELF_TOKEN" \
  -H "If-Match: $CONTACT_VERSION" \
  "$CONTACT_HOST/api/v1/Users/contacts/$CONTACT_ID"
```
> `If-Match` 的值来自创建 / 查询返回的 ETag，避免并发覆盖。

---

## 三、分组（Group）

| 操作 | 方法 | 路径 |
|------|------|------|
| 创建 → 返回 `group_id` | POST | `/api/v1/Users/groups` |
| 批量创建 | POST | `/api/v1/Users/groups/bulk` |
| 重命名 | PATCH | `/api/v1/Users/groups/<groupId>` |
| 加成员 / 移除成员 | PATCH | `/api/v1/Users/groups/<groupId>` |
| 删除 | DELETE | `/api/v1/Users/groups/<groupId>`（需 `If-Match`） |

**添加联系人到分组**（`operation` 改成 `DELETE` 即为移除）：

```bash
curl -X PATCH \
  -H "Authorization: Bearer $SELF_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "members": [
      { "value": "'"$CONTACT_ID"'", "operation": "ADD" }
    ]
  }' \
  "$CONTACT_HOST/api/v1/Users/groups/$GROUP_ID"
```
