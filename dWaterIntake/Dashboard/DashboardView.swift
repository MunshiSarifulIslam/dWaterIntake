//
//  DashboardView.swift
//  dWaterIntake
//
//  Created by Munshi Sariful Islam on 31/05/25.
//

import SwiftUI

struct DashboardView: View {
    @StateObject private var storeManager = StoreManager()
    @State private var incrementValue: Int = 0
    var body: some View {
        VStack(spacing: 16) {
            Text("Total Intake Water Needed")
                .font(.system(size: 24))
                .fontWeight(.bold)
                .foregroundColor(Color.black)
            if let user = storeManager.storeDetails?.waterConsumttion {
                Text("\(calculateLtoML(data: user)) ml")
                    .font(.system(size: 24))
                    .fontWeight(.bold)
                    .foregroundColor(Color.black)
            } else {
                Text("No user details found.")
                    .foregroundStyle(.gray)
            }
            Text("You Take water")
                .font(.system(size: 24))
                .fontWeight(.bold)
                .foregroundColor(Color.black)
                .padding(.top, 50)
            Text("\(incrementValue)")
                .font(.system(size: 24))
                .fontWeight(.bold)
                .foregroundColor(Color.black)
            
            Button {
                if let user = storeManager.storeDetails?.waterConsumttion {
                    if incrementValue >= Int(calculateLtoML(data: user)) ?? 0 {
                        incrementValue += 200
                    }
                }
            } label: {
                HStack {
                    Spacer()
                    Text("Let's Calculate")
                        .foregroundStyle(LinearGradient(colors: [Color(hex: "#00FFFF"), Color(hex: "##7831F3")], startPoint: .leading, endPoint: .trailing))
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
            .padding(.top, 90)
        }
        .padding()
        .onAppear {
            storeManager.fetchUserDetails()
        }
    }
    func calculateLtoML(data: String) -> String {
        let result = String(data).compactMap { Double(String($0)) }.reduce(0, +) * 1000
        return String(result)
    }
}

#Preview {
    DashboardView()
}
