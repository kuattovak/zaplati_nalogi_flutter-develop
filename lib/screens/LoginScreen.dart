import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'HomeScreen.dart';
import 'IndividualEntrepreneurRegistration.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late InAppWebViewController _controller;

  void reloadWebView() {
    _controller.reload();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Авторизация'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: reloadWebView,
          ),
        ],
      ),
      body: InAppWebView(
  initialUrlRequest: URLRequest(
    url: Uri.parse(
        'http://176.9.24.125:12600/oauth2/authorize?response_type=code&client_id=client&scope=openid&redirect_uri=http://example.com/login/oauth2/code/'),
  ),
  onWebViewCreated: (InAppWebViewController webViewController) {
    _controller = webViewController;
  },
  onLoadStart: (controller, url) {
    if (url.toString().startsWith('http://example.com/login/oauth2/code/')) {
      _handleCodeRedirect(url.toString());
    }
  },
),
    );
  }

  void _handleCodeRedirect(String url) async {
    final uri = Uri.parse(url);
    final code = uri.queryParameters['code'];

    if (code != null) {
      final accessToken = await fetchAccessToken(code);
      final decodedToken = await decodeJWT(accessToken!);
      if (accessToken != null) {
        // final isRegistered = await checkRegistrationStatus(accessToken);
        // if (isRegistered) {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => HomePage(tokenData: decodedToken!),
          //   ),
          // );
        // } else {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => HomePageScreen(tokenData: decodedToken!),
          //   ),
          // );
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => IndividualEntrepreneurRegistration(accessToken: accessToken,tokenData: decodedToken!,),
            ),
          (route) => false,
          );
        //}
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Не удалось получить access token')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Не удалось получить код авторизации')),
      );
    }
  }

  Future<String?> fetchAccessToken(String code) async {
    String clientId = 'client';
    String clientSecret = 'secret';
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$clientId:$clientSecret'));

    final response = await http.post(
      Uri.parse('http://176.9.24.125:12600/oauth2/token'),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': basicAuth,
      },
      body: {
        'client_id': clientId,
        'redirect_uri': 'http://example.com/login/oauth2/code/',
        'grant_type': 'authorization_code',
        'code': code,
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return jsonResponse['access_token'];
    } else {
      print('Error status code: ${response.statusCode}');
      print('Error response body: ${response.body}');
      return null;
    }
  }

  Future<Map<String, dynamic>?> decodeJWT(String jwt) async {
    try {
      final parts = jwt.split('.');
      final payload = parts[1];
      final normalizedPayload = base64Url
          .normalize(payload); // Нормализовать для base64-декодирования
      final decodedPayload = utf8.decode(base64Url.decode(normalizedPayload));
      final payloadMap = jsonDecode(decodedPayload) as Map<String, dynamic>;
      return payloadMap;
    } catch (e) {
      print('Ошибка при декодировании JWT: $e');
      return null;
    }
  }

// Future<bool> checkRegistrationStatus(String accessToken) async {
//   final response = await http.get(
//     Uri.parse('http://176.9.24.125:12601/api/v1/individual-entrepreneur'),
//     headers: {
//       'Content-Type': 'application/json',
//       'Authorization': 'Bearer $accessToken',
//     },
//   );

//   if (response.statusCode == 201) {
//     // Если пользователь уже зарегистрирован, верните true
//     return true;
//   } else if (response.statusCode == 400) {
//     // Если пользователь не зарегистрирован, верните false
//     return false;
//   } else {
//     print('Ошибка при проверке регистрации ИП: ${response.statusCode}');
//     throw Exception('Не удалось проверить статус регистрации ИП');
//   }
// }

}
