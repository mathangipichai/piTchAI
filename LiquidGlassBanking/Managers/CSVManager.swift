import Foundation

// MARK: - CSV Manager
/// Handles import and export of transaction data to CSV format
final class CSVManager {
    
    // MARK: - CSV Export
    /// Export transactions to CSV format
    /// - Parameter transactions: Array of transactions to export
    /// - Returns: CSV string data
    static func exportTransactionsToCSV(_ transactions: [Transaction]) -> String {
        var csvContent = "ID,Title,Description,Amount,Type,Date,Category,Merchant\n"
        
        for transaction in transactions {
            let id = transaction.id
            let title = escapeCsvField(transaction.title)
            let description = escapeCsvField(transaction.description)
            let amount = String(format: "%.2f", transaction.amount)
            let type = transactionTypeToString(transaction.type)
            let date = formatDateForCSV(transaction.date)
            let category = transactionCategoryToString(transaction.category)
            let merchant = escapeCsvField(transaction.merchant)
            
            let row = "\(id),\(title),\(description),\(amount),\(type),\(date),\(category),\(merchant)"
            csvContent += row + "\n"
        }
        
        return csvContent
    }
    
    /// Export all data (account info + transactions) to CSV format
    /// - Parameters:
    ///   - account: Account information
    ///   - transactions: Array of transactions
    /// - Returns: CSV string data
    static func exportFullDataToCSV(account: Account, transactions: [Transaction]) -> String {
        var csvContent = ""
        
        // Account summary section
        csvContent += "ACCOUNT_SUMMARY\n"
        csvContent += "ID,Name,Type,Balance,Currency,LastUpdated\n"
        csvContent += "\(account.id),\(escapeCsvField(account.name)),\(account.accountType),\(String(format: "%.2f", account.balance)),\(account.currency),\(formatDateForCSV(account.lastUpdated))\n\n"
        
        // Transactions section
        csvContent += "TRANSACTIONS\n"
        csvContent += exportTransactionsToCSV(transactions)
        
        return csvContent
    }
    
    // MARK: - CSV Import
    /// Import transactions from CSV string
    /// - Parameter csvContent: CSV formatted string
    /// - Returns: Array of imported transactions or error
    static func importTransactionsFromCSV(_ csvContent: String) -> Result<[Transaction], CSVError> {
        let lines = csvContent.components(separatedBy: .newlines).filter { !$0.isEmpty }
        
        guard lines.count > 1 else {
            return .failure(.emptyFile)
        }
        
        // Skip header
        let dataLines = Array(lines.dropFirst())
        var transactions: [Transaction] = []
        
        for (index, line) in dataLines.enumerated() {
            let fields = parseCSVLine(line)
            
            guard fields.count >= 8 else {
                return .failure(.invalidFormat("Line \(index + 2): expected 8 fields, got \(fields.count)"))
            }
            
            let id = fields[0]
            let title = fields[1]
            let description = fields[2]
            let amountStr = fields[3]
            let typeStr = fields[4]
            let dateStr = fields[5]
            let categoryStr = fields[6]
            let merchant = fields[7]
            
            guard let amount = Double(amountStr) else {
                return .failure(.invalidAmount("Line \(index + 2): \(amountStr)"))
            }
            
            guard let type = stringToTransactionType(typeStr) else {
                return .failure(.invalidTransactionType("Line \(index + 2): \(typeStr)"))
            }
            
            guard let date = parseDateFromCSV(dateStr) else {
                return .failure(.invalidDate("Line \(index + 2): \(dateStr)"))
            }
            
            guard let category = stringToTransactionCategory(categoryStr) else {
                return .failure(.invalidCategory("Line \(index + 2): \(categoryStr)"))
            }
            
            let transaction = Transaction(
                id: id,
                title: title,
                description: description,
                amount: amount,
                type: type,
                date: date,
                category: category,
                merchant: merchant
            )
            
            transactions.append(transaction)
        }
        
        return .success(transactions)
    }
    
    // MARK: - Helper Functions
    private static func escapeCsvField(_ field: String) -> String {
        if field.contains(",") || field.contains("\"") || field.contains("\n") {
            return "\"\(field.replacingOccurrences(of: "\"", with: "\"\""))\""
        }
        return field
    }
    
    private static func parseCSVLine(_ line: String) -> [String] {
        var fields: [String] = []
        var currentField = ""
        var insideQuotes = false
        var i = line.startIndex
        
        while i < line.endIndex {
            let char = line[i]
            
            if char == "\"" {
                if insideQuotes && line.index(after: i) < line.endIndex && line[line.index(after: i)] == "\"" {
                    currentField.append("\"")
                    i = line.index(after: i)
                } else {
                    insideQuotes = !insideQuotes
                }
            } else if char == "," && !insideQuotes {
                fields.append(currentField)
                currentField = ""
            } else {
                currentField.append(char)
            }
            
            i = line.index(after: i)
        }
        
        fields.append(currentField)
        return fields
    }
    
    private static func formatDateForCSV(_ date: Date) -> String {
        let formatter = ISO8601DateFormatter()
        return formatter.string(from: date)
    }
    
    private static func parseDateFromCSV(_ dateString: String) -> Date? {
        let formatter = ISO8601DateFormatter()
        return formatter.date(from: dateString)
    }
    
    private static func transactionTypeToString(_ type: TransactionType) -> String {
        switch type {
        case .debit: return "debit"
        case .credit: return "credit"
        case .transfer: return "transfer"
        }
    }
    
    private static func stringToTransactionType(_ str: String) -> TransactionType? {
        switch str.lowercased() {
        case "debit": return .debit
        case "credit": return .credit
        case "transfer": return .transfer
        default: return nil
        }
    }
    
    private static func transactionCategoryToString(_ category: TransactionCategory) -> String {
        switch category {
        case .groceries: return "groceries"
        case .dining: return "dining"
        case .transport: return "transport"
        case .utilities: return "utilities"
        case .entertainment: return "entertainment"
        case .other: return "other"
        }
    }
    
    private static func stringToTransactionCategory(_ str: String) -> TransactionCategory? {
        switch str.lowercased() {
        case "groceries": return .groceries
        case "dining": return .dining
        case "transport": return .transport
        case "utilities": return .utilities
        case "entertainment": return .entertainment
        case "other": return .other
        default: return nil
        }
    }
}
