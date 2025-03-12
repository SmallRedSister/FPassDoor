

import 'dart:io';

import '../util/toast_util.dart';
import 'result_handler.dart';


class SocketHelper{

  static final Map<String, SocketHelper> _cache = <String, SocketHelper>{};
  final String ip;
  final int port;

  factory SocketHelper(String url, int baudRate) {
    return _cache.putIfAbsent(url, () => SocketHelper._internal(url, baudRate));
  }

  SocketHelper._internal(this.ip, this.port){
    open(ip, port);
  }

  ResultHandler resultHandler = ResultHandler();
  Socket? _socket;

  open(url, baudRate){
    Socket.connect(url, baudRate, timeout: const Duration(seconds: 4))
        .then((socket) async {
          print('connect');
          _socket = socket;
          _socket?.listen(
            onReceivedMsg,
            onError: (e){
              print('onError $e');
              close();
            },
            onDone: (){
              print('onDone');
              close();
            },
            cancelOnError: false,
          );
        }).catchError((error) {
          if (error is SocketException) {
            print("连接失败=$error");
            toastWarn('连接失败，请检查设备是否通电通网');
          }
        });
  }

  onReceivedMsg(data) async {
    String hexString = data.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();
    print("received=$hexString");
    resultHandler.dataReceived(hexString.toUpperCase(),ip);
    // resultHandler.dataReceived('DD11EF130701010106E0040153');
    // resultHandler.dataReceived('02FEBAA36617DD11EF0CFF0159000100AB21');
    // print('onReceivedMsg $event');
  }

  close(){
    _socket?.close();
    _socket?.destroy();
    _cache.remove(ip);
  }

  sendData(data){
    _socket?.add(data);
  }

}