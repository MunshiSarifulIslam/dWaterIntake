//
//  SettingsView.swift
//  dWaterIntake
//
//  Created by Munshi Sariful Islam on 12/06/25.
//

import SwiftUI

struct SettingsView: View {
    @State var isDarkModeEnabled: Bool = false
    @AppStorage("notificationsEnabled") private var notificationsEnabled: Bool = true
    @State var userImage: Image? = nil
    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    Image(systemName: "person.circle")
                        .resizable()
                        .frame(width:100, height: 100, alignment: .center)
                        .foregroundStyle(Color.secondary)
                    Text("Munshi Sariful")
                        .font(.title)
                        .fontWeight(.semibold)
                    Button {
                        print("This button under development")
                    } label: {
                        Text("Edit profile")
                            .font(.system(size: 18))
                            .foregroundStyle(Color.white)
                            .padding(.horizontal, 80)
                            .padding(.vertical, 10)
                        
                    }
                    .background(Color.blue)
                    .cornerRadius(25)
                    .padding(.bottom)
                }
                Form {
                    Section(header: Text("Appearance")) {
                        Toggle("Dark Mode", isOn: $isDarkModeEnabled)
                    }
                    Section(header: Text("Controls")) {
                        Toggle("Hydration Reminders", isOn: $notificationsEnabled)
                            .onChange(of: notificationsEnabled) {
                                if notificationsEnabled {
                                    setupHydrationNotifications()
                                } else {
                                    cancelHydrationNotifications()
                                }
                            }
                    }
                }
            }
        }
    }
}

#Preview {
    SettingsView()
}
