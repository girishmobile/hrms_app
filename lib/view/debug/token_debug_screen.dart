import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class TokenDebugScreen extends StatefulWidget {
  const TokenDebugScreen({super.key});

  @override
  State<TokenDebugScreen> createState() => _TokenDebugScreenState();
}

class _TokenDebugScreenState extends State<TokenDebugScreen> {
  String? _apnsToken;
  String? _fcmToken;
  String _permissionStatus = 'unknown';
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _refreshTokens();
  }

  Future<void> _refreshTokens() async {
    setState(() {
      _loading = true;
    });

    try {
      final messaging = FirebaseMessaging.instance;

      // Request permission (iOS) — safe to call on Android too
      NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      setState(() {
        _permissionStatus = settings.authorizationStatus.toString();
      });

      // APNs token (iOS) — wrap in try/catch because it throws on simulator if not available
      try {
        final apns = await messaging.getAPNSToken();
        setState(() => _apnsToken = apns);
      } catch (e) {
        setState(() => _apnsToken = 'error: $e');
      }

      // FCM token
      try {
        final fcm = await messaging.getToken();
        setState(() => _fcmToken = fcm);
      } catch (e) {
        setState(() => _fcmToken = 'error: $e');
      }
    } catch (e) {
      setState(() {
        _apnsToken = null;
        _fcmToken = null;
        _permissionStatus = 'error';
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FCM Token Debug')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Permission: $_permissionStatus'),
            const SizedBox(height: 12),
            Text('APNs token (getAPNSToken): ${_apnsToken ?? "<null>"}'),
            const SizedBox(height: 12),
            Text('FCM token (getToken): ${_fcmToken ?? "<null>"}'),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loading ? null : _refreshTokens,
              icon: const Icon(Icons.refresh),
              label: Text(_loading ? 'Refreshing...' : 'Refresh tokens'),
            ),
            const SizedBox(height: 24),
            const Text('Notes:'),
            const SizedBox(height: 6),
            const Text('- APNs token usually unavailable on Simulator.'),
            const Text(
              '- Run on a real device and accept notification permission.',
            ),
            const SizedBox(height: 12),
            const Text('Tap the Refresh button after granting permission.'),
            const SizedBox(height: 12),
            if (!kReleaseMode)
              Expanded(
                child: SingleChildScrollView(
                  child: SelectableText(
                    'Debug info:\nAPNs: ${_apnsToken ?? "<null>"}\nFCM: ${_fcmToken ?? "<null>"}\nPermission: $_permissionStatus',
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
