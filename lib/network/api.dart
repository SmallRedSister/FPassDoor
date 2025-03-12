
import '../bean/data_door_entity.dart';
import '../main.dart';
import '../util/toast_util.dart';
import 'api_url.dart';
import 'http_helper.dart';


Future postEnterShop(deviceId, ip, name, count) async {
  var (status,response) = await HttpHelper.instance.post(
      enterShop, data: {'device_id': deviceId, 'ip': ip, 'name': name, 'count': count}
  );
  if(status == 200){
    return status;
  } else {
    toastWarn('$response');
    return null;
  }
}


Future postLeaveShop(deviceId, ip, name, count) async {
  var (status,response) = await HttpHelper.instance.post(
      leaveShop, data: {'device_id': deviceId, 'ip': ip, 'name': name, 'count': count}
  );
  if(status == 200){
    return status;
  } else {
    toastWarn('$response');
    return null;
  }
}


Future postAlert(deviceId, ip, name) async {
  var (status,response) = await HttpHelper.instance.post(alert, data: {'device_id': deviceId, 'ip': ip, 'name': name});
  if(status == 200){
    return status;
  } else {
    toastWarn('$response');
    return null;
  }
}

Future postBookNumber(deviceId, ip, name,rfid) async {
  var (status,response) = await HttpHelper.instance.post(bookNumber, data: {'device_id': deviceId, 'ip': ip, 'name': name, 'rfid': rfid});
  if(status == 200){
    return status;
  } else {
    toastWarn('$response');
    return null;
  }
}


Future<DataDoorEntity?> postDataQuery(deviceId, ip) async {
  var (status,response) = await HttpHelper.instance.post(dataQuery, data: {'device_id': deviceId, 'ip': ip});
  if(status == 200){
    return DataDoorEntity.fromJson(response);
  } else {
    toastWarn('$response');
    return null;
  }
}


Future<DataDoorEntity?> postDayDataQuery(deviceId, ip) async {
  var (status,response) = await HttpHelper.instance.post(dayDataQuery, data: {'device_id': deviceId, 'ip': ip});
  if(status == 200){
    return DataDoorEntity.fromJson(response);
  } else {
    toastWarn('$response');
    return null;
  }
}








