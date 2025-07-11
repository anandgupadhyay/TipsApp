//
//  EditTipCalculationView.swift
//  Tips App
//
//  Created by Anand Upadhyay on 28/06/25.
//

import SwiftUI
import SwiftData

struct EditTipCalculationView: View {
    let calculation: TipCalculation
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var billAmount: String
    @State private var selectedTipPercentage: Double
    @State private var numberOfPeople: Int
    @State private var selectedPaymentMethod: PaymentMethod
    @State private var selectedExperience: Experience
    @State private var selectedCurrency: Currency
    @State private var customTipAmount: String
    @State private var notes: String
    
    private let tipPercentages = [10.0, 12.0, 15.0, 18.0, 20.0, 25.0]
    
    init(calculation: TipCalculation) {
        self.calculation = calculation
        _billAmount = State(initialValue: String(format: "%.2f", calculation.billAmount))
        _selectedTipPercentage = State(initialValue: calculation.tipPercentage)
        _numberOfPeople = State(initialValue: calculation.numberOfPeople)
        _selectedPaymentMethod = State(initialValue: calculation.paymentMethod)
        _selectedExperience = State(initialValue: calculation.experience)
        _selectedCurrency = State(initialValue: calculation.effectiveCurrency)
        _customTipAmount = State(initialValue: calculation.customTipAmount.map { String(format: "%.2f", $0) } ?? "")
        _notes = State(initialValue: calculation.notes ?? "")
    }
    
    private var calculatedTip: Double {
        if !customTipAmount.isEmpty, let customAmount = Double(customTipAmount) {
            return customAmount
        }
        guard let bill = Double(billAmount) else { return 0 }
        return bill * (selectedTipPercentage / 100.0)
    }
    
    private var calculatedTotal: Double {
        guard let bill = Double(billAmount) else { return 0 }
        return bill + calculatedTip
    }
    
    private var amountPerPerson: Double {
        return calculatedTotal / Double(numberOfPeople)
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Bill Amount Input
                    billAmountSection
                    
                    // Tip Percentage Selection
                    tipPercentageSection
                    
                    // Experience-based Tips
                    experienceSection
                    
                    // Number of People
                    numberOfPeopleSection
                    
                    // Payment Method
                    paymentMethodSection
                    
                    // Custom Tip Amount
                    customTipSection
                    
                    // Results Preview
                    resultsPreviewSection
                    
                    // Notes
                    notesSection
                }
                .padding()
            }
            .navigationTitle("edit_calculation".localized)
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("cancel".localized) {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("update_tip".localized) {
                        saveChanges()
                    }
                    .disabled(billAmount.isEmpty || Double(billAmount) == 0)
                }
            }
        }
    }
    
    private var billAmountSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("bill_amount".localized)
                .font(.headline)
            
            HStack {
                Text("currency_symbol".localized)
                    .font(.title2)
                    .foregroundColor(.secondary)
                
                TextField("0.00", text: $billAmount)
                    .font(.title)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .toolbar {
                                            ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        Button("done".localized) {
                            hideKeyboard()
                        }
                    }
                    }
            }
        }
    }
    
    private var tipPercentageSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("tip_percentage".localized)
                .font(.headline)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 12) {
                ForEach(tipPercentages, id: \.self) { percentage in
                    Button(action: {
                        selectedTipPercentage = percentage
                        customTipAmount = ""
                    }) {
                        Text("\(Int(percentage))\("percentage_symbol".localized)")
                            .font(.headline)
                            .foregroundColor(selectedTipPercentage == percentage ? .white : .primary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(selectedTipPercentage == percentage ? Color.blue : Color.gray.opacity(0.2))
                            )
                    }
                }
            }
        }
    }
    
    private var experienceSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("service_experience".localized)
                .font(.headline)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                ForEach(Experience.displayCases, id: \.self) { experience in
                    Button(action: {
                        selectedExperience = experience
                        selectedTipPercentage = experience.tipPercentage
                        customTipAmount = ""
                    }) {
                        HStack {
                            Image(systemName: experience.icon)
                                .foregroundColor(experience.color)
                            
                            VStack(alignment: .leading) {
                                Text(experience.rawValue)
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                Text("\(Int(experience.tipPercentage))\("percentage_symbol".localized)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(selectedExperience == experience ? Color.blue.opacity(0.1) : Color.gray.opacity(0.1))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(selectedExperience == experience ? Color.blue : Color.clear, lineWidth: 2)
                                )
                        )
                    }
                    .foregroundColor(.primary)
                }
            }
        }
    }
    
    private var numberOfPeopleSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("number_of_people".localized)
                .font(.headline)
            
            HStack {
                Button(action: {
                    if numberOfPeople > 1 {
                        numberOfPeople -= 1
                    }
                }) {
                    Image(systemName: "minus.circle.fill")
                        .font(.title2)
                        .foregroundColor(.red)
                }
                
                Spacer()
                
                Text("\(numberOfPeople)")
                    .font(.title)
                    .fontWeight(.bold)
                    .frame(minWidth: 60)
                
                Spacer()
                
                Button(action: {
                    numberOfPeople += 1
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundColor(.green)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.gray.opacity(0.1))
            )
        }
    }
    
    private var paymentMethodSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("payment_method".localized)
                .font(.headline)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 12) {
                ForEach(PaymentMethod.displayCases, id: \.self) { method in
                    Button(action: {
                        selectedPaymentMethod = method
                    }) {
                        VStack(spacing: 8) {
                            Image(systemName: method.icon)
                                .font(.title2)
                                .foregroundColor(selectedPaymentMethod == method ? .blue : .primary)
                            
                            Text(method.rawValue)
                                .font(.caption)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(selectedPaymentMethod == method ? Color.blue.opacity(0.1) : Color.gray.opacity(0.1))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(selectedPaymentMethod == method ? Color.blue : Color.clear, lineWidth: 2)
                                )
                        )
                    }
                    .foregroundColor(.primary)
                }
            }
        }
    }
    
    private var customTipSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("custom_tip_amount_optional".localized)
                .font(.headline)
            
            TextField("enter_custom_amount".localized, text: $customTipAmount)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.decimalPad)
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        Button("done".localized) {
                            hideKeyboard()
                        }
                    }
                }
        }
    }
    
    private var resultsPreviewSection: some View {
        VStack(spacing: 16) {
            Text("updated_results".localized)
                .font(.headline)
            
            VStack(spacing: 12) {
                ResultRow(title: "bill_amount_result".localized, value: "$\(String(format: "%.2f", Double(billAmount) ?? 0))")
                ResultRow(title: "tip_amount_result".localized, value: "$\(String(format: "%.2f", calculatedTip))")
                ResultRow(title: "total_amount_result".localized, value: "$\(String(format: "%.2f", calculatedTotal))")
                
                if numberOfPeople > 1 {
                    Divider()
                    ResultRow(title: "per_person_result".localized, value: "$\(String(format: "%.2f", amountPerPerson))")
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.blue.opacity(0.1))
            )
        }
    }
    
    private var notesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("notes_optional".localized)
                .font(.headline)
            
            TextField("add_notes_placeholder".localized, text: $notes, axis: .vertical)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .lineLimit(3...6)
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        Button("done".localized) {
                            hideKeyboard()
                        }
                    }
                }
        }
    }
    
    private func saveChanges() {
        guard let bill = Double(billAmount), bill > 0 else { return }
        
        // Update the existing calculation
        calculation.billAmount = bill
        calculation.tipPercentage = selectedTipPercentage
        calculation.numberOfPeople = numberOfPeople
        calculation.paymentMethod = selectedPaymentMethod
        calculation.experience = selectedExperience
        calculation.currency = selectedCurrency
        calculation.customTipAmount = Double(customTipAmount)
        calculation.notes = notes.isEmpty ? nil : notes
        
        // Note: tipAmount, totalAmount, and amountPerPerson are now computed properties
        // so they will automatically update when the stored properties change
        
        dismiss()
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    EditTipCalculationView(calculation: TipCalculation(
        billAmount: 50.0,
        tipPercentage: 15.0,
        numberOfPeople: 2,
        paymentMethod: .creditCard,
        experience: .good,
        currency: .usd,
        notes: "Great service!"
    ))
    .modelContainer(for: TipCalculation.self, inMemory: true)
} 
