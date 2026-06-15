# 手机 Flutter IDE

这是一个 Android 手机上使用的 Flutter 项目编辑和 APK 打包 IDE，目标形态是类似手机端编程软件的完整移动 IDE：选择项目、编辑代码、补全片段、执行命令、查看日志并在手机上直接输出 APK。

核心能力：

- 第一次进入后检查文件权限、内置运行时和备用 Termux 服务。
- 工作台项目栏：选择 Flutter 项目后展示当前项目，并保存最近项目。
- 可以安装 App 内置运行时，初始化 Git、JDK、CMake、Ninja 等基础工具，并检查 `flutter doctor`。
- 可以填写 Flutter 项目路径，执行 `pub get`、`clean`、`flutter build apk`。
- 构建日志实时写入 `/storage/emulated/0/Download/phone_flutter_ide_logs`。
- 构建成功后 APK 会复制到 `/storage/emulated/0/Download/phone_flutter_ide_outputs`。
- 内置简单文本文件编辑器，可编辑 Dart、YAML、Gradle、XML、Markdown 等文件。
- 内置代码补全：Flutter/Dart 常用代码片段、Widget 模板、异步模板和构建命令片段。

## 运行时模式

当前 App 提供两种运行时入口，默认使用内置运行时：

- 内置运行时：运行时安装到 App 私有目录 `/data/user/0/com.blinlin.phoneide.phone_flutter_ide/files/embedded-runtime`，命令通过 App 自己的 `ProcessBuilder` 执行。
- APK 自带运行时：正式包可以把 `bootstrap-aarch64.zip` 放到 `assets/runtime/`，安装时从 APK 内部解压。
- 调试运行时：开发阶段也可以把 `bootstrap-aarch64.zip` 放到 `/storage/emulated/0/Download/phone_flutter_ide_runtime/`，点击“安装内置运行时”后导入。
- 外部 Termux 兼容：保留使用已安装 Termux 执行 `flutter`、`git`、`gradle` 命令的备用模式。

Termux 是开源生态，可以参考它的 bootstrap、包管理和 shell 执行模型。但本 App 不直接依赖外部 Termux 私有目录，而是使用自己的包名和私有运行时目录。完整手机打包需要分层准备：bootstrap、Flutter SDK、Android SDK、JDK、Gradle 缓存。

## 第一次使用

推荐流程：

1. 打开 App，点击“文件授权”。
2. 点击“安装运行时”，优先从 APK 自带 `assets/runtime/bootstrap-aarch64.zip` 安装；如果 APK 没内置运行时，就从 Download 目录导入。
3. 点击“初始化环境”，安装或检查 Git、JDK、CMake、Ninja、Flutter SDK、Android SDK。
4. 在“工作台”点击“选择”，选择 Flutter 项目目录。
5. 在“构建”里点击“Doctor”或“开始打包 APK”。

外部 Termux 备用模式才需要在 Termux 中执行：

```sh
mkdir -p ~/.termux
printf '\nallow-external-apps = true\n' >> ~/.termux/termux.properties
termux-reload-settings
pkg update -y
pkg install -y git curl wget unzip zip xz-utils openjdk-17 clang cmake ninja make
termux-setup-storage
```

## 默认路径

- 内置运行时: `/data/user/0/com.blinlin.phoneide.phone_flutter_ide/files/embedded-runtime`
- Flutter SDK: `/data/user/0/com.blinlin.phoneide.phone_flutter_ide/files/embedded-runtime/home/flutter`
- Android SDK: `/data/user/0/com.blinlin.phoneide.phone_flutter_ide/files/embedded-runtime/home/android-sdk`
- JAVA_HOME: `/data/user/0/com.blinlin.phoneide.phone_flutter_ide/files/embedded-runtime/usr`
- 外部 Termux Shell: `/data/data/com.termux/files/usr/bin/bash`
- 日志目录: `/storage/emulated/0/Download/phone_flutter_ide_logs`
- APK 输出目录: `/storage/emulated/0/Download/phone_flutter_ide_outputs`

## 内置运行时包

完整离线 APK 可以内置：

```text
assets/runtime/bootstrap-aarch64.zip
```

这个 zip 解压后应包含：

```text
usr/bin/bash
usr/bin/pkg 或 usr/bin/apt
usr/lib
home
```

运行时包、Flutter SDK、Android SDK、JDK 体积很大，不建议直接提交到 Git 仓库。更合理的方式是通过发布脚本或下载器生成完整测试包。

## GitHub 自动打包

仓库内置 GitHub Actions：

- workflow: `.github/workflows/android-debug.yml`
- 触发方式：push 到 `main` 或手动运行 `Android Debug APK`
- 输出文件：Actions Artifacts 里的 `phone-flutter-ide-debug-apk`

下载后安装 `app-debug.apk` 即可在手机上测试。

## 注意

如果使用内置运行时，本 App 不需要外部 Termux。只有切换到外部 Termux 备用模式时，才需要 Termux 开启 `allow-external-apps = true`。
