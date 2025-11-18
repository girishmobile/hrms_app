import Flutter
import UIKit
import Firebase
import FirebaseMessaging
import UserNotifications

@main
@objc class AppDelegate: FlutterAppDelegate, MessagingDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        // Initialize Firebase
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }

        // Register Flutter plugins
        GeneratedPluginRegistrant.register(with: self)

        // Set UNUserNotificationCenter delegate (already conforms via FlutterAppDelegate)
        UNUserNotificationCenter.current().delegate = self

        // Request notification permissions
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { granted, error in
            if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
            } else {
                print("Notification permission granted: \(granted)")
            }
        }

        application.registerForRemoteNotifications()

        // Set Firebase Messaging delegate (must be set BEFORE requestAuthorization)
        Messaging.messaging().delegate = self

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    // MARK: - MessagingDelegate
    /// Called when FCM registration token is generated or refreshed
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("✅ Firebase registration token: \(fcmToken ?? "")")
        
        // Post notification so Flutter can receive the token
        let token = fcmToken ?? ""
        NotificationCenter.default.post(
            name: NSNotification.Name("FCMTokenDidChange"),
            object: nil,
            userInfo: ["token": token]
        )
    }
    
    // MARK: - Remote Notifications
    /// Called when APNs successfully registers the device for remote notifications
    override func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print("✅ APNs device token registered: \(token)")
        Messaging.messaging().apnsToken = deviceToken
    }
    
    /// Called if APNs registration fails
    override func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error
    ) {
        print("❌ Failed to register for remote notifications: \(error.localizedDescription)")
    }
}
