// ignore_for_file: avoid_print
import 'dart:async';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:todo_app/middleware/global.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class SentryManager {
  static Future<Map<String, dynamic>> getSentryEnvEvent() async {
    final packageInfo = await PackageInfo.fromPlatform();
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    final Map<String, dynamic> context = {
      'release': '${packageInfo.version} (${packageInfo.buildNumber})',
      'env': 'production'
    };

    if (Platform.isAndroid) {
      final AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
      context['os'] = SentryOperatingSystem(
        name: 'android',
        version: androidDeviceInfo.version.release,
      );
      context['device'] = SentryDevice(
        brand: androidDeviceInfo.brand,
        model: androidDeviceInfo.model,
        manufacturer: androidDeviceInfo.manufacturer,
        modelId: androidDeviceInfo.product,
      );
      context['extra'] = {
        'type': androidDeviceInfo.type,
        'device': androidDeviceInfo.device,
        'id': androidDeviceInfo.id,
        'display': androidDeviceInfo.display,
        'hardware': androidDeviceInfo.hardware,
        'supported32BitAbis': androidDeviceInfo.supported32BitAbis,
        'supported64BitAbis': androidDeviceInfo.supported64BitAbis,
        'supportedAbis': androidDeviceInfo.supportedAbis,
        'isPhysicalDevice': androidDeviceInfo.isPhysicalDevice,
      };
    }

    if (Platform.isIOS) {
      final IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
      context['os'] = SentryOperatingSystem(
        name: iosDeviceInfo.systemName,
        version: iosDeviceInfo.systemVersion,
      );
      context['device'] = SentryDevice(
        model: iosDeviceInfo.utsname.machine,
        family: iosDeviceInfo.model,
        manufacturer: 'Apple',
      );
      context['extra'] = {
        'name': iosDeviceInfo.name,
        'localizedModel': iosDeviceInfo.localizedModel,
        'utsname': iosDeviceInfo.utsname.sysname,
        'identifierForVendor': iosDeviceInfo.identifierForVendor,
        'isPhysicalDevice': iosDeviceInfo.isPhysicalDevice,
      };
    }

    return context;
  }

  static Future<void> reportError(Object error, StackTrace stackTrace) async {
    if (Global.settings.isTest) {
      print(error);
      print(stackTrace);
      return;
    } else {
      try {
        await Sentry.captureException(
          error,
          stackTrace: stackTrace,
        );
      } catch (err) {
        print(err);
      }
    }
  }
}
