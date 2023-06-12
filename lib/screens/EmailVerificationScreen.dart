import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'LoginScreen.dart';

import 'HomeScreen.dart';

class EmailVerificationScreen extends StatefulWidget {
  final String email;
  final String password;
  EmailVerificationScreen({required this.email,required this.password});

  @override
  _EmailVerificationScreenState createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final _verificationCodeController = TextEditingController();
  final _apiUrlVerify = 'http://176.9.24.125:12600/api/auth/verify';
  final _apiUrlNewCode =
      'http://176.9.24.125:12600/api/auth/new-verification-code';

  @override
  void dispose() {
    _verificationCodeController.dispose();
    super.dispose();
  }

  Future<void> _verifyEmail(String email,String password) async {
    String basicAuth = 'Basic ' + base64Encode(utf8.encode('$email:$password'));

    final response = await http.post(
      Uri.parse(_apiUrlVerify),
      headers: {
        'Content-Type': 'application/json',
        HttpHeaders.authorizationHeader: basicAuth,
      },
      body: jsonEncode({
        'emailVerificationCode': _verificationCodeController.text,
      }),
    );

    if (response.statusCode == 202) {
      // Обработка успешного подтверждения
      print('Подтверждение прошло успешно');
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ),
        (route) => false,
      );
    } else {
      // Обработка ошибки
      print('Ошибка подтверждения:  ${response.statusCode} ${response.body}');
    }
  }

  Future<void> _requestNewCode(String email, String password) async {
    String basicAuth = 'Basic ' + base64Encode(utf8.encode('$email:$password'));
   final response = await http.get(
      Uri.parse(_apiUrlNewCode),
      headers: {
        'Content-Type': 'application/json',
        HttpHeaders.authorizationHeader: basicAuth,
      },
    );

    if (response.statusCode == 200) {
      // Обработка успешного получения нового кода
      print('Новый код подтверждения отправлен на ${widget.email}');
    } else {
      // Обработка ошибки
      print(
          'Ошибка получения нового кода: ${response.statusCode} ${response.body}');
    }
  }

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Подтверждение эл. почты')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _verificationCodeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Код подтверждения'),
            ),
            ElevatedButton(
              onPressed: () => _verifyEmail(widget.email, widget.password),
              child: Text('Подтвердить'),
            ),
            TextButton(
              onPressed: () => _requestNewCode(widget.email, widget.password),
              child: Text('Получить новый код'),
            ),
          ],
        ),
      ),
    );
  }
}