import Flutter
import UIKit
import Firebase
import FirebaseMessaging
import UserNotifications

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    // Initialize Firebase
   if FirebaseApp.app() == nil {
      FirebaseApp.configure()
    }

    
    // Set UNUserNotificationCenter delegate
    UNUserNotificationCenter.current().delegate = self
 // Request permission (you can change options per your UX)
    let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
// Request permission (you can change options per your UX)
    UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { granted, error in
      if let error = error {
        print("Notification permission error: \(error.localizedDescription)")
      } else {
        print("Notification permission granted: \(granted)")
      }
    }
    // Register for remote notifications
    application.registerForRemoteNotifications()

    // Set Messaging delegate to receive FCM token callbacks
    Messaging.messaging().delegate = self

  //  GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

   // Pass APNs device token to Firebase Messaging
  override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    super.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
    // Set APNs token for FCM
    Messaging.messaging().apnsToken = deviceToken
    print("APNs device token set for FCM.")
  }

  // Optional: handle registration failure
  override func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
    super.application(application, didFailToRegisterForRemoteNotificationsWithError: error)
    print("failed to register for remote notifications: \(error.localizedDescription)")
  }
}

// MARK: - MessagingDelegate (FCM token updates)
extension AppDelegate: MessagingDelegate {
  func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
    guard let fcmToken = fcmToken else { return }
    print("FCM token: \(fcmToken)")
    // Optionally send token to app server
  }
}

