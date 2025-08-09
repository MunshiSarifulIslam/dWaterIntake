//
//  PrimaryButtonStyle.swift
//  dWaterIntake
//
//  Created by Munshi Sariful Islam on 09/08/25.
//

import SwiftUI

struct PrimaryButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
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
    }
}

extension View {
    func PrimaryButtonStyle() -> some View {
        self.modifier(PrimaryButtonModifier())
    }
}

#Preview {
    Text("Test Button")
        .PrimaryButtonStyle()
}
