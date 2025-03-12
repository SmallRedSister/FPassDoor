import 'package:event_bus/event_bus.dart';

class EventFactory{

  //声明稍后初始化变量
  late EventBus eventBus;

  EventBus getEventBus(){
    return eventBus;
  }

  //工厂构造函数
  factory EventFactory() => _singleton;

  //保持单例
  static final EventFactory _singleton = EventFactory._internal();

  //私有构造函数
  EventFactory._internal();

}