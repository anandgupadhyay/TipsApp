//
//  TipHistoryView.swift
//  TipsApp
//
//  Created by Anand Upadhyay on 28/06/25.
//

import SwiftUI
import SwiftData

struct TipHistoryView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query(sort: \TipCalculation.timestamp, order: .reverse) private var calculations: [TipCalculation]
    @State private var searchText = ""
    @State private var selectedFilter: FilterOption = .all
    @State private var selectedCurrencyFilter: Currency?
    @State private var selectedTipAmountFilter: TipAmountFilter = .all
    @State private var selectedExperienceFilter: Experience?
    @State private var selectedPaymentMethodFilter: PaymentMethod?
    @State private var showingAdvancedFilters = false
    
    enum FilterOption: String, CaseIterable {
        case all = "All"
        case today = "Today"
        case thisWeek = "This Week"
        case thisMonth = "This Month"
    }
    
    enum TipAmountFilter: String, CaseIterable {
        case all = "All"
        case low = "Low Tip (< 10%)"
        case medium = "Medium Tip (10-20%)"
        case high = "High Tip (> 20%)"
    }
    
    var filteredCalculations: [TipCalculation] {
        var filtered = calculations
        
        // Search filter
        if !searchText.isEmpty {
            filtered = filtered.filter { calculation in
                return calculation.notes?.localizedCaseInsensitiveContains(searchText) ?? false ||
                       String(format: "%.2f", calculation.billAmount).contains(searchText) ||
                       calculation.currency.rawValue.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        // Date filter
        switch selectedFilter {
        case .all:
            break
        case .today:
            filtered = filtered.filter { Calendar.current.isDateInToday($0.timestamp) }
        case .thisWeek:
            filtered = filtered.filter { Calendar.current.isDate($0.timestamp, equalTo: Date(), toGranularity: .weekOfYear) }
        case .thisMonth:
            filtered = filtered.filter { Calendar.current.isDate($0.timestamp, equalTo: Date(), toGranularity: .month) }
        }
        
        // Currency filter
        if let currencyFilter = selectedCurrencyFilter {
            filtered = filtered.filter { $0.currency == currencyFilter }
        }
        
        // Tip amount filter
        switch selectedTipAmountFilter {
        case .all:
            break
        case .low:
            filtered = filtered.filter { $0.tipPercentage < 10.0 }
        case .medium:
            filtered = filtered.filter { $0.tipPercentage >= 10.0 && $0.tipPercentage <= 20.0 }
        case .high:
            filtered = filtered.filter { $0.tipPercentage > 20.0 }
        }
        
        // Experience filter
        if let experienceFilter = selectedExperienceFilter {
            filtered = filtered.filter { $0.experience == experienceFilter }
        }
        
        // Payment method filter
        if let paymentMethodFilter = selectedPaymentMethodFilter {
            filtered = filtered.filter { $0.paymentMethod == paymentMethodFilter }
        }
        
        return filtered
    }
    
    var totalTipsPaid: Double {
        return filteredCalculations.reduce(0) { $0 + $1.tipAmount }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                // Search and Filter
                searchAndFilterSection
                
                if filteredCalculations.isEmpty {
                    emptyStateView
                } else {
                    calculationsList
                    
                    // Total Tips Paid
                    totalTipsSection
                }
            }
            .navigationTitle("tip_history".localized)
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("done".localized) {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAdvancedFilters.toggle() }) {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                    }
                }
            }
            .sheet(isPresented: $showingAdvancedFilters) {
                AdvancedFiltersView(
                    selectedCurrencyFilter: $selectedCurrencyFilter,
                    selectedTipAmountFilter: $selectedTipAmountFilter,
                    selectedExperienceFilter: $selectedExperienceFilter,
                    selectedPaymentMethodFilter: $selectedPaymentMethodFilter
                )
            }
        }
    }
    
    private var searchAndFilterSection: some View {
        VStack(spacing: 12) {
            // Search Bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                
                TextField("search_calculations".localized, text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            
            // Filter Picker
            Picker("Filter", selection: $selectedFilter) {
                ForEach(FilterOption.allCases, id: \.self) { option in
                    Text(option.rawValue.localized).tag(option)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
        }
        .padding(.horizontal)
    }
    
    private var calculationsList: some View {
        List {
            ForEach(filteredCalculations) { calculation in
                NavigationLink(destination: TipCalculationDetailView(calculation: calculation)) {
                    TipCalculationRowView(calculation: calculation)
                }
            }
            .onDelete(perform: deleteCalculations)
        }
    }
    
    private var totalTipsSection: some View {
        VStack(spacing: 8) {
            Divider()
            
            HStack {
                Text("total_tips_paid".localized)
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Text("$\(String(format: "%.2f", totalTipsPaid))")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.green)
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.green.opacity(0.1))
            )
            .padding(.horizontal)
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "clock.arrow.circlepath")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("no_calculations_found".localized)
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("calculations_history_description".localized)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Button(action: { dismiss() }) {
                Text("start_calculating".localized)
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.blue)
                    )
            }
        }
        .padding()
    }
    
    private func deleteCalculations(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(filteredCalculations[index])
            }
        }
    }
}

struct TipCalculationRowView: View {
    let calculation: TipCalculation
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading) {
                    Text("\(calculation.currency.symbol)\(String(format: "%.2f", calculation.billAmount))")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text(calculation.timestamp, style: .date)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("\(calculation.currency.symbol)\(String(format: "%.2f", calculation.totalAmount))")
                        .font(.headline)
                        .foregroundColor(.blue)
                    
                    Text("\(Int(calculation.tipPercentage))% tip")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            HStack {
                Label("\(calculation.numberOfPeople) \(calculation.numberOfPeople > 1 ? "persons".localized : "person".localized)", systemImage: "person.2")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Label(calculation.paymentMethod.rawValue.localized, systemImage: calculation.paymentMethod.icon)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            if let notes = calculation.notes, !notes.isEmpty {
                Text(notes)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    TipHistoryView()
        .modelContainer(for: TipCalculation.self, inMemory: true)
} 