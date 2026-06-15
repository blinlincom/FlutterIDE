# 手机 Flutter IDE

这是一个 Android 手机上使用的 Flutter 项目编辑和 APK 打包助手。

核心能力：

- 第一次进入后检查文件权限、Termux 权限和 Termux RUN_COMMAND 服务。
- 可以初始化 Termux 基础环境，检查 `flutter doctor`。
- 可以填写 Flutter 项目路径，执行 `pub get`、`clean`、`flutter build apk`。
- 构建日志实时写入 `/storage/emulated/0/Download/phone_flutter_ide_logs`。
- 构建成功后 APK 会复制到 `/storage/emulated/0/Download/phone_flutter_ide_outputs`。
- 内置简单文本文件编辑器，可编辑 Dart、YAML、Gradle、XML、Markdown 等文件。

## 第一次使用

先安装 Termux，然后在 Termux 中执行：

```sh
mkdir -p ~/.termux
printf '\nallow-external-apps = true\n' >> ~/.termux/termux.properties
termux-reload-settings
pkg update -y
pkg install -y git curl wget unzip zip xz-utils openjdk-17 clang cmake ninja make
termux-setup-storage
```

再打开本 App：

1. 点击“文件授权”，开启所有文件访问权限。
2. 点击“Termux授权”，允许本 App 调用 Termux 命令。
3. 在“设置”里确认 Flutter SDK、Android SDK、JAVA_HOME 和 Shell 路径。
4. 在“构建”里填写项目路径，点击“Doctor”或“开始打包 APK”。

## 默认路径

- Flutter SDK: `/data/data/com.termux/files/home/flutter`
- Android SDK: `/data/data/com.termux/files/home/android-sdk`
- Termux Shell: `/data/data/com.termux/files/usr/bin/bash`
- 日志目录: `/storage/emulated/0/Download/phone_flutter_ide_logs`
- APK 输出目录: `/storage/emulated/0/Download/phone_flutter_ide_outputs`

## 注意

Android 普通 App 不能直接进入 Termux 沙盒执行命令，所以本项目通过 Termux 的 `com.termux.RUN_COMMAND` 服务启动打包任务。Termux 必须开启 `allow-external-apps = true`。
