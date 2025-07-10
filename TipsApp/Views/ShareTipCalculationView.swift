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
            .navigationTitle("share_calculation_title".localized)
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("done".localized) {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private var sharePreviewSection: some View {
        VStack(spacing: 16) {
            Text("share_preview".localized)
                .font(.headline)
            
            VStack(spacing: 12) {
                HStack {
                    Text("bill_amount".localized)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text("\(calculation.effectiveCurrency.symbol)\(String(format: "%.2f", calculation.billAmount))")
                        .fontWeight(.semibold)
                }
                
                HStack {
                    Text("tip_amount".localized)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text("\(calculation.effectiveCurrency.symbol)\(String(format: "%.2f", calculation.tipAmount))")
                        .fontWeight(.semibold)
                        .foregroundColor(.green)
                }
                
                Divider()
                
                HStack {
                    Text("total_amount".localized)
                        .fontWeight(.semibold)
                    Spacer()
                    Text("\(calculation.effectiveCurrency.symbol)\(String(format: "%.2f", calculation.totalAmount))")
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                }
                
                if calculation.numberOfPeople > 1 {
                    HStack {
                        Text("per_person".localized)
                        .foregroundColor(.secondary)
                        Spacer()
                        Text("\(calculation.effectiveCurrency.symbol)\(String(format: "%.2f", calculation.amountPerPerson))")
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
            Text("share_options".localized)
                .font(.headline)
            
            VStack(spacing: 12) {
                ShareOptionRow(
                    title: "copy_to_clipboard".localized,
                    subtitle: "copy_calculation_details".localized,
                    icon: "doc.on.clipboard",
                    color: .blue
                ) {
                    copyToClipboard()
                }
                
                ShareOptionRow(
                    title: "share_via_message".localized,
                    subtitle: "send_via_messages_app".localized,
                    icon: "message",
                    color: .green
                ) {
                    shareViaMessage()
                }
                
                ShareOptionRow(
                    title: "share_via_email".localized,
                    subtitle: "send_via_mail_app".localized,
                    icon: "envelope",
                    color: .orange
                ) {
                    shareViaEmail()
                }
                
                ShareOptionRow(
                    title: "share_via_social_media".localized,
                    subtitle: "share_on_social_platforms".localized,
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
            Text("export_options".localized)
                .font(.headline)
            
            VStack(spacing: 12) {
                ShareOptionRow(
                    title: "export_as_pdf".localized,
                    subtitle: "create_pdf_document".localized,
                    icon: "doc.text",
                    color: .red
                ) {
                    exportAsPDF()
                }
                
                ShareOptionRow(
                    title: "export_as_csv".localized,
                    subtitle: "create_csv_file".localized,
                    icon: "tablecells",
                    color: .green
                ) {
                    exportAsCSV()
                }
                
                ShareOptionRow(
                    title: "save_to_files".localized,
                    subtitle: "save_to_files_app".localized,
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
        var text = "💳 \("tip_detail".localized)\n\n"
        text += "\("bill_amount".localized): \(calculation.effectiveCurrency.symbol)\(String(format: "%.2f", calculation.billAmount))\n"
        text += "\("tip_amount".localized): \(calculation.effectiveCurrency.symbol)\(String(format: "%.2f", calculation.tipAmount)) (\(Int(calculation.tipPercentage))%)\n"
        text += "\("total_amount".localized): \(calculation.effectiveCurrency.symbol)\(String(format: "%.2f", calculation.totalAmount))\n"
        
        if calculation.numberOfPeople > 1 {
            text += "\("per_person".localized): \(calculation.effectiveCurrency.symbol)\(String(format: "%.2f", calculation.amountPerPerson))\n"
        }
        
        text += "\("payment_method_label".localized): \(calculation.paymentMethod.rawValue.localized)\n"
        text += "\("service_experience_label".localized): \(calculation.experience.rawValue.localized)\n"
        
        if let notes = calculation.notes, !notes.isEmpty {
            text += "\("notes_optional".localized): \(notes)\n"
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        
        text += "\n\("tip_date".localized): \(dateFormatter.string(from: calculation.timestamp))"
        text += "\n\nGenerated by Tips App"
        
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
        currency: .usd,
        notes: "Great service!"
    ))
} 
