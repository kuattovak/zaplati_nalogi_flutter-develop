import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'HomeScreen.dart';

class IndividualEntrepreneurRegistration extends StatefulWidget {
  final String accessToken;
  final Map<String, dynamic> tokenData;
  const IndividualEntrepreneurRegistration(
      {Key? key, required this.accessToken, required this.tokenData})
      : super(key: key);

  @override
  State<IndividualEntrepreneurRegistration> createState() =>
      _IndividualEntrepreneurRegistrationState();
}

class _IndividualEntrepreneurRegistrationState
    extends State<IndividualEntrepreneurRegistration> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Map<String, dynamic> data = {
    "id": 0,
    "firstName": "",
    "lastName": "",
    "individualIdentificationNumber": "",
    "individualEntrepreneurName": "",
    "ibanNumber": "",
    "individualEntrepreneurCategoryId": 0
  };

  List<Map<String, dynamic>> categories = [];

  Future<void> loadCategories(String accessToken) async {
    final String url =
        'http://176.9.24.125:12601/api/v1/individual-entrepreneur-category';
    final http.Response response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      categories = List<Map<String, dynamic>>.from(
          jsonDecode(utf8.decode(response.bodyBytes)));
      setState(() {});
    } else {
      print('Ошибка при загрузке категорий ИП: ${response.statusCode}');
    }
  }

  Future<void> registerIndividualEntrepreneur(
      String accessToken, Map<String, dynamic> data) async {
    final String url =
        'http://176.9.24.125:12601/api/v1/individual-entrepreneur';
    try {
      final http.Response response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 201) {
        print('Регистрация ИП выполнена успешно');
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) => HomePageScreen(
                    tokenData: widget.tokenData,
                  )),
          (route) => false,
        );
      } else {
        final errorResponse = jsonDecode(response.body);
        final String errorMessage =
            errorResponse['message'] ?? 'Неизвестная ошибка';

        if (response.statusCode == 400) {
          if (errorMessage.contains('уже зарегистрированный ИИН') ||
              errorMessage.contains('неверный формат ИИН') ||
              errorMessage.contains(
                  'неверный формат счета IBAN(меньше или больше 20 символов или не начинается на "KZ")')) {
            print('Ошибка 400: $errorMessage');
          }
        } else if (response.statusCode == 404) {
          if (errorMessage.contains(
                  'не зарегистрированный ИИН в государственной базе') ||
              errorMessage.contains(
                  'не зарегистрированный IBAN в базе счетов в банках')) {
            print('Ошибка 404: $errorMessage');
          }
        } else {
          print(
              'Ошибка при регистрации ИП: ${response.statusCode} $errorMessage');
        }
      }
    } catch (e) {
      print('Произошла ошибка при регистрации ИП: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    loadCategories(widget.accessToken);
  }

  Widget _buildCategoryDropdown() {
    return DropdownButtonFormField<int>(
      value: data['individualEntrepreneurCategoryId'] != 0
          ? data['individualEntrepreneurCategoryId']
          : null,
      onChanged: (int? newValue) {
        setState(() {
          data['individualEntrepreneurCategoryId'] = newValue;
        });
      },
      items: categories
          .map<DropdownMenuItem<int>>((category) => DropdownMenuItem(
                value: category['id'],
                child: Text(category['name']),
              ))
          .toList(),
      decoration: InputDecoration(
        labelText: 'Категория ИП',
        border: OutlineInputBorder(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Регистрация ИП'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Material(
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(labelText: 'First Name'),
                    initialValue: data['firstName'],
                    onChanged: (value) {
                      setState(() {
                        data['firstName'] = value;
                      });
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Last Name'),
                    initialValue: data['lastName'],
                    onChanged: (value) {
                      setState(() {
                        data['lastName'] = value;
                      });
                    },
                  ),
// Здесь вы можете добавить другие поля для ввода данных
                  TextFormField(
                    decoration:
                        InputDecoration(labelText: 'Identification Number'),
                    initialValue: data['individualIdentificationNumber'],
                    onChanged: (value) {
                      setState(() {
                        data['individualIdentificationNumber'] = value;
                      });
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Entrepreneur Name'),
                    initialValue: data['individualEntrepreneurName'],
                    onChanged: (value) {
                      setState(() {
                        data['individualEntrepreneurName'] = value;
                      });
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'IBAN Number'),
                    initialValue: data['ibanNumber'],
                    onChanged: (value) {
                      setState(() {
                        data['ibanNumber'] = value;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  _buildCategoryDropdown(), // Добавляем выпадающий список категорий ИП
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await registerIndividualEntrepreneur(
                            widget.accessToken, data);
                      }
                    },
                    child: Text('Зарегистрировать ИП'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
