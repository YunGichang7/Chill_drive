import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math' as math;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}


class VehicleDetailScreen extends StatefulWidget {
  final String vehicleType;

  VehicleDetailScreen({Key? key, required this.vehicleType}) : super(key: key);

  @override
  _VehicleDetailScreenState createState() => _VehicleDetailScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> vehicleTypes = [];
  final DatabaseReference databaseReference = FirebaseDatabase.instance.ref();
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    loadVehicleTypes();
  }

  void loadVehicleTypes() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref();
    DatabaseEvent event = await ref.once();
    DataSnapshot snapshot = event.snapshot;

    if (snapshot.exists && snapshot.value is Map) {
      Map<dynamic, dynamic> values = Map<dynamic, dynamic>.from(snapshot.value as Map);
      if (mounted) {
        setState(() {
          vehicleTypes = values.keys.cast<String>().toList();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('차종 선택', style: TextStyle(color: Color(0xFF00B8FF))),
        backgroundColor: Colors.white,
      ),
      body: Column(
          children: [
      Expanded(
        child: ListView.builder(
        itemCount: vehicleTypes.length,
        itemBuilder: (context, index) {
          return Card(
            color: Colors.white,
            child: ListTile(
              title: Text(
                vehicleTypes[index],
                style: TextStyle(
                  fontSize: 25,
                  color: Color(0xFF00B8FF),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VehicleDetailScreen(vehicleType: vehicleTypes[index]),
                  ),
                );
              },
            ),
          );
        },
        ),
      ),
          ],
      ),
    );
  }
}

class GaugeScoreIndicator extends StatelessWidget {
  final double score; // 점수 (예: 0.0 에서 100.0 사이)
  final double maxScore; // 최대 점수

  const GaugeScoreIndicator({
    Key? key,
    required this.score,
    this.maxScore = 100.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _GaugeScorePainter(score: score, maxScore: maxScore),
      size: Size(150, 60), // 계기판의 크기 조정
    );
  }
}

class _GaugeScorePainter extends CustomPainter {
  final double score;
  final double maxScore;

  _GaugeScorePainter({required this.score, required this.maxScore});

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPaint = Paint()
      ..color = Colors.grey.shade300
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10;

    // 배경 아크 그리기
    canvas.drawArc(
      Rect.fromCircle(center: Offset(size.width / 2, size.height), radius: size.height),
      math.pi,
      math.pi,
      false,
      backgroundPaint,
    );

    final scorePaint = Paint()
      ..color = Colors.blue
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10;

    // 점수에 따른 아크 그리기
    double scoreAngle = (score / maxScore) * math.pi;
    canvas.drawArc(
      Rect.fromCircle(center: Offset(size.width / 2, size.height), radius: size.height),
      math.pi,
      scoreAngle,
      false,
      scorePaint,
    );

    // 점수 텍스트 그리기
    final textSpan = TextSpan(
      style: TextStyle(color: Colors.blue.shade800, fontSize: 18, fontWeight: FontWeight.bold),
      text: '${score.toInt()}',
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(size.width / 2 - textPainter.width / 2, size.height - 35));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class ScoreAndPieChartWidget extends StatelessWidget {
  final Map<String, dynamic> scoreComponents;
  final Map<String, dynamic> data;

  ScoreAndPieChartWidget({required this.scoreComponents, required this.data});

  @override
  Widget build(BuildContext context) {
    // Make sure to convert the score to double as the SemiCircleScoreIndicator expects a double
    double score = scoreComponents['finalScore'].toDouble();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center, // Center the content horizontally
      children: [
        // Replace the placeholder with SemiCircleScoreIndicator
        Flexible(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.only(right: 0), // 오른쪽 간격 추가
            child: Align(
              alignment: Alignment.topCenter, // 상단 중앙으로 정렬
              child: GaugeScoreIndicator(
                score: score,
                maxScore: 100.0,
              ),
            ),
          ),
        ),
        Flexible(
          flex: 1, // 여기서 flex 비율을 조절하여 크기를 조정할 수 있습니다.
          child: Align(
            alignment: Alignment.topCenter, // PieChart를 상단 중앙으로 정렬
            child: SizedBox(
              height: 80, // 원하는 높이 지정
              child: PieChart(
                PieChartData(
                  sections: _buildChartSections(),
                  centerSpaceRadius: 10,
                  sectionsSpace: 0,
                ),
              ),
            ),
          ),
        ),
    ],
    );
  }

  List<PieChartSectionData> _buildChartSections() {
    // 이 색상들은 테마 색상인 #00B8FF와 어울리는 색상들입니다.
    // final colors = [
    //   Color(0xFF00B8FF).withOpacity(0.8), // 테마 색상보다 약간 어둡게
    //   Color(0xFF00B8FF).withOpacity(0.6), // 더 어둡게
    //   Color(0xFF00B8FF).withOpacity(0.4), // 더욱 더 어둡게
    //   Color(0xFF00B8FF).withOpacity(0.2), // 가장 어둡게
    // ];
    //
    // final data = [
    //   {
    //     'label': '급출발',
    //     'value': scoreComponents['rapidStartScore'].abs(),
    //     'colorIndex': 0
    //   },
    //   {
    //     'label': '급가속',
    //     'value': scoreComponents['accelerationScore'].abs(),
    //     'colorIndex': 1
    //   },
    //   {
    //     'label': '급감속',
    //     'value': scoreComponents['rapiddeceleration'].abs(),
    //     'colorIndex': 2
    //   },
    //   {
    //     'label': '공회전',
    //     'value': scoreComponents['idleTimeScore'].abs(),
    //     'colorIndex': 3
    //   },
    //   // Add any additional sections here
    // ];
    //
    // return List.generate(data.length, (index) {
    //   final entry = data[index];
    //   final label = entry['label'];
    //   final value = entry['value'].toDouble();
    //   final color = colors[entry['colorIndex']]; // 위에서 정의한 색상 배열을 사용합니다.

    final data = [
      {'label': '급출발', 'value': scoreComponents['rapidStartScore'].abs(), 'color': Color(0xFFFF9900)}, // Orange
      {'label': '급가속', 'value': scoreComponents['accelerationScore'].abs(), 'color': Color(0xFFFFB740)}, // Light Orange
      {'label': '급감속', 'value': scoreComponents['rapiddeceleration'].abs(), 'color': Color(0xFFFFD28E)}, // Lighter Orange
      {'label': '공회전', 'value': scoreComponents['idleTimeScore'].abs(), 'color': Color(0xFFE6E6E6)}, // Grey
      // Add any additional sections here
    ];

    return List.generate(data.length, (index) {
      final entry = data[index];
      final label = entry['label'];
      final value = entry['value'].toDouble();
      final color = entry['color'] as Color;

      return PieChartSectionData(
        color: color,
        value: value,
        title: '$label',
        titleStyle: TextStyle(
          fontSize: 20,
          fontFamily: 'Dongle',
          fontWeight: FontWeight.bold,
          color: const Color(0xFF505050), // 텍스트 색상은 가독성을 위해 조정해야 할 수 있습니다.
        ),
        titlePositionPercentageOffset: 0.6, // 타이틀 위치 조정
      );
    });
  }
}


class _VehicleDetailScreenState extends State<VehicleDetailScreen> {
  final databaseReference = FirebaseDatabase.instance.ref();
  List<Map<String, dynamic>> vehicleData = [];
  bool isLoading = true;
  Set<DateTime> driveDates = {};
  DateTime? _selectedDay; // Make this nullable to handle no selection
  DateTime _focusedDay = DateTime.now();

  // Initialize with an empty list to represent no data selected
  List<dynamic> _selectedDayVehicleData = [];

  @override
  void initState() {
    super.initState();
    loadVehicleData();
  }

  void loadVehicleData() async {
    setState(() {
      isLoading = true;
    });

    try {
      DatabaseEvent event = await databaseReference.child(widget.vehicleType)
          .once();
      DataSnapshot snapshot = event.snapshot;

      if (snapshot.value != null) {
        List<dynamic> dataList = snapshot.value is List<dynamic> ? snapshot
            .value as List<dynamic> : [];
        List<Map<String, dynamic>> tempList = dataList.where((
            data) => data is Map).map((data) {
          Map<String, dynamic> stringDynamicMap = Map<String, dynamic>.from(
              data as Map);
          Map<String, dynamic> scoreComponents = calculateScore(
              stringDynamicMap);

          if (stringDynamicMap.containsKey('drive_date')) {
            DateTime driveDate = DateTime.parse(stringDynamicMap['drive_date']);
            driveDates.add(driveDate);
          }

          return {
            'data': stringDynamicMap,
            'scoreComponents': scoreComponents,
          };
        }).toList();

        if (mounted) {
          setState(() {
            vehicleData = tempList;
            isLoading = false;
          });
        }
      }
    } catch (e) {
      print('Error loading vehicle data: $e');
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Map<String, dynamic> calculateScore(Map<String, dynamic> value) {
    double totalHours = double.parse(value['시간H']?.toString() ?? '0');
    double normalizationFactor = totalHours == 0 ? 1 : 1 / totalHours;

    int Timewithoutdeduction = int.parse(value['감점없는시간점수'] ?? '0');
    int rapidDeceleration = int.parse(value['급감속회수'] ?? '0');
    double warmup_score = double.parse(value['warmup_score'] ?? '0.0');
    double Acceleration = double.parse(value['급과속점수'] ?? '0.0');
    double rapidStart = double.parse(value['급출발시간'] ?? '0.0');
    double fuelcut = double.parse(value['fuel_cut'] ?? '0.0');
    double idleTime = double.parse(value['공회전M'] ?? '0.0');

    int idleTimeScore = ((idleTime / 3) * normalizationFactor).round();
    int AccelerationScore = (Acceleration * normalizationFactor).round();
    int rapidStartScore = ((rapidStart * 0.5) * normalizationFactor).round();
    int fuelcutScore = (fuelcut * normalizationFactor).round();
    int warmupScore = warmup_score.round();

// 최종 점수 계산
    int score = 100;
    score += (Timewithoutdeduction * normalizationFactor).round();
    score -= (rapidDeceleration * normalizationFactor).round();
    score += warmupScore;
    score += AccelerationScore;
    score -= rapidStartScore;
    score += fuelcutScore;
    score -= idleTimeScore;

    if (score > 100) {
      score = 100;
    } else if (score < 0) {
      score = 0;
    }

    return {
      'finalScore': score,
      'timewithoutdeduction': (Timewithoutdeduction * normalizationFactor)
          .round(),
      'rapiddeceleration': (rapidDeceleration * normalizationFactor).round(),
      'warmupScore': warmupScore,
      'accelerationScore': AccelerationScore,
      'rapidStartScore': rapidStartScore,
      'fuelcutScore': fuelcutScore,
      'idleTimeScore': idleTimeScore,
    };
  }

  String formatDuration(double hours) {
    int totalSeconds = (hours * 3600).round();
    int hoursPart = totalSeconds ~/ 3600;
    int minutesPart = (totalSeconds % 3600) ~/ 60;
    int secondsPart = totalSeconds % 60;

    String formattedTime = '';
    if (hoursPart > 0) {
      formattedTime += "${hoursPart}시간 ";
    }
    if (minutesPart > 0) {
      formattedTime += "${minutesPart}분 ";
    }
    if (secondsPart > 0) {
      formattedTime += "${secondsPart}초";
    }

    return formattedTime.isEmpty ? '0초' : formattedTime;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.vehicleType} 운행 점수',
            style: TextStyle(color: Color(0xFF00B8FF))),
        backgroundColor: Colors.white,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
            children: [
              TableCalendar(
                daysOfWeekHeight: 25,
                firstDay: DateTime.utc(2010, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: _focusedDay,
                calendarFormat: CalendarFormat.month,
                selectedDayPredicate: (day) => _selectedDay != null && isSameDay(_selectedDay, day),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                    // Filter vehicleData for entries where drive_date matches selectedDay
                    _selectedDayVehicleData = vehicleData
                        .where((data) {
                      // Parse drive_date from each data entry
                      var driveDate = DateTime.parse(data['data']['drive_date']);
                      // Check if driveDate matches selectedDay
                      return isSameDay(driveDate, selectedDay);
                    })
                        .toList();
                  });
                },
                daysOfWeekStyle: DaysOfWeekStyle(
                  // Adjust style to prevent text clipping and improve visibility
                  weekdayStyle: TextStyle(color: Color(0xFF000000)),
                  weekendStyle: TextStyle(color: Color(0xFF000000)),
                ),
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  titleTextStyle: TextStyle(
                    color: Color(0xFF00B8FF),
                    fontSize: 30, // Increase font size
                  ),
                  leftChevronIcon: Icon(Icons.chevron_left, color: Color(0xFF00B8FF)),
                  rightChevronIcon: Icon(Icons.chevron_right, color: Color(0xFF00B8FF)),
                ),
                calendarBuilders: CalendarBuilders(
                  defaultBuilder: (context, day, focusedDay) {
                    // Check if the date has associated driving data
                    bool hasDrivingData = driveDates.contains(DateTime(day.year, day.month, day.day));

                    if (hasDrivingData) {
                      // For dates with driving data, customize the text color
                      return Container(
                        margin: const EdgeInsets.all(4.0),
                        alignment: Alignment.center,
                        child: Text(
                          day.day.toString(),
                          style: TextStyle(
                            color: Color(0xFF00B8FF), // Set the text color to #00B8FF
                          ),
                        ),
                      );
                    }
                    // Return null to use the default style for other dates
                    return null;
                  },
                ),
                calendarStyle: CalendarStyle(
                  // Customizing styles
                  defaultTextStyle: TextStyle(color: Colors.black),
                  weekendTextStyle: TextStyle(color: Colors.black),
                  todayTextStyle: TextStyle(color: Colors.black),
                ),
              ),
              Expanded(
                child: _selectedDayVehicleData.isNotEmpty
                    ? ListView.builder(
                  itemCount: _selectedDayVehicleData.length,
                  itemBuilder: (context, index) {
                    var item = _selectedDayVehicleData[index];
                    Map<String, dynamic> data = item['data'];
                    Map<String, dynamic> scoreComponents = item['scoreComponents'];

                    return Card(
                      margin: EdgeInsets.all(8.0),
                      child: ExpansionTile(
                          title: Text(
                            "운행 날짜: ${data['drive_date'] ?? '날짜 정보 없음'}",
                            style: TextStyle(
                              fontSize: 29.0,
                              color: Color(0xFF00B8FF),
                            ),
                          ),
                          children: <Widget>[
                      Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ScoreAndPieChartWidget(
                            scoreComponents: scoreComponents,
                            data: data,
                          ),
                          SizedBox(height: 8.0),
                          Text("총 운행 시간: ${formatDuration(double.parse(data['시간H']?.toString() ?? '0'))}"),
                          Text("급출발 점수: ${scoreComponents['rapidStartScore']} 점"),
                          Text("급가속 점수: ${scoreComponents['accelerationScore']} 점"),
                          Text("급감속 점수: ${scoreComponents['rapiddeceleration']} 점"),
                          Text("공회전 점수: ${scoreComponents['idleTimeScore']} 점"),
                          Text("웜업 점수: ${scoreComponents['warmupScore']} 점"),
                          Text("연료 절감 점수: ${scoreComponents['fuelcutScore']} 점"),
                          Text("무감점 시간 점수: ${scoreComponents['timewithoutdeduction']} 점"),
                            // Add any additional information you want to display here
                        ],
                      ),
                      ),
                          ],
                      ),
                    );
                  },
                )
                : Center(
                  child: Text("선택한 날짜에 대한 운행 데이터가 없습니다."),
            ),
          ),
        ],
      ),
    );
  }
}