import 'dart:convert';

import'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qpay/screens/LoginScreen.dart';

import 'EmailVerificationScreen.dart';

class RegistrationPageScreen extends StatefulWidget {
  @override
  _RegistrationPageScreenState createState() => _RegistrationPageScreenState();
}

class _RegistrationPageScreenState extends State<RegistrationPageScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _acceptedPrivateDataAgreement = false;
  final _apiUrl = 'http://176.9.24.125:12600/api/auth/user-registration';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _registerUser() async {
    if (_acceptedPrivateDataAgreement) {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': _emailController.text,
          'password': _passwordController.text,
          'acceptedPrivateDataAgreement': _acceptedPrivateDataAgreement,
        }),
      );

      if (response.statusCode == 201) {
        print('Регистрация прошла успешно');
        Navigator.push(context,
          MaterialPageRoute(
            builder: (context) => EmailVerificationScreen(email: _emailController.text,password: _passwordController.text,),
          ),
        );
      } else {
        print('Ошибка регистрации: ${response.statusCode} ${response.body}');
      }
    } else {
      print('Пожалуйста, согласитесь на обработку данных');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Регистрация')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(labelText: 'Эл. почта'),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Пароль'),
            ),
            Row(
              children: [
                Checkbox(
                  value: _acceptedPrivateDataAgreement,
                  onChanged: (bool? newValue) {
                    setState(() {
                      _acceptedPrivateDataAgreement = newValue!;
                    });
                  },
                ),
                Expanded(
                  child: Text('Согласие на обработку данных'),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: _registerUser,
              child: Text('Зарегистрироваться'),
            ),
     TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      },
      child: Text('Уже зарегистрированы? Войти'),
          ),
          ],
        ),
      ),
    );
  }
}


