//
//  LocalNotificationScheduler.swift
//  Common
//
//  Created by Egehan KARAKÖSE (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 27.03.2022.
//

import Foundation
import UserNotifications

public final class LocalNotificationScheduler {
    
    static private let center = UNUserNotificationCenter.current()
    
    private class func handlePermissions() {
        let options: UNAuthorizationOptions = [.alert, .sound]
        center.requestAuthorization(options: options) { (granted, error) in
            if let error = error {
                debugPrint(error)
            }
        }
    }
    
    public class func schedule(title: String = "",
                               body: String = "",
                               delay: TimeInterval = 1,
                               repeats: Bool = false,
                               completionHandler: ((Error?) -> Void)? = nil) {
        handlePermissions()
        let content = UNMutableNotificationContent()
        content.title = title.localized
        content.body = body.localized
        content.sound = UNNotificationSound.default
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: delay, repeats: repeats)
        let identifier = "VKFLocalNotification"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        center.add(request, withCompletionHandler: { (error) in
            completionHandler?(error)
        })
    }
    
}
