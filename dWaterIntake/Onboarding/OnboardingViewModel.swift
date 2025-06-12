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
        // Empty check
        guard !onboardingModel.name.isEmpty,
              !onboardingModel.weight.isEmpty,
              !onboardingModel.height.isEmpty,
              !onboardingModel.age.isEmpty,
              !onboardingModel.gender.isEmpty else {
            errorMessage = ErrorWrapper(message: "All fields are required")
            return false
        }
        
        // Name validation – only letters and spaces
        let nameRegex = "^[A-Za-z ]+$"
        if !NSPredicate(format: "SELF MATCHES %@", nameRegex).evaluate(with: onboardingModel.name) {
            errorMessage = ErrorWrapper(message: "Name should contain only letters and spaces.")
            return false
        }
        
        // Numeric fields validation
        if Double(onboardingModel.weight) == nil {
            errorMessage = ErrorWrapper(message: "Weight must be a valid number.")
            return false
        }
        
        if Double(onboardingModel.height) == nil {
            errorMessage = ErrorWrapper(message: "Height must be a valid number.")
            return false
        }
        
        if Int(onboardingModel.age) == nil {
            errorMessage = ErrorWrapper(message: "Age must be a valid number.")
            return false
        }
        
        // Optional: Gender validation (basic)
        let genderRegex = "^(?i)(male|female)$" // Allows: male, Female.
        if !NSPredicate(format: "SELF MATCHES %@", genderRegex).evaluate(with: onboardingModel.gender) {
            errorMessage = ErrorWrapper(message: "Gender must be Male, Female, or Other.")
            return false
        }
        
        errorMessage = nil
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
