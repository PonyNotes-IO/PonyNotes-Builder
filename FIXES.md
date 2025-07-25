# PonyNotes-Builder macOS 构建修复

## 问题描述

在 macOS 构建过程中，代码签名步骤失败，错误信息为：
```
security: SecKeychainItemImport: Unknown format in import.
```

## 根本原因

PonyNotes-Builder 项目中的 macOS 工作流使用了错误的 secret 名称，与原始 PonyNotes 项目不一致：

- **错误配置**：
  - `MACOS_CERTIFICATE_BASE64` 
  - `P12_PASSWORD`

- **正确配置**：
  - `MACOS_CERTIFICATE`
  - `MACOS_CERTIFICATE_PWD`

## 修复内容

### 1. 修复了三个代码签名步骤

在 `PonyNotes-Builder/.github/workflows/macos.yaml` 中修复了以下三个 job 的代码签名配置：

- `x86_64` job (第 143-165 行)
- `aarch64` job (第 331-353 行)  
- `universal` job (第 530-552 行)

### 2. 更新了 README.md

修正了 `PonyNotes-Builder/README.md` 中 macOS 构建要求的说明：

- 将 `MACOS_CERTIFICATE_BASE64` 改为 `MACOS_CERTIFICATE`
- 将 `P12_PASSWORD` 改为 `MACOS_CERTIFICATE_PWD`
- 添加了更详细的说明

## 所需的 GitHub Secrets

确保在 GitHub 仓库中配置以下 secrets：

### 必需
- `MACOS_CERTIFICATE` - base64 编码的 .p12 证书
- `MACOS_CERTIFICATE_PWD` - .p12 证书的密码
- `MACOS_CODESIGN_ID` - 开发者 ID 或证书名称

### 可选（用于公证）
- `MACOS_NOTARY_PWD`
- `MACOS_NOTARY_USER` 
- `MACOS_TEAM_ID`

## 验证

修复后，代码签名步骤应该能够正常执行，不再出现 "Unknown format in import" 错误。

## 注意事项

- iOS 工作流使用不同的 secret 名称，无需修改
- 确保证书格式正确（.p12 格式）
- 确保证书密码正确
- 确保开发者 ID 与证书匹配 