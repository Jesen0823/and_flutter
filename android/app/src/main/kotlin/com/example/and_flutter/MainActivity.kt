package com.example.and_flutter

import android.app.AlertDialog
import android.os.Bundle
import android.os.PersistableBundle
import android.text.TextUtils
import android.util.Log
import android.widget.Toast
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

/***
 *  MethodChannel 可以实现Android到Flutter,Flutter到Android的双向调用
 *  发送方是客户端，接收方是服务端
 * */

class MainActivity: FlutterActivity() {

    private val channel = "and_flutter/flutter2Android"
    private val channel_revese = "and_flutter.test/Android2Flutter"
    private lateinit var platfromChannel: MethodChannel

    override fun onCreate(savedInstanceState: Bundle?, persistentState: PersistableBundle?) {
        super.onCreate(savedInstanceState, persistentState)

    }

    override fun onStop() {
        super.onStop()

        // android 调用Flutter 修改Flutter页面
        var map: MutableMap<String, String> = HashMap()
        map["content"] = "电影[from Android]"
        platfromChannel.invokeMethod("changeText",map, object:MethodChannel.Result{
            override fun success(result: Any?) {
                result?.let {
                    Log.d("MainActivity---", it as String)
                }
            }

            override fun error(errorCode: String?, errorMessage: String?, errorDetails: Any?) {
                Log.d(
                    "MainActivity---",
                    "errorCode: ${errorCode.toString()}, errorMsg: ${errorMessage.toString()}" +
                            ", errorDetail: ${errorDetails.toString()}"
                )
            }

            override fun notImplemented() {
                Log.d("MainActivity---","notImplemented");
            }

        })
    }


    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        /** 与Flutter的交互, Flutter调用Android */
        GeneratedPluginRegistrant.registerWith(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor,channel).setMethodCallHandler(
            MethodChannel.MethodCallHandler { call, result ->
                when(call.method){
                    "appSetting" -> {
                        AlertDialog.Builder(this@MainActivity)
                            .setTitle("设置")
                            .setMessage(call.arguments as String)
                            .create().show()

                        // 返回消息
                        result.success(0)
                        return@MethodCallHandler
                    }
                    "toast" ->{
                        val content = if (call.hasArgument("content")) call.argument<String>("content") else "err"
                        Toast.makeText(this, content,Toast.LENGTH_SHORT).show()
                        if (TextUtils.equals("err",content)){
                            result.success("success")
                        }else{
                            result.error("-1","toast fail","content is null")
                        }
                    }
                    else -> {
                        result.notImplemented()
                        return@MethodCallHandler
                    }
                }
            })

        /** 与Flutter的交互, Android调用Flutter */
        platfromChannel = MethodChannel(flutterEngine.dartExecutor, channel_revese)

    }
}










