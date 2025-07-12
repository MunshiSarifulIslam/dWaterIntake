//
//  CustomTitleView.swift
//  dWaterIntake
//
//  Created by Munshi Sariful Islam on 11/07/25.
//

import SwiftUI

struct CustomTitleView: View {
    var title: String
    var isMendatory: Bool
    var body: some View {
        HStack(spacing: 2) {
            Text(title)
                .fontWeight(.semibold)
                .lineLimit(1)
            if isMendatory {
                Text("✶")
                    .foregroundStyle(Color.red)
                    .offset(x: 0, y: -5)
            } else {
                Text("(Optional)")
                    .fontWeight(.semibold)
            }
        }
    }
}

#Preview {
    CustomTitleView(title: "Name", isMendatory: true)
}
