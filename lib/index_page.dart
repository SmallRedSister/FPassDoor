
import 'dart:async';
import 'dart:ui';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:passdoor/network/api.dart';
import 'package:passdoor/socket/send_helper.dart';
import 'package:passdoor/socket/socket_helper.dart';
import 'package:passdoor/util/toast_util.dart';
import 'package:passdoor/util/tts_util.dart';
import 'package:passdoor/widget/dialog_main.dart';
import '../main.dart';
import 'bean/device_list_entity.dart';
import 'bean/pass_base_entity.dart';
import 'bean/setting_entity.dart';
import 'event/count_event.dart';
import 'event/inventory_event.dart';
import 'event/uid_event.dart';
import 'network/api_url.dart';
import 'dart:convert';


///
class Index extends StatefulWidget {

  const Index({Key? key}) : super(key: key);

  @override
  State<Index> createState() => _IndexState();

}

class _IndexState extends State<Index> {

  late final _event;
  late final _event2;
  late final _event3;
  late String _name = "宁波图书馆";
  final box = GetStorage();
  RxInt enter = 0.obs;  //进馆
  RxInt leave = 0.obs;  //出馆
  String readerIP = "";//存放左边通道门设备读写器ip
  RxDouble enterAll = RxDouble(0);//进馆总数
  RxDouble alertAll = RxDouble(0);//警告总数
  String doorName = "";//门禁名称
  bool direction = false;//门禁正反方向
  bool isEAS = false;//是否开启AES
  bool isAFI = false;//是否开启AFI
  Set<String> setRfid = {};
  RxInt num = RxInt(0); //图书数量
  List<String> deviceData = [];
  bool isUp = true;//判断是新增还是更新
  var olderId = "";
  var mIndex = 0;
  bool one = false;
  //下面是与网络变化相关
  // Connectivity 对象
  final Connectivity _connectivity = Connectivity();
  // 初始返回的网络状态
  ConnectivityResult? _connectivityStatus;
  // 消息订阅
  late StreamSubscription<ConnectivityResult> _subscription;



  @override
  initState() {
    super.initState();
    _initNetwork();
    upSetting();
    upUiData("read", "", "");
    _event = eventFactory.on<InventoryEvent>().listen((event) {
      //接收数据并按需更新界面
      setState(() {
        print("${event.data[2]}");
      });
    });
    //警告+UID=rfid
    _event3 = eventFactory.on<UidEvent>().listen((event) {
      //接收数据并按需更新界面
      var warn = event.data.$1;
      var rfid = event.data.$2;
      var ip = event.data.$3;
      print("警告+UID=${event.data}/warn=$warn");
      if(readerIP == ip) {
        switch(warn) {
          case "00":{
            print("无警报");
          }
          break;
          case "01":{
            if(!setRfid.contains(rfid)){
              //DialogWidget.dismiss();
              //DialogWidget().warnDialog((e){});
              _postBookData(ip, rfid);
              num.value +=1;
            }
            setRfid.add(rfid);
          }
          break;
          case "58":{
            if(isAFI){
              _alertManage(rfid, ip);
            }
          }
          break;
          case "59":{
            if(isEAS){
              _alertManage(rfid, ip);
            }
          }
          break;
        }
      }

    });
    //计数板
    _event2 = eventFactory.on<CountEvent>().listen((event) {
      //接收数据并按需更新界面
      var name = event.data.$1;
      var data = event.data.$2;
      var ip = event.data.$3;
        print("测试计数/${ip}//$readerIP/dir==>$direction");
        var ent = int.tryParse(data);
        if(readerIP == ip) {
          if(name == "D1"){
            isD1D2 = false;
            if(direction){
              if(ent! > enter.value && enter.value!=0) {
                _postEnterData(ent - enter.value, ip);
                enterAll.value += 1;
              }
              enter.value = ent;
            } else{
              if(ent! >leave.value && leave.value!=0) {
                _postLeaveData(ent - leave.value, ip);
              }
              leave.value = ent;
            }
          } else if(name == "D2"){
            isD1D2 = true;
            if(direction){
              if(ent! >leave.value && leave.value!=0) {
                _postLeaveData(ent - leave.value, ip);
              }
              leave.value = ent;
            } else{
              if(ent! > enter.value && enter.value!=0) {
                _postEnterData(ent - enter.value, ip);
                enterAll.value += 1;
              }
              enter.value = ent;
            }
          } else{
            enter.value = 0;
            leave.value = 0;
          }
        }
    });

  }

  _alertManage(String rfid, String ip){
    if(!setRfid.contains(rfid)){
      DialogWidget.dismiss();
      DialogWidget().warnDialog((e){});
      alertAll.value = alertAll.value+1;
      num.value +=1;
      _postAlertData(ip);
      _postBookData(ip, rfid);
    }
    setRfid.add(rfid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          width: double.infinity,
          height: double.infinity,
          //alignment: Alignment.center,
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage(
                "assets/images/ic_app_bg.png",
              ),
            ),
          ),
          child: Stack(
            children: [
              Row(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width * 0.12,
                    // color: Color(0xFFFF6666),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width * 0.88,
                    // color: Color(0xFFFFFF66),
                    child: Stack(
                      alignment: AlignmentDirectional.center,
                      children: [
                        //设置
                        Positioned(
                          top: 13.h,right: 230.w,
                          child: InkWell(
                              child: Image.asset("assets/images/ic_setting.png"),
                              onTap: () {
                                DialogWidget().settingDialog((e){
                                  toastWarn('保存成功');
                                  upSetting();
                                });
                              }
                          ),
                        ),

                        //时间+日期
                        Positioned(
                          top: 1.h,right: 1.w,
                          child: SizedBox(
                            width: 190, height: 50,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Obx(() => Text(clock.time.value,
                                    style: TextStyle(fontSize: 25.sp,color: Colors.white, fontFamily: "titleFonts"))),
                                Obx(() => Text("${clock.day.value}\T${clock.weekDay.value}",style: TextStyle(fontSize: 12.sp,color: Colors.white),))
                              ],
                            ),
                          ),
                        ),

                        //进馆总人次
                        Positioned(
                            top: 250.h,
                            child: SizedBox(width: 1000, height: 66,
                                child: Align(alignment: Alignment.topCenter, /*color: Colors.black,*/
                                    child: Obx(() =>
                                        Text("${_toFormat(enterAll.value)}", textAlign: TextAlign.center, maxLines: 1,
                                            //${FormatUtil.decimalPattern()
                                            style: const TextStyle(
                                                color: Color(0xff1AF1FF),
                                                fontSize: 58.5,
                                                height: 1,
                                                fontWeight: FontWeight.w600,
                                                decoration:TextDecoration.underline,
                                                decorationStyle: TextDecorationStyle.dashed
                                            )
                                        )
                                    )
                                )
                            )
                        ),


                        //进馆人数
                        Positioned(
                            right: 1180.w, bottom: 400.h,
                            child: Obx(() => Text("${enter.value}", textAlign: TextAlign.center, maxLines: 1,
                                style: const TextStyle(
                                    color: Color(0xff1AF1FF),
                                    fontSize: 55,
                                    height: 1,
                                    fontWeight: FontWeight.w600,
                                    decoration:TextDecoration.underline,
                                    decorationStyle: TextDecorationStyle.dashed
                                )
                            ),)
                        ),

                        //出馆人数
                        Positioned(
                            right: 464.w, bottom: 400.h,
                            child: Obx(() => Text("${leave.value}", textAlign: TextAlign.center, maxLines: 1,
                                style: const TextStyle(
                                    color: Color(0xff1AF1FF),
                                    fontSize: 55,
                                    height: 1,
                                    decoration:TextDecoration.underline,
                                    decorationStyle: TextDecorationStyle.dashed
                                )
                            ),)
                        ),

                        Positioned(
                          left: 530.w, bottom: 400.h,
                          child: const Text("次", textAlign: TextAlign.center, maxLines: 1,
                              style: TextStyle(
                                  color: Color(0xff1AF1FF),
                                  fontSize: 33,
                                  height: 1,
                                  decoration:TextDecoration.underline,
                                  decorationStyle: TextDecorationStyle.dashed
                              )
                          ),
                        ),

                        Positioned(
                          right: 400.w, bottom: 400.h,
                          child: const Text("次", textAlign: TextAlign.center, maxLines: 1,
                              style: TextStyle(
                                  color: Color(0xff1AF1FF),
                                  fontSize: 33,
                                  height: 1,
                                  decoration:TextDecoration.underline,
                                  decorationStyle: TextDecorationStyle.dashed
                              )
                          ),
                        ),

                      ],
                    ),
                  )

                ],
              ),

              //应用标题
              Positioned(
                top: 13.h, left: 5.w,
                child: Text(_name, textAlign: TextAlign.center, maxLines: 1,
                  style: const TextStyle(
                      color: Color(0xffD8F0FF),
                      fontSize: 21.5,
                      height: 1,
                      fontFamily: "titleFonts",
                      // fontWeight: FontWeight.w600,
                      decoration:TextDecoration.underline,
                      decorationStyle: TextDecorationStyle.dashed
                  )
                ),
              ),

              //设备信息展示
              Positioned(
                  left:15.w, top: 155.h,
                  child: Obx(() => SizedBox(width: 200.w,height: 800.h,
                      child: CustomScrollView(
                        slivers: [
                          _list(),//设备列表
                          SliverToBoxAdapter(
                            child: InkWell(
                              child: Image.asset("assets/images/ic_new_pass.png",width: 200.w,height: 200.h),
                              onTap: (){
                                // _saveDeviceData();
                                DialogWidget().configDialog( "", (e){
                                  Map<String, dynamic> userMap = jsonDecode(e);
                                  DialogWidget.dismiss();
                                  DialogWidget().showLoadingDialog(context);
                                  print("userMap=${userMap}");
                                  print("userMap=ID="+userMap["boxId"]);
                                  isUp = userMap["addAndUp"];
                                  olderId = userMap["olderId"];
                                  _addAndUp(userMap["boxId"],userMap["ipAdder"],userMap["name"],userMap["aAndb"],userMap["eas"],userMap["afi"]);
                                });
                              },
                            ),
                          )
                        ],
                      ),
                  ))
              ),

              //当前图书数量
              Positioned(
                left: 560.w, bottom: 115.h,
                child: Obx(() => Text(num.value.toString().padLeft(2,'0').substring(0,1), textAlign: TextAlign.center, maxLines: 1,
                    style: const TextStyle(
                        color: Color(0xff1AF1FF),
                        fontSize: 80.5,
                        height: 1,
                        fontWeight: FontWeight.w600,
                        decoration:TextDecoration.underline,
                        decorationStyle: TextDecorationStyle.dashed
                    )
                ),)
              ),

              Positioned(
                left: 690.w, bottom: 115.h,
                child: Obx(() => Text(num.value.toString().padLeft(2,'0').substring(1,2), textAlign: TextAlign.center, maxLines: 1,
                    style: const TextStyle(
                        color: Color(0xff1AF1FF),
                        fontSize: 80.5,
                        height: 1,
                        fontWeight: FontWeight.w600,
                        decoration:TextDecoration.underline,
                        decorationStyle: TextDecorationStyle.dashed
                    )
                ),)
              ),

              //警告次数
              Positioned(
                right: 270.w, bottom: 145.h,
                  child: Container(width: 200, height: 60,
                      alignment: Alignment.center,/* color: Colors.black,*/
                      child: Obx(() =>
                          Text("${alertAll.value.toInt()}", textAlign: TextAlign.center, maxLines: 1,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 34.5,
                                  height: 1,
                                  decoration:TextDecoration.underline,
                                  decorationStyle: TextDecorationStyle.dashed
                              )
                          ),
                      )
                )
              ),

              /*Positioned(
                  bottom: 20.h,
                  child: InkWell(
                    onTap: (){
                      //sock.sendData(getPassDoorEAS());
                    },
                    child:const Text('浙江轩毅信息技术有限公司 v2.1.0',style: TextStyle(color: Colors.white)),
                  ),
              ),*/

            ],
          )
      ),
    );
  }


  @override
  void dispose() {
    super.dispose();
    _event.dispose();
    _event2.dispose();
    _event3.dispose();
    myTimer?.cancel();
    clock.cancel();
    _subscription.cancel();
  }

  RxList<DeviceListEntity> doorList = RxList();

  _list(){
    return SliverList.builder(
      //itemBuilder是列表项的构建器
      itemBuilder: (context, index) {
        return _listItem(index);
        },
      //列表项的数量，如果为null，则为无限列表。
      itemCount: doorList.length,
    );
  }

  _listItem(index){
    var item = doorList[index];
    return Listener(
          onPointerDown: (PointerDownEvent event) async {
            if (event.kind == PointerDeviceKind.mouse && event.buttons == kSecondaryMouseButton) {
              final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
              final menuItem = await showMenu<int>(
                  context: context,
                  items: [
                    PopupMenuItem(
                        child: Align(
                          child: Text('门禁配置', style: TextStyle(
                              color: Colors.black, decorationStyle: TextDecorationStyle.dashed)),
                        ) , value: 1),
                    const PopupMenuDivider(), //下划线
                    PopupMenuItem(
                        child: Align(
                            child: Text('删除门禁', style: TextStyle(
                                color: Colors.red, decorationStyle: TextDecorationStyle.dashed))
                        ), value: 2),
                  ],
                  position: RelativeRect.fromSize(event.position & Size(38.0, 20.0), overlay.size));
              // Check if menu item clicked
              switch (menuItem) {
                case 1:
                  print("up=id="+item.boxId);
                  DialogWidget().configDialog(item.boxId, (e){
                    Map<String, dynamic> userMap = jsonDecode(e);
                    DialogWidget.dismiss();
                    DialogWidget().showLoadingDialog(context);
                    isUp = userMap["addAndUp"];
                    olderId = userMap["olderId"];
                    _addAndUp(userMap["boxId"],userMap["ipAdder"],userMap["name"],userMap["aAndb"],userMap["eas"],userMap["afi"]);
                  });
                  /*ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Copy clicket'),
                        behavior: SnackBarBehavior.floating,
                      ));*/
                  break;
                case 2:
                  DialogWidget().deleteDialog(item.name, (e){
                    if(e == "delete"){
                      //toastWarn('删除成功');
                      //upUiData(item.boxId, item.ipAdder, item.name, true, true, true);
                      DialogWidget.dismiss();
                      DialogWidget().showLoadingDialog(context);
                      _deleteData(item.boxId, item.ipAdder, item.name);
                    }
                  });

                  /*ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('您点击了删除按钮'),
                          behavior: SnackBarBehavior.floating)
                  );*/

                  break;
                default:
              }
            }
          },
          child: Container(
            margin: EdgeInsets.only(top: 10.r),
            decoration: BoxDecoration(
              // color: Colors.white,
              image: DecorationImage(
                fit: BoxFit.fill, image: AssetImage(item.itemBg)
              ),
              borderRadius: BorderRadius.all(Radius.circular(6.r))
            ),
            padding: EdgeInsets.all(10.r),
            child: InkWell(
              child: Column(
                children: [
                  Image.asset(item.icon),
                  Text(item.name, textAlign: TextAlign.center, maxLines: 1,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          height: 1,
                          decoration:TextDecoration.underline,
                          decorationStyle: TextDecorationStyle.dashed
                      )
                  ),
                  Text("ip:${item.ipAdder}", textAlign: TextAlign.center, maxLines: 1,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          height: 1,
                          decoration:TextDecoration.underline,
                          decorationStyle: TextDecorationStyle.dashed
                      )
                  ),
                ],
              ),
              onTap: (){
                //这里切换设备，所有数据需要重新获取
                mIndex = index;
                doorName = item.name;
                readerIP = item.ipAdder;
                DialogWidget().showLoadingDialog(context);
                setState(() {
                  for(var i = 0; i < doorList.length; i++){
                    if(i == index){
                      doorList[index].itemBg = "assets/images/ic_yes_select_bg.png";
                      doorList[index].icon = "assets/images/ic_yes_select.png";
                    }else{
                      doorList[i].itemBg = "assets/images/ic_no_select_bg.png";
                      doorList[i].icon = "assets/images/ic_no_select.png";
                    }
                  }
                });
                _getUiData(item.name, item.ipAdder);
              },
            ),
          )
    );

  }

  //设置数据刷新
  void upSetting() {
    if(box.hasData('setting_entity')){
      var entity = SettingEntity.fromJson(box.read("setting_entity"));
      if(settingEntity.apiAddr != null){
        apiUrl = settingEntity.apiAddr!;
      }
      if(settingEntity.deviceId != null){
        deviceId = settingEntity.deviceId!;
      }
      print(entity);
      setState(() {
        if(entity!.title != null){
          _name = entity!.title!;
        }
      });
    }
  }


  void upUiData(String boxId, String ipAdder, String name){
    if(boxId == "read"){//表示重启或者首次启用
      // box.remove("deviceData");
      var result = box.read("deviceData");
      print("result=$result");
      doorList.clear();
      if(!result.isEmpty){
        for(var j=0; j < result.length; j++){
          Map<String, dynamic> dataMap = jsonDecode(result[j]);
          DeviceListEntity deviceListEntity = DeviceListEntity("", "", "", "", "", false);
          print("data=${dataMap["boxId"]}/${dataMap["ipAdder"]}/${dataMap["name"]}/}");
          if(j == 0){
            deviceListEntity.itemBg = "assets/images/ic_yes_select_bg.png";
            deviceListEntity.icon = "assets/images/ic_yes_select.png";
          }else{
            deviceListEntity.itemBg = "assets/images/ic_no_select_bg.png";
            deviceListEntity.icon = "assets/images/ic_no_select.png";
          }
          deviceListEntity.name = dataMap["name"];
          deviceListEntity.boxId = dataMap["boxId"];
          deviceListEntity.ipAdder = dataMap["ipAdder"];
          deviceListEntity.state = false;
          doorList.add(deviceListEntity);
          //刷新list
        }
        if(ipAdder == "" && name == ""){//每次启动默认启动的设备
          //获取数据
          if(box.hasData(doorList[0].boxId)){
            PassBaseEntity entity = PassBaseEntity.fromJson(box.read(doorList[0].boxId));
            direction = entity.arrow;
            isEAS = entity.eas;
            isAFI = entity.afi;
          }
          _getUiData(doorList[0].name, doorList[0].ipAdder);
        }
      }else{
        doorName = "";
        readerIP = "";
        enter.value = 0;
        leave.value = 0;
        enterAll.value = 0;
        alertAll.value = 0;
        myTimer?.cancel();
        //语音提示
        direction = false;
        isEAS = false;
        isAFI = false;
      }
    }

  }


  //新增和更新设备
  _addAndUp(String boxId, String ipAdder, String name, bool aAndb, bool eas, bool afi){
    deviceData.clear();
    if(doorList.isEmpty){
      //首次新增第一台设备
      String data = '{"boxId": "$boxId", "ipAdder": "$ipAdder", "name": "$name"}';
      deviceData.add(data);
      print("<-----------------数据集合为空（首次添加数据）----------------->");
      _futureUp("read",  "", "");
    }else{
      var upIp = "";
      var upName = "";
      box.remove("deviceData");
      doorList.forEach((element) {
        print("ddj=${element.boxId}");
        if(element.boxId == olderId && isUp){//更新
          String data = '{"boxId": "$boxId", "ipAdder": "$ipAdder", "name": "$name"}';
          deviceData.add(data);
        } else{
          String data = '{"boxId": "${element.boxId}", "ipAdder": "${element.ipAdder}", "name": "${element.name}"}';
          deviceData.add(data);
        }
      });
      if(isUp){
        /*upIp = ipAdder;
        upName = name;
        _getUiData(upName, upIp);*/
      } else{//新增
        String data = '{"boxId": "$boxId", "ipAdder": "$ipAdder", "name": "$name"}';
        deviceData.add(data);
      }
      print("<------------------------------addAndUp------------------------------>");
      _futureUp("read", "", "");
    }
  }

  //删除设备
  _deleteData(String boxId, String ipAdder, String name){
    box.remove("deviceData");
    deviceData.clear();
    doorList.forEach((element) {
      if(element.boxId == boxId){
        //过滤掉删除位置数据
        box.remove(boxId);
      } else{
        String data = '{"boxId": "${element.boxId}", "ipAdder": "${element.ipAdder}", "name": "${element.name}"}';
        deviceData.add(data);
      }
    });
    print("<---------------------------delete--------------------------------->");
    print("deviceData=$deviceData");
    _futureUp("read", "", "");
  }

  //更新数据
  _futureUp(String boxId, String ipAdder, String name){
    box.write("deviceData", deviceData);
    Future.delayed(Duration(seconds: 1)).then((value) =>
        setState(() {
          //重新构建列表
          upUiData(boxId, ipAdder, name);
        })
    );
  }

  //左边设备列表数据id操作 测试使用
  _saveDeviceData(){
    // deviceData.add(DeviceDataEntity("yhiuj", "213", "312"));
    // deviceData.add(DeviceDataEntity("132", "213", "etgh"));
    // deviceData.add(DeviceDataEntity("132", "sdfg", "312"));
    // deviceData.add(DeviceDataEntity("ytu", "213", "4563"));
    // deviceData.add(DeviceDataEntity("see", "213", "312"));
    // box.write("deviceData", deviceData);
    var result = box.read("deviceData");
    print("result=$result");
    if(result != null){
      for(Map<String, dynamic> item in result){
        print("ddd=${result[item]}");
      }
    }
  }

  //获取所有数据
  _getAllEnter(String ip) {
    postDataQuery(deviceId, ip).then((result) {//异步
      print("RESULT=$result");
      if(result != null) {
        enterAll.value = result.enter;
        alertAll.value = result.alert;
        Get.back();
      }
    });
  }

  //进馆
  _postEnterData(int num, String ip){
    postEnterShop(deviceId, ip, doorName, num).then((value) {
      print("_postEnterData$value");
    });
  }


  //出馆
  _postLeaveData(int num, String ip){
    postLeaveShop(deviceId, ip, doorName, num).then((value) {
      print("_postLeaveData=$value");
    });
  }

  //警告
  _postAlertData(String ip){
    postAlert(deviceId, ip, doorName).then((value) {
      print("_postAlertData=$value");
    });
  }

  //图书量
  _postBookData(String ip, String rfid){
    postBookNumber(deviceId, ip, doorName, rfid).then((value) {
      print("_postBookData=$value");
    });
  }

  //金额转换
  _toFormat(double num){
    return NumberFormat.decimalPattern().format(num.toInt());
  }

  var isD1D2 = true;
  Timer? myTimer;
  _connectSocket(String ip){
    var sock = SocketHelper(ip, 8899);
    if(myTimer != null){
      myTimer?.cancel();
    }
    print("object=$ip");
    //每隔1秒获取进出馆人计数
    myTimer =  Timer.periodic(Duration(seconds: 1), (Timer timer) {
      // 要执行的函数逻辑
      if(isD1D2){
        //isD1D2 = false;
        sock.sendData(getD1Data());
      }else{
        //isD1D2= true;
        sock.sendData(getD2Data());
        setRfid.clear();
        num.value = 0;
      }
      //每天12点重置归零
      if(clock.time.value == "14:14:00"){
        print("time="+clock.time.value);
        sock.sendData(setD3Data());
      }
    });
  }

  _getUiData(String name, String ipAdder){
    doorName = name;
    readerIP = ipAdder;
    enter.value = 0;
    leave.value = 0;
    enterAll.value = 0;
    alertAll.value = 0;
    _connectSocket(ipAdder);
    _getAllEnter(ipAdder);
  }


  // 订阅方式  初始化
  Future<void> _initNetwork() async {
    try {
      // 方式1：单次请求检查
      // final connectivityResult = await _connectivity.checkConnectivity();
      // _updateConnectionStatus(connectivityResult);

      // 方式2：状态订阅
      _subscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    } on PlatformException catch (e) {
      print(e);
      print('连接网络出现了异常');
    }
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectivityStatus = result;
    });

    if (result == ConnectivityResult.mobile) {
      print('成功连接移动网络');
      _netWorkUp();
    } else if (result == ConnectivityResult.wifi) {
      print('成功连接WIFI');
      _netWorkUp();
    } else if (result == ConnectivityResult.ethernet) {
      print('成功连接到以太网');
      _netWorkUp();
    } else if (result == ConnectivityResult.vpn) {
      print('成功连接vpn网络');
      _netWorkUp();
    } else if (result == ConnectivityResult.bluetooth) {
      print('成功连接蓝牙');
    } else if (result == ConnectivityResult.other) {
      print('成功连接除以上以外的网络');
    } else if (result == ConnectivityResult.none) {
      print('没有连接到任何网络');
      toastError("网络已断开");
      myTimer?.cancel();
      isNetWork = true;
    }
  }

  bool isNetWork = true;
  _netWorkUp(){
    if(isNetWork){
      isNetWork = false;
      _getUiData(doorName, doorList[0].ipAdder);
    }
  }


  //dd11ef170350010100e004a21104a9458200010203d4a6
  //dd11ef170450010100e004a211080d0749e14018008ecf
  //dd11ef170250010100e004a211080d0749e1401800acaf
//  dd11ef170150010100e004a211080d5224e14018009c16

}

