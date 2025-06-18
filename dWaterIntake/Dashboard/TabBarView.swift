//
//  TabBarView.swift
//  dWaterIntake
//
//  Created by Munshi Sariful Islam on 12/06/25.
//

import SwiftUI

enum Tab {
    case home, history, settings
}

struct TabBarView: View {
    @State private var selectedTab: Tab = .home
    @StateObject private var storeManager = StoreManager()
    @StateObject private var dashboardVM: DashboardViewModel

    init() {
        let manager = StoreManager()
        _storeManager = StateObject(wrappedValue: manager)
        _dashboardVM = StateObject(wrappedValue: DashboardViewModel(storeManager: manager))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            ZStack {
                switch selectedTab {
                case .home:
                    DashboardView(viewModel: dashboardVM)
                case .history:
                    HistoryView(context: storeManager.container.viewContext)
                case .settings:
                    SettingsView()
                }
            }
            Spacer()
            CustomTabBar(selectedTab: $selectedTab)
        }
        .ignoresSafeArea(edges: .bottom)
    }
}


#Preview {
    TabBarView()
}

struct CustomTabBar: View {
    @Binding var selectedTab: Tab
    
    var body: some View {
        HStack {
            tabButton(tab: .home, icon: "house.fill", label: "Home")
            tabButton(tab: .history, icon: "clock.arrow.circlepath", label: "History")
            tabButton(tab: .settings, icon: "gearshape", label: "Settings")
        }
        .padding(.vertical, 8)
        .background(Color(.systemBackground)
        .shadow(radius: 2))
    }
    
    private func tabButton(tab: Tab, icon: String, label: String) -> some View {
        Button(action: {
            selectedTab = tab
        }) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 26, height: 26)
                Text(label)
                    .font(.system(size: 16, weight: selectedTab == tab ? .bold : .regular))
            }
            .foregroundColor(selectedTab == tab ? Color(hex: "#00FFFF") : .gray)
            .frame(maxWidth: .infinity)
        }
    }
}
