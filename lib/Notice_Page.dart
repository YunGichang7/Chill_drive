import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
        // 선택되지 않은 항목의 라벨 스타일
        unselectedLabelStyle: TextStyle(
        fontSize: 12, // 원하는 크기로 조정
        ),
        // 선택된 항목의 라벨 스타일
        selectedLabelStyle: TextStyle(
        fontSize: 14, // 원하는 크기로 조정
        ),
        ),
        primarySwatch: Colors.blue,
        primaryColor: Color(0xFF00B8FF),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: NoticePage(),
    );
  }
}

class NoticePage extends StatefulWidget {
  @override
  _NoticePageState createState() => _NoticePageState();
}

class _NoticePageState extends State<NoticePage> {
  final List<String> notices = [
    "공지사항 1: 새로운 업데이트가 있습니다.",
    "공지사항 2: 시스템 점검 안내입니다.",
    "공지사항 3: 새로운 기능이 추가되었습니다.",
  ];

  final Map<String, String> noticeDetails = {
    // "공지사항 1: 새로운 업데이트가 있습니다.": "여기에 공지사항 1의 상세 내용을 작성하세요.",
    // "공지사항 2: 시스템 점검 안내입니다.": "여기에 공지사항 2의 상세 내용을 작성하세요.",
    // "공지사항 3: 새로운 기능이 추가되었습니다.": "여기에 공지사항 3의 상세 내용을 작성하세요.",
  };

  void showNoticeDialog(String title) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(noticeDetails[title] ?? "상세 내용이 없습니다."),
          actions: <Widget>[
            TextButton(
              child: Text("닫기"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('공지사항 페이지'),
        backgroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: notices.length,
        itemBuilder: (context, index) {
          return Card(
            color: Colors.white,
            child: ListTile(
              title: Text(
                notices[index],
                style: TextStyle(
                    color: Color(0xFF00B8FF),
                    fontSize: 25,
                ),
              ),
              onTap: () => showNoticeDialog(notices[index]),
            ),
          );
        },
      ),
      backgroundColor: Colors.white,
      // floatingActionButton 제거됨
    );
  }
}
