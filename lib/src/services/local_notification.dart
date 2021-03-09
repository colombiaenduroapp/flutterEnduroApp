import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class LocalNotification {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  LocalNotification() {
    var initializationSettingsIOs = IOSInitializationSettings();
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('app_icon');
    var initSetttings = new InitializationSettings(
        iOS: initializationSettingsIOs, android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();

    flutterLocalNotificationsPlugin.initialize(initSetttings,
        onSelectNotification: onSelectNotification);
  }

  Future onSelectNotification(String payload) async {
    print('hola');
  }

  Future<void> showNotificationMediaStyle() async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'media channel id',
      'media channel name',
      'media channel description',
      color: Colors.red,
      enableLights: true,
      largeIcon: DrawableResourceAndroidBitmap("app_icon"),
      styleInformation: MediaStyleInformation(),
    );
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: null);
    await flutterLocalNotificationsPlugin.show(
        0, 'notification title', 'notification body', platformChannelSpecifics);
  }

  Future<void> showBigPictureNotification() async {
    var bigPictureStyleInformation = BigPictureStyleInformation(
        DrawableResourceAndroidBitmap("app_icon"),
        largeIcon: DrawableResourceAndroidBitmap("app_icon"),
        contentTitle: 'flutter devs',
        htmlFormatContentTitle: true,
        summaryText: 'summaryText',
        htmlFormatSummaryText: true);
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'big text channel id',
        'big text channel name',
        'big text channel description',
        styleInformation: bigPictureStyleInformation);
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: null);
    await flutterLocalNotificationsPlugin.show(
        0, 'big text title', 'silent body', platformChannelSpecifics,
        payload: "big image notifications");
  }

  Future<void> scheduleNotification(String title, String description) async {
    String groupKey = 'com.android.example.WORK_EMAIL';
    String groupChannelId = 'grouped channel id';
    String groupChannelName = 'grouped channel name';
    String groupChannelDescription = 'grouped channel description';
    var scheduledNotificationDateTime =
        DateTime.now().add(Duration(seconds: 5));
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        groupChannelId, groupChannelName, groupChannelDescription,
        icon: 'app_icon',
        largeIcon: DrawableResourceAndroidBitmap('app_icon'),
        priority: Priority.high,
        importance: Importance.max,
        setAsGroupSummary: true,
        playSound: true,
        onlyAlertOnce: true,
        enableVibration: true,
        groupKey: groupKey);
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.schedule(
        DateTime.now().microsecond,
        title,
        description,
        scheduledNotificationDateTime,
        platformChannelSpecifics);
  }

  Future<void> cancelNotification() async {
    await flutterLocalNotificationsPlugin.cancel(0);
  }

  showNotification(String title, String description) async {
    var android = new AndroidNotificationDetails(
        'id', 'channel ', 'description',
        icon: 'app_icon', priority: Priority.high, importance: Importance.max);
    var iOS = new IOSNotificationDetails();
    var platform = new NotificationDetails(android: android, iOS: iOS);
    await flutterLocalNotificationsPlugin.show(0, title, description, platform,
        payload: 'Welcome to the Local Notification demo ');
  }
}
