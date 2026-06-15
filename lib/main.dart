import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const PhoneFlutterIdeApp());
}

const Color _primaryColor = Color(0xFF6366F1);
const Color _successColor = Color(0xFF10B981);
const Color _warningColor = Color(0xFFF59E0B);
const Color _backgroundColor = Color(0xFFF8FAFC);
const Color _cardColor = Color(0xFFFFFFFF);
const Color _titleColor = Color(0xFF1E293B);
const Color _bodyColor = Color(0xFF64748B);
const Color _mutedColor = Color(0xFF94A3B8);

const String _configPath =
    '/storage/emulated/0/Download/phone_flutter_ide_config.json';
const String _defaultLogDir =
    '/storage/emulated/0/Download/phone_flutter_ide_logs';
const String _defaultOutputDir =
    '/storage/emulated/0/Download/phone_flutter_ide_outputs';

class PhoneFlutterIdeApp extends StatelessWidget {
  const PhoneFlutterIdeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '手机 Flutter IDE',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _primaryColor,
          surface: _backgroundColor,
        ),
        scaffoldBackgroundColor: _backgroundColor,
        appBarTheme: const AppBarTheme(
          centerTitle: false,
          elevation: 0,
          backgroundColor: _backgroundColor,
          foregroundColor: _titleColor,
          titleTextStyle: TextStyle(
            color: _titleColor,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        navigationBarTheme: NavigationBarThemeData(
          elevation: 0,
          backgroundColor: _cardColor,
          indicatorColor: _primaryColor.withValues(alpha: 0.12),
          labelTextStyle: WidgetStateProperty.all(
            const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            color: _titleColor,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
          titleMedium: TextStyle(
            color: _titleColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          bodyMedium: TextStyle(
            color: _bodyColor,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          bodySmall: TextStyle(
            color: _mutedColor,
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: _primaryColor,
            foregroundColor: Colors.white,
            minimumSize: const Size(0, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            textStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: _titleColor,
            minimumSize: const Size(0, 48),
            side: BorderSide(color: _primaryColor.withValues(alpha: 0.16)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFF1F5F9),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: _primaryColor, width: 1.4),
          ),
          labelStyle: const TextStyle(color: _bodyColor),
          hintStyle: const TextStyle(color: _mutedColor),
        ),
      ),
      home: const IdeHomePage(),
    );
  }
}

class AppConfig {
  const AppConfig({
    required this.projectPath,
    required this.flutterSdkPath,
    required this.androidHome,
    required this.javaHome,
    required this.termuxShell,
    required this.logDir,
    required this.outputDir,
    required this.buildMode,
    required this.extraArgs,
    required this.runtimeMode,
    required this.recentProjects,
  });

  factory AppConfig.defaults() {
    return const AppConfig(
      projectPath: '/storage/emulated/0/Download',
      flutterSdkPath: '/data/data/com.termux/files/home/flutter',
      androidHome: '/data/data/com.termux/files/home/android-sdk',
      javaHome: '/data/data/com.termux/files/usr',
      termuxShell: '/data/data/com.termux/files/usr/bin/bash',
      logDir: _defaultLogDir,
      outputDir: _defaultOutputDir,
      buildMode: 'debug',
      extraArgs: '',
      runtimeMode: 'embedded',
      recentProjects: <String>['/storage/emulated/0/Download'],
    );
  }

  final String projectPath;
  final String flutterSdkPath;
  final String androidHome;
  final String javaHome;
  final String termuxShell;
  final String logDir;
  final String outputDir;
  final String buildMode;
  final String extraArgs;
  final String runtimeMode;
  final List<String> recentProjects;

  AppConfig copyWith({
    String? projectPath,
    String? flutterSdkPath,
    String? androidHome,
    String? javaHome,
    String? termuxShell,
    String? logDir,
    String? outputDir,
    String? buildMode,
    String? extraArgs,
    String? runtimeMode,
    List<String>? recentProjects,
  }) {
    return AppConfig(
      projectPath: projectPath ?? this.projectPath,
      flutterSdkPath: flutterSdkPath ?? this.flutterSdkPath,
      androidHome: androidHome ?? this.androidHome,
      javaHome: javaHome ?? this.javaHome,
      termuxShell: termuxShell ?? this.termuxShell,
      logDir: logDir ?? this.logDir,
      outputDir: outputDir ?? this.outputDir,
      buildMode: buildMode ?? this.buildMode,
      extraArgs: extraArgs ?? this.extraArgs,
      runtimeMode: runtimeMode ?? this.runtimeMode,
      recentProjects: recentProjects ?? this.recentProjects,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'projectPath': projectPath,
      'flutterSdkPath': flutterSdkPath,
      'androidHome': androidHome,
      'javaHome': javaHome,
      'termuxShell': termuxShell,
      'logDir': logDir,
      'outputDir': outputDir,
      'buildMode': buildMode,
      'extraArgs': extraArgs,
      'runtimeMode': runtimeMode,
      'recentProjects': recentProjects,
    };
  }

  static AppConfig fromJson(Map<String, dynamic> json) {
    final defaults = AppConfig.defaults();
    return defaults.copyWith(
      projectPath: (json['projectPath'] as String?) ?? defaults.projectPath,
      flutterSdkPath:
          (json['flutterSdkPath'] as String?) ?? defaults.flutterSdkPath,
      androidHome: (json['androidHome'] as String?) ?? defaults.androidHome,
      javaHome: (json['javaHome'] as String?) ?? defaults.javaHome,
      termuxShell: (json['termuxShell'] as String?) ?? defaults.termuxShell,
      logDir: (json['logDir'] as String?) ?? defaults.logDir,
      outputDir: (json['outputDir'] as String?) ?? defaults.outputDir,
      buildMode: (json['buildMode'] as String?) ?? defaults.buildMode,
      extraArgs: (json['extraArgs'] as String?) ?? defaults.extraArgs,
      runtimeMode: (json['runtimeMode'] as String?) ?? defaults.runtimeMode,
      recentProjects:
          (json['recentProjects'] as List<dynamic>?)
              ?.whereType<String>()
              .where((path) => path.trim().isNotEmpty)
              .toList() ??
          defaults.recentProjects,
    );
  }
}

class ConfigStore {
  Future<AppConfig> load() async {
    final file = File(_configPath);
    if (!await file.exists()) {
      return AppConfig.defaults();
    }
    try {
      final raw = await file.readAsString();
      final jsonMap = jsonDecode(raw) as Map<String, dynamic>;
      return AppConfig.fromJson(jsonMap);
    } catch (_) {
      return AppConfig.defaults();
    }
  }

  Future<void> save(AppConfig config) async {
    final file = File(_configPath);
    await file.parent.create(recursive: true);
    await file.writeAsString(
      const JsonEncoder.withIndent('  ').convert(config.toJson()),
    );
  }
}

class NativeStatus {
  const NativeStatus({
    required this.storageGranted,
    required this.termuxPermissionGranted,
    required this.termuxServiceAvailable,
    required this.termuxInstalled,
    required this.embeddedRuntimeInstalled,
  });

  factory NativeStatus.unknown() {
    return const NativeStatus(
      storageGranted: false,
      termuxPermissionGranted: false,
      termuxServiceAvailable: false,
      termuxInstalled: false,
      embeddedRuntimeInstalled: false,
    );
  }

  final bool storageGranted;
  final bool termuxPermissionGranted;
  final bool termuxServiceAvailable;
  final bool termuxInstalled;
  final bool embeddedRuntimeInstalled;

  bool get readyForBuild {
    return storageGranted &&
        (embeddedRuntimeInstalled ||
            (termuxInstalled &&
                termuxPermissionGranted &&
                termuxServiceAvailable));
  }

  int get readyCount {
    return [
      storageGranted,
      termuxInstalled,
      termuxPermissionGranted,
      termuxServiceAvailable,
      embeddedRuntimeInstalled,
    ].where((ready) => ready).length;
  }

  static NativeStatus fromMap(Map<dynamic, dynamic> map) {
    return NativeStatus(
      storageGranted: map['storageGranted'] == true,
      termuxPermissionGranted: map['termuxPermissionGranted'] == true,
      termuxServiceAvailable: map['termuxServiceAvailable'] == true,
      termuxInstalled: map['termuxInstalled'] == true,
      embeddedRuntimeInstalled: map['embeddedRuntimeInstalled'] == true,
    );
  }
}

class NativeBridge {
  static const MethodChannel _channel = MethodChannel(
    'com.blinlin.phoneide/native',
  );

  static Future<NativeStatus> status() async {
    final result = await _channel.invokeMethod<Map<dynamic, dynamic>>('status');
    return NativeStatus.fromMap(result ?? const {});
  }

  static Future<void> openStorageSettings() {
    return _channel.invokeMethod<void>('openStorageSettings');
  }

  static Future<void> requestTermuxPermission() {
    return _channel.invokeMethod<void>('requestTermuxPermission');
  }

  static Future<void> openTermux() {
    return _channel.invokeMethod<void>('openTermux');
  }

  static Future<Map<dynamic, dynamic>?> pickProjectDirectory() {
    return _channel.invokeMethod<Map<dynamic, dynamic>?>(
      'pickProjectDirectory',
    );
  }

  static Future<Map<dynamic, dynamic>> runTermux({
    required String shell,
    required String command,
    required String workdir,
  }) async {
    final result = await _channel.invokeMethod<Map<dynamic, dynamic>>(
      'runTermux',
      {'shell': shell, 'command': command, 'workdir': workdir},
    );
    return result ?? const {};
  }

  static Future<Map<dynamic, dynamic>> runEmbedded({
    required String command,
    required String workdir,
  }) async {
    final result = await _channel.invokeMethod<Map<dynamic, dynamic>>(
      'runEmbedded',
      {'command': command, 'workdir': workdir},
    );
    return result ?? const {};
  }

  static Future<Map<dynamic, dynamic>> installEmbeddedRuntime() async {
    final result = await _channel.invokeMethod<Map<dynamic, dynamic>>(
      'installEmbeddedRuntime',
    );
    return result ?? const {};
  }
}

class IdeHomePage extends StatefulWidget {
  const IdeHomePage({super.key});

  @override
  State<IdeHomePage> createState() => _IdeHomePageState();
}

class _IdeHomePageState extends State<IdeHomePage> {
  final ConfigStore _store = ConfigStore();
  final TextEditingController _projectController = TextEditingController();
  final TextEditingController _flutterController = TextEditingController();
  final TextEditingController _androidHomeController = TextEditingController();
  final TextEditingController _javaHomeController = TextEditingController();
  final TextEditingController _shellController = TextEditingController();
  final TextEditingController _logDirController = TextEditingController();
  final TextEditingController _outputDirController = TextEditingController();
  final TextEditingController _extraArgsController = TextEditingController();

  AppConfig _config = AppConfig.defaults();
  NativeStatus _status = NativeStatus.unknown();
  int _tabIndex = 0;
  String? _activeLogPath;
  String _activeLogText = '';
  String _statusText = '准备就绪';
  bool _showOnboarding = true;
  Timer? _logTimer;

  @override
  void initState() {
    super.initState();
    _loadConfig();
    _refreshStatus();
  }

  @override
  void dispose() {
    _logTimer?.cancel();
    _projectController.dispose();
    _flutterController.dispose();
    _androidHomeController.dispose();
    _javaHomeController.dispose();
    _shellController.dispose();
    _logDirController.dispose();
    _outputDirController.dispose();
    _extraArgsController.dispose();
    super.dispose();
  }

  Future<void> _loadConfig() async {
    final config = await _store.load();
    if (!mounted) return;
    setState(() {
      _config = config;
      _syncControllers(config);
    });
    await _ensureDirectories(config);
  }

  void _syncControllers(AppConfig config) {
    _projectController.text = config.projectPath;
    _flutterController.text = config.flutterSdkPath;
    _androidHomeController.text = config.androidHome;
    _javaHomeController.text = config.javaHome;
    _shellController.text = config.termuxShell;
    _logDirController.text = config.logDir;
    _outputDirController.text = config.outputDir;
    _extraArgsController.text = config.extraArgs;
  }

  Future<void> _ensureDirectories(AppConfig config) async {
    try {
      await Directory(config.logDir).create(recursive: true);
      await Directory(config.outputDir).create(recursive: true);
    } catch (_) {
      // The user may not have granted all-files access yet.
    }
  }

  AppConfig _readConfigFromFields() {
    return _config.copyWith(
      projectPath: _projectController.text.trim(),
      flutterSdkPath: _flutterController.text.trim(),
      androidHome: _androidHomeController.text.trim(),
      javaHome: _javaHomeController.text.trim(),
      termuxShell: _shellController.text.trim(),
      logDir: _logDirController.text.trim(),
      outputDir: _outputDirController.text.trim(),
      extraArgs: _extraArgsController.text.trim(),
    );
  }

  List<String> _mergeRecentProjects(String selected) {
    final normalized = selected.trim();
    final next = <String>[
      if (normalized.isNotEmpty) normalized,
      ..._config.recentProjects.where((path) => path != normalized),
    ];
    return next.take(8).toList();
  }

  Future<void> _selectProject(String path) async {
    final normalized = path.trim();
    if (normalized.isEmpty) return;
    final next = _config.copyWith(
      projectPath: normalized,
      recentProjects: _mergeRecentProjects(normalized),
    );
    setState(() {
      _config = next;
      _projectController.text = normalized;
    });
    await _store.save(next);
  }

  Future<void> _pickProjectDirectory() async {
    try {
      final result = await NativeBridge.pickProjectDirectory();
      final path = result?['displayPath']?.toString();
      if (path == null || path.isEmpty) return;
      await _selectProject(path);
      _showSnack('已选择项目：${_baseName(path)}');
    } on PlatformException catch (error) {
      _showSnack(error.message ?? '选择目录失败');
    }
  }

  Future<void> _saveConfig({bool showMessage = false}) async {
    final next = _readConfigFromFields();
    final withRecent = next.copyWith(
      recentProjects: _mergeRecentProjects(next.projectPath),
    );
    setState(() => _config = withRecent);
    await _ensureDirectories(withRecent);
    await _store.save(withRecent);
    if (showMessage && mounted) {
      _showSnack('配置已保存');
    }
  }

  Future<void> _refreshStatus() async {
    try {
      final next = await NativeBridge.status();
      if (!mounted) return;
      setState(() {
        _status = next;
        _showOnboarding = !next.readyForBuild;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _statusText = '原生通道不可用：$error');
    }
  }

  void _startLogPolling(String logPath) {
    _logTimer?.cancel();
    _activeLogPath = logPath;
    _readActiveLog();
    _logTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      _readActiveLog();
    });
  }

  Future<void> _readActiveLog() async {
    final path = _activeLogPath;
    if (path == null) return;
    try {
      final file = File(path);
      if (!await file.exists()) return;
      var text = await file.readAsString();
      if (text.length > 24000) {
        text = text.substring(text.length - 24000);
      }
      if (!mounted) return;
      setState(() => _activeLogText = text);
    } catch (_) {
      // The log may be rotated while reading.
    }
  }

  Future<void> _runIdeTask({
    required String title,
    required String prefix,
    required String body,
    required String workdir,
  }) async {
    await _saveConfig();
    final logPath = _newLogPath(prefix);
    await File(logPath).parent.create(recursive: true);
    await File(logPath).writeAsString('[$title] 等待运行时启动...\n');
    _startLogPolling(logPath);
    setState(() => _statusText = '$title 已提交到运行时');

    final wrapped = _wrapTermuxScript(
      title: title,
      body: body,
      logPath: logPath,
    );
    try {
      final useEmbedded =
          _config.runtimeMode == 'embedded' && _status.embeddedRuntimeInstalled;
      final result = useEmbedded
          ? await NativeBridge.runEmbedded(command: wrapped, workdir: workdir)
          : await NativeBridge.runTermux(
              shell: _config.termuxShell,
              command: wrapped,
              workdir: workdir,
            );
      setState(() => _statusText = result['message']?.toString() ?? '命令已启动');
    } on PlatformException catch (error) {
      await File(logPath).writeAsString(
        '\n启动失败：${error.message ?? error.code}\n',
        mode: FileMode.append,
      );
      setState(() => _statusText = '启动失败：${error.message ?? error.code}');
      _readActiveLog();
    }
  }

  String _newLogPath(String prefix) {
    final now = DateTime.now()
        .toIso8601String()
        .replaceAll(':', '-')
        .replaceAll('.', '-');
    return '${_config.logDir}/$prefix-$now.log';
  }

  String _wrapTermuxScript({
    required String title,
    required String body,
    required String logPath,
  }) {
    final log = _shellQuote(logPath);
    final logDir = _shellQuote(_config.logDir);
    final outputDir = _shellQuote(_config.outputDir);
    final flutterBin = _shellQuote(_flutterExecutable());
    final flutterPath = _shellQuote('${_config.flutterSdkPath}/bin');
    final androidHome = _shellQuote(_config.androidHome);
    final javaHome = _shellQuote(_config.javaHome);
    final runtimeMode = _shellQuote(_config.runtimeMode);
    return '''
mkdir -p $logDir $outputDir
{
echo "========== $title =========="
date
echo "工作目录: \$(pwd)"
echo "运行时模式: $runtimeMode"
export PATH=$flutterPath:/data/data/com.termux/files/usr/bin:\$PATH
export ANDROID_HOME=$androidHome
export ANDROID_SDK_ROOT=$androidHome
export JAVA_HOME=$javaHome
export PHONE_FLUTTER_IDE_OUTPUT=$outputDir
export FLUTTER_BIN=$flutterBin
echo "Flutter: \$FLUTTER_BIN"
echo "ANDROID_HOME: \$ANDROID_HOME"
echo
(
$body
)
exit_code=\$?
echo
echo "========== 结束，退出码 \$exit_code =========="
exit \$exit_code
} >> $log 2>&1
''';
  }

  String _flutterExecutable() {
    final path = _config.flutterSdkPath.trim();
    if (path.isEmpty) return 'flutter';
    return '$path/bin/flutter';
  }

  String _projectWorkdir() {
    final value = _projectController.text.trim();
    return value.isEmpty ? '/storage/emulated/0/Download' : value;
  }

  Future<void> _runEnvironmentSetup() async {
    await _runIdeTask(
      title: '一键配置手机 Flutter IDE 环境',
      prefix: 'setup',
      workdir: '/data/data/com.termux/files/home',
      body:
          '''
echo "安装基础工具..."
pkg update -y
pkg install -y git curl wget unzip zip xz-utils openjdk-17 clang cmake ninja make openssh
mkdir -p "\$HOME/.termux"
mkdir -p "/storage/emulated/0/Download/phone_flutter_ide_runtime"
if ! grep -q "^allow-external-apps *= *true" "\$HOME/.termux/termux.properties" 2>/dev/null; then
  printf "\\nallow-external-apps = true\\n" >> "\$HOME/.termux/termux.properties"
fi
termux-reload-settings || true
termux-setup-storage || true
mkdir -p "\$HOME/projects"
echo
echo "检查 Flutter..."
if [ -x "\$FLUTTER_BIN" ]; then
  "\$FLUTTER_BIN" --version
  "\$FLUTTER_BIN" doctor -v
else
  echo "没有找到 Flutter SDK: \$FLUTTER_BIN"
  echo "可以把 Flutter SDK 安装到 ${_config.flutterSdkPath}"
fi
''',
    );
  }

  Future<void> _runEnvironmentAudit() async {
    await _runIdeTask(
      title: 'IDE 环境自检',
      prefix: 'env-audit',
      workdir: _projectWorkdir(),
      body: '''
echo "Termux: \$(uname -a)"
echo "PATH: \$PATH"
echo
command -v git && git --version || true
command -v java && java -version || true
command -v clang && clang --version | head -n 1 || true
command -v cmake && cmake --version | head -n 1 || true
command -v ninja && ninja --version || true
echo
if [ -x "\$FLUTTER_BIN" ]; then
  "\$FLUTTER_BIN" --version
  "\$FLUTTER_BIN" doctor -v
else
  echo "Flutter 不存在: \$FLUTTER_BIN"
fi
echo
if [ -f pubspec.yaml ]; then
  echo "当前项目: \$(pwd)"
  sed -n '1,80p' pubspec.yaml
else
  echo "当前目录没有 pubspec.yaml"
fi
''',
    );
  }

  Future<void> _runDoctor() async {
    await _runIdeTask(
      title: 'Flutter Doctor',
      prefix: 'doctor',
      workdir: _projectWorkdir(),
      body: '''
if [ ! -x "\$FLUTTER_BIN" ]; then
  echo "Flutter 不存在: \$FLUTTER_BIN"
  exit 2
fi
"\$FLUTTER_BIN" --version
"\$FLUTTER_BIN" doctor -v
''',
    );
  }

  Future<void> _runPubGet() async {
    await _runIdeTask(
      title: 'Pub Get',
      prefix: 'pub-get',
      workdir: _projectWorkdir(),
      body: '''
if [ ! -f pubspec.yaml ]; then
  echo "当前目录没有 pubspec.yaml"
  exit 2
fi
"\$FLUTTER_BIN" pub get
''',
    );
  }

  Future<void> _runAnalyze() async {
    await _runIdeTask(
      title: 'Flutter Analyze',
      prefix: 'analyze',
      workdir: _projectWorkdir(),
      body: '''
if [ ! -f pubspec.yaml ]; then
  echo "当前目录没有 pubspec.yaml"
  exit 2
fi
"\$FLUTTER_BIN" analyze
''',
    );
  }

  Future<void> _runGitStatus() async {
    await _runIdeTask(
      title: 'Git 状态',
      prefix: 'git-status',
      workdir: _projectWorkdir(),
      body: '''
if [ ! -d .git ]; then
  echo "当前目录不是 Git 仓库"
  exit 0
fi
git status --short --branch
echo
git log --oneline --decorate --max-count=12
''',
    );
  }

  Future<void> _runClean() async {
    await _runIdeTask(
      title: 'Flutter Clean',
      prefix: 'clean',
      workdir: _projectWorkdir(),
      body: '''
if [ ! -f pubspec.yaml ]; then
  echo "当前目录没有 pubspec.yaml"
  exit 2
fi
"\$FLUTTER_BIN" clean
''',
    );
  }

  Future<void> _runBuild() async {
    final mode = _config.buildMode;
    final extraArgs = _extraArgsController.text.trim();
    await _runIdeTask(
      title: '构建 Android APK',
      prefix: 'build-apk',
      workdir: _projectWorkdir(),
      body:
          '''
if [ ! -f pubspec.yaml ]; then
  echo "当前目录没有 pubspec.yaml"
  exit 2
fi
"\$FLUTTER_BIN" --version
"\$FLUTTER_BIN" pub get
"\$FLUTTER_BIN" build apk --$mode $extraArgs
status=\$?
if [ "\$status" -eq 0 ]; then
  mkdir -p "\$PHONE_FLUTTER_IDE_OUTPUT"
  find build/app/outputs/flutter-apk -maxdepth 1 -type f -name "*.apk" -exec cp -f {} "\$PHONE_FLUTTER_IDE_OUTPUT"/ \\;
  echo
  echo "APK 已复制到: \$PHONE_FLUTTER_IDE_OUTPUT"
  ls -lh "\$PHONE_FLUTTER_IDE_OUTPUT"/*.apk 2>/dev/null || true
fi
exit "\$status"
''',
    );
  }

  Future<void> _copySetupCommand() async {
    final command = '''
mkdir -p ~/.termux
printf '\\nallow-external-apps = true\\n' >> ~/.termux/termux.properties
termux-reload-settings
pkg update -y
pkg install -y git curl wget unzip zip xz-utils openjdk-17 clang cmake ninja make
termux-setup-storage
''';
    await Clipboard.setData(ClipboardData(text: command.trim()));
    _showSnack('Termux 初始化命令已复制');
  }

  Future<void> _openTermux() async {
    try {
      await NativeBridge.openTermux();
    } on PlatformException catch (error) {
      _showSnack(error.message ?? '无法打开 Termux');
    }
  }

  Future<void> _installEmbeddedRuntime() async {
    try {
      final result = await NativeBridge.installEmbeddedRuntime();
      setState(() {
        _statusText = result['message']?.toString() ?? '内置运行时安装已启动';
      });
      _showSnack('内置运行时安装已启动');
      await Future<void>.delayed(const Duration(seconds: 1));
      _refreshStatus();
    } on PlatformException catch (error) {
      _showSnack(error.message ?? '内置运行时安装失败');
    }
  }

  Future<void> _copyPrompt(String text) async {
    await Clipboard.setData(ClipboardData(text: text.trim()));
    _showSnack('提示词已复制');
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      DashboardPage(
        status: _status,
        statusText: _statusText,
        activeLogText: _activeLogText,
        activeLogPath: _activeLogPath,
        projectController: _projectController,
        currentProject: _config.projectPath,
        recentProjects: _config.recentProjects,
        runtimeMode: _config.runtimeMode,
        onPickProject: _pickProjectDirectory,
        onSelectProject: _selectProject,
        onRefreshStatus: _refreshStatus,
        onOpenStorageSettings: () async {
          await NativeBridge.openStorageSettings();
          await Future<void>.delayed(const Duration(milliseconds: 600));
          _refreshStatus();
        },
        onRequestTermuxPermission: () async {
          await NativeBridge.requestTermuxPermission();
          await Future<void>.delayed(const Duration(milliseconds: 600));
          _refreshStatus();
        },
        onOpenTermux: _openTermux,
        onSetup: _runEnvironmentSetup,
        onAudit: _runEnvironmentAudit,
        onDoctor: _runDoctor,
        onPubGet: _runPubGet,
        onAnalyze: _runAnalyze,
        onGitStatus: _runGitStatus,
        onOpenBuildTab: () => setState(() => _tabIndex = 2),
        onDismissGuide: () => setState(() => _showOnboarding = false),
        showGuide: _showOnboarding,
      ),
      FileBrowserPage(initialPath: _config.projectPath),
      BuildPage(
        status: _status,
        statusText: _statusText,
        activeLogText: _activeLogText,
        activeLogPath: _activeLogPath,
        projectController: _projectController,
        extraArgsController: _extraArgsController,
        buildMode: _config.buildMode,
        onBuildModeChanged: (value) {
          setState(() => _config = _config.copyWith(buildMode: value));
        },
        onRefreshStatus: _refreshStatus,
        onOpenStorageSettings: () async {
          await NativeBridge.openStorageSettings();
          await Future<void>.delayed(const Duration(milliseconds: 600));
          _refreshStatus();
        },
        onRequestTermuxPermission: () async {
          await NativeBridge.requestTermuxPermission();
          await Future<void>.delayed(const Duration(milliseconds: 600));
          _refreshStatus();
        },
        onOpenTermux: _openTermux,
        onSetup: _runEnvironmentSetup,
        onAudit: _runEnvironmentAudit,
        onDoctor: _runDoctor,
        onPubGet: _runPubGet,
        onClean: _runClean,
        onAnalyze: _runAnalyze,
        onGitStatus: _runGitStatus,
        onBuild: _runBuild,
      ),
      PromptPage(onCopyPrompt: _copyPrompt),
      SettingsPage(
        status: _status,
        flutterController: _flutterController,
        androidHomeController: _androidHomeController,
        javaHomeController: _javaHomeController,
        shellController: _shellController,
        logDirController: _logDirController,
        outputDirController: _outputDirController,
        runtimeMode: _config.runtimeMode,
        onRuntimeModeChanged: (mode) async {
          final next = _config.copyWith(runtimeMode: mode);
          setState(() => _config = next);
          await _store.save(next);
        },
        onSave: () => _saveConfig(showMessage: true),
        onCopySetupCommand: _copySetupCommand,
        onOpenTermux: _openTermux,
        onInstallEmbeddedRuntime: _installEmbeddedRuntime,
        onSetup: _runEnvironmentSetup,
        onAudit: _runEnvironmentAudit,
      ),
      LogsPage(
        logDir: _config.logDir,
        outputDir: _config.outputDir,
        activeLogPath: _activeLogPath,
        onSelectLog: (path) {
          _startLogPolling(path);
          setState(() => _tabIndex = 2);
        },
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mobile Flutter Studio'),
        actions: [
          IconButton(
            tooltip: '打开 Termux',
            onPressed: _openTermux,
            icon: const Icon(Icons.terminal_outlined),
          ),
          IconButton(
            tooltip: '刷新状态',
            onPressed: _refreshStatus,
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: SafeArea(
        child: IndexedStack(index: _tabIndex, children: pages),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tabIndex,
        onDestinationSelected: (index) => setState(() => _tabIndex = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: '工作台',
          ),
          NavigationDestination(
            icon: Icon(Icons.folder_open_outlined),
            selectedIcon: Icon(Icons.folder),
            label: '文件',
          ),
          NavigationDestination(
            icon: Icon(Icons.terminal_outlined),
            selectedIcon: Icon(Icons.terminal),
            label: '构建',
          ),
          NavigationDestination(
            icon: Icon(Icons.auto_awesome_outlined),
            selectedIcon: Icon(Icons.auto_awesome),
            label: '提示词',
          ),
          NavigationDestination(
            icon: Icon(Icons.tune_outlined),
            selectedIcon: Icon(Icons.tune),
            label: '设置',
          ),
          NavigationDestination(
            icon: Icon(Icons.subject_outlined),
            selectedIcon: Icon(Icons.subject),
            label: '日志',
          ),
        ],
      ),
    );
  }
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({
    super.key,
    required this.status,
    required this.statusText,
    required this.activeLogText,
    required this.activeLogPath,
    required this.projectController,
    required this.currentProject,
    required this.recentProjects,
    required this.runtimeMode,
    required this.onPickProject,
    required this.onSelectProject,
    required this.onRefreshStatus,
    required this.onOpenStorageSettings,
    required this.onRequestTermuxPermission,
    required this.onOpenTermux,
    required this.onSetup,
    required this.onAudit,
    required this.onDoctor,
    required this.onPubGet,
    required this.onAnalyze,
    required this.onGitStatus,
    required this.onOpenBuildTab,
    required this.onDismissGuide,
    required this.showGuide,
  });

  final NativeStatus status;
  final String statusText;
  final String activeLogText;
  final String? activeLogPath;
  final TextEditingController projectController;
  final String currentProject;
  final List<String> recentProjects;
  final String runtimeMode;
  final VoidCallback onPickProject;
  final ValueChanged<String> onSelectProject;
  final VoidCallback onRefreshStatus;
  final VoidCallback onOpenStorageSettings;
  final VoidCallback onRequestTermuxPermission;
  final VoidCallback onOpenTermux;
  final VoidCallback onSetup;
  final VoidCallback onAudit;
  final VoidCallback onDoctor;
  final VoidCallback onPubGet;
  final VoidCallback onAnalyze;
  final VoidCallback onGitStatus;
  final VoidCallback onOpenBuildTab;
  final VoidCallback onDismissGuide;
  final bool showGuide;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      children: [
        IdeHero(
          title: 'Mobile Flutter Studio',
          subtitle: '手机端项目编辑、环境配置、日志诊断和 APK 构建工作台',
          icon: Icons.code_rounded,
          trailing: status.readyForBuild ? 'READY' : '${status.readyCount}/4',
        ),
        if (showGuide) ...[
          const SizedBox(height: 20),
          OnboardingPanel(
            status: status,
            onOpenStorageSettings: onOpenStorageSettings,
            onRequestTermuxPermission: onRequestTermuxPermission,
            onOpenTermux: onOpenTermux,
            onSetup: onSetup,
            onDismiss: onDismissGuide,
          ),
        ],
        const SizedBox(height: 20),
        SectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionTitle(
                icon: Icons.insights_outlined,
                title: '项目栏',
                subtitle: '选择 Flutter 项目后，会展示到这里并保存到最近项目',
              ),
              const SizedBox(height: 16),
              ProjectHeader(
                path: currentProject,
                runtimeMode: runtimeMode,
                onPickProject: onPickProject,
              ),
              const SizedBox(height: 14),
              TextField(
                controller: projectController,
                decoration: const InputDecoration(
                  labelText: '项目路径',
                  prefixIcon: Icon(Icons.folder_outlined),
                ),
              ),
              if (recentProjects.isNotEmpty) ...[
                const SizedBox(height: 14),
                Text('最近项目', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 10),
                SizedBox(
                  height: 78,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: recentProjects.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 10),
                    itemBuilder: (context, index) {
                      final project = recentProjects[index];
                      return RecentProjectChip(
                        path: project,
                        selected: project == currentProject,
                        onTap: () => onSelectProject(project),
                      );
                    },
                  ),
                ),
              ],
              const SizedBox(height: 14),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  ActionChipButton(
                    icon: Icons.terminal_outlined,
                    label: '构建面板',
                    onPressed: onOpenBuildTab,
                  ),
                  ActionChipButton(
                    icon: Icons.fact_check_outlined,
                    label: '环境自检',
                    onPressed: onAudit,
                  ),
                  ActionChipButton(
                    icon: Icons.medical_information_outlined,
                    label: 'Doctor',
                    onPressed: onDoctor,
                  ),
                  ActionChipButton(
                    icon: Icons.download_done_outlined,
                    label: 'Pub Get',
                    onPressed: onPubGet,
                  ),
                  ActionChipButton(
                    icon: Icons.manage_search_outlined,
                    label: 'Analyze',
                    onPressed: onAnalyze,
                  ),
                  ActionChipButton(
                    icon: Icons.account_tree_outlined,
                    label: 'Git状态',
                    onPressed: onGitStatus,
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        SectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionTitle(
                icon: Icons.health_and_safety_outlined,
                title: '服务状态',
                subtitle: '文件权限、Termux、外部命令服务必须全部可用',
              ),
              const SizedBox(height: 16),
              StatusPills(status: status),
              const SizedBox(height: 12),
              Text(statusText, style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 14),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  ActionChipButton(
                    icon: Icons.folder_special_outlined,
                    label: '文件授权',
                    onPressed: onOpenStorageSettings,
                  ),
                  ActionChipButton(
                    icon: Icons.terminal_outlined,
                    label: 'Termux授权',
                    onPressed: onRequestTermuxPermission,
                  ),
                  ActionChipButton(
                    icon: Icons.open_in_new_rounded,
                    label: '打开Termux',
                    onPressed: onOpenTermux,
                  ),
                  ActionChipButton(
                    icon: Icons.refresh_rounded,
                    label: '刷新',
                    onPressed: onRefreshStatus,
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        SectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionTitle(
                icon: Icons.receipt_long_outlined,
                title: '最近终端',
                subtitle: activeLogPath ?? '暂无运行日志',
              ),
              const SizedBox(height: 14),
              LogBox(
                text: activeLogText.isEmpty ? '运行命令后会在这里看到日志。' : activeLogText,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class OnboardingPanel extends StatelessWidget {
  const OnboardingPanel({
    super.key,
    required this.status,
    required this.onOpenStorageSettings,
    required this.onRequestTermuxPermission,
    required this.onOpenTermux,
    required this.onSetup,
    required this.onDismiss,
  });

  final NativeStatus status;
  final VoidCallback onOpenStorageSettings;
  final VoidCallback onRequestTermuxPermission;
  final VoidCallback onOpenTermux;
  final VoidCallback onSetup;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(
            icon: Icons.rocket_launch_outlined,
            title: '首次环境向导',
            subtitle: '按顺序完成后，手机就能作为 Flutter Android 打包工作站',
          ),
          const SizedBox(height: 16),
          SetupStepTile(
            index: 1,
            title: '开启文件访问',
            subtitle: '允许 IDE 读取项目、保存日志和复制 APK',
            done: status.storageGranted,
            actionLabel: '去授权',
            onTap: onOpenStorageSettings,
          ),
          SetupStepTile(
            index: 2,
            title: '检测 Termux',
            subtitle: status.termuxInstalled
                ? '已安装，继续授权外部命令服务'
                : '需要安装 Termux 后才能运行 Flutter 工具链',
            done: status.termuxInstalled,
            actionLabel: '打开',
            onTap: onOpenTermux,
          ),
          SetupStepTile(
            index: 3,
            title: '授权 RUN_COMMAND',
            subtitle: '允许本 App 调用 Termux 执行 flutter、git、gradle',
            done:
                status.termuxPermissionGranted && status.termuxServiceAvailable,
            actionLabel: '授权',
            onTap: onRequestTermuxPermission,
          ),
          SetupStepTile(
            index: 4,
            title: '一键配置环境',
            subtitle: '安装 JDK、Git、CMake、Ninja，并检查 Flutter SDK',
            done: status.readyForBuild,
            actionLabel: '配置',
            onTap: onSetup,
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: onDismiss,
            icon: const Icon(Icons.visibility_off_outlined),
            label: const Text('暂时隐藏向导'),
          ),
        ],
      ),
    );
  }
}

class SetupStepTile extends StatelessWidget {
  const SetupStepTile({
    super.key,
    required this.index,
    required this.title,
    required this.subtitle,
    required this.done,
    required this.actionLabel,
    required this.onTap,
  });

  final int index;
  final String title;
  final String subtitle;
  final bool done;
  final String actionLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = done ? _successColor : _primaryColor;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.12)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: color.withValues(alpha: 0.16),
            child: done
                ? const Icon(
                    Icons.check_rounded,
                    size: 18,
                    color: _successColor,
                  )
                : Text(
                    '$index',
                    style: const TextStyle(
                      color: _primaryColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 4),
                Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          const SizedBox(width: 8),
          if (!done)
            TextButton(onPressed: onTap, child: Text(actionLabel))
          else
            const Icon(Icons.verified_outlined, color: _successColor),
        ],
      ),
    );
  }
}

class ProjectHeader extends StatelessWidget {
  const ProjectHeader({
    super.key,
    required this.path,
    required this.runtimeMode,
    required this.onPickProject,
  });

  final String path;
  final String runtimeMode;
  final VoidCallback onPickProject;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: _primaryColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.flutter_dash, color: _primaryColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _baseName(path).isEmpty ? '未选择项目' : _baseName(path),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  '$path · ${runtimeMode == 'embedded' ? '内置运行时优先' : '外部 Termux'}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          FilledButton.icon(
            onPressed: onPickProject,
            icon: const Icon(Icons.folder_open_outlined, size: 18),
            label: const Text('选择'),
            style: FilledButton.styleFrom(
              minimumSize: const Size(0, 42),
              padding: const EdgeInsets.symmetric(horizontal: 12),
            ),
          ),
        ],
      ),
    );
  }
}

class RecentProjectChip extends StatelessWidget {
  const RecentProjectChip({
    super.key,
    required this.path,
    required this.selected,
    required this.onTap,
  });

  final String path;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 220,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: selected
              ? _primaryColor.withValues(alpha: 0.1)
              : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected
                ? _primaryColor.withValues(alpha: 0.25)
                : const Color(0xFFE2E8F0),
          ),
        ),
        child: Row(
          children: [
            Icon(
              selected ? Icons.folder_special : Icons.folder_outlined,
              color: selected ? _primaryColor : _bodyColor,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _baseName(path),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: _titleColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    path,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BuildPage extends StatelessWidget {
  const BuildPage({
    super.key,
    required this.status,
    required this.statusText,
    required this.activeLogText,
    required this.activeLogPath,
    required this.projectController,
    required this.extraArgsController,
    required this.buildMode,
    required this.onBuildModeChanged,
    required this.onRefreshStatus,
    required this.onOpenStorageSettings,
    required this.onRequestTermuxPermission,
    required this.onOpenTermux,
    required this.onSetup,
    required this.onAudit,
    required this.onDoctor,
    required this.onPubGet,
    required this.onClean,
    required this.onAnalyze,
    required this.onGitStatus,
    required this.onBuild,
  });

  final NativeStatus status;
  final String statusText;
  final String activeLogText;
  final String? activeLogPath;
  final TextEditingController projectController;
  final TextEditingController extraArgsController;
  final String buildMode;
  final ValueChanged<String> onBuildModeChanged;
  final VoidCallback onRefreshStatus;
  final VoidCallback onOpenStorageSettings;
  final VoidCallback onRequestTermuxPermission;
  final VoidCallback onOpenTermux;
  final VoidCallback onSetup;
  final VoidCallback onAudit;
  final VoidCallback onDoctor;
  final VoidCallback onPubGet;
  final VoidCallback onClean;
  final VoidCallback onAnalyze;
  final VoidCallback onGitStatus;
  final VoidCallback onBuild;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      children: [
        IdeHero(
          title: '构建终端',
          subtitle: status.readyForBuild
              ? '运行时服务已准备，可以直接打包 Android APK'
              : '先完成环境授权和 Termux 服务配置，再开始构建',
          icon: Icons.terminal,
          trailing: '${status.readyCount}/4',
        ),
        const SizedBox(height: 20),
        SectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionTitle(
                icon: Icons.health_and_safety_outlined,
                title: '运行状态',
                subtitle: '第一次使用先授权，再运行环境初始化',
              ),
              const SizedBox(height: 16),
              StatusPills(status: status),
              const SizedBox(height: 12),
              Text(statusText, style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 16),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  ActionChipButton(
                    icon: Icons.folder_special_outlined,
                    label: '文件授权',
                    onPressed: onOpenStorageSettings,
                  ),
                  ActionChipButton(
                    icon: Icons.terminal_outlined,
                    label: 'Termux授权',
                    onPressed: onRequestTermuxPermission,
                  ),
                  ActionChipButton(
                    icon: Icons.open_in_new_rounded,
                    label: '打开Termux',
                    onPressed: onOpenTermux,
                  ),
                  ActionChipButton(
                    icon: Icons.refresh_rounded,
                    label: '刷新',
                    onPressed: onRefreshStatus,
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        SectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionTitle(
                icon: Icons.android_outlined,
                title: 'Flutter 项目',
                subtitle: '填写要打包的项目根目录，目录下必须有 pubspec.yaml',
              ),
              const SizedBox(height: 16),
              TextField(
                controller: projectController,
                decoration: const InputDecoration(
                  labelText: '项目路径',
                  hintText: '/storage/emulated/0/Download/your_flutter_app',
                  prefixIcon: Icon(Icons.folder_outlined),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: buildMode,
                      decoration: const InputDecoration(
                        labelText: '构建模式',
                        prefixIcon: Icon(Icons.speed_outlined),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'debug', child: Text('Debug')),
                        DropdownMenuItem(
                          value: 'profile',
                          child: Text('Profile'),
                        ),
                        DropdownMenuItem(
                          value: 'release',
                          child: Text('Release'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) onBuildModeChanged(value);
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: extraArgsController,
                      decoration: const InputDecoration(
                        labelText: '额外参数',
                        hintText: '--no-tree-shake-icons',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: onBuild,
                icon: const Icon(Icons.file_upload_outlined),
                label: const Text('开始打包 APK'),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  ActionChipButton(
                    icon: Icons.install_mobile_outlined,
                    label: '初始化环境',
                    onPressed: onSetup,
                  ),
                  ActionChipButton(
                    icon: Icons.fact_check_outlined,
                    label: '环境自检',
                    onPressed: onAudit,
                  ),
                  ActionChipButton(
                    icon: Icons.medical_information_outlined,
                    label: 'Doctor',
                    onPressed: onDoctor,
                  ),
                  ActionChipButton(
                    icon: Icons.download_done_outlined,
                    label: 'Pub Get',
                    onPressed: onPubGet,
                  ),
                  ActionChipButton(
                    icon: Icons.cleaning_services_outlined,
                    label: 'Clean',
                    onPressed: onClean,
                  ),
                  ActionChipButton(
                    icon: Icons.manage_search_outlined,
                    label: 'Analyze',
                    onPressed: onAnalyze,
                  ),
                  ActionChipButton(
                    icon: Icons.account_tree_outlined,
                    label: 'Git状态',
                    onPressed: onGitStatus,
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        SectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionTitle(
                icon: Icons.receipt_long_outlined,
                title: '实时日志',
                subtitle: activeLogPath ?? '还没有构建日志',
              ),
              const SizedBox(height: 14),
              LogBox(text: activeLogText.isEmpty ? '日志会显示在这里。' : activeLogText),
            ],
          ),
        ),
      ],
    );
  }
}

class FileBrowserPage extends StatefulWidget {
  const FileBrowserPage({super.key, required this.initialPath});

  final String initialPath;

  @override
  State<FileBrowserPage> createState() => _FileBrowserPageState();
}

class _FileBrowserPageState extends State<FileBrowserPage> {
  late final TextEditingController _pathController;
  final TextEditingController _editorController = TextEditingController();
  List<FileSystemEntity> _items = const [];
  String? _openedFile;
  String _message = '';

  static const Set<String> _editableExtensions = {
    '.dart',
    '.yaml',
    '.yml',
    '.json',
    '.gradle',
    '.kts',
    '.kt',
    '.java',
    '.xml',
    '.md',
    '.txt',
    '.properties',
    '.sh',
  };

  @override
  void initState() {
    super.initState();
    _pathController = TextEditingController(text: widget.initialPath);
    _refresh();
  }

  @override
  void didUpdateWidget(covariant FileBrowserPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialPath != widget.initialPath && _openedFile == null) {
      _pathController.text = widget.initialPath;
      _refresh();
    }
  }

  @override
  void dispose() {
    _pathController.dispose();
    _editorController.dispose();
    super.dispose();
  }

  void _refresh() {
    try {
      final directory = Directory(_pathController.text.trim());
      final items = directory.listSync()
        ..sort((a, b) {
          final ad = a is Directory ? 0 : 1;
          final bd = b is Directory ? 0 : 1;
          if (ad != bd) return ad.compareTo(bd);
          return a.path.toLowerCase().compareTo(b.path.toLowerCase());
        });
      setState(() {
        _items = items;
        _message = '${items.length} 个项目';
      });
    } catch (error) {
      setState(() {
        _items = const [];
        _message = '读取失败：$error';
      });
    }
  }

  void _goParent() {
    final current = Directory(_pathController.text.trim());
    final parent = current.parent.path;
    if (parent != current.path) {
      _pathController.text = parent;
      _refresh();
    }
  }

  Future<void> _openFile(File file) async {
    final name = file.path.toLowerCase();
    final editable = _editableExtensions.any(name.endsWith);
    if (!editable) {
      setState(() => _message = '暂不直接编辑这个文件类型');
      return;
    }
    try {
      final stat = await file.stat();
      if (stat.size > 1024 * 1024) {
        setState(() => _message = '文件超过 1MB，不建议在手机上直接编辑');
        return;
      }
      final text = await file.readAsString();
      setState(() {
        _openedFile = file.path;
        _editorController.text = text;
        _message = '已打开 ${_baseName(file.path)}';
      });
    } catch (error) {
      setState(() => _message = '打开失败：$error');
    }
  }

  Future<void> _saveFile() async {
    final path = _openedFile;
    if (path == null) return;
    try {
      await File(path).writeAsString(_editorController.text);
      setState(() => _message = '已保存 ${_baseName(path)}');
    } catch (error) {
      setState(() => _message = '保存失败：$error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      children: [
        const IdeHero(
          title: '项目文件',
          subtitle: '浏览项目、编辑源码、修改配置文件，适合手机端快速修复和小步迭代',
          icon: Icons.folder_open,
          trailing: 'EDITOR',
        ),
        const SizedBox(height: 20),
        SectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionTitle(
                icon: Icons.folder_open_outlined,
                title: '文件管理',
                subtitle: '可以编辑 Dart、YAML、Gradle、XML 等文本文件',
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _pathController,
                decoration: const InputDecoration(
                  labelText: '当前目录',
                  prefixIcon: Icon(Icons.folder_outlined),
                ),
                onSubmitted: (_) => _refresh(),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  ActionChipButton(
                    icon: Icons.arrow_upward_rounded,
                    label: '上一级',
                    onPressed: _goParent,
                  ),
                  ActionChipButton(
                    icon: Icons.refresh_rounded,
                    label: '刷新',
                    onPressed: _refresh,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(_message, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
        const SizedBox(height: 20),
        if (_openedFile != null) ...[
          SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionTitle(
                  icon: Icons.edit_note_outlined,
                  title: _baseName(_openedFile!),
                  subtitle: _openedFile!,
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: _editorController,
                  minLines: 12,
                  maxLines: 24,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 13,
                    height: 1.45,
                  ),
                  decoration: const InputDecoration(
                    alignLabelWithHint: true,
                    labelText: '代码编辑器',
                  ),
                ),
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: _saveFile,
                  icon: const Icon(Icons.save_outlined),
                  label: const Text('保存文件'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
        SectionCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              if (_items.isEmpty)
                const EmptyTile(text: '当前目录没有文件')
              else
                for (final item in _items)
                  FileTile(
                    entity: item,
                    onTap: () {
                      if (item is Directory) {
                        _pathController.text = item.path;
                        _refresh();
                      } else if (item is File) {
                        _openFile(item);
                      }
                    },
                  ),
            ],
          ),
        ),
      ],
    );
  }
}

class LogsPage extends StatefulWidget {
  const LogsPage({
    super.key,
    required this.logDir,
    required this.outputDir,
    required this.activeLogPath,
    required this.onSelectLog,
  });

  final String logDir;
  final String outputDir;
  final String? activeLogPath;
  final ValueChanged<String> onSelectLog;

  @override
  State<LogsPage> createState() => _LogsPageState();
}

class _LogsPageState extends State<LogsPage> {
  List<FileSystemEntity> _logs = const [];
  List<FileSystemEntity> _outputs = const [];
  String _message = '';

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  @override
  void didUpdateWidget(covariant LogsPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.logDir != widget.logDir ||
        oldWidget.outputDir != widget.outputDir) {
      _refresh();
    }
  }

  void _refresh() {
    setState(() {
      _logs = _listFiles(widget.logDir, '.log');
      _outputs = _listFiles(widget.outputDir, '.apk');
      _message = '日志 ${_logs.length} 个，APK ${_outputs.length} 个';
    });
  }

  List<FileSystemEntity> _listFiles(String dir, String suffix) {
    try {
      final items = Directory(dir)
          .listSync()
          .where((item) => item.path.toLowerCase().endsWith(suffix))
          .toList();
      items.sort((a, b) {
        final at = a.statSync().modified;
        final bt = b.statSync().modified;
        return bt.compareTo(at);
      });
      return items;
    } catch (_) {
      return const [];
    }
  }

  Future<void> _clearLogs() async {
    for (final item in _logs) {
      try {
        await item.delete();
      } catch (_) {}
    }
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      children: [
        SectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionTitle(
                icon: Icons.subject_outlined,
                title: '构建日志',
                subtitle: '所有日志会保存在 Download 目录，方便你发出来排查',
              ),
              const SizedBox(height: 12),
              Text(widget.logDir, style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  ActionChipButton(
                    icon: Icons.refresh_rounded,
                    label: '刷新',
                    onPressed: _refresh,
                  ),
                  ActionChipButton(
                    icon: Icons.delete_outline,
                    label: '清空日志',
                    onPressed: _clearLogs,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(_message, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
        const SizedBox(height: 20),
        SectionCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              if (_logs.isEmpty)
                const EmptyTile(text: '暂无日志')
              else
                for (final log in _logs)
                  SimpleFileTile(
                    icon: Icons.description_outlined,
                    title: _baseName(log.path),
                    subtitle: _fileSubtitle(log),
                    active: log.path == widget.activeLogPath,
                    onTap: () => widget.onSelectLog(log.path),
                  ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        SectionCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: SectionTitle(
                  icon: Icons.inventory_2_outlined,
                  title: 'APK 输出',
                  subtitle: widget.outputDir,
                ),
              ),
              if (_outputs.isEmpty)
                const EmptyTile(text: '暂无 APK')
              else
                for (final apk in _outputs)
                  SimpleFileTile(
                    icon: Icons.android_outlined,
                    title: _baseName(apk.path),
                    subtitle: _fileSubtitle(apk),
                    active: false,
                    onTap: () {},
                  ),
            ],
          ),
        ),
      ],
    );
  }
}

class PromptPage extends StatelessWidget {
  const PromptPage({super.key, required this.onCopyPrompt});

  final ValueChanged<String> onCopyPrompt;

  static const List<PromptTemplate> _templates = [
    PromptTemplate(
      icon: Icons.bug_report_outlined,
      title: '分析构建失败',
      subtitle: '把日志交给 AI，要求定位根因和给出补丁',
      prompt: '''
你是一位资深 Flutter/Android 构建工程师。请分析下面的构建日志，先判断失败根因，再给出最小修复方案。
要求：
1. 不要改业务逻辑。
2. 如果是 Gradle/NDK/JDK/SDK 环境问题，给出明确命令。
3. 如果是代码问题，给出具体文件和补丁建议。
4. 最后列出验证命令。

构建日志：
【把日志粘贴到这里】
''',
    ),
    PromptTemplate(
      icon: Icons.palette_outlined,
      title: '现代化 UI 重构',
      subtitle: '保留业务逻辑，只改布局和视觉',
      prompt: '''
你是一位 5 年以上 Flutter UI 工程师。请在 100% 保留业务逻辑、变量名、方法名、点击事件和数据结构的前提下，只重构 UI。
要求：
1. Material 3。
2. 主色 #6366F1，背景 #F8FAFC，卡片 #FFFFFF。
3. 卡片圆角 20，轻阴影。
4. 页面采用顶部导航、模块化内容区、底部导航。
5. 所有控件适配 Android 手机小屏。
6. 输出需要修改的文件和完整代码。
''',
    ),
    PromptTemplate(
      icon: Icons.call_outlined,
      title: '音视频通话排查',
      subtitle: 'WebRTC、信令、推送、权限一起检查',
      prompt: '''
你是一位 Flutter WebRTC 和 IM 信令工程师。请排查音视频通话问题。
重点检查：
1. 麦克风/摄像头权限申请。
2. RTCPeerConnection 创建时机。
3. addTrack 前 track 是否为空。
4. 呼叫、接听、取消、忙线、超时信令是否完整。
5. App 后台或锁屏时推送是否能拉起来电页。
6. TURN/STUN 配置是否走自建服务器。

现象：
【描述问题】

日志：
【粘贴日志】
''',
    ),
    PromptTemplate(
      icon: Icons.account_tree_outlined,
      title: 'Git 提交说明',
      subtitle: '根据变更生成专业 commit message',
      prompt: '''
请根据下面的 git diff 生成一个专业的提交说明。
要求：
1. 使用中文。
2. 第一行不超过 50 字。
3. 正文列出关键改动和验证方式。
4. 不要夸张描述。

diff：
【粘贴 git diff】
''',
    ),
    PromptTemplate(
      icon: Icons.description_outlined,
      title: 'README 生成',
      subtitle: '给 Flutter 项目生成用户可读文档',
      prompt: '''
请为这个 Flutter 项目生成 README。
包含：
1. 项目定位。
2. 功能列表。
3. 环境要求。
4. Android 打包步骤。
5. 常见问题。
6. 目录说明。

项目说明：
【粘贴项目说明】
''',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      children: [
        const IdeHero(
          title: '提示词工作台',
          subtitle: '把开发、排错、UI 重构和提交说明模板内置到手机 IDE',
          icon: Icons.auto_awesome,
          trailing: 'AI',
        ),
        const SizedBox(height: 20),
        for (final template in _templates) ...[
          SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionTitle(
                  icon: template.icon,
                  title: template.title,
                  subtitle: template.subtitle,
                ),
                const SizedBox(height: 12),
                Text(
                  template.prompt,
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _bodyColor,
                    fontFamily: 'monospace',
                    fontSize: 12,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: () => onCopyPrompt(template.prompt),
                  icon: const Icon(Icons.copy_outlined),
                  label: const Text('复制提示词'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
        ],
      ],
    );
  }
}

class PromptTemplate {
  const PromptTemplate({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.prompt,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String prompt;
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({
    super.key,
    required this.status,
    required this.flutterController,
    required this.androidHomeController,
    required this.javaHomeController,
    required this.shellController,
    required this.logDirController,
    required this.outputDirController,
    required this.runtimeMode,
    required this.onRuntimeModeChanged,
    required this.onSave,
    required this.onCopySetupCommand,
    required this.onOpenTermux,
    required this.onInstallEmbeddedRuntime,
    required this.onSetup,
    required this.onAudit,
  });

  final NativeStatus status;
  final TextEditingController flutterController;
  final TextEditingController androidHomeController;
  final TextEditingController javaHomeController;
  final TextEditingController shellController;
  final TextEditingController logDirController;
  final TextEditingController outputDirController;
  final String runtimeMode;
  final ValueChanged<String> onRuntimeModeChanged;
  final VoidCallback onSave;
  final VoidCallback onCopySetupCommand;
  final VoidCallback onOpenTermux;
  final VoidCallback onInstallEmbeddedRuntime;
  final VoidCallback onSetup;
  final VoidCallback onAudit;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      children: [
        IdeHero(
          title: '运行时设置',
          subtitle: '配置手机端 Flutter、Android SDK、JDK 和 Termux 服务',
          icon: Icons.tune,
          trailing: status.readyForBuild ? 'ONLINE' : 'SETUP',
        ),
        const SizedBox(height: 20),
        SectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionTitle(
                icon: Icons.memory_outlined,
                title: '运行时模式',
                subtitle: '当前版本通过 Termux RUN_COMMAND 托管 Flutter 工具链',
              ),
              const SizedBox(height: 14),
              StatusPills(status: status),
              const SizedBox(height: 12),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(
                    value: 'embedded',
                    icon: Icon(Icons.inventory_2_outlined),
                    label: Text('内置运行时'),
                  ),
                  ButtonSegment(
                    value: 'termux',
                    icon: Icon(Icons.terminal_outlined),
                    label: Text('外部Termux'),
                  ),
                ],
                selected: {runtimeMode},
                onSelectionChanged: (value) =>
                    onRuntimeModeChanged(value.first),
              ),
              const SizedBox(height: 12),
              Text(
                runtimeMode == 'embedded'
                    ? '内置运行时会优先使用 App 私有目录里的 bootstrap。把 bootstrap-aarch64.zip 放到 Download/phone_flutter_ide_runtime 后，点击安装内置运行时。'
                    : '外部 Termux 模式使用已安装的 Termux 执行 flutter、git 和 gradle，稳定但需要用户授权 RUN_COMMAND。',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  ActionChipButton(
                    icon: Icons.inventory_2_outlined,
                    label: '安装内置运行时',
                    onPressed: onInstallEmbeddedRuntime,
                  ),
                  ActionChipButton(
                    icon: Icons.open_in_new_rounded,
                    label: '打开Termux',
                    onPressed: onOpenTermux,
                  ),
                  ActionChipButton(
                    icon: Icons.install_mobile_outlined,
                    label: '初始化环境',
                    onPressed: onSetup,
                  ),
                  ActionChipButton(
                    icon: Icons.fact_check_outlined,
                    label: '环境自检',
                    onPressed: onAudit,
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        SectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionTitle(
                icon: Icons.tune_outlined,
                title: '本机路径',
                subtitle: '按这台手机 Termux 的实际安装路径配置',
              ),
              const SizedBox(height: 16),
              SettingsField(
                controller: flutterController,
                label: 'Flutter SDK',
                icon: Icons.flutter_dash_outlined,
              ),
              SettingsField(
                controller: androidHomeController,
                label: 'Android SDK',
                icon: Icons.android_outlined,
              ),
              SettingsField(
                controller: javaHomeController,
                label: 'JAVA_HOME',
                icon: Icons.coffee_outlined,
              ),
              SettingsField(
                controller: shellController,
                label: 'Termux Shell',
                icon: Icons.terminal_outlined,
              ),
              SettingsField(
                controller: logDirController,
                label: '日志目录',
                icon: Icons.subject_outlined,
              ),
              SettingsField(
                controller: outputDirController,
                label: 'APK 输出目录',
                icon: Icons.inventory_2_outlined,
              ),
              const SizedBox(height: 8),
              FilledButton.icon(
                onPressed: onSave,
                icon: const Icon(Icons.save_outlined),
                label: const Text('保存配置'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        SectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionTitle(
                icon: Icons.info_outline,
                title: '第一次使用',
                subtitle: '如果授权失败，复制脚本到 Termux 手动执行一次',
              ),
              const SizedBox(height: 12),
              const Text(
                '如果 Termux 授权按钮启动失败，先打开 Termux 手动执行初始化命令。执行后重启 Termux，再回到本 App 点击初始化环境。',
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: onCopySetupCommand,
                icon: const Icon(Icons.copy_outlined),
                label: const Text('复制 Termux 初始化命令'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class SectionCard extends StatelessWidget {
  const SectionCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}

class IdeHero extends StatelessWidget {
  const IdeHero({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.trailing,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final String trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _titleColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: _primaryColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: Colors.white, size: 26),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Color(0xFFCBD5E1),
                    fontSize: 13,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              trailing,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  const SectionTitle({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: _primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: _primaryColor, size: 24),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 4),
              Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      ],
    );
  }
}

class StatusPills extends StatelessWidget {
  const StatusPills({super.key, required this.status});

  final NativeStatus status;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        StatusPill(label: '文件访问', ok: status.storageGranted),
        StatusPill(label: '内置运行时', ok: status.embeddedRuntimeInstalled),
        StatusPill(label: 'Termux安装', ok: status.termuxInstalled),
        StatusPill(label: 'Termux权限', ok: status.termuxPermissionGranted),
        StatusPill(label: 'Termux服务', ok: status.termuxServiceAvailable),
      ],
    );
  }
}

class StatusPill extends StatelessWidget {
  const StatusPill({super.key, required this.label, required this.ok});

  final String label;
  final bool ok;

  @override
  Widget build(BuildContext context) {
    final color = ok ? _successColor : _warningColor;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            ok ? Icons.check_circle_outline : Icons.error_outline,
            color: color,
            size: 18,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class ActionChipButton extends StatelessWidget {
  const ActionChipButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 20),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(0, 42),
        padding: const EdgeInsets.symmetric(horizontal: 14),
      ),
    );
  }
}

class LogBox extends StatelessWidget {
  const LogBox({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 180, maxHeight: 360),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(16),
      ),
      child: SingleChildScrollView(
        reverse: true,
        child: Text(
          text,
          style: const TextStyle(
            color: Color(0xFFE2E8F0),
            fontFamily: 'monospace',
            fontSize: 12,
            height: 1.45,
          ),
        ),
      ),
    );
  }
}

class FileTile extends StatelessWidget {
  const FileTile({super.key, required this.entity, required this.onTap});

  final FileSystemEntity entity;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDir = entity is Directory;
    return SimpleFileTile(
      icon: isDir ? Icons.folder_outlined : Icons.insert_drive_file_outlined,
      title: _baseName(entity.path),
      subtitle: isDir ? entity.path : _fileSubtitle(entity),
      active: false,
      onTap: onTap,
    );
  }
}

class SimpleFileTile extends StatelessWidget {
  const SimpleFileTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.active,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: active
              ? _primaryColor.withValues(alpha: 0.08)
              : Colors.transparent,
          border: const Border(
            bottom: BorderSide(color: Color(0xFFE2E8F0), width: 0.6),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: active ? _primaryColor : _bodyColor, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right_rounded, color: _mutedColor),
          ],
        ),
      ),
    );
  }
}

class EmptyTile extends StatelessWidget {
  const EmptyTile({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          const Icon(Icons.inbox_outlined, color: _mutedColor),
          const SizedBox(width: 12),
          Text(text, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}

class SettingsField extends StatelessWidget {
  const SettingsField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
  });

  final TextEditingController controller;
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon)),
      ),
    );
  }
}

String _shellQuote(String value) {
  return "'${value.replaceAll("'", "'\"'\"'")}'";
}

String _baseName(String path) {
  final trimmed = path.endsWith('/')
      ? path.substring(0, path.length - 1)
      : path;
  final index = trimmed.lastIndexOf('/');
  return index >= 0 ? trimmed.substring(index + 1) : trimmed;
}

String _fileSubtitle(FileSystemEntity entity) {
  try {
    final stat = entity.statSync();
    final size = _formatBytes(stat.size);
    return '$size · ${stat.modified.toLocal()}';
  } catch (_) {
    return entity.path;
  }
}

String _formatBytes(int bytes) {
  if (bytes < 1024) return '$bytes B';
  final kb = bytes / 1024;
  if (kb < 1024) return '${kb.toStringAsFixed(1)} KB';
  final mb = kb / 1024;
  if (mb < 1024) return '${mb.toStringAsFixed(1)} MB';
  return '${(mb / 1024).toStringAsFixed(1)} GB';
}
