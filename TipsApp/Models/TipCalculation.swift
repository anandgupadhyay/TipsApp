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
    
    init(billAmount: Double, tipPercentage: Double, numberOfPeople: Int, paymentMethod: PaymentMethod, experience: Experience, customTipAmount: Double? = nil, notes: String? = nil) {
        self.id = UUID()
        self.billAmount = billAmount
        self.tipPercentage = tipPercentage
        self.numberOfPeople = numberOfPeople
        self.paymentMethod = paymentMethod
        self.experience = experience
        self.customTipAmount = customTipAmount
        self.notes = notes
        self.timestamp = Date()
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