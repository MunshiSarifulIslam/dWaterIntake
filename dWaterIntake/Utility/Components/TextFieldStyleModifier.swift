//
//  TextFieldStyleModifier.swift
//  dWaterIntake
//
//  Created by Munshi Sariful Islam on 10/06/25.
//

import SwiftUI

struct TextFieldStyleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color(hex: "#00FFFF").opacity(0.15))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(hex: "#00FFFF").opacity(0.5), lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.25), radius: 10, x: 0, y: 5)
    }
}
extension View {
    func customTextFieldStyle() -> some View {
        self.modifier(TextFieldStyleModifier())
    }
}

#Preview {
        TextField("Enter text", text: .constant(""))
            .modifier(TextFieldStyleModifier())
}
