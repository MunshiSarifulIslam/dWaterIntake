//
//  OnboardingTests.swift
//  dWaterIntakeTests
//
//  Created by Munshi Sariful Islam on 09/08/25.
//

import Testing
import CoreData
@testable import dWaterIntake

struct OnboardingTests {
    
    let viewModel = OnboardingViewModel()
    
    @Test func validateFields_AllFieldsEmpty_ShouldFail() {
        
        let result = viewModel.validateFields()
        
        #expect(result == false)
        #expect(viewModel.errorMessage?.message == "All fields are required")
    }

    @Test func validateFields_InvalidName_ShouldFail() {
        viewModel.onboardingModel = OnboardingModel(
            name: "John123", weight: "70", height: "170",
            age: "25", gender: "Male", femaleCondition: ""
        )
        
        let result = viewModel.validateFields()
        
        #expect(result == false)
        #expect(viewModel.errorMessage?.message == "Name should contain only letters and spaces.")
    }
    
    @Test func validateFields_InvalidHeight_ShouldFail() {
        viewModel.onboardingModel = OnboardingModel(
            name: "John", weight: "70", height: "abc",
            age: "25", gender: "Male", femaleCondition: ""
        )
        
        let result = viewModel.validateFields()
        
        #expect(result == false)
        #expect(viewModel.errorMessage?.message == "Height must be a valid number.")
    }
    
    @Test func validateFields_InvalidAge_ShouldFail() {
        viewModel.onboardingModel = OnboardingModel(
            name: "John", weight: "70", height: "170",
            age: "abc", gender: "Male", femaleCondition: ""
        )
        
        let result = viewModel.validateFields()
        
        #expect(result == false)
        #expect(viewModel.errorMessage?.message == "Age must be a valid number.")
    }
    
    @Test func validateFields_AllValid_ShouldPass() {
        viewModel.onboardingModel = OnboardingModel(
            name: "John", weight: "70", height: "170",
            age: "25", gender: "Male", femaleCondition: ""
        )
        
        let result = viewModel.validateFields()
        
        #expect(result == true)
        #expect(viewModel.errorMessage == nil)
    }
    
    @Test func testSaveUserData_ShouldStoreInCoreData() async throws {
        let context = makeInMemoryManagedObjectContext()
        
        viewModel.onboardingModel = OnboardingModel(
            name: "John",
            weight: "70",
            height: "170",
            age: "25",
            gender: "Male",
            femaleCondition: ""
        )
        viewModel.saveUserData(context: context)
        
        let fetchRequest: NSFetchRequest<StoreDetails> = StoreDetails.fetchRequest()
        let result = try context.fetch(fetchRequest)
        
        #expect(result.count == 1)
        #expect(result.first?.name == "John")
    }
}
