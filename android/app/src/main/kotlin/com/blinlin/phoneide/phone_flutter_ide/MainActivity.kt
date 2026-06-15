package com.blinlin.phoneide.phone_flutter_ide

import android.content.Intent
import android.content.ComponentName
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import android.os.Environment
import android.provider.Settings
import android.app.Activity
import io.flutter.FlutterInjector
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.FileOutputStream
import java.io.InputStream
import java.util.zip.ZipInputStream

class MainActivity : FlutterActivity() {
    private val channelName = "com.blinlin.phoneide/native"
    private val termuxPermission = "com.termux.permission.RUN_COMMAND"
    private val termuxRunAction = "com.termux.RUN_COMMAND"
    private val pickProjectRequestCode = 6201
    private val bundledRuntimeArchives = listOf(
        "runtime/bootstrap-aarch64.zip",
        "runtime/bootstrap.zip"
    )
    private var pendingPickProjectResult: MethodChannel.Result? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "status" -> result.success(statusMap())
                    "openStorageSettings" -> {
                        openStorageSettings()
                        result.success(null)
                    }
                    "requestTermuxPermission" -> {
                        requestTermuxPermission()
                        result.success(null)
                    }
                    "openTermux" -> {
                        openTermux(result)
                    }
                    "pickProjectDirectory" -> {
                        pickProjectDirectory(result)
                    }
                    "installEmbeddedRuntime" -> {
                        installEmbeddedRuntime(result)
                    }
                    "runEmbedded" -> {
                        val command = call.argument<String>("command") ?: ""
                        val workdir = call.argument<String>("workdir") ?: ""
                        runEmbedded(command, workdir, result)
                    }
                    "runTermux" -> {
                        val shell = call.argument<String>("shell")
                            ?: "/data/data/com.termux/files/usr/bin/bash"
                        val command = call.argument<String>("command") ?: ""
                        val workdir = call.argument<String>("workdir") ?: ""
                        runTermux(shell, command, workdir, result)
                    }
                    else -> result.notImplemented()
                }
            }
    }

    private fun statusMap(): Map<String, Boolean> {
        return mapOf(
            "storageGranted" to hasStorageAccess(),
            "termuxPermissionGranted" to hasTermuxPermission(),
            "termuxServiceAvailable" to isTermuxServiceAvailable(),
            "termuxInstalled" to isTermuxInstalled(),
            "embeddedRuntimeInstalled" to isEmbeddedRuntimeInstalled()
        )
    }

    private fun hasStorageAccess(): Boolean {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
            Environment.isExternalStorageManager()
        } else {
            checkSelfPermission(android.Manifest.permission.READ_EXTERNAL_STORAGE) ==
                PackageManager.PERMISSION_GRANTED
        }
    }

    private fun hasTermuxPermission(): Boolean {
        return checkSelfPermission(termuxPermission) == PackageManager.PERMISSION_GRANTED
    }

    private fun isTermuxServiceAvailable(): Boolean {
        return try {
            packageManager.getServiceInfo(termuxRunCommandService(), 0)
            true
        } catch (_: Exception) {
            val intent = Intent(termuxRunAction).setPackage("com.termux")
            packageManager.queryIntentServices(intent, 0).isNotEmpty()
        }
    }

    private fun termuxRunCommandService(): ComponentName {
        return ComponentName("com.termux", "com.termux.app.RunCommandService")
    }

    private fun isTermuxInstalled(): Boolean {
        return try {
            packageManager.getPackageInfo("com.termux", 0)
            true
        } catch (_: Exception) {
            false
        }
    }

    private fun runtimeRoot(): File {
        return File(filesDir, "embedded-runtime")
    }

    private fun runtimePrefix(): File {
        return File(runtimeRoot(), "usr")
    }

    private fun runtimeShell(): File {
        return File(runtimePrefix(), "bin/bash")
    }

    private fun externalRuntimeArchive(): File {
        val downloads = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS)
        return File(downloads, "phone_flutter_ide_runtime/bootstrap-aarch64.zip")
    }

    private fun bundledRuntimeArchiveName(): String? {
        for (name in bundledRuntimeArchives) {
            try {
                assets.open(flutterAssetPath(name)).close()
                return name
            } catch (_: Exception) {
            }
        }
        return null
    }

    private fun flutterAssetPath(name: String): String {
        return FlutterInjector.instance().flutterLoader().getLookupKeyForAsset("assets/$name")
    }

    private fun isEmbeddedRuntimeInstalled(): Boolean {
        return runtimeShell().exists() && runtimeShell().canExecute()
    }

    private fun runtimeLogFile(): File {
        val downloads = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS)
        val logDir = File(downloads, "phone_flutter_ide_logs")
        logDir.mkdirs()
        return File(logDir, "embedded-runtime-install.log")
    }

    private fun appendRuntimeLog(message: String) {
        try {
            runtimeLogFile().appendText("${System.currentTimeMillis()} $message\n")
        } catch (_: Exception) {
        }
    }

    private fun openStorageSettings() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
            val intent = Intent(
                Settings.ACTION_MANAGE_APP_ALL_FILES_ACCESS_PERMISSION,
                Uri.parse("package:$packageName")
            )
            try {
                startActivity(intent)
            } catch (_: Exception) {
                startActivity(Intent(Settings.ACTION_MANAGE_ALL_FILES_ACCESS_PERMISSION))
            }
        } else if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            requestPermissions(
                arrayOf(android.Manifest.permission.READ_EXTERNAL_STORAGE),
                5101
            )
        }
    }

    private fun requestTermuxPermission() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            requestPermissions(arrayOf(termuxPermission), 5102)
        }
    }

    private fun openTermux(result: MethodChannel.Result) {
        val launchIntent = packageManager.getLaunchIntentForPackage("com.termux")
        if (launchIntent == null) {
            result.error("TERMUX_NOT_INSTALLED", "没有安装 Termux", null)
            return
        }
        try {
            startActivity(launchIntent)
            result.success(null)
        } catch (error: Exception) {
            result.error("OPEN_TERMUX_FAILED", error.message, null)
        }
    }

    private fun pickProjectDirectory(result: MethodChannel.Result) {
        if (pendingPickProjectResult != null) {
            result.error("PICK_RUNNING", "已有目录选择器正在运行", null)
            return
        }
        val intent = Intent(Intent.ACTION_OPEN_DOCUMENT_TREE).apply {
            addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
            addFlags(Intent.FLAG_GRANT_WRITE_URI_PERMISSION)
            addFlags(Intent.FLAG_GRANT_PERSISTABLE_URI_PERMISSION)
            addFlags(Intent.FLAG_GRANT_PREFIX_URI_PERMISSION)
        }
        pendingPickProjectResult = result
        try {
            startActivityForResult(intent, pickProjectRequestCode)
        } catch (error: Exception) {
            pendingPickProjectResult = null
            result.error("PICK_FAILED", error.message, null)
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode != pickProjectRequestCode) return
        val pending = pendingPickProjectResult ?: return
        pendingPickProjectResult = null
        if (resultCode != Activity.RESULT_OK || data?.data == null) {
            pending.success(null)
            return
        }
        val uri = data.data!!
        val flags = data.flags and (
            Intent.FLAG_GRANT_READ_URI_PERMISSION or Intent.FLAG_GRANT_WRITE_URI_PERMISSION
        )
        try {
            contentResolver.takePersistableUriPermission(uri, flags)
        } catch (_: Exception) {
        }
        pending.success(
            mapOf(
                "uri" to uri.toString(),
                "displayPath" to displayPathFromTreeUri(uri)
            )
        )
    }

    private fun displayPathFromTreeUri(uri: Uri): String {
        val raw = uri.toString()
        val marker = "primary%3A"
        val index = raw.indexOf(marker)
        if (index >= 0) {
            val encodedPath = raw.substring(index + marker.length)
            val decoded = Uri.decode(encodedPath)
            return if (decoded.isBlank()) {
                "/storage/emulated/0"
            } else {
                "/storage/emulated/0/$decoded"
            }
        }
        return raw
    }

    private fun installEmbeddedRuntime(result: MethodChannel.Result) {
        val assetArchiveName = bundledRuntimeArchiveName()
        val externalArchive = externalRuntimeArchive()
        if (assetArchiveName == null && !externalArchive.exists()) {
            result.error(
                "RUNTIME_ARCHIVE_MISSING",
                "没有找到内置运行时包。正式包请内置 assets/runtime/bootstrap-aarch64.zip，调试时也可以放到 ${externalArchive.absolutePath}",
                null
            )
            return
        }
        Thread {
            try {
                val sourceLabel = if (assetArchiveName != null) {
                    "assets/$assetArchiveName"
                } else {
                    externalArchive.absolutePath
                }
                appendRuntimeLog("开始安装内置运行时: $sourceLabel")
                val root = runtimeRoot()
                if (root.exists()) {
                    root.deleteRecursively()
                }
                root.mkdirs()
                val archiveInput = if (assetArchiveName != null) {
                    assets.open(flutterAssetPath(assetArchiveName))
                } else {
                    externalArchive.inputStream()
                }
                archiveInput.use { input ->
                    unzipRuntime(input, root)
                }
                val home = File(root, "home")
                val tmp = File(root, "tmp")
                val projects = File(home, "projects")
                home.mkdirs()
                tmp.mkdirs()
                projects.mkdirs()
                if (!runtimeShell().exists()) {
                    throw IllegalStateException("bootstrap 缺少 usr/bin/bash")
                }
                if (!runtimeShell().canExecute()) {
                    runtimeShell().setExecutable(true, true)
                    if (!runtimeShell().canExecute()) {
                        throw IllegalStateException("usr/bin/bash 没有执行权限")
                    }
                }
                markRuntimeExecutables(runtimeRoot())
                appendRuntimeLog("内置运行时安装完成: ${runtimeRoot().absolutePath}")
            } catch (error: Exception) {
                appendRuntimeLog("内置运行时安装失败: ${error.message}")
            }
        }.start()
        result.success(
            mapOf(
                "started" to true,
                "message" to "内置运行时安装已开始，日志写入 ${runtimeLogFile().absolutePath}"
            )
        )
    }

    private fun unzipRuntime(input: InputStream, root: File) {
        ZipInputStream(input.buffered()).use { zip ->
            var entry = zip.nextEntry
            val buffer = ByteArray(DEFAULT_BUFFER_SIZE)
            while (entry != null) {
                val outFile = File(root, entry.name)
                val canonicalRoot = root.canonicalPath
                val canonicalOut = outFile.canonicalPath
                if (!canonicalOut.startsWith(canonicalRoot)) {
                    throw SecurityException("非法 zip 路径: ${entry.name}")
                }
                if (entry.isDirectory) {
                    outFile.mkdirs()
                } else {
                    outFile.parentFile?.mkdirs()
                    FileOutputStream(outFile).use { output ->
                        while (true) {
                            val count = zip.read(buffer)
                            if (count <= 0) break
                            output.write(buffer, 0, count)
                        }
                    }
                }
                zip.closeEntry()
                entry = zip.nextEntry
            }
        }
    }

    private fun markRuntimeExecutables(root: File) {
        val executableDirs = listOf(
            File(root, "usr/bin"),
            File(root, "usr/libexec"),
            File(root, "usr/lib/apt/methods")
        )
        executableDirs.forEach { dir ->
            if (dir.exists()) {
                dir.walkTopDown().forEach { file ->
                    if (file.isFile) {
                        file.setExecutable(true, true)
                    }
                }
            }
        }
    }

    private fun runEmbedded(command: String, workdir: String, result: MethodChannel.Result) {
        if (command.isBlank()) {
            result.error("EMPTY_COMMAND", "命令为空", null)
            return
        }
        val shell = runtimeShell()
        if (!shell.exists()) {
            result.error("RUNTIME_NOT_INSTALLED", "内置运行时未安装", null)
            return
        }
        try {
            val workingDir = File(workdir).takeIf { it.exists() && it.isDirectory } ?: filesDir
            val processBuilder = ProcessBuilder(shell.absolutePath, "-lc", command)
            processBuilder.directory(workingDir)
            val env = processBuilder.environment()
            val prefix = runtimePrefix().absolutePath
            env["PREFIX"] = prefix
            env["HOME"] = File(runtimeRoot(), "home").absolutePath
            env["TMPDIR"] = File(runtimeRoot(), "tmp").absolutePath
            env["PATH"] = "$prefix/bin:$prefix/bin/applets:${env["PATH"] ?: ""}"
            env["LD_LIBRARY_PATH"] = "$prefix/lib:${env["LD_LIBRARY_PATH"] ?: ""}"
            env["TERM"] = "xterm-256color"
            env["LANG"] = "C.UTF-8"
            File(env["HOME"] ?: "").mkdirs()
            File(env["TMPDIR"] ?: "").mkdirs()
            processBuilder.redirectErrorStream(true)
            processBuilder.start()
            result.success(
                mapOf(
                    "started" to true,
                    "message" to "内置运行时命令已启动"
                )
            )
        } catch (error: Exception) {
            result.error("EMBEDDED_START_FAILED", error.message, null)
        }
    }

    private fun runTermux(
        shell: String,
        command: String,
        workdir: String,
        result: MethodChannel.Result
    ) {
        if (command.isBlank()) {
            result.error("EMPTY_COMMAND", "命令为空", null)
            return
        }
        if (!isTermuxServiceAvailable()) {
            result.error(
                "TERMUX_NOT_READY",
                "没有检测到 Termux RUN_COMMAND 服务，请安装 Termux 并开启 allow-external-apps",
                null
            )
            return
        }
        if (!hasTermuxPermission()) {
            result.error("TERMUX_PERMISSION", "请先授予 Termux RUN_COMMAND 权限", null)
            return
        }

        val intent = Intent(termuxRunAction).apply {
            setPackage("com.termux")
            component = termuxRunCommandService()
            putExtra("com.termux.RUN_COMMAND_PATH", shell)
            putExtra("com.termux.RUN_COMMAND_ARGUMENTS", arrayOf("-lc", command))
            putExtra("com.termux.RUN_COMMAND_WORKDIR", workdir)
            putExtra("com.termux.RUN_COMMAND_BACKGROUND", true)
            putExtra("com.termux.RUN_COMMAND_SESSION_ACTION", "0")
        }

        try {
            startService(intent)
            result.success(
                mapOf(
                    "started" to true,
                    "message" to "Termux 命令已启动，日志会持续写入"
                )
            )
        } catch (error: SecurityException) {
            result.error("TERMUX_SECURITY", error.message, null)
        } catch (error: Exception) {
            result.error("TERMUX_START_FAILED", error.message, null)
        }
    }
}
