import 'package:flutter/material.dart';

class HomePageScreen extends StatefulWidget {
  final Map<String, dynamic> tokenData;

  HomePageScreen({required this.tokenData});

  @override
  _HomePageScreenState createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Главная страница'),
      ),
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Главная',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_outlined),
            label: 'Личный кабинет',
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    switch (_currentIndex) {
      case 0:
        return _buildHomePage();
      case 1:
        return _buildAccountPage();
      default:
        return _buildHomePage();
    }
  }

  Widget _buildHomePage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // Text(
          //   'Статус ИП:',
          //   style: TextStyle(fontSize: 24),
          // ),
          // Text(
          //   'Зарегистрирован', // Здесь можно использовать статус ИП, полученный с сервера
          //   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          // ),
        ],
      ),
    );
  }

  Widget _buildAccountPage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Декодированный токен:'),
          SizedBox(height: 8.0),
          ...widget.tokenData.entries.map((entry) {
            return Text('${entry.key}: ${entry.value}');
          }).toList(),
        ],
      ),
    );
  }
}


// import 'package:flutter/material.dart';

// class HomePage extends StatelessWidget {
//   final Map<String, dynamic> tokenData;

//   HomePage({required this.tokenData});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Home'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text('Декодированный токен:'),
//             SizedBox(height: 8.0),
//             ...tokenData.entries.map((entry) {
//               return Text('${entry.key}: ${entry.value}');
//             }).toList(),
//           ],
//         ),
//       ),
//     );
//   }
// }






















// class HomePage extends StatelessWidget {
//   final String email;

//   HomePage({required this.email});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Главная страница')),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text('Эл. почта: $email'),
//             Text('Статус: OK'),
//           ],
//         ),
//       ),
//     );
//   }
// }
