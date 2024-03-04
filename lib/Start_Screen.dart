import 'dart:async';
import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'package:connectivity/connectivity.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'main.dart';

class StartScreen extends StatefulWidget {
  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  double loadingProgress = 0.0;
  String currentTime = '';
  Timer? loadingTimer;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    // 현재 시간을 업데이트하는 타이머
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) => updateCurrentTime());
    // 로딩 바를 업데이트하는 타이머 시작
    startLoading();
    // 네트워크 상태 스트림을 구독합니다.
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      // 네트워크 상태가 변경될 때마다 호출됩니다.
      if (result != ConnectivityResult.none) {
        // 인터넷에 연결되면 완료 함수를 호출합니다.
        completeLoading();
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void updateCurrentTime() {
    final now = DateTime.now().toUtc().add(Duration(hours: 9));
    final formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    final String formatted = formatter.format(now);

    setState(() {
      currentTime = formatted;
    });
  }


  void checkConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      // 네트워크 연결이 없으면 로딩 바가 0.5에서 멈춥니다.
      loadingTimer?.cancel(); // 로딩 타이머를 멈춥니다.
    } else {
      // 네트워크 연결이 있으면 로딩을 완료합니다.
      completeLoading();
    }
  }

  void completeLoading() {
    loadingTimer?.cancel();
    loadingTimer = Timer.periodic(Duration(milliseconds: 50), (Timer t) {
      setState(() {
        if (loadingProgress < 1.0) {
          loadingProgress += 0.01;
        } else {
          t.cancel();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MainPage()),
          );
        }
      });
    });
  }

  void handleNoInternet() {
    // 인터넷 연결이 없을 때 사용자에게 알리는 로직입니다.
    setState(() {
      // 로딩 바를 일시 중지하고 사용자에게 알립니다.
      // 예를 들어, AlertDialog를 표시할 수 있습니다.
    });
  }

  void startLoading() {
    loadingTimer?.cancel(); // 현재 실행 중인 타이머가 있으면 취소
    loadingTimer = Timer.periodic(Duration(milliseconds: 100), (Timer t) {
      setState(() {
        if (loadingProgress < 0.5) {
          loadingProgress += 0.005; // 천천히 증가
        } else {
          // 연결 상태를 다시 확인합니다.
          checkConnection();
          t.cancel(); // 0.5에 도달하면 타이머를 멈춥니다.
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // 배경색을 흰색으로 설정
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/car_dashboard.png'),
            Text(
              'Loading Screen',
              style: TextStyle(color: Colors.black), // 글자 색상을 검정색으로 설정
            ),
            LinearProgressIndicator(value: loadingProgress),
            Text(
              '인터넷 연결 상태를 확인 중입니다...',
              style: TextStyle(color: Colors.black), // 글자 색상을 검정색으로 설정
            ),
            Text(
              currentTime,
              style: TextStyle(color: Colors.black), // 글자 색상을 검정색으로 설정
            ),
          ],
        ),
      ),
    );
  }
}