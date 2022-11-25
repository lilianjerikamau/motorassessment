// import 'dart:convert';
// import 'package:flutter/foundation.dart';
// import 'package:http/http.dart' as http;
// import 'package:motorassesmentapp/utils/config.dart' as Config;

// class ApiService {
//   ApiService(this.endPointURL);

//   final endPointURL;
//   List customersJson = [];

//   Future getResponse() async {
//     final response = await http.get(Uri.parse(endPointURL));
//     print('URL: $endPointURL \n status: ${response.statusCode}');
//     print('Response: $response');
//     return response.statusCode == 200 ? jsonDecode(response.body) : null;
//   }

//   _fetchCustomers() async {
//     String url = await Config.getBaseUrl();

//     HttpClientResponse response = await Config.getRequestObject(
//         url + 'trackerjobcard/customer/?type=1&param=', Config.get);
//     if (response != null) {
//       print(response);
//       response.transform(utf8.decoder).transform(LineSplitter()).listen((data) {
//         var jsonResponse = json.decode(data);
//       });
//     } else {
//       print('response is null ');
//     }
//   }

//   _fetchValuationInstructions() async {
//     String url = await Config.getBaseUrl();

//     HttpClientResponse response = await Config.getRequestObject(
//         url +
//             'valuation/custinstruction/?custid=${Config.custid}&hrid=${Config.hrid}&typeid=1&revised=$revised',
//         Config.get);
//     if (response != null) {
//       print(url +
//           'valuation/custinstruction/?custid=$_custId&hrid=$_hrid&typeid=1&revised=$revised');
//       print(response);
//       response.transform(utf8.decoder).transform(LineSplitter()).listen((data) {
//         var jsonResponse = json.decode(data);
//       });
//     } else {
//       print('response is null ');
//     }
//   }
// }
