//
//  DashboardView.swift
//  dWaterIntake
//
//  Created by Munshi Sariful Islam on 31/05/25.
//

import SwiftUI

struct DashboardView: View {
    @ObservedObject var viewModel: DashboardViewModel
    var body: some View {
        VStack(spacing: 16) {
            Text("Total Intake Water Needed")
                .font(.system(size: 24))
                .fontWeight(.bold)
                .foregroundColor(Color.black)
            if viewModel.waterML > 0 {
                Text("\(Int(viewModel.waterML)) ml")
                    .font(.system(size: 24))
                    .fontWeight(.bold)
                    .foregroundColor(Color.black)
            } else {
                Text("No user details found.")
                    .foregroundStyle(.gray)
            }
            HStack {
                Text("You Take water")
                    .font(.system(size: 24))
                    .fontWeight(.bold)
                    .foregroundColor(Color.black)
                Text("\(viewModel.incrementValue)")
                    .font(.system(size: 24))
                    .fontWeight(.bold)
                    .foregroundColor(Color.black)
            }
            .padding(.top, 20)
            WaterGlassView(
                currentIntake: CGFloat(viewModel.incrementValue),
                dailyGoal: CGFloat(viewModel.waterML)
            )
            Button {
                viewModel.increaseIntake()
            } label: {
                HStack {
                    Spacer()
                    Text("Water Intake")
                        .foregroundStyle(LinearGradient(colors: [Color(hex: "#00FFFF"), Color(hex: "#7831F3")], startPoint: .leading, endPoint: .trailing))
                        .fontWeight(.bold)
                        .padding()
                        .padding(.horizontal, 60)
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
            .padding(.top, 20)
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            viewModel.checkAndResetIfNewDay()
        }
    }
}

#Preview {
    let storeManager = StoreManager()
    let context = storeManager.container.viewContext

    let details = StoreDetails(context: context)
    details.name = "Preview User"
    details.waterConsumttion = "2.5"

    try? context.save()

    let viewModel = DashboardViewModel(storeManager: storeManager)
    viewModel.incrementValue = 600

    return DashboardView(viewModel: viewModel)
}
