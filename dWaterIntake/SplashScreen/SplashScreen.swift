//
//  SplashScreen.swift
//  dWaterIntake
//
//  Created by Munshi Sariful Islam on 31/05/25.
//

import SwiftUI

struct SplashScreen: View {
    @State private var fontSize: CGFloat = 20
    @State private var moveToLeading = false
    @State private var navigateToLogin = false
    
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    
    var body: some View {
        if navigateToLogin {
            if isLoggedIn {
                TabBarView()
            } else {
                OnboardingView()
            }
        } else {
            ZStack {
                LinearGradient(colors: [Color.cyan.opacity(0.7), Color.cyan.opacity(0.2), Color.cyan.opacity(0.3)], startPoint: .topLeading, endPoint: .bottomTrailing)
                
                GeometryReader { geometry in
                    VStack {
                        Text("dWater")
                            .font(.system(size: fontSize))
                            .fontWeight(.heavy)
                            .foregroundStyle(Color.cyan)
                            .position(x: moveToLeading ? -150 : geometry.size.width / 2, y: geometry.size.height / 2)
                            .onAppear {
                                withAnimation(.easeInOut(duration: 1.5)) {
                                    fontSize = 80
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                        withAnimation {
                                            moveToLeading = true
                                        }
                                    }
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                                    withAnimation {
                                        navigateToLogin = true
                                    }
                                }
                            }
                    }
                }
            }
            .ignoresSafeArea()
//            .onAppear {
//                // Just call the function directly
//                if let data = loadHydrationData() {
//                    print("✅ Loaded hydration data successfully")
//                    print(data) // You can inspect the model here
//                } else {
//                    print("❌ Failed to load hydration data")
//                }
//            }
        }
    }
}

#Preview {
    SplashScreen()
}
