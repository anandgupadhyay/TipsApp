//
//  SplashScreenView.swift
//  Tips App
//
//  Created by Anand Upadhyay on 28/06/25.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false
    @State private var iconScale: CGFloat = 0.8
    @State private var textOpacity: Double = 0
    @State private var iconRotation: Double = 0
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.purple.opacity(0.6)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
             
            VStack(spacing: 30) {
                // App Icon
                Image("Icon-App-60x60@2x.png")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
                    .scaleEffect(iconScale)
                    .rotationEffect(.degrees(iconRotation))
                    .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                
                // App Name
                VStack(spacing: 8) {
                    Text("app_name".localized)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("Smart Tip Calculator")
                        .font(.title3)
                        .foregroundColor(.white.opacity(0.9))
                }
                .opacity(textOpacity)
                
                // Loading indicator
//                if !isActive {
//                    ProgressView()
//                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
//                        .scaleEffect(1.2)
//                        .opacity(textOpacity)
//                }
            }
        }
        .onAppear {
            startAnimation()
        }
        .fullScreenCover(isPresented: $isActive) {
            ContentView()
        }
    }
    
    private func startAnimation() {
        // Animate icon scale and rotation
        withAnimation(.easeOut(duration: 1.0)) {
            iconScale = 1.0
            iconRotation = 360
        }
        
        // Animate text opacity
        withAnimation(.easeIn(duration: 0.8).delay(0.3)) {
            textOpacity = 1.0
        }
        
        // Navigate to main app after delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            withAnimation(.easeInOut(duration: 0.5)) {
                isActive = true
            }
        }
    }
}

#Preview {
    SplashScreenView()
} 
