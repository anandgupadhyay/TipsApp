//
//  TipCalculation.swift
//  TipsApp
//
//  Created by Anand Upadhyay on 28/06/25.
//

import Foundation
import SwiftData
import SwiftUI

@Model
final class TipCalculation {
    var id: UUID
    var billAmount: Double
    var tipPercentage: Double
    var numberOfPeople: Int
    var paymentMethod: PaymentMethod
    var experience: Experience
    var customTipAmount: Double?
    var timestamp: Date
    var notes: String?
    var currency: Currency
    
    // Computed properties instead of stored properties
    var tipAmount: Double {
        if let customTip = customTipAmount {
            return customTip
        }
        return billAmount * (tipPercentage / 100.0)
    }
    
    var totalAmount: Double {
        return billAmount + tipAmount
    }
    
    var amountPerPerson: Double {
        return totalAmount / Double(numberOfPeople)
    }
    
    init(billAmount: Double, tipPercentage: Double, numberOfPeople: Int, paymentMethod: PaymentMethod, experience: Experience, currency: Currency, customTipAmount: Double? = nil, notes: String? = nil) {
        self.id = UUID()
        self.billAmount = billAmount
        self.tipPercentage = tipPercentage
        self.numberOfPeople = numberOfPeople
        self.paymentMethod = paymentMethod
        self.experience = experience
        self.currency = currency
        self.customTipAmount = customTipAmount
        self.notes = notes
        self.timestamp = Date()
    }
}

enum Currency: String, CaseIterable, Codable {
    case usd = "USD"
    case eur = "EUR"
    case gbp = "GBP"
    case inr = "INR"
    case pkr = "PKR"
    case kes = "KES"
    case cad = "CAD"
    case aud = "AUD"
    
    var symbol: String {
        switch self {
        case .usd: return "$"
        case .eur: return "€"
        case .gbp: return "£"
        case .inr: return "₹"
        case .pkr: return "₨"
        case .kes: return "KSh"
        case .cad: return "C$"
        case .aud: return "A$"
        }
    }
    
    var name: String {
        switch self {
        case .usd: return "US Dollar"
        case .eur: return "Euro"
        case .gbp: return "British Pound"
        case .inr: return "Indian Rupee"
        case .pkr: return "Pakistani Rupee"
        case .kes: return "Kenyan Shilling"
        case .cad: return "Canadian Dollar"
        case .aud: return "Australian Dollar"
        }
    }
}

enum PaymentMethod: String, CaseIterable, Codable {
    case cash = "Cash"
    case creditCard = "Credit Card"
    case debitCard = "Debit Card"
    case qrCode = "QR Code"
    case digitalWallet = "Digital Wallet"
    
    var icon: String {
        switch self {
        case .cash: return "banknote"
        case .creditCard: return "creditcard"
        case .debitCard: return "creditcard.fill"
        case .qrCode: return "qrcode"
        case .digitalWallet: return "iphone"
        }
    }
}

enum Experience: String, CaseIterable, Codable {
    case excellent = "Excellent"
    case good = "Good"
    case average = "Average"
    case poor = "Poor"
    
    var tipPercentage: Double {
        switch self {
        case .excellent: return 20.0
        case .good: return 15.0
        case .average: return 10.0
        case .poor: return 5.0
        }
    }
    
    var color: Color {
        switch self {
        case .excellent: return .green
        case .good: return .blue
        case .average: return .orange
        case .poor: return .red
        }
    }
    
    var icon: String {
        switch self {
        case .excellent: return "star.fill"
        case .good: return "star"
        case .average: return "star.leadinghalf.filled"
        case .poor: return "star.slash"
        }
    }
} 