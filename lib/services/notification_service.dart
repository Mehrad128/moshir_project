import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'platform_service.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  // شناسه‌های نوتیفیکیشن
  int _notificationId = 0;
  bool _isInitialized = false;

  // کانال‌های نوتیفیکیشن
  static const String _generalChannelId = 'general_channel';
  static const String _generalChannelName = 'اعلان‌های عمومی';
  static const String _generalChannelDescription = 'کانال اعلان‌های عمومی';

  static const String _importantChannelId = 'important_channel';
  static const String _importantChannelName = 'اعلان‌های مهم';
  static const String _importantChannelDescription = 'کانال اعلان‌های مهم';

  static const String _payrollChannelId = 'payroll_channel';
  static const String _payrollChannelName = 'اعلان‌های حقوقی';
  static const String _payrollChannelDescription = 'کانال اعلان‌های حقوقی';

  // مقداردهی اولیه
  Future<void> initialize() async {
    if (_isInitialized) return;

    if (kIsWeb) {
      // برای وب از Web implementation استفاده کن
      return;
    }

    // مقداردهی اولیه timezone
    tz.initializeTimeZones();

    // تنظیمات اندروید
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // تنظیمات iOS
    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    // تنظیمات بر اساس پلتفرم
    late InitializationSettings initSettings;

    if (PlatformService.isLinux) {
      // تنظیمات مخصوص لینوکس
      LinuxInitializationSettings linuxSettings = LinuxInitializationSettings(
        defaultActionName: 'باز کردن',
        // defaultIcon: LinuxNotificationIcon(File('/path/to/icon.png')), // Removed because LinuxNotificationIcon is abstract
      );

      initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
        linux: linuxSettings,
      );
    } else {
      initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );
    }

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    // ایجاد کانال‌های اندروید
    if (PlatformService.isAndroid) {
      await _createAndroidChannels();
    }

    _isInitialized = true;
  }

  // ایجاد کانال‌های اندروید
  Future<void> _createAndroidChannels() async {
    final androidPlugin = _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (androidPlugin == null) return;

    const androidGeneralChannel = AndroidNotificationChannel(
      _generalChannelId,
      _generalChannelName,
      description: _generalChannelDescription,
      importance: Importance.max,
      enableVibration: true,
      playSound: true,
    );

    const androidImportantChannel = AndroidNotificationChannel(
      _importantChannelId,
      _importantChannelName,
      description: _importantChannelDescription,
      importance: Importance.max,
      enableVibration: true,
      playSound: true,
    );

    const androidPayrollChannel = AndroidNotificationChannel(
      _payrollChannelId,
      _payrollChannelName,
      description: _payrollChannelDescription,
      importance: Importance.max,
      enableVibration: true,
      playSound: true,
    );

    await androidPlugin.createNotificationChannel(androidGeneralChannel);
    await androidPlugin.createNotificationChannel(androidImportantChannel);
    await androidPlugin.createNotificationChannel(androidPayrollChannel);
  }

  // نمایش نوتیفیکیشن ساده
  Future<void> showSimpleNotification({
    required String title,
    required String body,
    String? payload,
    NotificationType type = NotificationType.general,
  }) async {
    if (!_isInitialized) await initialize();

    _notificationId++;

    final androidDetails = _createAndroidDetails(type);
    final iosDetails = _createIosDetails(type);
    final notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      _notificationId,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  // نمایش نوتیفیکیشن پیشرفته
  Future<void> showAdvancedNotification({
    required String title,
    required String body,
    String? payload,
    NotificationType type = NotificationType.general,
    String? imagePath,
  }) async {
    if (!_isInitialized) await initialize();

    _notificationId++;

    final androidDetails = AndroidNotificationDetails(
      _getChannelId(type),
      _getChannelName(type),
      channelDescription: _getChannelDescription(type),
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      color: _getColor(type),
      largeIcon: imagePath != null ? FilePathAndroidBitmap(imagePath) : null,
      styleInformation: imagePath != null
          ? BigPictureStyleInformation(
              FilePathAndroidBitmap(imagePath),
              contentTitle: title,
              summaryText: body,
            )
          : null,
    );

    final notificationDetails = NotificationDetails(android: androidDetails);

    await _localNotifications.show(
      _notificationId,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  // نمایش نوتیفیکیشن زمان‌بندی شده
  Future<void> showScheduledNotification({
    required String title,
    required String body,
    required Duration delay,
    NotificationType type = NotificationType.general,
    String? payload,
  }) async {
    if (!_isInitialized) await initialize();

    _notificationId++;

    final scheduledDate = _getScheduledDate(delay);
    final androidDetails = _createAndroidDetails(type);
    final iosDetails = _createIosDetails(type);
    final notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.zonedSchedule(
      _notificationId,
      title,
      body,
      scheduledDate,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload,
    );
  }

  // نمایش نوتیفیکیشن گروهی
  Future<void> showGroupedNotification({
    required String groupKey,
    required List<Map<String, String>> notifications,
  }) async {
    if (!_isInitialized) await initialize();

    for (var i = 0; i < notifications.length; i++) {
      _notificationId++;

      final androidDetails = AndroidNotificationDetails(
        groupKey,
        'اعلان‌های گروهی',
        channelDescription: 'اعلان‌های گروهی',
        importance: Importance.defaultImportance,
        groupKey: groupKey,
        setAsGroupSummary: i == 0,
      );

      final notificationDetails = NotificationDetails(android: androidDetails);

      await _localNotifications.show(
        _notificationId,
        notifications[i]['title']!,
        notifications[i]['body']!,
        notificationDetails,
      );
    }
  }

  // نمایش نوتیفیکیشن با نوار پیشرفت
  Future<void> showProgressNotification({
    required String title,
    required int current,
    required int total,
    String? payload,
  }) async {
    if (!_isInitialized) await initialize();

    _notificationId++;

    final androidDetails = AndroidNotificationDetails(
      'progress_channel',
      'اعلان‌های پیشرفت',
      channelDescription: 'کانال اعلان‌های پیشرفت',
      importance: Importance.defaultImportance,
      showProgress: true,
      progress: current,
      maxProgress: total,
      indeterminate: false,
    );

    final notificationDetails = NotificationDetails(android: androidDetails);

    await _localNotifications.show(
      _notificationId,
      title,
      '$current از $total',
      notificationDetails,
      payload: payload,
    );
  }

  // ============== توابع کمکی ==============

  AndroidNotificationDetails _createAndroidDetails(NotificationType type) {
    return AndroidNotificationDetails(
      _getChannelId(type),
      _getChannelName(type),
      channelDescription: _getChannelDescription(type),
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      color: _getColor(type),
    );
  }

  DarwinNotificationDetails _createIosDetails(NotificationType type) {
    return DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      subtitle: type == NotificationType.important ? 'مهم' : null,
    );
  }

  tz.TZDateTime _getScheduledDate(Duration delay) {
    return tz.TZDateTime.now(tz.local).add(delay);
  }

  String _getChannelId(NotificationType type) {
    switch (type) {
      case NotificationType.general:
        return _generalChannelId;
      case NotificationType.important:
        return _importantChannelId;
      case NotificationType.payroll:
        return _payrollChannelId;
    }
  }

  String _getChannelName(NotificationType type) {
    switch (type) {
      case NotificationType.general:
        return _generalChannelName;
      case NotificationType.important:
        return _importantChannelName;
      case NotificationType.payroll:
        return _payrollChannelName;
    }
  }

  String _getChannelDescription(NotificationType type) {
    switch (type) {
      case NotificationType.general:
        return _generalChannelDescription;
      case NotificationType.important:
        return _importantChannelDescription;
      case NotificationType.payroll:
        return _payrollChannelDescription;
    }
  }

  Color _getColor(NotificationType type) {
    switch (type) {
      case NotificationType.general:
        return Colors.blue;
      case NotificationType.important:
        return Colors.red;
      case NotificationType.payroll:
        return Colors.green;
    }
  }

  void _onNotificationTap(NotificationResponse response) {
    debugPrint('نوتیفیکیشن کلیک شد: ${response.payload}');

    if (response.payload != null) {
      try {
        final data = jsonDecode(response.payload!);
        // اینجا می‌تونی کاربر رو به صفحه مناسب هدایت کنی
        // NavigationService().navigateTo(data['screen']);
      } catch (e) {
        debugPrint('خطا در پردازش payload: $e');
      }
    }
  }

  // تنظیم بج - فقط برای اندروید و iOS
  Future<void> setBadge(int count) async {
    // فقط روی اندروید و iOS اجرا کن
    if (PlatformService.isAndroid || PlatformService.isIOS) {
      if (await FlutterAppBadger.isAppBadgeSupported()) {
        if (count > 0) {
          FlutterAppBadger.updateBadgeCount(count);
        } else {
          FlutterAppBadger.removeBadge();
        }
      }
    } else {
      debugPrint('❌ بج فقط روی اندروید و iOS پشتیبانی میشه');
    }
  }

  // لغو نوتیفیکیشن
  Future<void> cancelNotification(int id) async {
    await _localNotifications.cancel(id);
  }

  // لغو همه نوتیفیکیشن‌ها
  Future<void> cancelAllNotifications() async {
    await _localNotifications.cancelAll();
    if (await FlutterAppBadger.isAppBadgeSupported()) {
      FlutterAppBadger.removeBadge();
    }
  }
}

enum NotificationType { general, important, payroll }
