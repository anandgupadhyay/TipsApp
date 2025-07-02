//
//  QRScannerView.swift
//  Tips App
//
//  Created by Anand Upadhyay on 28/06/25.
//

import SwiftUI
import AVFoundation

struct QRScannerView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var scannerViewModel = QRScannerViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                // Camera view
                QRCodeScannerRepresentable(scannedCode: $scannerViewModel.scannedCode)
                    .ignoresSafeArea()
                
                // Overlay
                VStack {
                    Spacer()
                    
                    // Scanning frame
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white, lineWidth: 3)
                        .frame(width: 250, height: 250)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.blue, lineWidth: 1)
                                .frame(width: 250, height: 250)
                        )
                    
                    Spacer()
                    
                    // Instructions
                    VStack(spacing: 16) {
                        Text("Scan QR Code for Payment")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                        
                        Text("Position the QR code within the frame")
                            .font(.body)
                            .foregroundColor(.white.opacity(0.8))
                            .multilineTextAlignment(.center)
                        
                        if let scannedCode = scannerViewModel.scannedCode {
                            VStack(spacing: 8) {
                                Text("Scanned Code:")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                
                                Text(scannedCode)
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.8))
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Color.black.opacity(0.5))
                                    )
                            }
                        }
                        
                        HStack(spacing: 20) {
                            Button("Cancel") {
                                dismiss()
                            }
                            .foregroundColor(.white)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.red)
                            )
                            
                            if scannerViewModel.scannedCode != nil {
                                Button("Process Payment") {
                                    processPayment()
                                }
                                .foregroundColor(.white)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.green)
                                )
                            }
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.black.opacity(0.7))
                    )
                    .padding()
                }
            }
            .navigationTitle("QR Scanner")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarHidden(true)
        }
        .onAppear {
            scannerViewModel.requestCameraPermission()
        }
    }
    
    private func processPayment() {
        // Here you would integrate with payment processing APIs
        // For now, we'll just show a success message and dismiss
        dismiss()
    }
}

class QRScannerViewModel: ObservableObject {
    @Published var scannedCode: String?
    @Published var cameraPermissionGranted = false
    
    func requestCameraPermission() {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            DispatchQueue.main.async {
                self.cameraPermissionGranted = granted
            }
        }
    }
}

struct QRCodeScannerRepresentable: UIViewRepresentable {
    @Binding var scannedCode: String?
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.black
        
        // This is a simplified implementation
        // In a real app, you would implement AVCaptureSession for QR code scanning
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        // Update view if needed
    }
}

#Preview {
    QRScannerView()
} 