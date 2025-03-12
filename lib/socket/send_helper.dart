import 'dart:typed_data';


//询查标签
inventoryWithAnt(String ant){
  int antByte = int.parse("0x${int.parse(ant).toRadixString(16).padLeft(2,'0')}");
  var array = [0xdd, 0x11, 0xef, 0x09,  antByte, 0x01, 0x00,0x00,0x00];
  // var (byte1,byte2) = analyzeCRC(array);
  // array.add(byte1);
  // array.add(byte2);
  Uint8List bytes = Uint8List.fromList(array);
  print(bytes);
  return bytes;
}

//询查标签
inventoryAll(){
  var array = [0xdd, 0x11, 0xef, 0x09, 0xff, 0x01, 0x00,0x00,0x00];
  Uint8List bytes = Uint8List.fromList(array);
  print(bytes);
  return bytes;
}
//读块
readBlock(String tid,String ant){
  List<int> uids = [];
  if(tid.length%2 == 1){
    tid = "${tid}0";
  }
  int length = tid.length;
  int i = 0;
  while(i<length){
    var u = int.parse("0x${tid.substring(i,i+2)}");
    uids.add(u);
    i = i+2;
  }

  int antByte = int.parse("0x${int.parse(ant,radix: 16).toRadixString(16).padLeft(2,'0')}");
  var array = [0xdd, 0x11, 0xef, 0x13, antByte, 0x23, 0x01];
  array.addAll(uids);
  array.addAll([0x00,0x03,0x00,0x00]);
  Uint8List bytes = Uint8List.fromList(array);
  print(bytes);
  return bytes;
}

(int, int) analyzeCRC(data) {
  try {
    int i, j;
    int current_crc_value = 0xFFFF;
    for (i = 0; i < data.length; i++) {
      current_crc_value = current_crc_value ^ (data[i] & 0xFF);
      for (j = 0; j < 8; j++) {
        if ((current_crc_value & 0x01) != 0) {
          current_crc_value = (current_crc_value >> 1) ^ 0x8408;
        } else {
          current_crc_value = (current_crc_value >> 1);
        }
      }
    }
    Uint8List dataResult = Uint8List.fromList([0,0]);
    dataResult[0]= (current_crc_value &0xFF);
    dataResult[1]= ((current_crc_value >> 8) & 0xFF);
    int byte1 = int.parse("0x${dataResult[0].toRadixString(16).padLeft(2, '0').toUpperCase()}");
    int byte2 = int.parse("0x${dataResult[1].toRadixString(16).padLeft(2, '0').toUpperCase()}");
    return (byte1,byte2);
  } catch (e ) {
    print(e);
    return (00,00);
  }
}

 calculateBCC(Uint8List data) {
  int bcc = 0;
  for (int b in data) {
    bcc ^= b;
  }
  return "0x${bcc.toRadixString(16).toUpperCase()}";
}


//以下是进出计数板通信协议

getD1Data() {
  var array1 = [0xdd, 0x11, 0xef, 0x08, 0x00, 0xD1, 0x62, 0x9f];
  Uint8List bytes1 = Uint8List.fromList(array1);
  print(bytes1);
  return bytes1;
}

getD2Data() {
  var array2 = [0xdd, 0x11, 0xef, 0x08, 0x00, 0xD2, 0x62, 0x9f];
  Uint8List bytes2 = Uint8List.fromList(array2);
  print(bytes2);
  return bytes2;
}

//清空计数
setD3Data() {
  var array3 = [0xdd, 0x11, 0xef, 0x08, 0x00, 0xD3, 0x62, 0x9f];
  Uint8List bytes3 = Uint8List.fromList(array3);
  print(bytes3);
  return bytes3;
}

//和读写器相关指令
//获取通道门硬件版本信息
getPassDoorInfo() {
  var array = [0xdd, 0x11, 0xef, 0x09, 0x00, 0x00, 0x00, 0xD7, 0xB1];
  Uint8List bytes = Uint8List.fromList(array);
  print(bytes);
  return bytes;
}

//通道门级联数量设置
setPassDoorCascade() {
  var array = [0xdd, 0x11, 0xef, 0x0b, 0x00, 0xFa, 0x00, 0x10, 0x01, 0x2b, 0x26];
  Uint8List bytes = Uint8List.fromList(array);
  print(bytes);
  return bytes;
}

//通道门主从设置
setPassDoorMasterSlave() {
  var array = [0xdd, 0x11, 0xef, 0x0b, 0x00, 0xFa, 0x00, 0x11, 0xFF, 0x2b, 0x26];
  Uint8List bytes = Uint8List.fromList(array);
  print(bytes);
  return bytes;
}

//通道门设置EAS模式
setPassDoorEAS() {
  var array = [0xdd, 0x11, 0xef, 0x0b, 0x00, 0xFa, 0x00, 0x20, 0x01, 0x2b, 0x26];
  Uint8List bytes = Uint8List.fromList(array);
  print(bytes);
  return bytes;
}

//通道门设置AFI模式
setPassDoorAFI() {
  var array = [0xdd, 0x11, 0xef, 0x0b, 0x00, 0xFa, 0x00, 0x21, 0x01, 0x2b, 0x26];
  Uint8List bytes = Uint8List.fromList(array);
  print(bytes);
  return bytes;
}

//通道门设置UID模式
setPassDoorUID() {
  var array = [0xdd, 0x11, 0xef, 0x0b, 0x00, 0xFa, 0x00, 0x23, 0x01, 0x2b, 0x26];
  Uint8List bytes = Uint8List.fromList(array);
  print(bytes);
  return bytes;
}

//通道门配置AFI 07
configPassDoorAFI() {
  var array = [0xdd, 0x11, 0xef, 0x0b, 0x00, 0xFa, 0x00, 0x30, 0x07, 0x2b, 0x26];
  Uint8List bytes = Uint8List.fromList(array);
  print(bytes);
  return bytes;
}

//通道门设置UID模式状态
getPassDoorUID() {
  var array = [0xdd, 0x11, 0xef, 0x0b, 0x00, 0xF9, 0x00, 0x23, 0x01, 0x2b, 0x26];
  Uint8List bytes = Uint8List.fromList(array);
  print(bytes);
  return bytes;
}


//获取EAS状态
getPassDoorEAS() {
  var array = [0xdd, 0x11, 0xef, 0x0b, 0x00, 0xF9, 0x00, 0x20, 0x00, 0x2b, 0x26];
  Uint8List bytes = Uint8List.fromList(array);
  print(bytes);
  return bytes;
}
//received=dd11ef0b02f90020011ef8

