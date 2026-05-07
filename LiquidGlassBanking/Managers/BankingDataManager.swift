import Foundation

// MARK: - Banking Data Manager
/// Observable manager handling account, transactions, and portfolio data
/// Provides a single source of truth for the app's financial data
@Observable
final class BankingDataManager {
    // MARK: - Account State
    private(set) var account: Account
    private(set) var transactions: [Transaction]
    private(set) var assets: [PortfolioAsset]
    
    // MARK: - UI State
    var isProcessingPayment = false
    var lastPaymentSuccess = false
    var errorMessage: String?
    
    // MARK: - Initialization
    init() {
        self.account = MockDataStore.account
        self.transactions = MockDataStore.transactions
        self.assets = MockDataStore.assets
    }
    
    // MARK: - Account Operations
    /// Process a payment transaction
    func processPayment(recipient: String, amount: Double) {
        isProcessingPayment = true
        errorMessage = nil
        lastPaymentSuccess = false
        
        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            guard let self = self else { return }
            
            // Validate sufficient funds
            guard amount <= self.account.balance else {
                self.errorMessage = "Insufficient funds"
                self.isProcessingPayment = false
                return
            }
            
            // Update balance
            self.account.balance -= amount
            self.account = Account(
                id: self.account.id,
                name: self.account.name,
                accountType: self.account.accountType,
                balance: self.account.balance,
                currency: self.account.currency,
                lastUpdated: Date()
            )
            
            // Create new transaction
            let newTransaction = Transaction(
                id: "TRX-\(UUID().uuidString.prefix(8))",
                title: recipient,
                description: "Transfer to \(recipient)",
                amount: amount,
                type: .transfer,
                date: Date(),
                category: .other,
                merchant: recipient
            )
            
            // Insert at top of transactions list
            self.transactions.insert(newTransaction, at: 0)
            
            self.lastPaymentSuccess = true
            self.isProcessingPayment = false
        }
    }
    
    /// Refresh account data (simulated network call)
    func refreshAccount() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            self.account = Account(
                id: self.account.id,
                name: self.account.name,
                accountType: self.account.accountType,
                balance: self.account.balance,
                currency: self.account.currency,
                lastUpdated: Date()
            )
        }
    }
    
    /// Get portfolio total value
    var portfolioTotalValue: Double {
        assets.reduce(0) { $0 + $1.currentValue }
    }
    
    /// Get total portfolio gain/loss
    var portfolioTotalGainLoss: Double {
        assets.reduce(0) { $0 + $1.gainLoss }
    }
    
    /// Get recent transactions (with limit)
    func getRecentTransactions(limit: Int = 3) -> [Transaction] {
        Array(transactions.prefix(limit))
    }
    
    /// Record a money request
    func recordRequest(from requester: String, amount: Double) {
        let newTransaction = Transaction(
            id: "REQ-\(UUID().uuidString.prefix(8))",
            title: "Request from \(requester)",
            description: "Money request from \(requester)",
            amount: amount,
            type: .debit,
            date: Date(),
            category: .other,
            merchant: requester
        )
        transactions.insert(newTransaction, at: 0)
    }
    
    /// Add imported transactions to the transaction list
    func addImportedTransactions(_ importedTransactions: [Transaction]) {
        // Add imported transactions to the beginning of the list
        transactions = importedTransactions + transactions
    }
}

// MARK: - Mock Data Extension
extension MockDataStore {
    static let assets: [PortfolioAsset] = [
        PortfolioAsset(
            id: "AAPL",
            symbol: "AAPL",
            name: "Apple Inc.",
            quantity: 50,
            currentPrice: 190.50,
            purchasePrice: 145.30
        ),
        PortfolioAsset(
            id: "GOOGL",
            symbol: "GOOGL",
            name: "Alphabet Inc.",
            quantity: 30,
            currentPrice: 140.75,
            purchasePrice: 120.50
        ),
        PortfolioAsset(
            id: "MSFT",
            symbol: "MSFT",
            name: "Microsoft Corp.",
            quantity: 25,
            currentPrice: 380.20,
            purchasePrice: 300.00
        ),
        PortfolioAsset(
            id: "TSLA",
            symbol: "TSLA",
            name: "Tesla Inc.",
            quantity: 15,
            currentPrice: 242.80,
            purchasePrice: 200.00
        )
    ]
}
