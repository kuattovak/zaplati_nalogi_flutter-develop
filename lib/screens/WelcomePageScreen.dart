import 'package:flutter/material.dart';
import 'LoginScreen.dart';
import 'RegisterScreen.dart';


class WelcomePageScreen extends StatelessWidget {
  const WelcomePageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Column(
        children: [
          SizedBox(height: 50,),
          Container(
            alignment: Alignment.topCenter,
            child: Text("Q-PAY",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.blue,
              fontSize: 30,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.bold
            ),
            ),
          ),
          SizedBox(height: 250,),
        Container(
          alignment: Alignment.center,
          child:TextButton(
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
          ),
          onPressed: () { 
            Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen(),
        ),
        (route) => false,
        );
          },
          child: Text('Вход',
                  textAlign: TextAlign.center,
                  style:TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                  ),),
        ),
        ),
          Container(
          alignment: Alignment.center,
          child:TextButton(
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
          ),
          onPressed: () {
             Navigator.pushAndRemoveUntil(
             context,
             MaterialPageRoute(
             builder: (context) => RegistrationPageScreen(),
          ),
          (route) => false,
          );
           },
          child: Text('Зарегистрироваться',textAlign: TextAlign.center,
                  style:TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                  ),),
        ),
        ),

        ],
      ),
    );
  }
}
