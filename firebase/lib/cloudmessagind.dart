import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;

class PushNotificationService {
  static Future<String> getAccessToken() async {
    final serviceAcountJson = {'Your data from json file '};
    List<String> scopes = [
      "https://www.googleapis.com/auth/userinfo.email",
      "https://www.googleapis.com/auth/firebase.database",
      "https://www.googleapis.com/auth/firebase.messaging"
    ];
    http.Client client = await auth.clientViaServiceAccount(
        auth.ServiceAccountCredentials.fromJson(serviceAcountJson), scopes);
    // get the access  token
    auth.AccessCredentials credentials =
        await auth.obtainAccessCredentialsViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAcountJson),
      scopes,
      client,
    );
    client.close();
    return credentials.accessToken.data;
  }

  static sendNotificationToAdmin(
    String deviceToken,
    BuildContext context,
    String tripId,
    String messageSender,
    String messageBody,
  ) async {
    final String serverAccessTokenKey = await getAccessToken();
    String endPointFirebaseCloudMessaging =
        'https://fcm.googleapis.com/v1/projects/<your-project-id>/messages:send';

    final Map<String, dynamic> message = {
      'message': {
        'token': deviceToken,
        'notification': {'title': messageSender, 'body': messageBody},
        'data': {
          'tripId': tripId,
        }
      }
    };

    final http.Response response =
        await http.post(Uri.parse(endPointFirebaseCloudMessaging),
            headers: <String, String>{
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $serverAccessTokenKey'
            },
            body: jsonEncode(message));
    if (response.statusCode == 200) {
      print('Notification send successfully');
    } else {
      print('Send notification faild: ${response.statusCode}');
    }
  }
}