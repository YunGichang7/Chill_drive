import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/firebase_options.dart';
import 'Start_Screen.dart';
import 'Home_Screen.dart';
import 'Notice_Page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '차량 운행 정보 앱',
      theme: ThemeData(
        primaryColor: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Color(0xFF00B8FF),
        ),
        textTheme: GoogleFonts.dongleTextTheme(
          TextTheme(
            bodyText1: TextStyle(fontSize: 26), // 기본 본문 텍스트 크기
            bodyText2: TextStyle(fontSize: 24), // 세부 본문 텍스트 크기
            headline1: TextStyle(fontSize: 37), // 가장 큰 제목
            headline6: TextStyle(fontSize: 30), // AppBar 제목 등에 사용
            subtitle1: TextStyle(fontSize: 28), // 부제목
            // 기타 필요한 스타일에 대해서도 동일하게 설정
          ),
        ).apply(
          bodyColor: Color(0xFF00B8FF),
          displayColor: Color(0xFF00B8FF),
        ),
      ),
      home: StartScreen(),
      routes: {
        '/home': (context) => HomeScreen(),
        '/notice': (context) => NoticePage(),
      },
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  final List<Widget> _pages = [
    HomeScreen(),
    NoticePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        unselectedItemColor: Colors.black.withOpacity(0.60),
        selectedItemColor: Colors.black,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: '공지사항',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

