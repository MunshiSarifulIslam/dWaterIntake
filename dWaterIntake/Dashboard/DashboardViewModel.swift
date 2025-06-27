//
//  DashboardViewModel.swift
//  dWaterIntake
//
//  Created by Munshi Sariful Islam on 14/06/25.
//

import Foundation
import SwiftUI
import CoreData

class DashboardViewModel: ObservableObject {
    @Published var incrementValue: Int = 0 {
        didSet {
            UserDefaults.standard.set(incrementValue, forKey: "currentIncrementValue")
        }
    }

    @Published var waterML: Double = 0
    @AppStorage("isLoggedIn") private var isLoggedIn = false

    private let storeManager: StoreManager
    private var context: NSManagedObjectContext
    private var lastSavedDate: Date
    private var timer: Timer?

    init(storeManager: StoreManager) {
        self.storeManager = storeManager
        self.context = storeManager.container.viewContext

        let today = Calendar.current.startOfDay(for: Date())
//        let today = Calendar.current.startOfDay(for: Calendar.current.date(byAdding: .day, value: 1, to: Date())!)

        if let savedDate = UserDefaults.standard.object(forKey: "lastSavedDate") as? Date {
            lastSavedDate = Calendar.current.startOfDay(for: savedDate)
        } else {
            lastSavedDate = today
            UserDefaults.standard.set(today, forKey: "lastSavedDate")
        }

        if isLoggedIn {
            if Calendar.current.isDate(lastSavedDate, inSameDayAs: today) {
                self.incrementValue = UserDefaults.standard.integer(forKey: "currentIncrementValue")
            } else {
                handleDateDifference()
                self.incrementValue = 0
                UserDefaults.standard.set(0, forKey: "currentIncrementValue")
            }
        }

        fetchUserDetails()
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

    func handleDateDifference() {
        let currentDate = Calendar.current.startOfDay(for: Date())
//        let currentDate = Calendar.current.startOfDay(for: Calendar.current.date(byAdding: .day, value: 1, to: Date())!)
        guard !Calendar.current.isDate(currentDate, inSameDayAs: lastSavedDate) else {
            return
        }

        let components = Calendar.current.dateComponents([.day], from: lastSavedDate, to: currentDate)
        guard let dayDifference = components.day else { return }

        let valueToSave = UserDefaults.standard.integer(forKey: "currentIncrementValue")

        if dayDifference == 1 {
            saveDailyIntake(for: lastSavedDate, amount: valueToSave)
        } else if dayDifference > 1 {
            saveDailyIntake(for: lastSavedDate, amount: valueToSave)
            for i in 1..<dayDifference {
                if let missingDate = Calendar.current.date(byAdding: .day, value: i, to: lastSavedDate) {
                    saveDailyIntake(for: missingDate, amount: 0)
                }
            }
        }

        incrementValue = 0
        UserDefaults.standard.set(0, forKey: "currentIncrementValue")
        UserDefaults.standard.set(currentDate, forKey: "lastSavedDate")
        lastSavedDate = currentDate
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
            } else {
                print("Entry already exists for \(date), skipping save.")
            }
        } catch {
            print("Error saving daily intake: \(error)")
        }
    }

    func startDailyCheckTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] _ in
            self?.handleDateDifference()
        }
    }
}

