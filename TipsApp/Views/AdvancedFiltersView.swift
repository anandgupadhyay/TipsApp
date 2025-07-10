//
//  AdvancedFiltersView.swift
//  Tips App
//
//  Created by Anand Upadhyay on 28/06/25.
//

import SwiftUI

struct AdvancedFiltersView: View {
    @Binding var selectedCurrencyFilter: Currency?
    @Binding var selectedTipAmountFilter: TipHistoryView.TipAmountFilter
    @Binding var selectedExperienceFilter: Experience?
    @Binding var selectedPaymentMethodFilter: PaymentMethod?
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                // Currency Filter
                Section(header: Text("filter_by_currency".localized)) {
                    Picker("Currency", selection: $selectedCurrencyFilter) {
                        Text("all_currencies".localized).tag(nil as Currency?)
                        ForEach(Currency.allCases, id: \.self) { currency in
                            HStack {
                                Text(currency.symbol)
                                Text(currency.name)
                            }.tag(currency as Currency?)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
                
                // Tip Amount Filter
                Section(header: Text("filter_by_tip_amount".localized)) {
                    Picker("Tip Amount", selection: $selectedTipAmountFilter) {
                        ForEach(TipHistoryView.TipAmountFilter.allCases, id: \.self) { filter in
                            Text(filter.rawValue.localized).tag(filter)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                // Experience Filter
                Section(header: Text("filter_by_experience".localized)) {
                    Picker("Experience", selection: $selectedExperienceFilter) {
                        Text("all_experiences".localized).tag(nil as Experience?)
                        ForEach(Experience.displayCases, id: \.self) { experience in
                            HStack {
                                Image(systemName: experience.icon)
                                    .foregroundColor(experience.color)
                                Text(experience.rawValue.localized)
                            }.tag(experience as Experience?)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
                
                // Payment Method Filter
                Section(header: Text("filter_by_payment_method".localized)) {
                    Picker("Payment Method", selection: $selectedPaymentMethodFilter) {
                        Text("all_payment_methods".localized).tag(nil as PaymentMethod?)
                        ForEach(PaymentMethod.displayCases, id: \.self) { method in
                            HStack {
                                Image(systemName: method.icon)
                                Text(method.rawValue.localized)
                            }.tag(method as PaymentMethod?)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
                
                // Clear Filters
                Section {
                    Button(action: clearAllFilters) {
                        HStack {
                            Image(systemName: "trash")
                            Text("clear_all_filters".localized)
                        }
                        .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("advanced_filters".localized)
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("cancel".localized) {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("done".localized) {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func clearAllFilters() {
        selectedCurrencyFilter = nil
        selectedTipAmountFilter = .all
        selectedExperienceFilter = nil
        selectedPaymentMethodFilter = nil
    }
}

#Preview {
    AdvancedFiltersView(
        selectedCurrencyFilter: .constant(nil),
        selectedTipAmountFilter: .constant(.all),
        selectedExperienceFilter: .constant(nil),
        selectedPaymentMethodFilter: .constant(nil)
    )
} 