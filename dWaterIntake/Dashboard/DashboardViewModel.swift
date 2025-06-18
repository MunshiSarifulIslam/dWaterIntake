//
//  DashboardViewModel.swift
//  dWaterIntake
//
//  Created by Munshi Sariful Islam on 14/06/25.
//

import Foundation
import CoreData
import SwiftUI

class DashboardViewModel: ObservableObject {
    @Published var incrementValue: Int = 0 {
        didSet {
            UserDefaults.standard.set(incrementValue, forKey: "currentIncrementValue")
        }
    }

    @Published var waterML: Double = 0

    private let storeManager: StoreManager
    private var context: NSManagedObjectContext
    private var timer: Timer?

    init(storeManager: StoreManager) {
        self.storeManager = storeManager
        self.context = storeManager.container.viewContext

        // Load saved intake if same day
        let today = Calendar.current.startOfDay(for: Date())
        let lastSaved = UserDefaults.standard.object(forKey: "lastSavedDate") as? Date ?? .distantPast
        if Calendar.current.isDate(lastSaved, inSameDayAs: today) {
            self.incrementValue = UserDefaults.standard.integer(forKey: "currentIncrementValue")
        }

        fetchUserDetails()
        checkAndResetIfNewDay()
        startDailyCheckTimer()
    }
    deinit {
        timer?.invalidate()
    }

    func fetchUserDetails() {
        storeManager.fetchUserDetails()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let data = self.storeManager.storeDetails?.waterConsumttion ?? "0"
            self.waterML = self.calculateLitersToML(data: data)
        }
    }

    func calculateLitersToML(data: String) -> Double {
        (Double(data) ?? 0) * 1000
    }

    func increaseIntake(by amount: Int = 200) {
        incrementValue += amount
    }

    func checkAndResetIfNewDay() {
        let lastSaved = UserDefaults.standard.object(forKey: "lastSavedDate") as? Date ?? .distantPast
        let today = Calendar.current.startOfDay(for: Date())

        if !Calendar.current.isDate(lastSaved, inSameDayAs: today) {
            let saveDate = Calendar.current.date(byAdding: .day, value: -1, to: today) ?? today
            saveDailyIntake(for: saveDate, amount: incrementValue)

            incrementValue = 0
            UserDefaults.standard.set(0, forKey: "currentIncrementValue")
            UserDefaults.standard.set(today, forKey: "lastSavedDate")
        }
    }

    func saveDailyIntake(for date: Date, amount: Int) {
        let fetchRequest: NSFetchRequest<WaterLog> = WaterLog.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "date == %@", date as NSDate)

        do {
            let existing = try context.fetch(fetchRequest)
            if existing.isEmpty {
                let log = WaterLog(context: context)
                log.date = date
                log.intakeAmount = Int64(amount)
                try context.save()
                print("Saved \(amount)ml for \(date)")
            }
        } catch {
            print("Error saving daily intake: \(error)")
        }
    }

    func saveDailyIntake() {
        let today = Calendar.current.startOfDay(for: Date())
        saveDailyIntake(for: today, amount: incrementValue)
    }

    func startDailyCheckTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] _ in
            self?.checkAndResetIfNewDay()
        }
    }
}
