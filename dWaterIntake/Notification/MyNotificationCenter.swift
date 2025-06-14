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

func scheduleDailyHydrationReminders() {
    let center = UNUserNotificationCenter.current()
    center.removeAllPendingNotificationRequests()

    let hours = [6, 8, 10, 12, 14, 16, 18, 20, 22, 0]

    for (index, hour) in hours.enumerated() {
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = 0

        let content = UNMutableNotificationContent()
        content.title = "Hydration Reminder 💧"
        content.body = "Time to drink some water!"
        content.sound = .default
        content.badge = NSNumber(value: index + 1)

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

        let request = UNNotificationRequest(identifier: "hydration_\(hour)", content: content, trigger: trigger)

        center.add(request) { error in
            if let error = error {
                print("Error scheduling notification for \(hour): \(error.localizedDescription)")
            }
        }
    }
}
