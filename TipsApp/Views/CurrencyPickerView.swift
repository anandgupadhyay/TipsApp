//
//  CurrencyPickerView.swift
//  TipsApp
//
//  Created by Anand Upadhyay on 28/06/25.
//

import SwiftUI

struct CurrencyPickerView: View {
    @Binding var selectedCurrency: Currency
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            List {
                ForEach(Currency.allCases, id: \.self) { currency in
                    Button(action: {
                        selectedCurrency = currency
                        dismiss()
                    }) {
                        HStack {
                            Text(currency.symbol)
                                .font(.title2)
                                .fontWeight(.semibold)
                                .frame(width: 40, alignment: .leading)
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text(currency.name)
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                
                                Text(currency.rawValue)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            if selectedCurrency == currency {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                                    .font(.title3)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .navigationTitle("select_currency".localized)
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
}

#Preview {
    CurrencyPickerView(selectedCurrency: .constant(.usd))
} 