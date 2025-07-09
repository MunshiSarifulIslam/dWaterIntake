//
//  dWaterIntakeApp.swift
//  dWaterIntake
//
//  Created by Munshi Sariful Islam on 30/05/25.
//

import SwiftUI
import UserNotifications

@main
struct dWaterIntakeApp: App {
    @StateObject private var manager: StoreManager = StoreManager()
    @StateObject private var dashboardViewModel: DashboardViewModel

    @Environment(\.scenePhase) private var scenePhase

    init() {
        let storeManager = StoreManager()
        _dashboardViewModel = StateObject(wrappedValue: DashboardViewModel(storeManager: storeManager))
    }

    var body: some Scene {
        WindowGroup {
            SplashScreen()
                .environmentObject(manager)
                .environmentObject(dashboardViewModel)
                .environment(\.managedObjectContext, manager.container.viewContext)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                        setupHydrationNotifications()
                    }
                }
        }
        .onChange(of: scenePhase) { oldPhase, newPhase in
            if newPhase == .background || newPhase == .inactive {
                dashboardViewModel.handleDateDifference()
//                dashboardViewModel.saveDailyIntake()
            }
        }
    }
}
