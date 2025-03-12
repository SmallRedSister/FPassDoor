import 'package:bot_toast/bot_toast.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'bean/setting_entity.dart';
import 'index_page.dart';
import 'network/api_url.dart';
import 'util/clock.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  eventFactory = EventBus();
  await GetStorage.init();
  final box = GetStorage();
  if(box.hasData('setting_entity')){
    settingEntity = SettingEntity.fromJson(box.read("setting_entity"));
    if(settingEntity.apiAddr != null){
      apiUrl = settingEntity.apiAddr!;
    }
  } else{
    settingEntity = SettingEntity("","","");
  }

  clock = Clock()..start();
  runApp(const MyApp());
}

late EventBus eventFactory;
late SettingEntity settingEntity;
late Clock clock;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    return  ScreenUtilInit(
      designSize: const Size(1920, 1080),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_ , child) {
        return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            builder: BotToastInit(),
            home: Index()
        );
      },
    );
  }
}



//硬件-》杰克
//window调试flutter项目，指令=flutter run
//通道门（门禁）--高频，在电脑上看
//先实现功能（汉堂读写器），，有红外线
//通信是网口还是串口(网口通信)，读写器IP地址没有
//多个门禁情况
//https://flowus.cn/share/356f063b-3352-4a88-8fb9-4b5a6a9f7e48   API服务文档
