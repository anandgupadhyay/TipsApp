//
//  ShareTipCalculationView.swift
//  TipsApp
//
//  Created by Anand Upadhyay on 28/06/25.
//

import SwiftUI

struct ShareTipCalculationView: View {
    let calculation: TipCalculation
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Share preview
                    sharePreviewSection
                    
                    // Share options
                    shareOptionsSection
                    
                    // Export options
                    exportOptionsSection
                }
                .padding()
            }
            .navigationTitle("Share Calculation")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private var sharePreviewSection: some View {
        VStack(spacing: 16) {
            Text("Share Preview")
                .font(.headline)
            
            VStack(spacing: 12) {
                HStack {
                    Text("Bill Amount")
                        .foregroundColor(.secondary)
                    Spacer()
                    Text("$\(String(format: "%.2f", calculation.billAmount))")
                        .fontWeight(.semibold)
                }
                
                HStack {
                    Text("Tip Amount")
                        .foregroundColor(.secondary)
                    Spacer()
                    Text("$\(String(format: "%.2f", calculation.tipAmount))")
                        .fontWeight(.semibold)
                        .foregroundColor(.green)
                }
                
                Divider()
                
                HStack {
                    Text("Total Amount")
                        .fontWeight(.semibold)
                    Spacer()
                    Text("$\(String(format: "%.2f", calculation.totalAmount))")
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                }
                
                if calculation.numberOfPeople > 1 {
                    HStack {
                        Text("Per Person")
                        .foregroundColor(.secondary)
                        Spacer()
                        Text("$\(String(format: "%.2f", calculation.amountPerPerson))")
                            .fontWeight(.semibold)
                            .foregroundColor(.orange)
                    }
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.1))
            )
        }
    }
    
    private var shareOptionsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Share Options")
                .font(.headline)
            
            VStack(spacing: 12) {
                ShareOptionRow(
                    title: "Copy to Clipboard",
                    subtitle: "Copy calculation details",
                    icon: "doc.on.clipboard",
                    color: .blue
                ) {
                    copyToClipboard()
                }
                
                ShareOptionRow(
                    title: "Share via Message",
                    subtitle: "Send via Messages app",
                    icon: "message",
                    color: .green
                ) {
                    shareViaMessage()
                }
                
                ShareOptionRow(
                    title: "Share via Email",
                    subtitle: "Send via Mail app",
                    icon: "envelope",
                    color: .orange
                ) {
                    shareViaEmail()
                }
                
                ShareOptionRow(
                    title: "Share via Social Media",
                    subtitle: "Share on social platforms",
                    icon: "square.and.arrow.up",
                    color: .purple
                ) {
                    shareViaSocialMedia()
                }
            }
        }
    }
    
    private var exportOptionsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Export Options")
                .font(.headline)
            
            VStack(spacing: 12) {
                ShareOptionRow(
                    title: "Export as PDF",
                    subtitle: "Create a PDF document",
                    icon: "doc.text",
                    color: .red
                ) {
                    exportAsPDF()
                }
                
                ShareOptionRow(
                    title: "Export as CSV",
                    subtitle: "Create a CSV file",
                    icon: "tablecells",
                    color: .green
                ) {
                    exportAsCSV()
                }
                
                ShareOptionRow(
                    title: "Save to Files",
                    subtitle: "Save to Files app",
                    icon: "folder",
                    color: .blue
                ) {
                    saveToFiles()
                }
            }
        }
    }
    
    private func copyToClipboard() {
        let shareText = generateShareText()
        UIPasteboard.general.string = shareText
        
        // Show success feedback
        // In a real app, you might want to show a toast or alert
    }
    
    private func shareViaMessage() {
        let shareText = generateShareText()
        let activityVC = UIActivityViewController(
            activityItems: [shareText],
            applicationActivities: nil
        )
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController?.present(activityVC, animated: true)
        }
    }
    
    private func shareViaEmail() {
        let shareText = generateShareText()
        let subject = "Tip Calculation - $\(String(format: "%.2f", calculation.totalAmount))"
        
        if let url = URL(string: "mailto:?subject=\(subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")&body=\(shareText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")") {
            UIApplication.shared.open(url)
        }
    }
    
    private func shareViaSocialMedia() {
        let shareText = generateShareText()
        let activityVC = UIActivityViewController(
            activityItems: [shareText],
            applicationActivities: nil
        )
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController?.present(activityVC, animated: true)
        }
    }
    
    private func exportAsPDF() {
        // Implementation for PDF export
        // This would create a PDF document with the calculation details
    }
    
    private func exportAsCSV() {
        // Implementation for CSV export
        // This would create a CSV file with the calculation details
    }
    
    private func saveToFiles() {
        // Implementation for saving to Files app
        // This would save the calculation data to the Files app
    }
    
    private func generateShareText() -> String {
        var text = "💳 Tip Calculation\n\n"
        text += "Bill Amount: $\(String(format: "%.2f", calculation.billAmount))\n"
        text += "Tip Amount: $\(String(format: "%.2f", calculation.tipAmount)) (\(Int(calculation.tipPercentage))%)\n"
        text += "Total Amount: $\(String(format: "%.2f", calculation.totalAmount))\n"
        
        if calculation.numberOfPeople > 1 {
            text += "Per Person: $\(String(format: "%.2f", calculation.amountPerPerson))\n"
        }
        
        text += "Payment Method: \(calculation.paymentMethod.rawValue)\n"
        text += "Service Experience: \(calculation.experience.rawValue)\n"
        
        if let notes = calculation.notes, !notes.isEmpty {
            text += "Notes: \(notes)\n"
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        
        text += "\nCalculated on \(dateFormatter.string(from: calculation.timestamp))"
        text += "\n\nGenerated by TipsApp"
        
        return text
    }
}

struct ShareOptionRow: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                    .font(.title2)
                    .frame(width: 30)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
                    .font(.caption)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.gray.opacity(0.1))
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    ShareTipCalculationView(calculation: TipCalculation(
        billAmount: 50.0,
        tipPercentage: 15.0,
        numberOfPeople: 2,
        paymentMethod: .creditCard,
        experience: .good,
        notes: "Great service!"
    ))
} 