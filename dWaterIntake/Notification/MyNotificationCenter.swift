//
//  MyNotificationCenter.swift
//  dWaterIntake
//
//  Created by Munshi Sariful Islam on 13/06/25.
//

import Foundation
import UserNotifications

func requestNotificationPermission() {
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
        if let error = error {
            print("Error requesting notification permission: \(error)")
            return
        }
        
        if granted {
            print("Notification permission granted.")
        } else {
            print("Notification permission denied.")
        }
    }
}

func scheduleHydrationReminders() {
    let center = UNUserNotificationCenter.current()
    center.removeAllPendingNotificationRequests()
    
    let hoursToNotify = Array(6...22).filter { $0 % 2 == 0 }

    for hour in hoursToNotify {
        let content = UNMutableNotificationContent()
        content.title = "💧 Time to Hydrate"
        content.body = "Don't forget to drink water!"
        content.sound = .default
        
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(
            identifier: "waterIntakeNotification_\(hour)",
            content: content,
            trigger: trigger
        )
        
        center.add(request) { error in
            if let error = error {
                print("Error scheduling notification for hour \(hour): \(error)")
            }
        }
    }
}
