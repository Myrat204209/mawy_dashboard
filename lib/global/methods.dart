import 'dart:io';

import 'package:fluttertoast/fluttertoast.dart';
import '/global/colors.dart';
import '/global/values.dart';

showToast(String x) {
  return Fluttertoast.showToast(
    backgroundColor: grey,
    textColor: black,
    msg: x,
    toastLength: Toast.LENGTH_SHORT,
  );
}

Future<bool> connCheck() async {
  Socket? socket;
  if (address != "") {
    try {
      socket = await Socket.connect(
          InternetAddress(address, type: InternetAddressType.IPv4), 80,
          timeout: Duration(seconds: 2));

      socket.destroy();
      return true;
    } on SocketException {
      // showToast("Нет подключения к интернету");
      socket?.destroy();

      return false;
    }
  } else {
    return false;
  }
}
