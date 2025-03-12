
import '../event/count_event.dart';
import '../event/inventory_event.dart';
import '../event/uid_event.dart';
import '../main.dart';
import '../util/convert_util.dart';

class ResultHandler{

  String ip = "";
  String result = "";
  bool isAnalyze = false;

  Set<(String,String,String)> set = {};


  dataReceived(hexString, ip){
    this.ip = ip;

    //沾包
    /*if(!hexString.startsWith('DD11')){
      result += hexString;
      analyze();
      // eventFactory.fire(CountEvent("d3"));//清除计数
      return;
    }*/

    //询查标签
    if(hexString.length > 12 && hexString.substring(10,12) == "01"){
      result = hexString;
      analyze();
      return;
    }

    //UID
    if(hexString.length > 37){
      result = hexString;
      var uid = result.substring(18, 34);
      var warn = result.substring(12, 14);
      print("UID=$uid/warn=$warn/");
      eventFactory.fire(UidEvent((warn,uid,ip)));
    }

    //dd11ef0c00d1000000509e44
    //分进出
    if(hexString.length == 24){
      result = hexString;
      var name = result.substring(10,12);
      var number16 = result.substring(12,20);
      print(name);
      eventFactory.fire(CountEvent(("$name","${hexToInt(number16)}",ip)));
    }

  }

  analyze(){
    print('result=$result');
    if(isAnalyze){
      return;
    }
    isAnalyze = true;
    //盘点结束指令
    if(result.startsWith("DD11EF0C") && result.length>=24){
      var data = set.toList();
      eventFactory.fire(InventoryEvent(data));
      result = "";
      set.clear();
      isAnalyze = false;
      return;
    }
    if(result.length>=38){
      set.add((result.substring(18,34),result.substring(8,10),ip));
      result = result.substring(38);
      isAnalyze = false;
      if(result.isNotEmpty){
        analyze();
      }
    }else{
      isAnalyze = false;
    }
  }

}