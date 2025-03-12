
String? apiUrl = 'http://8.130.24.109:60060';

String? deviceId = "rfid_door_0001";


//进馆
String enterShop = '$apiUrl/openapi/rfid-door/enter';

//出馆
String leaveShop = '$apiUrl/openapi/rfid-door/leave';

//报警
String alert = '$apiUrl/openapi/rfid-door/alert';

//图书量
String bookNumber = '$apiUrl/openapi/rfid-door/book';

//查询数据
String dataQuery = '$apiUrl/openapi/rfid-door/query';

//查询今日数据
String dayDataQuery = '$apiUrl/openapi/rfid-door/query-today';




///ban
///[{"id":"","ip":"","name":"10","arrow":false,"eas":true,"afi":true,"afiText":"07","state":true}]
///{"boxId":"","ipAdder":"192","name":"00"}
/// https://flowus.cn/share/356f063b-3352-4a88-8fb9-4b5a6a9f7e48   API服务文档
///