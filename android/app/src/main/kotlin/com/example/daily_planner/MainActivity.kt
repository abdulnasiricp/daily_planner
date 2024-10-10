package com.example.daily_planner

import android.content.Intent
import android.provider.AlarmClock
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.content.pm.PackageManager
import android.util.Log

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.daily_planner/alarm"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "setAlarm") {
                val hour = call.argument<Int>("hour") ?: 0
                val minute = call.argument<Int>("minute") ?: 0
                val message = call.argument<String>("message") ?: "Alarm"

                val intent = Intent(AlarmClock.ACTION_SET_ALARM).apply {
                    putExtra(AlarmClock.EXTRA_HOUR, hour)
                    putExtra(AlarmClock.EXTRA_MINUTES, minute)
                    putExtra(AlarmClock.EXTRA_MESSAGE, message)
                    putExtra(AlarmClock.EXTRA_SKIP_UI, false) // Show UI for confirmation
                }

                // Check if there's an app that can handle this intent
                val activities = packageManager.queryIntentActivities(intent, PackageManager.MATCH_DEFAULT_ONLY)
                Log.d("AlarmAppCheck", "Number of apps that can handle the alarm intent: ${activities.size}")
                activities.forEach { activity ->
                    Log.d("AlarmAppCheck", "Alarm app available: ${activity.activityInfo.packageName}")
                }

                if (intent.resolveActivity(packageManager) != null) {
                    startActivity(intent)
                    result.success(true)
                } else {
                    Log.e("AlarmError", "No Alarm App Available")
                    result.error("UNAVAILABLE", "Alarm app not available", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }
}
