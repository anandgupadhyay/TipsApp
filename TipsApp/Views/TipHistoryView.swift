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
    
    enum FilterOption: String, CaseIterable {
        case all = "All"
        case today = "Today"
        case thisWeek = "This Week"
        case thisMonth = "This Month"
    }
    
    var filteredCalculations: [TipCalculation] {
        let filtered = calculations.filter { calculation in
            if searchText.isEmpty { return true }
            return calculation.notes?.localizedCaseInsensitiveContains(searchText) ?? false ||
                   String(format: "%.2f", calculation.billAmount).contains(searchText)
        }
        
        switch selectedFilter {
        case .all:
            return filtered
        case .today:
            return filtered.filter { Calendar.current.isDateInToday($0.timestamp) }
        case .thisWeek:
            return filtered.filter { Calendar.current.isDate($0.timestamp, equalTo: Date(), toGranularity: .weekOfYear) }
        case .thisMonth:
            return filtered.filter { Calendar.current.isDate($0.timestamp, equalTo: Date(), toGranularity: .month) }
        }
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
                }
            }
            .navigationTitle("Tip History")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: exportData) {
                        Image(systemName: "square.and.arrow.up")
                    }
                }
            }
        }
    }
    
    private var searchAndFilterSection: some View {
        VStack(spacing: 12) {
            // Search Bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                
                TextField("Search calculations...", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            
            // Filter Picker
            Picker("Filter", selection: $selectedFilter) {
                ForEach(FilterOption.allCases, id: \.self) { option in
                    Text(option.rawValue).tag(option)
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
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "clock.arrow.circlepath")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("No Calculations Found")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Your tip calculations will appear here once you save them.")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Button(action: { dismiss() }) {
                Text("Start Calculating")
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
    
    private func exportData() {
        // Implementation for exporting data
        // This could export to CSV, PDF, or share via other apps
    }
}

struct TipCalculationRowView: View {
    let calculation: TipCalculation
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading) {
                    Text("$\(String(format: "%.2f", calculation.billAmount))")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text(calculation.timestamp, style: .date)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("$\(String(format: "%.2f", calculation.totalAmount))")
                        .font(.headline)
                        .foregroundColor(.blue)
                    
                    Text("\(Int(calculation.tipPercentage))% tip")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            HStack {
                Label("\(calculation.numberOfPeople) person\(calculation.numberOfPeople > 1 ? "s" : "")", systemImage: "person.2")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Label(calculation.paymentMethod.rawValue, systemImage: calculation.paymentMethod.icon)
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