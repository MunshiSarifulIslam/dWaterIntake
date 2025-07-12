//
//  OnboardingView.swift
//  dWaterIntake
//
//  Created by Munshi Sariful Islam on 10/06/25.
//

import SwiftUI

struct OnboardingView: View {
    
    @StateObject private var viewModel = OnboardingViewModel()
    @Environment(\.managedObjectContext) private var viewContext
    @State private var showConfirmationDialog = false
    let manager = HydrationDataManager()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Spacer()
           CustomTitleView(title: "Enter Your Name", isMendatory: true)
            TextField("", text: $viewModel.onboardingModel.name)
                .customTextFieldStyle()
            
            CustomTitleView(title: "Enter Your Weight", isMendatory: true)
            TextField("", text: $viewModel.onboardingModel.weight)
                .customTextFieldStyle()
            
            CustomTitleView(title: "Enter Your Height", isMendatory: true)
            TextField("", text: $viewModel.onboardingModel.height)
                .customTextFieldStyle()
            
            CustomTitleView(title: "Enter Your Age", isMendatory: true)
            TextField("", text: $viewModel.onboardingModel.age)
                .customTextFieldStyle()
            
            HStack(spacing: 16) {
                CustomTitleView(title: "Chose Your gender", isMendatory: true)
                Spacer()
                Picker("Gender", selection: $viewModel.onboardingModel.gender) {
                    Text("Male").tag("Male")
                    Text("Female").tag("Female")
                }

            }
            .padding(.top, 16)
            if viewModel.onboardingModel.gender == "Female" {
                HStack {
                    CustomTitleView(title: "Special Condition", isMendatory: false)
                    Spacer()
                    Picker("Condition", selection: $viewModel.onboardingModel.femaleCondition) {
                            Text("None").tag("None")
                            Text("Pregnant").tag("Pregnant")
                            Text("Breastfeeding").tag("Breastfeeding")
                        }
                }
            }
            Button {
                if viewModel.validateFields() {
                    showConfirmationDialog = true
                }
            } label: {
                HStack {
                    Spacer()
                    Text("Let's Calculate")
                        .foregroundStyle(LinearGradient(colors: [Color(hex: "#00FFFF"), Color(hex: "##7831F3")], startPoint: .leading, endPoint: .trailing))
                        .fontWeight(.bold)
                        .padding()
                        .padding(.horizontal, 50)
                        .background(LinearGradient(colors: [Color(hex: "#00FFFF").opacity(0.1), Color(hex: "#00FFFF").opacity(0.5)], startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color(hex: "#00FFFF").opacity(0.5), lineWidth: 1)
                        )
                        .shadow(color: Color.black.opacity(0.25), radius: 10, x: 0, y: 5)
                    Spacer()
                }
                
            }
            .alert("Save Details", isPresented: $showConfirmationDialog) {
                Button(action: {
                    viewModel.clearFields()
                }, label: {
                    Text("Cancel")
                        .font(.title)
                        .fontWeight(.bold)
                })
                Button(action: {
                    viewModel.saveUserData(context: viewContext)
                }, label: {
                    Text("OK")
                        .font(.title)
                        .fontWeight(.bold)
                })
            } message: {
                Text("Are you want to save all details ?")
            }
            .padding(.top, 32)
            Spacer()
            
        }
        .foregroundStyle(Color.black)
        .padding(16)
    }
}

#Preview {
    OnboardingView()
}
