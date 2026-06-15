package com.blinlin.phoneide.phone_flutter_ide

import android.content.Intent
import android.content.ComponentName
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import android.os.Environment
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val channelName = "com.blinlin.phoneide/native"
    private val termuxPermission = "com.termux.permission.RUN_COMMAND"
    private val termuxRunAction = "com.termux.RUN_COMMAND"

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
            "termuxServiceAvailable" to isTermuxServiceAvailable()
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
