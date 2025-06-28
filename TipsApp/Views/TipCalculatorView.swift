//
//  TipCalculatorView.swift
//  TipsApp
//
//  Created by Anand Upadhyay on 28/06/25.
//

import SwiftUI
import SwiftData

struct TipCalculatorView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var billAmount: String = ""
    @State private var selectedTipPercentage: Double = 15.0
    @State private var numberOfPeople: Int = 1
    @State private var selectedPaymentMethod: PaymentMethod = .creditCard
    @State private var selectedExperience: Experience = .good
    @State private var selectedCurrency: Currency = .usd
    @State private var customTipAmount: String = ""
    @State private var notes: String = ""
    @State private var showingQRScanner = false
    @State private var showingHistory = false
    @State private var showingSuccessAlert = false
    @State private var showingCurrencyPicker = false
    
    private let tipPercentages = [10.0, 12.0, 15.0, 18.0, 20.0, 25.0]
    private let quickTipAmounts = [5.0, 10.0, 20.0]
    
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
                    // Header
                    headerSection
                    
                    // Currency Selection
                    currencySection
                    
                    // Bill Amount Input
                    billAmountSection
                    
                    // Tip Percentage Selection
                    tipPercentageSection
                    
                    // Quick Tip Options
                    quickTipSection
                    
                    // Experience-based Tips
                    experienceSection
                    
                    // Number of People
                    numberOfPeopleSection
                    
                    // Payment Method
                    paymentMethodSection
                    
                    // Results
                    resultsSection
                    
                    // Notes
                    notesSection
                    
                    // Action Buttons
                    actionButtonsSection
                }
                .padding()
            }
            .navigationTitle("tip_calculator".localized)
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingHistory = true }) {
                        Image(systemName: "clock.arrow.circlepath")
                    }
                }
            }
            .sheet(isPresented: $showingHistory) {
                TipHistoryView()
            }
            .sheet(isPresented: $showingQRScanner) {
                QRScannerView()
            }
            .sheet(isPresented: $showingCurrencyPicker) {
                CurrencyPickerView(selectedCurrency: $selectedCurrency)
            }
            .overlay(
                // Custom Success Alert
                Group {
                    if showingSuccessAlert {
                        Color.black.opacity(0.3)
                            .ignoresSafeArea()
                            .onTapGesture {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    showingSuccessAlert = false
                                }
                            }
                        
                        VStack(spacing: 20) {
                            // Success Icon
                            ZStack {
                                Circle()
                                    .fill(Color.green)
                                    .frame(width: 80, height: 80)
                                
                                Image(systemName: "checkmark")
                                    .font(.system(size: 40, weight: .bold))
                                    .foregroundColor(.white)
                            }
                            .scaleEffect(showingSuccessAlert ? 1.0 : 0.5)
                            .animation(.spring(response: 0.6, dampingFraction: 0.8), value: showingSuccessAlert)
                            
                            // Success Message
                            VStack(spacing: 8) {
                                Text("tip_saved".localized)
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.primary)
                                
                                Text("tip_saved_message".localized)
                                    .font(.body)
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal)
                            }
                            
                            // Action Buttons
                            HStack(spacing: 12) {
                                Button(action: {
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        showingSuccessAlert = false
                                        showingHistory = true
                                    }
                                }) {
                                    Text("view_history".localized)
                                        .font(.headline)
                                        .foregroundColor(.blue)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(Color.blue, lineWidth: 2)
                                        )
                                }
                                
                                Button(action: {
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        showingSuccessAlert = false
                                    }
                                }) {
                                    Text("new_tip".localized)
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(
                                            RoundedRectangle(cornerRadius: 10)
                                                .fill(Color.blue)
                                        )
                                }
                            }
                            .padding(.horizontal)
                        }
                        .padding(30)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color(.systemBackground))
                                .shadow(color: .black.opacity(0.2), radius: 20, x: 0, y: 10)
                        )
                        .padding(.horizontal, 40)
                        .scaleEffect(showingSuccessAlert ? 1.0 : 0.8)
                        .opacity(showingSuccessAlert ? 1.0 : 0.0)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: showingSuccessAlert)
                    }
                }
            )
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 8) {
            Image(systemName: "calculator")
                .font(.system(size: 40))
                .foregroundColor(.blue)
            
            Text("smart_tip_calculator".localized)
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("calculate_tips_description".localized)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
    }
    
    private var currencySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("currency".localized)
                .font(.headline)
            
            Button(action: { showingCurrencyPicker = true }) {
                HStack {
                    Text(selectedCurrency.symbol)
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text(selectedCurrency.name)
                        .font(.body)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.gray.opacity(0.1))
                )
            }
            .foregroundColor(.primary)
        }
    }
    
    private var billAmountSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("bill_amount".localized)
                .font(.headline)
            
            HStack {
                Text(selectedCurrency.symbol)
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
                        Text("\(Int(percentage))%")
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
    
    private var quickTipSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("quick_tip_options".localized)
                .font(.headline)
            
            HStack(spacing: 12) {
                ForEach(quickTipAmounts, id: \.self) { amount in
                    Button(action: {
                        customTipAmount = String(amount)
                    }) {
                        VStack {
                            Text("\(selectedCurrency.symbol)\(Int(amount))")
                                .font(.headline)
                                .foregroundColor(.white)
                            Text("Quick")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.8))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.green)
                        )
                    }
                }
            }
            
            HStack {
                Text("custom_amount".localized + ":")
                    .font(.subheadline)
                
                TextField("enter_amount".localized, text: $customTipAmount)
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
    }
    
    private var experienceSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("service_experience".localized)
                .font(.headline)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                ForEach(Experience.allCases, id: \.self) { experience in
                    Button(action: {
                        selectedExperience = experience
                        selectedTipPercentage = experience.tipPercentage
                        customTipAmount = ""
                    }) {
                        HStack {
                            Image(systemName: experience.icon)
                                .foregroundColor(experience.color)
                            
                            VStack(alignment: .leading) {
                                Text(experience.rawValue.localized)
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                Text("\(Int(experience.tipPercentage))%")
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
                ForEach(PaymentMethod.allCases, id: \.self) { method in
                    Button(action: {
                        selectedPaymentMethod = method
                        if method == .qrCode {
                            showingQRScanner = true
                        }
                    }) {
                        VStack(spacing: 8) {
                            Image(systemName: method.icon)
                                .font(.title2)
                                .foregroundColor(selectedPaymentMethod == method ? .blue : .primary)
                            
                            Text(method.rawValue.localized)
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
    
    private var resultsSection: some View {
        VStack(spacing: 16) {
            Text("calculation_results".localized)
                .font(.headline)
            
            VStack(spacing: 12) {
                ResultRow(title: "bill_amount".localized, value: "\(selectedCurrency.symbol)\(String(format: "%.2f", Double(billAmount) ?? 0))")
                ResultRow(title: "tip_amount".localized, value: "\(selectedCurrency.symbol)\(String(format: "%.2f", calculatedTip))")
                ResultRow(title: "total_amount".localized, value: "\(selectedCurrency.symbol)\(String(format: "%.2f", calculatedTotal))")
                
                if numberOfPeople > 1 {
                    Divider()
                    ResultRow(title: "per_person".localized, value: "\(selectedCurrency.symbol)\(String(format: "%.2f", amountPerPerson))")
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
    
    private var actionButtonsSection: some View {
        VStack(spacing: 12) {
            Button(action: saveCalculation) {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                    Text("add_tip".localized)
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
            .disabled(billAmount.isEmpty || Double(billAmount) == 0)
            
            Button(action: resetForm) {
                HStack {
                    Image(systemName: "arrow.clockwise")
                    Text("reset".localized)
                }
                .font(.subheadline)
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.gray.opacity(0.1))
                )
            }
        }
    }
    
    private func saveCalculation() {
        guard let bill = Double(billAmount), bill > 0 else { return }
        
        let calculation = TipCalculation(
            billAmount: bill,
            tipPercentage: selectedTipPercentage,
            numberOfPeople: numberOfPeople,
            paymentMethod: selectedPaymentMethod,
            experience: selectedExperience,
            currency: selectedCurrency,
            customTipAmount: Double(customTipAmount),
            notes: notes.isEmpty ? nil : notes
        )
        
        modelContext.insert(calculation)
        
        // Reset form and show success alert
        withAnimation {
            resetForm()
            showingSuccessAlert = true
        }
    }
    
    private func resetForm() {
        billAmount = ""
        selectedTipPercentage = 15.0
        numberOfPeople = 1
        selectedPaymentMethod = .creditCard
        selectedExperience = .good
        selectedCurrency = .usd
        customTipAmount = ""
        notes = ""
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct ResultRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .fontWeight(.semibold)
        }
    }
}

#Preview {
    TipCalculatorView()
        .modelContainer(for: TipCalculation.self, inMemory: true)
} 