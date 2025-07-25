#!/bin/bash

# 调试证书问题的脚本
# 这个脚本可以帮助诊断 macOS 代码签名证书的问题

echo "🔍 开始调试证书问题..."

# 检查证书 secret 是否存在
if [ -z "$MACOS_CERTIFICATE_BASE64" ]; then
    echo "❌ MACOS_CERTIFICATE_BASE64 未设置"
    exit 1
fi

if [ -z "$P12_PASSWORD" ]; then
    echo "❌ P12_PASSWORD 未设置"
    exit 1
fi

echo "✅ 证书 secrets 已设置"

# 解码证书
echo "📦 解码证书..."
echo $MACOS_CERTIFICATE_BASE64 | base64 --decode > certificate.p12

# 检查解码后的文件
if [ ! -f "certificate.p12" ]; then
    echo "❌ 证书解码失败，文件不存在"
    exit 1
fi

echo "✅ 证书文件已创建"
echo "📊 证书文件大小: $(ls -lh certificate.p12 | awk '{print $5}')"

# 检查文件格式
echo "🔍 检查证书文件格式..."
file certificate.p12

# 尝试使用 openssl 检查证书内容
echo "🔍 使用 OpenSSL 检查证书..."
if command -v openssl &> /dev/null; then
    echo "证书信息:"
    openssl pkcs12 -info -in certificate.p12 -noout -passin pass:"$P12_PASSWORD" 2>/dev/null || {
        echo "❌ OpenSSL 无法读取证书，可能是密码错误或格式问题"
        echo "尝试不提供密码:"
        openssl pkcs12 -info -in certificate.p12 -noout 2>&1 | head -5
    }
else
    echo "⚠️ OpenSSL 未安装，跳过证书内容检查"
fi

# 检查证书中的私钥
echo "🔍 检查证书中的私钥..."
if command -v openssl &> /dev/null; then
    openssl pkcs12 -in certificate.p12 -passin pass:"$P12_PASSWORD" -nocerts -out /dev/null 2>&1 | head -3 || {
        echo "❌ 无法提取私钥，可能是密码错误"
    }
fi

# 尝试导入到临时钥匙串
echo "🔍 尝试导入到临时钥匙串..."
security create-keychain -p test123 test.keychain
security default-keychain -s test.keychain
security unlock-keychain -p test123 test.keychain

# 尝试导入证书
echo "📥 尝试导入证书..."
security import certificate.p12 -k test.keychain -P "$P12_PASSWORD" -T /usr/bin/codesign 2>&1 || {
    echo "❌ 证书导入失败"
    echo "尝试不指定信任设置:"
    security import certificate.p12 -k test.keychain -P "$P12_PASSWORD" 2>&1 || {
        echo "❌ 即使不指定信任设置也失败"
    }
}

# 清理
security delete-keychain test.keychain
rm -f certificate.p12

echo "🔍 调试完成" 