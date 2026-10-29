// import 'dart:io';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:base_app/core/di/dependency_injection.dart';
// import 'package:base_app/core/helpers/secure_storage_helper.dart';
// import 'package:base_app/core/helpers/shared_prefs_helper.dart';
// import 'package:base_app/core/network/network_result.dart';
// import 'package:sps/features/auth/data/models/update_firebase_token_request.dart';
// import 'package:sps/features/auth/data/repositories/i_auth_repository.dart';

// class FireBaseApi {
//   // create an instance of FirebaseMessaging
//   final _fireBaseMessaging = FirebaseMessaging.instance;
//   static bool appInitialized = false; // Track app initialization

//   // function to initialize the notifications
//   Future<void> initNotifications() async {

//     try {
//       // request for the permission to send notifications
//       await _fireBaseMessaging.requestPermission(
//         alert: true,
//         badge: true,
//         sound: true,
//       );
//       await FirebaseMessaging.instance
//           .setForegroundNotificationPresentationOptions(
//             alert: true,
//             badge: true,
//             sound: true,
//           );

//       // Listen to FCM token updates/changes
//       _fireBaseMessaging.onTokenRefresh.listen((fcmToken) async {
//         debugPrint("FCM Token refreshed: $fcmToken");
//         final accessToken = await SecureStorageHelper.getToken();
//         if (accessToken != null) {
//           final storedFcm = await SharedPrefsHelper.getFcmToken();
//           if (storedFcm != fcmToken) {
//             final platform = Platform.isIOS ? 'ios' : (Platform.isAndroid ? 'android' : 'web');
//             final authRepository = getIt<IAuthRepository>();
//             final result = await authRepository.updateFirebaseToken(
//               UpdateFirebaseTokenRequest(
//                 firebasePlatform: platform,
//                 firebaseToken: fcmToken,
//               ),
//             );
//             switch (result) {
//               case ApiSuccess():
//                 debugPrint("Refreshed Firebase token updated successfully on server.");
//                 await SharedPrefsHelper.setFcmToken(fcmToken);
//               case ApiFailure(failure: final failure):
//                 debugPrint("Failed to update refreshed Firebase token: ${failure.message}");
//             }
//           }
//         }
//       });

//       if (Platform.isIOS) {
//         // Wait for APNs token before getting FCM token to ensure it's available
//         String? apnsToken = await _fireBaseMessaging.getAPNSToken();
//         debugPrint("APNs Token: $apnsToken");
//       }

//       // fetch the FCM token for device
//       final fcmToken = await _fireBaseMessaging.getToken();
//       debugPrint("FCM Token: $fcmToken");
//       if (fcmToken != null) {
//         final storedFcm = await SharedPrefsHelper.getFcmToken();
//         if (storedFcm != fcmToken) {
//           await SharedPrefsHelper.setFcmToken(fcmToken);
//         }
//       }

//       // Sync with server if access token exists
//       await updateFirebaseTokenOnServer();

//       await initPushNotifications();
//     } catch (e) {
//       debugPrint("Error initializing Firebase Messaging: $e");
//     }
//   }

//   Future<void> updateFirebaseTokenOnServer({bool force = false}) async {
//     final accessToken = await SecureStorageHelper.getToken();
//     if (accessToken == null) {
//       debugPrint("Firebase Helper: No access token stored. Skipping API call.");
//       return;
//     }

//     try {
//       final fcmToken = await _fireBaseMessaging.getToken();
//       if (fcmToken == null) {
//         debugPrint("Firebase Helper: FCM Token is null.");
//         return;
//       }

//       final storedFcm = await SharedPrefsHelper.getFcmToken();
//       if (force || storedFcm != fcmToken) {
//         debugPrint("Firebase Helper: Token changed or needs updating. Syncing with backend...");
//         final platform = Platform.isIOS ? 'ios' : (Platform.isAndroid ? 'android' : 'web');
//         final authRepository = getIt<IAuthRepository>();
//         final result = await authRepository.updateFirebaseToken(
//           UpdateFirebaseTokenRequest(
//             firebasePlatform: platform,
//             firebaseToken: fcmToken,
//           ),
//         );
//         switch (result) {
//           case ApiSuccess():
//             debugPrint("Firebase token updated successfully on server.");
//             await SharedPrefsHelper.setFcmToken(fcmToken);
//           case ApiFailure(failure: final failure):
//             debugPrint("Failed to update firebase token on server: ${failure.message}");
//         }
//       } else {
//         debugPrint("Firebase Helper: FCM Token matches stored token. No sync needed.");
//       }
//     } catch (e) {
//       debugPrint("Error updating firebase token on server: $e");
//     }
//   }

//   static void markAppAsInitialized() {
//     appInitialized = true;
//     debugPrint("App marked as fully initialized");
//   }

//   Future<void> initPushNotifications() async {
//     // handle notification if the app is terminated and now opened
//     FirebaseMessaging.instance.getInitialMessage().then(handleMessage);

//     // attach event listeners for when a notification opens the app
//     FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
//   }

//   void handleMessage(RemoteMessage? message) {
//     if (message == null) return;
//     debugPrint("Notification tapped: ${message.notification?.title}");
//     // Route navigation can be added here if needed in the future
//   }
// }
