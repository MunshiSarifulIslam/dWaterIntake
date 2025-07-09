//
//  SettingsView.swift
//  dWaterIntake
//
//  Created by Munshi Sariful Islam on 12/06/25.
//

import SwiftUI

struct SettingsView: View {
    @State var isDarkModeEnabled: Bool = true
    @State var downloadViaWifiEnabled: Bool = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Profile")) {
                    VStack {
                        Image(systemName: "person.circle")
                            .resizable()
                            .frame(width:100, height: 100, alignment: .center)
                            .foregroundStyle(Color.secondary)
                        Text("Munshi Sariful")
                            .font(.title)
                            .fontWeight(.semibold)
                        Text("www.apple.com")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .padding(.bottom)
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
                        
                    }
                    .frame(maxWidth: .infinity)
                }
                
                Section(header: Text("CONTENT"), content: {
                    HStack{
                        Image(systemName: "star")
                        Text("Favorites")
                    }
                    
                    HStack{
                        Image(systemName: "arrowshape.down")
                        Text("Downloads")
                    }
                    
                })
                
                Section(header: Text("PREFRENCES"), content: {
                    HStack{
                        Image(systemName: "globe")
                        Text("Language")
                    }
                    HStack{
                        Image(systemName: "moon")
                        Toggle(isOn: $isDarkModeEnabled) {
                            Text("Dark Mode")
                        }
                    }
                    HStack{
                        Image(systemName: "wifi")
                        Toggle(isOn: $downloadViaWifiEnabled) {
                            Text("Only Download via Wi-Fi")
                        }
                    }
                    HStack{
                        Image(systemName: "iphone.gen1.badge.play")
                        Text("Play in Background")
                    }
                    
                })
            }
            .navigationBarTitle("Settings")
        }
    }
}

#Preview {
    SettingsView()
}
