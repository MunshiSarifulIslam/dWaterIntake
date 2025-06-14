//
//  WaterGlassView.swift
//  dWaterIntake
//
//  Created by Munshi Sariful Islam on 14/06/25.
//

import SwiftUI

struct WaterGlassShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height
        
        path.move(to: CGPoint(x: width * 0.2, y: 0))
        
        path.addCurve(to: CGPoint(x: width * 0.1, y: height),
                      control1: CGPoint(x: width * 0.35, y: height * 0.3),
                      control2: CGPoint(x: width * 0.05, y: height * 0.7))
        
        path.addArc(center: CGPoint(x: width / 2, y: height),
                    radius: width * 0.4,
                    startAngle: .degrees(0),
                    endAngle: .degrees(0),
                    clockwise: true)
        
        path.addCurve(to: CGPoint(x: width * 0.8, y: 0),
                      control1: CGPoint(x: width * 0.95, y: height * 0.7),
                      control2: CGPoint(x: width * 0.65, y: height * 0.3))
        
        path.closeSubpath()
        return path
    }
}

struct WaveShape: Shape {
    var waveHeight: CGFloat
    var phase: CGFloat
    var progress: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height
        let yOffset = height * (1 - progress)
        
        path.move(to: CGPoint(x: 0, y: yOffset))
        
        for x in stride(from: 0, through: width, by: 1) {
            let angle = (x / width + phase) * .pi * 2
            let y = waveHeight * sin(angle) + yOffset
            path.addLine(to: CGPoint(x: x, y: y))
        }
        
        path.addLine(to: CGPoint(x: width, y: height))
        path.addLine(to: CGPoint(x: 0, y: height))
        path.closeSubpath()
        
        return path
    }
    
    var animatableData: CGFloat {
        get { phase }
        set { phase = newValue }
    }
}

struct WaterGlassView: View {
    var currentIntake: CGFloat
    var dailyGoal: CGFloat
    @State private var wavePhase: CGFloat = 0
    var fillPercentage: CGFloat {
        guard dailyGoal > 0 else { return 0 }
        return min(currentIntake / dailyGoal, 1.0)
    }
    
    let timer = Timer.publish(every: 0.02, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            ZStack {
                WaterGlassShape()
                    .fill(.ultraThinMaterial)
                    .frame(width: 150, height: 200)
                    .shadow(radius: 5)
                
                ZStack {
                    WaveShape(waveHeight: 8, phase: wavePhase, progress: fillPercentage)
                        .fill(Color.blue.opacity(0.4))
                    WaveShape(waveHeight: 5, phase: wavePhase + 0.5, progress: fillPercentage)
                        .fill(Color.blue.opacity(0.6))
                }
                .frame(width: 150, height: 200)
                .mask(WaterGlassShape())
            }
        }
        .onReceive(timer) { _ in
            wavePhase += 0.01
        }
    }
}

#Preview {
    WaterGlassView(currentIntake: 800, dailyGoal: 4000)
}
