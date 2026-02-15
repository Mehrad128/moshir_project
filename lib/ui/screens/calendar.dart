import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moshir_ui/main.dart';
import 'package:moshir_ui/ui/components/bottom_navi.dart';
import 'package:moshir_ui/ui/home/home.dart';
import 'package:moshir_ui/ui/screens/settings.dart';
import 'package:moshir_ui/ui/screens/user_profile.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    // final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    // final iconColor = isDarkMode ? Colors.white : Colors.black;
    final backgroundColor = isDarkMode ? Colors.black : Colors.white;
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const _HeaderMenuButton(),
                  Text(
                    "صفحه تقویم",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const _HeaderBackButton(),
                ],
              ),
              SelectedDateCard(selectedDate: selectedDate),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 150, 0, 0),
                child: ElevatedButton(
                  onPressed: () {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      IOSDatePicker.show(
                        context: context,
                        initialDate: selectedDate,
                        onDateSelected: (value) {
                          setState(() {
                            selectedDate = value;
                          });
                        },
                      );
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(150, 40),
                    padding: EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        30,
                      ),
                    ),
                  ),
                  child: Text(
                    "Select Date",
                    style: TextStyle(fontSize: 16), // اندازه فونت کوچکتر
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNaviState(),
    );
  }
}

class _HeaderMenuButton extends StatelessWidget {
  const _HeaderMenuButton();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showCupertinoModalPopup(
          context: context,
          builder: (context) => CupertinoActionSheet(
            actions: [
              CupertinoActionSheetAction(
                child: Text(
                  'پروفایل',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                onPressed: () {
                  // Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UserProfileState()),
                  );
                },
              ),
              CupertinoActionSheetAction(
                child: Text(
                  'تنظیمات',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (builder) => SettingsPage()),
                  );
                },
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              child: Text(
                'لغو',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        );
      },
      child: SvgPicture.asset("assets/images/More.svg"),
    );
  }
}

class _HeaderBackButton extends StatelessWidget {
  const _HeaderBackButton();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _showTopMessage(context);
        // String currentTime = MyApp().getTime();
        // String currentDate = MyApp().getDate();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      },
      onLongPress: () {
        _showTopMessage(context);
      },
      child: SvgPicture.asset("assets/images/Arrow.svg"),
      // width: 24,
      // height: 24,
    );
  }

  void _showTopMessage(BuildContext context) {
    final overlay = Overlay.of(context);
    String currentTime = MyApp().getTime();

    final entry = OverlayEntry(
      builder: (_) => Positioned(
        top: 50,
        left: 16,
        right: 16,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              "You are in Profile page \n $currentTime",

              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w100,
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );

    overlay.insert(entry);

    Future.delayed(const Duration(seconds: 1), () {
      entry.remove();
    });
  }
}

class IOSDatePicker {
  static show({
    required BuildContext context,
    required DateTime initialDate,
    required ValueChanged<DateTime> onDateSelected,
    Color backgroundColor = const Color(0xFF1E1E1E), // بک‌گراند دارک
    Color doneButtonColor = Colors.orange, // رنگ دکمه Done
    TextStyle doneTextStyle = const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Colors.orange,
    ),
    double borderRadius = 16, // گوشه‌های گرد
  }) {
    showCupertinoModalPopup(
      context: context,
      barrierColor: Colors.black54, // بک‌گراند نیمه شفاف
      builder: (_) => AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(borderRadius),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, -3),
            ),
          ],
        ),
        height: 300,
        child: Column(
          children: [
            // نوار بالا با Done Button استایل‌شده
            SizedBox(
              height: 44,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CupertinoButton(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Text('Done', style: doneTextStyle),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            // خود DatePicker با بک‌گراند شفاف
            Expanded(
              child: CupertinoTheme(
                data: CupertinoThemeData(
                  textTheme: CupertinoTextThemeData(
                    dateTimePickerTextStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: initialDate,
                  backgroundColor: Colors.transparent,
                  onDateTimeChanged: onDateSelected,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SelectedDateCard extends StatelessWidget {
  final DateTime selectedDate;

  const SelectedDateCard({super.key, required this.selectedDate});

  @override
  Widget build(BuildContext context) {
    // روز هفته و تاریخ به فرمت زیبا
    final dayOfWeek = [
      "Sun",
      "Mon",
      "Tue",
      "Wed",
      "Thu",
      "Fri",
      "Sat",
    ][selectedDate.weekday % 7];
    final day = selectedDate.day.toString().padLeft(2, '0');
    final month = selectedDate.month.toString().padLeft(2, '0');
    final year = selectedDate.year.toString();

    return Expanded(
      child: AnimatedContainer(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(vertical: 40),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color.fromARGB(255, 255, 153, 0),
              Colors.deepOrange.shade700,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(26),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 12,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // دایره روز هفته
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.2),
              ),
              child: Text(
                dayOfWeek,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 7),
            // تاریخ
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$day / $month / $year',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Selected Date',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
