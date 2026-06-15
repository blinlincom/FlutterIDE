# 手机 Flutter IDE

这是一个 Android 手机上使用的 Flutter 项目编辑和 APK 打包 IDE。

核心能力：

- 第一次进入后检查文件权限、Termux 权限和 Termux RUN_COMMAND 服务。
- 工作台项目栏：选择 Flutter 项目后展示当前项目，并保存最近项目。
- 可以初始化 Termux 基础环境，检查 `flutter doctor`。
- 可以填写 Flutter 项目路径，执行 `pub get`、`clean`、`flutter build apk`。
- 构建日志实时写入 `/storage/emulated/0/Download/phone_flutter_ide_logs`。
- 构建成功后 APK 会复制到 `/storage/emulated/0/Download/phone_flutter_ide_outputs`。
- 内置简单文本文件编辑器，可编辑 Dart、YAML、Gradle、XML、Markdown 等文件。
- 内置提示词工作台：构建失败分析、UI 重构、音视频排查、Git 提交说明等模板。

## 运行时模式

当前 App 提供两种运行时入口：

- 内置运行时优先：App 会预留 `/storage/emulated/0/Download/phone_flutter_ide_runtime` 作为工具链目录，后续可以放入自建 bootstrap、Flutter SDK、Android SDK 和 JDK。
- 外部 Termux 兼容：使用手机已安装的 Termux 执行真实 `flutter`、`git`、`gradle` 命令。

Android 普通 App 不能直接复用 Termux 私有沙盒，也不能简单把官方 Termux bootstrap 原样塞进另一个包名稳定运行。因此当前版本默认提供“内置运行时入口 + 外部 Termux 兼容执行”。如果后续要完全内置，需要单独制作自有 bootstrap 包和工具链分发。

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
3. 在“工作台”点击“选择”，选择 Flutter 项目目录。
4. 在“设置”里确认运行时模式、Flutter SDK、Android SDK、JAVA_HOME 和 Shell 路径。
5. 在“构建”里点击“Doctor”或“开始打包 APK”。

## 默认路径

- Flutter SDK: `/data/data/com.termux/files/home/flutter`
- Android SDK: `/data/data/com.termux/files/home/android-sdk`
- Termux Shell: `/data/data/com.termux/files/usr/bin/bash`
- 日志目录: `/storage/emulated/0/Download/phone_flutter_ide_logs`
- APK 输出目录: `/storage/emulated/0/Download/phone_flutter_ide_outputs`

## GitHub 自动打包

仓库内置 GitHub Actions：

- workflow: `.github/workflows/android-debug.yml`
- 触发方式：push 到 `main` 或手动运行 `Android Debug APK`
- 输出文件：Actions Artifacts 里的 `phone-flutter-ide-debug-apk`

下载后安装 `app-debug.apk` 即可在手机上测试。

## 注意

Android 普通 App 不能直接进入 Termux 沙盒执行命令，所以本项目通过 Termux 的 `com.termux.RUN_COMMAND` 服务启动打包任务。Termux 必须开启 `allow-external-apps = true`。
