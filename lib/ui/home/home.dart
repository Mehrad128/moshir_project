import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moshir_ui/ui/components/header.dart'; // فرض بر این است که Header تعریف شده است
import 'package:moshir_ui/ui/components/bottom_navi.dart'; // فرض بر این است که BottomNaviState تعریف شده است

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(
        context,
      ).scaffoldBackgroundColor, // پس‌زمینه بر اساس تم
      // appBar: AppBar(title: Text('Home Page')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
          child: Column(
            children: [
              Header(),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset('assets/images/Logo_light.svg'),
                      SizedBox(height: 18),
                      Text(
                        "Moshir Home Page",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar:
          const BottomNaviState(), // فرض بر این است که BottomNaviState درست تعریف شده است
    );
  }
}
