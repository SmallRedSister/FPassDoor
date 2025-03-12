import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../bean/pass_base_entity.dart';
import '../bean/setting_entity.dart';
import '../util/toast_util.dart';

class DialogWidget {

  //门禁设置弹窗
  settingDialog(cill){

    SettingEntity? entity;
    final box = GetStorage();
    var _apiAddr = "http://8.130.24.109:60060";
    var _title = "";
    var _deviceNo = "";

    if(box.hasData('setting_entity')){
      entity = SettingEntity.fromJson(box.read("setting_entity"));
      if(entity!.apiAddr != null){
        _apiAddr = entity!.apiAddr!;
      }
      if(entity!.deviceId != null){
        _deviceNo = entity!.deviceId!;
      }
      if(entity!.title != null){
        _title = entity!.title!;
      }
    } else{
      entity = SettingEntity("","","");
    }

    Get.defaultDialog(
      title: "",
      contentPadding:EdgeInsets.zero,
      titlePadding:EdgeInsets.zero,
      backgroundColor: Colors.transparent,
      content: Container(
        // constraints: const BoxConstraints(maxHeight: 600),
        width: 999.w,
        height: 500.h,
        // margin: const EdgeInsets.all(10),
        decoration: const ShapeDecoration(
            color: Color(0xff010F2F),
            shape: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                borderSide: BorderSide(color: Colors.blue, width: 2)
            ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                const Align(
                  alignment: Alignment.center,
                  child: Text("设置", style: TextStyle(
                      color: Color(0xffD1FAFF),
                      fontSize: 25.5,
                      height: 2,
                      fontFamily: "Courier",
                      // background: Colors.deepOrange,
                      // decoration:TextDecoration.underline,
                      decorationStyle: TextDecorationStyle.dashed)
                  ),
                ),
                Positioned(
                  top: 10, right: 18.w,
                    child: Align(alignment: Alignment.topRight,
                        child: InkWell(
                          child: Image.asset("assets/images/ic_clear.png",
                              width:50.w,height: 50.h,fit: BoxFit.fitHeight),
                          onTap: (){
                            Get.back();
                          },
                        )
                    ),
                ),
              ]
            ),
            Container(width: 999.w, height: 2.h, color: Colors.blue),
            Expanded(child: Container()),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("  自定义标题", style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.5,
                    height: 2,
                    fontFamily: "Courier",
                    // background: Colors.deepOrange,
                    // decoration:TextDecoration.underline,
                    decorationStyle: TextDecorationStyle.dashed
                )),
                Container (
                    width: 650.w,
                    height: 55.h,
                    margin: EdgeInsets.all(10),
                    child: TextField(
                      autofocus: false,
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white70,
                        hintText: "请输入标题名",
                        hintMaxLines: 1,
                        hintStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 15.5,
                            height: 1,
                            fontFamily: "Courier",
                            // background: Colors.deepOrange,
                            // decoration:TextDecoration.underline,
                            decorationStyle: TextDecorationStyle.dashed
                        ),
                        ///设置边框
                        ///   InputBorder.none 无下划线
                        ///   OutlineInputBorder 上下左右 都有边框
                        ///   UnderlineInputBorder 只有下边框  默认使用的就是下边框
                        border: OutlineInputBorder(
                          ///设置边框四个角的弧度
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                          ///用来配置边框的样式
                          borderSide: BorderSide(
                            ///设置边框的颜色
                            color: Colors.red,
                            ///设置边框的粗细
                            width: 2.0,
                          ),
                        ),
                        ///设置输入框可编辑时的边框样式
                        enabledBorder: OutlineInputBorder(
                          ///设置边框四个角的弧度
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                          ///用来配置边框的样式
                          borderSide: BorderSide(
                            ///设置边框的颜色
                            color: Colors.blue,
                            ///设置边框的粗细
                            width: 2.0,
                          ),
                        ),
                        disabledBorder: OutlineInputBorder(
                          ///设置边框四个角的弧度
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                          ///用来配置边框的样式
                          borderSide: BorderSide(
                            ///设置边框的颜色
                            color: Colors.red,
                            ///设置边框的粗细
                            width: 2.0,
                          ),
                        ),
                        ///用来配置输入框获取焦点时的颜色
                        focusedBorder: OutlineInputBorder(
                          ///设置边框四个角的弧度
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                          ///用来配置边框的样式
                          borderSide: BorderSide(
                            ///设置边框的颜色
                            color: Colors.green,
                            ///设置边框的粗细
                            width: 2.0,
                          ),
                        ),
                      ),
                      //controller: _unameController1,//设置controller
                      onChanged: (value){
                        _title = value;
                      },
                      //赋值
                      controller: TextEditingController.fromValue(TextEditingValue(
                          text: _title,
                          selection: TextSelection.fromPosition(
                              TextPosition(
                                  affinity: TextAffinity.downstream,
                                  offset: _title.length)
                          )
                      )),
                    )
                )
            ],),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              const Text(" \u{2003}\u{2003}API地址", style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.5,
                  height: 2,
                  fontFamily: "Courier",
                  // background: Colors.deepOrange,
                  // decoration:TextDecoration.underline,
                  decorationStyle: TextDecorationStyle.dashed
              )),
              Container (
                width: 650.w,
                height: 55.h,
                margin: EdgeInsets.all(10),
                child: TextField(
                autofocus: false,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white70,
                  hintText: "请输入API地址",
                  hintMaxLines: 1,
                  hintStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 15.5,
                    height: 1,
                    fontFamily: "Courier",
                    // background: Colors.deepOrange,
                    // decoration:TextDecoration.underline,
                    decorationStyle: TextDecorationStyle.dashed
                  ),
                  ///设置边框
                  border: OutlineInputBorder(
                    ///设置边框四个角的弧度
                    borderRadius: BorderRadius.all(Radius.circular(7)),
                    ///用来配置边框的样式
                    borderSide: BorderSide(
                      ///设置边框的颜色
                      color: Colors.red,
                      ///设置边框的粗细
                      width: 2.0,
                    ),
                  ),
                  ///设置输入框可编辑时的边框样式
                  enabledBorder: OutlineInputBorder(
                    ///设置边框四个角的弧度
                    borderRadius: BorderRadius.all(Radius.circular(7)),
                    ///用来配置边框的样式
                    borderSide: BorderSide(
                      ///设置边框的颜色
                      color: Colors.blue,
                      ///设置边框的粗细
                      width: 2.0,
                    ),
                  ),
                  disabledBorder: OutlineInputBorder(
                    ///设置边框四个角的弧度
                    borderRadius: BorderRadius.all(Radius.circular(7)),
                    ///用来配置边框的样式
                    borderSide: BorderSide(
                      ///设置边框的颜色
                      color: Colors.red,
                      ///设置边框的粗细
                      width: 2.0,
                    ),
                  ),
                  ///用来配置输入框获取焦点时的颜色
                  focusedBorder: OutlineInputBorder(
                    ///设置边框四个角的弧度
                    borderRadius: BorderRadius.all(Radius.circular(7)),
                    ///用来配置边框的样式
                    borderSide: BorderSide(
                      ///设置边框的颜色
                      color: Colors.green,
                      ///设置边框的粗细
                      width: 2.0,
                    ),
                  ),
                ),
                //controller: _unameController2, //设置controller
                  onChanged: (value){
                    _apiAddr = value;
                  },
                  //赋值
                  controller: TextEditingController.fromValue(TextEditingValue(
                      text: _apiAddr,
                      selection: TextSelection.fromPosition(
                          TextPosition(
                              affinity: TextAffinity.downstream,
                              offset: _apiAddr.length)
                      )
                  )),
              ),
              )
            ],),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("\u{2003}\u{2003}Deviceld", style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.5,
                    height: 2,
                    fontFamily: "Courier",
                    // background: Colors.deepOrange,
                    // decoration:TextDecoration.underline,
                    decorationStyle: TextDecorationStyle.dashed
                )),
                Container (
                  width: 650.w,
                  height: 55.h,
                  margin: EdgeInsets.all(10),
                  child: TextField(
                    autofocus: false,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white70,
                      hintText: "请输入设备号，谨慎填写",
                      hintMaxLines: 1,
                      hintStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 15.5,
                          height: 1,
                          fontFamily: "Courier",
                          // background: Colors.deepOrange,
                          // decoration:TextDecoration.underline,
                          decorationStyle: TextDecorationStyle.dashed
                      ),
                      ///设置边框
                      border: OutlineInputBorder(
                        ///设置边框四个角的弧度
                        borderRadius: BorderRadius.all(Radius.circular(7)),
                        ///用来配置边框的样式
                        borderSide: BorderSide(
                          ///设置边框的颜色
                          color: Colors.red,
                          ///设置边框的粗细
                          width: 2.0,
                        ),
                      ),
                      ///设置输入框可编辑时的边框样式
                      enabledBorder: OutlineInputBorder(
                        ///设置边框四个角的弧度
                        borderRadius: BorderRadius.all(Radius.circular(7)),
                        ///用来配置边框的样式
                        borderSide: BorderSide(
                          ///设置边框的颜色
                          color: Colors.blue,
                          ///设置边框的粗细
                          width: 2.0,
                        ),
                      ),
                      disabledBorder: OutlineInputBorder(
                        ///设置边框四个角的弧度
                        borderRadius: BorderRadius.all(Radius.circular(7)),
                        ///用来配置边框的样式
                        borderSide: BorderSide(
                          ///设置边框的颜色
                          color: Colors.red,
                          ///设置边框的粗细
                          width: 2.0,
                        ),
                      ),
                      ///用来配置输入框获取焦点时的颜色
                      focusedBorder: OutlineInputBorder(
                        ///设置边框四个角的弧度
                        borderRadius: BorderRadius.all(Radius.circular(7)),
                        ///用来配置边框的样式
                        borderSide: BorderSide(
                          ///设置边框的颜色
                          color: Colors.green,
                          ///设置边框的粗细
                          width: 2.0,
                        ),
                      ),
                    ),
                    onChanged: (value){
                      _deviceNo = value;
                    },
                    //赋值
                    controller: TextEditingController.fromValue(TextEditingValue(
                        text: _deviceNo,
                        selection: TextSelection.fromPosition(
                            TextPosition(
                                affinity: TextAffinity.downstream,
                                offset: _deviceNo.length)
                        )
                    )),
                  ),)
              ]
            ),
            Expanded(child: Container()),
            InkWell(
                onTap: () async {
                  print(_title);
                  if(_title.isEmpty){
                    toastWarn('自定义标题不能为空');
                    return;
                  }
                  if(_apiAddr.isEmpty){
                    toastWarn('API地址不能为空');
                    return;
                  }
                  if(_deviceNo.isEmpty){
                    toastWarn('设备id不能为空');
                    return;
                  }
                  entity!.deviceId = _deviceNo;
                  entity!.apiAddr = _apiAddr;
                  entity!.title = _title;
                  box.write('setting_entity', entity!.toJson());
                  cill("ok");
                  Get.back();
                },
                child: const DecoratedBox(
                  decoration: BoxDecoration(color: Colors.blue),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 5.0),
                    child: Text(
                        "保存", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)
                    ),
                  ),
                )
            ),
            Expanded(child: Container())
          ],
        ),
      ),
    );


  }


  //门禁配置弹窗,boxId=设备信息存储id，result=操作回调
  configDialog(String boxId, result){

    var _ipAdder = "";
    var _name = "";
    var _afiTxt = "";

    RxBool _aAndb = false.obs; //单选开关状态
    RxBool _eas = false.obs; //
    RxBool _afi = true.obs; //


    PassBaseEntity? entity;
    final box = GetStorage();

    if(boxId!=""){
      //获取数据
      if(box.hasData(boxId)){
        entity = PassBaseEntity.fromJson(box.read(boxId));
        if(entity!.ip != null){
          _ipAdder = entity!.ip!;
        }
        if(entity!.name != null){
          _name = entity!.name!;
        }
        if(entity!.afiText != null){
          _afiTxt = entity!.afiText!;
        }

        _aAndb.value = entity.arrow;
        _eas.value = entity.eas;
        _afi.value = entity.afi;

      }else{
        entity = PassBaseEntity(" "," "," ",false,false,false," ",false);
      }
    }else{
      entity = PassBaseEntity(" "," "," ",false,false,false," ",false);
    }


    Get.defaultDialog(
        title: "",
        contentPadding:EdgeInsets.zero,
        titlePadding:EdgeInsets.zero,
        backgroundColor: Colors.transparent,
        content: Container(width: 1100.w,height: 550.h,
        // margin: const EdgeInsets.all(10),
        decoration: const ShapeDecoration(
          color: Color(0xff010F2F),
          shape: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              borderSide: BorderSide(color: Colors.blue, width: 2)
          ),
        ),
          child: Stack(
            alignment:Alignment.center,
              children: [
                const Positioned(
                  top:1,
                  child: Text("门禁配置", style: TextStyle(
                      color: Color(0xffD1FAFF),
                      fontSize: 25.5,
                      height: 2,
                      fontFamily: "Courier",
                      // background: Colors.deepOrange,
                      decoration:TextDecoration.underline,
                      decorationStyle: TextDecorationStyle.dashed
                  )),
                ),
                Positioned(
                    top: 10, right: 10,
                    child: InkWell(
                      child: Image.asset("assets/images/ic_clear.png",width:50.w,height: 50.h,fit: BoxFit.fitHeight),
                      onTap: (){
                        Get.back();
                      },
                    )
                ),
                Positioned(
                    top: 50,
                    child: Container(
                        width: 1100.w,
                        height: 2.h,
                        color: Colors.blue
                    )
                ),

                Positioned(
                    bottom: 68,
                    child: Column(children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('\t\t 门禁IP ', style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.5,
                              height: 2,
                              fontFamily: "Courier",
                              // decoration:TextDecoration.underline,
                              decorationStyle: TextDecorationStyle.dashed
                          )),
                          Container (
                            width: 650.w,
                            height: 55.h,
                            margin: EdgeInsets.all(10),
                            child: TextField(
                              autofocus: false,
                              decoration: const InputDecoration(
                                filled: true,
                                fillColor: Colors.white70,
                                hintText: "请输入门禁IP",
                                hintMaxLines: 1,
                                hintStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15.5,
                                    height: 1,
                                    fontFamily: "Courier",
                                    // background: Colors.deepOrange,
                                    // decoration:TextDecoration.underline,
                                    decorationStyle: TextDecorationStyle.dashed
                                ),
                                ///设置边框
                                border: OutlineInputBorder(
                                  ///设置边框四个角的弧度
                                  borderRadius: BorderRadius.all(Radius.circular(7)),
                                  ///用来配置边框的样式
                                  borderSide: BorderSide(
                                    ///设置边框的颜色
                                    color: Colors.red,
                                    ///设置边框的粗细
                                    width: 2.0,
                                  ),
                                ),
                                ///设置输入框可编辑时的边框样式
                                enabledBorder: OutlineInputBorder(
                                  ///设置边框四个角的弧度
                                  borderRadius: BorderRadius.all(Radius.circular(7)),
                                  ///用来配置边框的样式
                                  borderSide: BorderSide(
                                    ///设置边框的颜色
                                    color: Colors.blue,
                                    ///设置边框的粗细
                                    width: 2.0,
                                  ),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  ///设置边框四个角的弧度
                                  borderRadius: BorderRadius.all(Radius.circular(7)),
                                  ///用来配置边框的样式
                                  borderSide: BorderSide(
                                    ///设置边框的颜色
                                    color: Colors.red,
                                    ///设置边框的粗细
                                    width: 2.0,
                                  ),
                                ),
                                ///用来配置输入框获取焦点时的颜色
                                focusedBorder: OutlineInputBorder(
                                  ///设置边框四个角的弧度
                                  borderRadius: BorderRadius.all(Radius.circular(7)),
                                  ///用来配置边框的样式
                                  borderSide: BorderSide(
                                    ///设置边框的颜色
                                    color: Colors.green,
                                    ///设置边框的粗细
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              onChanged: (value){
                                _ipAdder = value;
                              },
                              //赋值
                              controller: TextEditingController.fromValue(TextEditingValue(
                                  text: _ipAdder,
                                  selection: TextSelection.fromPosition(
                                      TextPosition(
                                          affinity: TextAffinity.downstream,
                                          offset: _ipAdder.length)
                                  )
                              )), //设置controller
                            ),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("门禁名称", style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.5,
                              height: 2,
                              fontFamily: "Courier",
                              decorationStyle: TextDecorationStyle.dashed
                          )),
                          Container (
                            width: 650.w,
                            height: 55.h,
                            margin: EdgeInsets.all(10),
                            child: TextField(
                              autofocus: false,
                              decoration: const InputDecoration(
                                filled: true,
                                fillColor: Colors.white70,
                                hintText: "请输入门禁名称",
                                hintMaxLines: 1,
                                hintStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15.5,
                                    height: 1,
                                    fontFamily: "Courier",
                                    // background: Colors.deepOrange,
                                    // decoration:TextDecoration.underline,
                                    decorationStyle: TextDecorationStyle.dashed
                                ),
                                ///设置边框
                                border: OutlineInputBorder(
                                  ///设置边框四个角的弧度
                                  borderRadius: BorderRadius.all(Radius.circular(7)),
                                  ///用来配置边框的样式
                                  borderSide: BorderSide(
                                    ///设置边框的颜色
                                    color: Colors.red,
                                    ///设置边框的粗细
                                    width: 2.0,
                                  ),
                                ),
                                ///设置输入框可编辑时的边框样式
                                enabledBorder: OutlineInputBorder(
                                  ///设置边框四个角的弧度
                                  borderRadius: BorderRadius.all(Radius.circular(7)),
                                  ///用来配置边框的样式
                                  borderSide: BorderSide(
                                    ///设置边框的颜色
                                    color: Colors.blue,
                                    ///设置边框的粗细
                                    width: 2.0,
                                  ),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  ///设置边框四个角的弧度
                                  borderRadius: BorderRadius.all(Radius.circular(7)),
                                  ///用来配置边框的样式
                                  borderSide: BorderSide(
                                    ///设置边框的颜色
                                    color: Colors.red,
                                    ///设置边框的粗细
                                    width: 2.0,
                                  ),
                                ),
                                ///用来配置输入框获取焦点时的颜色
                                focusedBorder: OutlineInputBorder(
                                  ///设置边框四个角的弧度
                                  borderRadius: BorderRadius.all(Radius.circular(7)),
                                  ///用来配置边框的样式
                                  borderSide: BorderSide(
                                    ///设置边框的颜色
                                    color: Colors.green,
                                    ///设置边框的粗细
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              onChanged: (value){
                                _name = value;
                              },
                              //赋值
                              controller: TextEditingController.fromValue(TextEditingValue(
                                  text: _name,
                                  selection: TextSelection.fromPosition(
                                      TextPosition(
                                          affinity: TextAffinity.downstream,
                                          offset: _name.length)
                                  )
                              )), //设置controller
                            ),
                          )
                        ],
                      ),
                      Row(children: [
                        const Text("门禁正反", style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.5,
                            height: 2,
                            fontFamily: "Courier",
                            decorationStyle: TextDecorationStyle.dashed
                        )),

                        Obx(() =>Switch(
                          value: _aAndb.value,//当前状态
                          onChanged:(value){
                            //重新构建页面
                            _aAndb.value =! _aAndb.value;
                          },),
                        ),
                        const Text("EAS报警", style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.5,
                            height: 2,
                            fontFamily: "Courier",
                            decorationStyle: TextDecorationStyle.dashed
                        )),
                        Obx(() =>Switch(
                          value: _eas.value,//当前状态
                          onChanged:(value){
                            //重新构建页面
                            _eas.value =! _eas.value;
                          },
                        ),)
                        ],
                      ),
                      Row(
                        children: [
                          const Text("AFI报警", style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.5,
                              height: 2,
                              fontFamily: "Courier",
                              decorationStyle: TextDecorationStyle.dashed
                          )),
                          Obx(() =>Switch(
                            value: _afi.value,//当前状态
                            onChanged:(value){
                              //重新构建页面
                              _afi.value =! _afi.value;
                            },
                          ),),
                          Container (
                            width: 550.w,
                            height: 55.h,
                            margin: EdgeInsets.all(10),
                            child: TextField(
                              autofocus: false,
                              decoration: const InputDecoration(
                                filled: true,
                                fillColor: Colors.white70,
                                hintText: "请输入AFI值",
                                hintMaxLines: 1,
                                hintStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15.5,
                                    height: 1,
                                    fontFamily: "Courier",
                                    // background: Colors.deepOrange,
                                    // decoration:TextDecoration.underline,
                                    decorationStyle: TextDecorationStyle.dashed
                                ),
                                ///设置边框
                                border: OutlineInputBorder(
                                  ///设置边框四个角的弧度
                                  borderRadius: BorderRadius.all(Radius.circular(7)),
                                  ///用来配置边框的样式
                                  borderSide: BorderSide(
                                    ///设置边框的颜色
                                    color: Colors.red,
                                    ///设置边框的粗细
                                    width: 2.0,
                                  ),
                                ),
                                ///设置输入框可编辑时的边框样式
                                enabledBorder: OutlineInputBorder(
                                  ///设置边框四个角的弧度
                                  borderRadius: BorderRadius.all(Radius.circular(7)),
                                  ///用来配置边框的样式
                                  borderSide: BorderSide(
                                    ///设置边框的颜色
                                    color: Colors.blue,
                                    ///设置边框的粗细
                                    width: 2.0,
                                  ),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  ///设置边框四个角的弧度
                                  borderRadius: BorderRadius.all(Radius.circular(7)),
                                  ///用来配置边框的样式
                                  borderSide: BorderSide(
                                    ///设置边框的颜色
                                    color: Colors.red,
                                    ///设置边框的粗细
                                    width: 2.0,
                                  ),
                                ),
                                ///用来配置输入框获取焦点时的颜色
                                focusedBorder: OutlineInputBorder(
                                  ///设置边框四个角的弧度
                                  borderRadius: BorderRadius.all(Radius.circular(7)),
                                  ///用来配置边框的样式
                                  borderSide: BorderSide(
                                    ///设置边框的颜色
                                    color: Colors.green,
                                    ///设置边框的粗细
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              onChanged: (value){
                                _afiTxt = value;
                              },
                              //赋值
                              controller: TextEditingController.fromValue(TextEditingValue(
                                  text: _afiTxt,
                                  selection: TextSelection.fromPosition(
                                      TextPosition(
                                          affinity: TextAffinity.downstream,
                                          offset: _afiTxt.length)
                                  )
                              )), //设置controller
                            ),
                          )
                        ],
                      ),
                    ],),
                ),

                Positioned(
                  bottom: 15,
                  child: InkWell(
                    onTap: () {
                      if(_ipAdder.isEmpty){
                        toastWarn('门禁IP地址不能为空');
                        return;
                      }
                      if(_name.isEmpty){
                        toastWarn('门禁名称不能为空');
                        return;
                      }
                      if(_afi == true){
                        if(_afiTxt.isEmpty){
                          toastWarn('门禁AFI不能为空');
                          return;
                        }
                      }
                      var id = "";
                      bool addAndUp = true;
                      id = _ipAdder.replaceAll(".", "");
                      if(boxId == "") {
                        print("id"+id);
                        addAndUp = false;
                      }else{
                        box.remove(boxId);
                      }
                      entity!.id = id;
                      entity!.ip = _ipAdder;
                      entity!.name = _name;
                      entity!.arrow = _aAndb.value;
                      entity!.eas = _eas.value;
                      entity!.afi = _afi.value;
                      entity!.afiText = _afiTxt;
                      entity!.state = true;
                      box.write(id, entity!.toJson());
                      // result({boxId, _ipAdder, _name, _aAndb.value, _eas.value, _afi.value});
                      String jsonString = '{"boxId": "$id", "ipAdder": "$_ipAdder", "name": "$_name", "aAndb": ${_aAndb.value}, "eas": ${_eas.value}, "afi": ${_afi.value}, "addAndUp": $addAndUp, "olderId": "$boxId"}';
                      result(jsonString);
                      Get.back();
                    },
                    child: const DecoratedBox(
                      decoration: BoxDecoration(color: Colors.blue),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 5.0),
                        child: Text(
                            "保存", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)
                        ),
                      ),
                    ),
                  ),
                ),
              ]
          ),
        )
    );
  }

  //删除门禁
  deleteDialog(String name, result){
    Get.defaultDialog(
        title: "",
        contentPadding:EdgeInsets.zero,
        titlePadding:EdgeInsets.zero,
        backgroundColor: Colors.transparent,
        content: Container(width: 750.w,height: 400.h,
        // margin: const EdgeInsets.all(10),
        decoration: const ShapeDecoration(
          color: Color(0xff010F2F),
          shape: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              borderSide: BorderSide(color: Colors.blue, width: 2)
          ),
        ),
          child: Stack(
              alignment:Alignment.center,
              children: [
                const Positioned(
                    top:1,
                    child: Text("删除门禁", style: TextStyle(
                        color: Color(0xffD1FAFF),
                        fontSize: 25.5,
                        height: 2,
                        fontFamily: "Courier",
                        // background: Colors.deepOrange,
                        decoration:TextDecoration.underline,
                        decorationStyle: TextDecorationStyle.dashed
                    )),
                ),
                Positioned(
                    top: 10, right: 10,
                    child: InkWell(
                      child: Image.asset("assets/images/ic_clear.png",width:50.w,height: 50.h,fit: BoxFit.fitHeight),
                      onTap: (){
                        Get.back();
                      },
                    )
                ),
                Positioned(
                  top: 50,
                  child: Container(
                    width: 750.w,
                    height: 2.h,
                    color: Colors.blue
                  )
                ),
                Text("确定要删除 $name 门禁吗？", style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20.5,
                    height: 1,
                    fontFamily: "Courier",
                    fontWeight: FontWeight.w600,
                    decoration:TextDecoration.underline,
                    decorationStyle: TextDecorationStyle.dashed
                )),
                Positioned(
                  bottom: 20,
                  child: InkWell(
                    onTap: () async {
                      result("delete");
                      Get.back();
                    },
                    child: const DecoratedBox(
                      decoration: BoxDecoration(color: Colors.blue),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 5.0),
                        child: Text(
                            "确认", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)
                        ),
                      ),
                    ),
                  ),
                ),
              ]
          ),
        ),
    );
  }

  //警告弹窗
  warnDialog(result){
    if (Get.isDialogOpen == true) {
      return;
    }
    Get.defaultDialog(
      title: "",
      contentPadding:EdgeInsets.zero,
      titlePadding:EdgeInsets.zero,
      backgroundColor: Colors.transparent,
      barrierDismissible: true, //设置为false，点击空白处弹窗不关闭
      content: SizedBox(width: 830.w,height: 575.h,
        child: Image.asset("assets/images/ic_warn.png"),
      ),
    );
    Future.delayed(Duration(seconds: 3), () {
      dismiss();
    });
  }

  static void dismiss() {
    if (Get.isDialogOpen == true) {
      Get.back();
    }
  }


  // 加载中等待框
  Future<bool?> showLoadingDialog(context) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return const UnconstrainedBox(
          constrainedAxis: Axis.vertical,
          child: SizedBox(
            width: 280,
            child: AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  CircularProgressIndicator(),//value: .8,
                  Padding(
                    padding: EdgeInsets.only(top: 26.0),
                    child: Text("正在加载，请稍后..."),
                  )
                ],
              ),
            ),
          ),
        ); // This trailing comma makes auto-formatting nicer for build methods.
      },
    );
  }


}