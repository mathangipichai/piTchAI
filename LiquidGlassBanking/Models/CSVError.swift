//
//  CSVError.swift
//  LiquidGlassBanking
//
//  Created for CSV import/export error handling
//

import Foundation

/// Error types for CSV import/export operations
enum CSVError: LocalizedError {
    case emptyFile
    case invalidFormat(String)
    case invalidAmount(String)
    case invalidTransactionType(String)
    case invalidDate(String)
    case invalidCategory(String)
    case exportFailed(String)
    
    var errorDescription: String? {
        switch self {
        case .emptyFile:
            return "CSV file is empty or contains no data"
        case .invalidFormat(let message):
            return message
        case .invalidAmount(let message):
            return message
        case .invalidTransactionType(let message):
            return message
        case .invalidDate(let message):
            return message
        case .invalidCategory(let message):
            return message
        case .exportFailed(let message):
            return message
        }
    }
    
    var localizedDescription: String {
        errorDescription ?? "An unknown CSV error occurred"
    }
}
