//
//  TipCalculationDetailView.swift
//  TipsApp
//
//  Created by Anand Upadhyay on 28/06/25.
//

import SwiftUI
import SwiftData

struct TipCalculationDetailView: View {
    let calculation: TipCalculation
    @Environment(\.dismiss) private var dismiss
    @State private var showingEditSheet = false
    @State private var showingShareSheet = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header with total amount
                headerSection
                
                // Calculation breakdown
                calculationBreakdownSection
                
                // Service details
                serviceDetailsSection
                
                // Payment information
                paymentInfoSection
                
                // Notes
                if let notes = calculation.notes, !notes.isEmpty {
                    notesSection(notes: notes)
                }
                
                // Action buttons
                actionButtonsSection
            }
            .padding()
        }
        .navigationTitle("Calculation Details")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showingShareSheet = true }) {
                    Image(systemName: "square.and.arrow.up")
                }
            }
        }
        .sheet(isPresented: $showingEditSheet) {
            EditTipCalculationView(calculation: calculation)
        }
        .sheet(isPresented: $showingShareSheet) {
            ShareTipCalculationView(calculation: calculation)
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 16) {
            Text("Total Amount")
                .font(.headline)
                .foregroundColor(.secondary)
            
            Text("$\(String(format: "%.2f", calculation.totalAmount))")
                .font(.system(size: 48, weight: .bold, design: .rounded))
                .foregroundColor(.blue)
            
            Text("Calculated on \(calculation.timestamp, style: .date) at \(calculation.timestamp, style: .time)")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.blue.opacity(0.1))
        )
    }
    
    private var calculationBreakdownSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Calculation Breakdown")
                .font(.headline)
            
            VStack(spacing: 12) {
                DetailRow(title: "Bill Amount", value: "$\(String(format: "%.2f", calculation.billAmount))", icon: "dollarsign.circle")
                
                DetailRow(title: "Tip Amount", value: "$\(String(format: "%.2f", calculation.tipAmount))", icon: "plus.circle")
                    .foregroundColor(.green)
                
                Divider()
                
                DetailRow(title: "Total Amount", value: "$\(String(format: "%.2f", calculation.totalAmount))", icon: "equal.circle")
                    .fontWeight(.semibold)
                
                if calculation.numberOfPeople > 1 {
                    DetailRow(title: "Per Person", value: "$\(String(format: "%.2f", calculation.amountPerPerson))", icon: "person.2.circle")
                        .foregroundColor(.orange)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.1))
            )
        }
    }
    
    private var serviceDetailsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Service Details")
                .font(.headline)
            
            VStack(spacing: 12) {
                HStack {
                    Image(systemName: calculation.experience.icon)
                        .foregroundColor(calculation.experience.color)
                        .font(.title2)
                    
                    VStack(alignment: .leading) {
                        Text("Service Experience")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text(calculation.experience.rawValue)
                            .font(.headline)
                    }
                    
                    Spacer()
                    
                    Text("\(Int(calculation.tipPercentage))%")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                }
                
                if let customTip = calculation.customTipAmount {
                    HStack {
                        Image(systemName: "star.circle")
                            .foregroundColor(.yellow)
                            .font(.title2)
                        
                        VStack(alignment: .leading) {
                            Text("Custom Tip Amount")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Text("$\(String(format: "%.2f", customTip))")
                                .font(.headline)
                        }
                        
                        Spacer()
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
    
    private var paymentInfoSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Payment Information")
                .font(.headline)
            
            VStack(spacing: 12) {
                HStack {
                    Image(systemName: calculation.paymentMethod.icon)
                        .foregroundColor(.blue)
                        .font(.title2)
                    
                    VStack(alignment: .leading) {
                        Text("Payment Method")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text(calculation.paymentMethod.rawValue)
                            .font(.headline)
                    }
                    
                    Spacer()
                }
                
                HStack {
                    Image(systemName: "person.2.circle")
                        .foregroundColor(.green)
                        .font(.title2)
                    
                    VStack(alignment: .leading) {
                        Text("Split Between")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text("\(calculation.numberOfPeople) person\(calculation.numberOfPeople > 1 ? "s" : "")")
                            .font(.headline)
                    }
                    
                    Spacer()
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.1))
            )
        }
    }
    
    private func notesSection(notes: String) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Notes")
                .font(.headline)
            
            Text(notes)
                .font(.body)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.yellow.opacity(0.1))
                )
        }
    }
    
    private var actionButtonsSection: some View {
        VStack(spacing: 12) {
            Button(action: { showingEditSheet = true }) {
                HStack {
                    Image(systemName: "pencil")
                    Text("Edit Calculation")
                }
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.blue)
                )
            }
            
            Button(action: { showingShareSheet = true }) {
                HStack {
                    Image(systemName: "square.and.arrow.up")
                    Text("Share")
                }
                .font(.headline)
                .foregroundColor(.blue)
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.blue, lineWidth: 2)
                )
            }
        }
    }
}

struct DetailRow: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 24)
            
            Text(title)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Text(value)
                .fontWeight(.semibold)
        }
    }
}

#Preview {
    NavigationView {
        TipCalculationDetailView(calculation: TipCalculation(
            billAmount: 50.0,
            tipPercentage: 15.0,
            numberOfPeople: 2,
            paymentMethod: .creditCard,
            experience: .good,
            notes: "Great service!"
        ))
    }
    .modelContainer(for: TipCalculation.self, inMemory: true)
} 