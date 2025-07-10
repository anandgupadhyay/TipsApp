//
//  TipCalculation.swift
//  Tips App
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
    var currency: Currency?
    
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
    
    // Computed property to get currency with default
    var effectiveCurrency: Currency {
        return currency ?? .usd
    }
    
    init(billAmount: Double, tipPercentage: Double, numberOfPeople: Int, paymentMethod: PaymentMethod, experience: Experience, currency: Currency? = nil, customTipAmount: Double? = nil, notes: String? = nil) {
        self.id = UUID()
        self.billAmount = billAmount
        self.tipPercentage = tipPercentage
        self.numberOfPeople = numberOfPeople
        self.paymentMethod = paymentMethod
        self.experience = experience
        self.currency = currency ?? .usd
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
        case .usd: return "us_dollar".localized
        case .eur: return "euro".localized
        case .gbp: return "british_pound".localized
        case .inr: return "indian_rupee".localized
        case .pkr: return "pakistani_rupee".localized
        case .kes: return "kenyan_shilling".localized
        case .cad: return "canadian_dollar".localized
        case .aud: return "australian_dollar".localized
        }
    }
}

enum PaymentMethod: String, CaseIterable, Codable {
    // Old values for migration
    case cashOld = "Cash"
    case creditCardOld = "Credit Card"
    case debitCardOld = "Debit Card"
    case qrCodeOld = "QR Code"
    case digitalWalletOld = "Digital Wallet"
    // New values
    case cash = "cash"
    case creditCard = "credit_card"
    case debitCard = "debit_card"
    case qrCode = "qr_code"
    case digitalWallet = "digital_wallet"
    
    var icon: String {
        switch self {
        case .cash, .cashOld: return "banknote"
        case .creditCard, .creditCardOld: return "creditcard"
        case .debitCard, .debitCardOld: return "creditcard.fill"
        case .qrCode, .qrCodeOld: return "qrcode"
        case .digitalWallet, .digitalWalletOld: return "iphone"
        }
    }
    // Migration helper
    var migrated: PaymentMethod {
        switch self {
        case .cashOld: return .cash
        case .creditCardOld: return .creditCard
        case .debitCardOld: return .debitCard
        case .qrCodeOld: return .qrCode
        case .digitalWalletOld: return .digitalWallet
        default: return self
        }
    }
    
    static var displayCases: [PaymentMethod] {
        return [.cash, .creditCard, .debitCard, .qrCode, .digitalWallet]
    }
}

enum Experience: String, CaseIterable, Codable {
    // Old values for migration
    case excellentOld = "Excellent"
    case goodOld = "Good"
    case averageOld = "Average"
    case poorOld = "Poor"
    // New values
    case excellent = "excellent"
    case good = "good"
    case average = "average"
    case poor = "poor"

    var tipPercentage: Double {
        switch self {
        case .excellent, .excellentOld: return 20.0
        case .good, .goodOld: return 15.0
        case .average, .averageOld: return 10.0
        case .poor, .poorOld: return 5.0
        }
    }

    var color: Color {
        switch self {
        case .excellent, .excellentOld: return .green
        case .good, .goodOld: return .blue
        case .average, .averageOld: return .orange
        case .poor, .poorOld: return .red
        }
    }

    var icon: String {
        switch self {
        case .excellent, .excellentOld: return "star.fill"
        case .good, .goodOld: return "star"
        case .average, .averageOld: return "star.leadinghalf.filled"
        case .poor, .poorOld: return "star.slash"
        }
    }

    // Migration helper
    var migrated: Experience {
        switch self {
        case .excellentOld: return .excellent
        case .goodOld: return .good
        case .averageOld: return .average
        case .poorOld: return .poor
        default: return self
        }
    }
    
    static var displayCases: [Experience] {
        return [.excellent, .good, .average, .poor]
    }
} 