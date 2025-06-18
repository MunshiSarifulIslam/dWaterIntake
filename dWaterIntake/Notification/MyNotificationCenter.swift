//
//  MyNotificationCenter.swift
//  dWaterIntake
//
//  Created by Munshi Sariful Islam on 13/06/25.
//

import Foundation
import UserNotifications

func setupHydrationNotifications() {
    requestNotificationPermission()
    scheduleDailyHydrationReminders()
    scheduleDailyMidnightNotification()
}

func requestNotificationPermission() {
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
        if let error = error {
            print("Notification permission error: \(error)")
            return
        }
        print(granted ? "Notification permission granted." : "Notification permission denied.")
    }
}

func scheduleDailyHydrationReminders() {
    let center = UNUserNotificationCenter.current()
    let hours = [6, 8, 10, 12, 14, 16, 18, 20, 22, 0]
    
    let identifiers = hours.map { "hydration_\($0)" }
    center.removePendingNotificationRequests(withIdentifiers: identifiers)
    
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
                print("Error scheduling for \(hour): \(error.localizedDescription)")
            }
        }
    }
}

func scheduleDailyMidnightNotification() {
    let center = UNUserNotificationCenter.current()
    center.removePendingNotificationRequests(withIdentifiers: ["dailyMidnightReminder"])

    let content = UNMutableNotificationContent()
    content.title = "Water Intake Saved!"
    content.body = "Your daily water intake has been saved to history."
    content.sound = .default

    var dateComponents = DateComponents()
    dateComponents.hour = 0
    dateComponents.minute = 0

    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
    let request = UNNotificationRequest(identifier: "dailyMidnightReminder", content: content, trigger: trigger)

    center.add(request)
}
