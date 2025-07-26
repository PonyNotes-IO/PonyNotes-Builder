# iOS 构建配置摘要

## 证书和 Provisioning Profile 信息

### 证书
- **名称**: bofeng ma
- **类型**: iOS Development
- **过期时间**: 2026/07/26
- **Team ID**: 5MC7J2V78W

### Provisioning Profile
- **名称**: pony-ios-profile
- **类型**: Development
- **App ID**: 5MC7J2V78W.com.ioi.ponynotes
- **过期时间**: 2026/07/26

## 项目配置

### Bundle ID
- **配置**: com.ioi.ponynotes
- **位置**: 
  - `Info.plist`: `$(PRODUCT_BUNDLE_IDENTIFIER)`
  - `project.pbxproj`: `PRODUCT_BUNDLE_IDENTIFIER = com.ioi.ponynotes;`

### 签名配置
- **签名方式**: Manual
- **Team ID**: 5MC7J2V78W
- **Provisioning Profile**: pony-ios-profile
- **代码签名身份**: Apple Development

### ExportOptions.plist
```xml
<key>method</key>
<string>development</string>
<key>teamID</key>
<string>5MC7J2V78W</string>
<key>signingStyle</key>
<string>manual</string>
<key>provisioningProfiles</key>
<dict>
    <key>com.ioi.ponynotes</key>
    <string>pony-ios-profile</string>
</dict>
```

## GitHub Secrets 要求

### 必需的 Secrets
1. **IOS_CERTIFICATE_BASE64**
   - 内容: bofeng ma 证书的 base64 编码
   - 格式: .p12 证书文件的 base64 字符串

2. **IOS_PROVISION_PROFILE_BASE64**
   - 内容: pony-ios-profile 的 base64 编码
   - 格式: .mobileprovision 文件的 base64 字符串

3. **P12_PASSWORD**
   - 内容: 导出 .p12 证书时设置的密码

4. **IOS_KEYCHAIN_PASSWORD**
   - 内容: 任意密码（用于临时钥匙串）

## 配置验证清单

- [x] ExportOptions.plist 使用正确的 provisioning profile 名称
- [x] project.pbxproj 中所有构建配置都使用正确的 provisioning profile
- [x] Bundle ID 在所有配置中保持一致
- [x] 签名方式设置为 Manual
- [x] Team ID 正确配置
- [ ] GitHub Secrets 已更新（需要手动完成）

## 故障排除

如果构建仍然失败，请检查：
1. 证书是否正确导出为 .p12 格式
2. Provisioning profile 是否包含正确的证书
3. Bundle ID 是否完全匹配
4. GitHub Secrets 是否正确更新
5. 证书和 provisioning profile 是否都未过期 