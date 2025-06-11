//
//  OnboardingViewModel.swift
//  dWaterIntake
//
//  Created by Munshi Sariful Islam on 10/06/25.
//

import Foundation
import CoreData
import SwiftUI

struct ErrorWrapper: Identifiable {
    let id = UUID()
    let message: String
}

class OnboardingViewModel: ObservableObject {
    @Published var onboardingModel = OnboardingModel(name: "", weight: "", height: "", age: "", gender: "")
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    @Published var errorMessage: ErrorWrapper?
    let manager = HydrationDataManager()
    
    func validateFields() -> Bool {
        guard !onboardingModel.name.isEmpty,
              !onboardingModel.weight.isEmpty,
              !onboardingModel.height.isEmpty,
              !onboardingModel.age.isEmpty,
              !onboardingModel.gender.isEmpty
        else {
            DispatchQueue.main.async {
                self.errorMessage = ErrorWrapper(message: "All fields are required")
            }
            return false
        }
        DispatchQueue.main.async {
            self.errorMessage = nil
        }
        return true
    }

    func saveUserData(context: NSManagedObjectContext) {
        guard validateFields() else { return }

        let saveData = StoreDetails(context: context)

        saveData.name = onboardingModel.name
        saveData.weight = onboardingModel.weight
        saveData.height = onboardingModel.height
        saveData.gender = onboardingModel.gender
        if let waterRate = manager.getNormalWaterIntake(height: Double(onboardingModel.height) ?? 0, weight: Double(onboardingModel.weight) ?? 0, gender: onboardingModel.gender) {
            saveData.waterConsumttion = String(waterRate)
        }
        
        do {
            try context.save()
            print("User details saved to CoreData")
            printCoreDataPath()
            clearFields()
            DispatchQueue.main.async {
                self.isLoggedIn = true
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = ErrorWrapper(message: "Failed to save user details: \(error.localizedDescription)")
            }
            print("Failed to save user details: \(error)")
        }
    }

    func clearFields() {
        onboardingModel = OnboardingModel(name: "", weight: "", height: "", age: "", gender: "")
    }

    private func printCoreDataPath() {
        if let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last {
            print("Core Data Path: \(url.path)")
        }
    }
}
