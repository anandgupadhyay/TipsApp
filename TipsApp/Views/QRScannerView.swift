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

// Dedicated UIView subclass for camera preview
class CameraPreviewView: UIView {
    private var previewLayer: AVCaptureVideoPreviewLayer?

    func setSession(_ session: AVCaptureSession) {
        if let existingLayer = previewLayer {
            existingLayer.removeFromSuperlayer()
        }
        let layer = AVCaptureVideoPreviewLayer(session: session)
        layer.videoGravity = .resizeAspectFill
        self.layer.insertSublayer(layer, at: 0)
        self.previewLayer = layer
        setNeedsLayout()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        previewLayer?.frame = self.bounds
    }
}

struct QRCodeScannerRepresentable: UIViewRepresentable {
    @Binding var scannedCode: String?
    @Environment(\.presentationMode) var presentationMode

    class Coordinator: NSObject, AVCaptureMetadataOutputObjectsDelegate {
        var parent: QRCodeScannerRepresentable
        var session: AVCaptureSession?

        init(parent: QRCodeScannerRepresentable) {
            self.parent = parent
        }

        func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
            if let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
               metadataObject.type == .qr,
               let stringValue = metadataObject.stringValue {
                parent.scannedCode = stringValue
                session?.stopRunning()
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIView(context: Context) -> UIView {
        let view = CameraPreviewView()
        view.backgroundColor = UIColor.black

        let status = AVCaptureDevice.authorizationStatus(for: .video)
        print("[QRScanner] Camera permission status: \(status.rawValue)")
        if status == .denied || status == .restricted {
            let errorLabel = UILabel()
            errorLabel.text = "Camera permission denied. Please enable it in Settings."
            errorLabel.textColor = .white
            errorLabel.backgroundColor = UIColor.red.withAlphaComponent(0.7)
            errorLabel.textAlignment = .center
            errorLabel.frame = view.bounds
            errorLabel.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            view.addSubview(errorLabel)
            return view
        }

        let session = AVCaptureSession()
        context.coordinator.session = session

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            print("[QRScanner] Camera not available")
            showError(on: view, message: "Camera not available")
            return view
        }

        do {
            let videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
            if session.canAddInput(videoInput) {
                session.addInput(videoInput)
                print("[QRScanner] Camera input added")
            } else {
                print("[QRScanner] Cannot add camera input")
                showError(on: view, message: "Cannot add camera input")
                return view
            }
        } catch {
            print("[QRScanner] Camera input error: \(error.localizedDescription)")
            showError(on: view, message: "Camera input error: \(error.localizedDescription)")
            return view
        }

        let metadataOutput = AVCaptureMetadataOutput()
        if session.canAddOutput(metadataOutput) {
            session.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(context.coordinator, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
            print("[QRScanner] Metadata output added")
        } else {
            print("[QRScanner] Cannot add metadata output")
            showError(on: view, message: "Cannot add metadata output")
            return view
        }

        view.setSession(session)

        DispatchQueue.main.async {
            session.startRunning()
            print("[QRScanner] Session started: \(session.isRunning)")
            if !session.isRunning {
                self.showError(on: view, message: "Camera session failed to start")
            }
        }

        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        // No dynamic updates needed
    }

    private func showError(on view: UIView, message: String) {
        let errorLabel = UILabel()
        errorLabel.text = message
        errorLabel.textColor = .white
        errorLabel.backgroundColor = UIColor.red.withAlphaComponent(0.7)
        errorLabel.textAlignment = .center
        errorLabel.frame = view.bounds
        errorLabel.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(errorLabel)
    }
}

private var previewLayerObserverKey: UInt8 = 0

#Preview {
    QRScannerView()
} 