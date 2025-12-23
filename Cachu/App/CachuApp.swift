//
//  CachuApp.swift
//  Cachu
//
//  Created by 박도원 on 12/10/25.
//

import SwiftUI
import FirebaseCore
import FirebaseMessaging

// 1. AppDelegate 클래스 생성 (Firebase 설정 및 알림 등록)
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        // Firebase 초기화
        FirebaseApp.configure()
        
        // 원격 알림 등록
        UNUserNotificationCenter.current().delegate = self
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
        )
        
        application.registerForRemoteNotifications()
        
        // 메시징 델리게이트 설정
        Messaging.messaging().delegate = self
        
        return true
    }
    
    // APNs 토큰을 받았을 때 (디바이스 토큰과 Firebase 매핑)
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
}

// 2. 메시징 델리게이트 확장 (토큰 수신 및 알림 처리)
extension AppDelegate: MessagingDelegate {
    
    // FCM 토큰이 갱신될 때 호출됨 (테스트 할 때 이 토큰이 필요합니다!)
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("⭐️ FCM Token: \(fcmToken ?? "")")
        
        // 필요한 경우 서버로 이 토큰을 전송하는 로직을 여기에 추가합니다.
    }
}

// 3. UNUserNotificationCenter 델리게이트 (앱이 실행 중일 때 알림 처리)
extension AppDelegate: UNUserNotificationCenterDelegate {
    
    // 앱이 포그라운드(켜진 상태)에 있을 때 알림이 오면 호출됨
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let userInfo = notification.request.content.userInfo
        print("🔔 알림 수신: \(userInfo)")
        
        // 배너와 소리를 표시하도록 설정
        completionHandler([.banner, .sound, .badge])
    }
}

@main
struct CachuApp: App {
    let container = DIContainer()
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
        
    var body: some Scene {
        WindowGroup {
            LoginView()
        }
    }
}
