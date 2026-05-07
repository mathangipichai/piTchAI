import Foundation

// MARK: - Account Model
struct Account {
    let id: String
    let name: String
    let accountType: String
    var balance: Double
    let currency: String
    let lastUpdated: Date
    
    var formattedBalance: String {
        String(format: "$%.2f", balance)
    }
}

// MARK: - Transaction Model
struct Transaction {
    let id: String
    let title: String
    let description: String
    let amount: Double
    let type: TransactionType
    let date: Date
    let category: TransactionCategory
    let merchant: String
    
    var formattedAmount: String {
        String(format: "$%.2f", amount)
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: date)
    }
}

enum TransactionType {
    case debit
    case credit
    case transfer
}

enum TransactionCategory {
    case groceries
    case dining
    case transport
    case utilities
    case entertainment
    case other
    
    var icon: String {
        switch self {
        case .groceries: return "🛒"
        case .dining: return "🍽️"
        case .transport: return "🚗"
        case .utilities: return "💡"
        case .entertainment: return "🎬"
        case .other: return "📋"
        }
    }
}

// MARK: - Portfolio Asset Model
struct PortfolioAsset {
    let id: String
    let symbol: String
    let name: String
    let quantity: Double
    let currentPrice: Double
    let purchasePrice: Double
    
    var currentValue: Double {
        quantity * currentPrice
    }
    
    var gainLoss: Double {
        (currentPrice - purchasePrice) * quantity
    }
    
    var gainLossPercentage: Double {
        ((currentPrice - purchasePrice) / purchasePrice) * 100
    }
    
    var formattedValue: String {
        String(format: "$%.2f", currentValue)
    }
    
    var formattedGainLoss: String {
        String(format: "%+.2f%%", gainLossPercentage)
    }
}

// MARK: - Virtual Card Model
struct VirtualCard: Identifiable {
    let id: String
    let cardName: String
    let cardNumber: String
    let cvv: String
    let expirationDate: String
    let balance: Double
    let isActive: Bool
    
    var status: String {
        isActive ? "Active" : "Inactive"
    }
    
    var formattedBalance: String {
        String(format: "$%.2f", balance)
    }
}

// MARK: - Physical Card Model
struct PhysicalCard: Identifiable {
    let id: String
    let cardName: String
    let lastFourDigits: String
    let holderName: String
    let expiryDate: String
    var status: String
    let issuedDate: String
    
    var isActive: Bool {
        status == "Active"
    }
}

// MARK: - Mock Data
class MockDataStore {
    static let account = Account(
        id: "ACC-001",
        name: "Primary Checking",
        accountType: "Checking",
        balance: 12458.50,
        currency: "USD",
        lastUpdated: Date()
    )
    
    static let transactions: [Transaction] = [
        Transaction(
            id: "TRX-001",
            title: "Whole Foods",
            description: "Grocery Store",
            amount: 124.50,
            type: .debit,
            date: Date().addingTimeInterval(-86400),
            category: .groceries,
            merchant: "Whole Foods Market"
        ),
        Transaction(
            id: "TRX-002",
            title: "Restaurant XYZ",
            description: "Dinner",
            amount: 68.75,
            type: .debit,
            date: Date().addingTimeInterval(-172800),
            category: .dining,
            merchant: "Restaurant XYZ"
        ),
        Transaction(
            id: "TRX-003",
            title: "Salary Deposit",
            description: "Monthly Salary",
            amount: 5500.00,
            type: .credit,
            date: Date().addingTimeInterval(-259200),
            category: .other,
            merchant: "Employer Inc"
        ),
        Transaction(
            id: "TRX-004",
            title: "Uber",
            description: "Ride",
            amount: 35.20,
            type: .debit,
            date: Date().addingTimeInterval(-345600),
            category: .transport,
            merchant: "Uber"
        ),
        Transaction(
            id: "TRX-005",
            title: "Netflix",
            description: "Monthly Subscription",
            amount: 15.99,
            type: .debit,
            date: Date().addingTimeInterval(-432000),
            category: .entertainment,
            merchant: "Netflix"
        )
    ]
    
    static let portfolio: [PortfolioAsset] = [
        PortfolioAsset(
            id: "AST-001",
            symbol: "AAPL",
            name: "Apple Inc",
            quantity: 25,
            currentPrice: 185.50,
            purchasePrice: 150.00
        ),
        PortfolioAsset(
            id: "AST-002",
            symbol: "MSFT",
            name: "Microsoft Corporation",
            quantity: 15,
            currentPrice: 425.75,
            purchasePrice: 380.00
        ),
        PortfolioAsset(
            id: "AST-003",
            symbol: "GOOGL",
            name: "Alphabet Inc",
            quantity: 10,
            currentPrice: 142.30,
            purchasePrice: 120.00
        ),
        PortfolioAsset(
            id: "AST-004",
            symbol: "TSLA",
            name: "Tesla Inc",
            quantity: 5,
            currentPrice: 238.50,
            purchasePrice: 200.00
        )
    ]
}
