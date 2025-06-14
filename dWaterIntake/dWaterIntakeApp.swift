//
//  dWaterIntakeApp.swift
//  dWaterIntake
//
//  Created by Munshi Sariful Islam on 30/05/25.
//

import SwiftUI

@main
struct dWaterIntakeApp: App {
    @StateObject private var manager: StoreManager = StoreManager()
    var body: some Scene {
        WindowGroup {
            SplashScreen()
                .environmentObject(manager)
                .environment(\.managedObjectContext, manager.container.viewContext)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                        requestNotificationPermission()
                        scheduleDailyHydrationReminders()
                    }
                }
        }
    }
}
