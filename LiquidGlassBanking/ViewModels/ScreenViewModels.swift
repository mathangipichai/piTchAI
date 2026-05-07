import Foundation
import SwiftUI
import Combine

// MARK: - Dashboard View Model
@Observable
final class DashboardViewModel {
    let dataManager: BankingDataManager
    var animateCards = false
    var showPaymentModal = false
    
    var account: Account {
        dataManager.account
    }
    
    var transactions: [Transaction] {
        dataManager.getRecentTransactions(limit: 3)
    }
    
    var formattedTime: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: account.lastUpdated)
    }
    
    init(dataManager: BankingDataManager) {
        self.dataManager = dataManager
    }
    
    func animateOnAppear() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(.easeOut(duration: 0.6)) {
                self.animateCards = true
            }
        }
    }
    
    func refreshData() {
        dataManager.refreshAccount()
    }
    
    // MARK: - Request Menu Actions
    func requestFromContact() {
        // Placeholder: In production, this would open a contact picker
        // or navigate to a request flow
    }
    
    func requestLink() {
        // Placeholder: Generate and share a request link
    }
    
    func requestQRCode() {
        // Placeholder: Generate a QR code for money request
    }
    
    // MARK: - Card Menu Actions
    func addCard() {
        // Placeholder: Navigate to card addition flow
    }
    
    func cardSettings() {
        // Placeholder: Open card settings
    }
    
    func virtualCard() {
        // Placeholder: Create a virtual card
    }
}

// MARK: - Payment View Model
@Observable
final class PaymentViewModel {
    let dataManager: BankingDataManager
    
    var currentStep: PaymentStep = .selectRecipient
    var selectedRecipient: String = ""
    var amount: String = ""
    var showConfirmation = false
    
    enum PaymentStep: Int {
        case selectRecipient = 0
        case enterAmount = 1
        case review = 2
        case confirmation = 3
    }
    
    var recipients: [(String, String)] {
        [
            ("Alex Johnson", "alex@bank.com"),
            ("Sarah Smith", "sarah@bank.com"),
            ("Michael Brown", "michael@bank.com"),
            ("Emma Wilson", "emma@bank.com")
        ]
    }
    
    var isProcessing: Bool {
        dataManager.isProcessingPayment
    }
    
    var paymentSuccess: Bool {
        dataManager.lastPaymentSuccess
    }
    
    var canContinue: Bool {
        switch currentStep {
        case .selectRecipient:
            return !selectedRecipient.isEmpty
        case .enterAmount:
            return !amount.isEmpty && Double(amount) ?? 0 > 0
        case .review:
            return true
        case .confirmation:
            return true
        }
    }
    
    var availableBalance: Double {
        dataManager.account.balance
    }
    
    init(dataManager: BankingDataManager) {
        self.dataManager = dataManager
    }
    
    func processPayment() {
        guard let paymentAmount = Double(amount), paymentAmount > 0 else {
            return
        }
        dataManager.processPayment(recipient: selectedRecipient, amount: paymentAmount)
        currentStep = .confirmation
    }
    
    func reset() {
        currentStep = .selectRecipient
        selectedRecipient = ""
        amount = ""
        showConfirmation = false
    }
    
    func nextStep() {
        switch currentStep {
        case .selectRecipient:
            currentStep = .enterAmount
        case .enterAmount:
            currentStep = .review
        case .review:
            break
        case .confirmation:
            break
        }
    }
    
    func previousStep() {
        switch currentStep {
        case .selectRecipient:
            break
        case .enterAmount:
            currentStep = .selectRecipient
        case .review:
            currentStep = .enterAmount
        case .confirmation:
            break
        }
    }
    
    func getStepColor(for step: PaymentStep) -> Color {
        switch step {
        case .selectRecipient:
            return currentStep == .selectRecipient ? .blue : .gray.opacity(0.3)
        case .enterAmount:
            return currentStep == .enterAmount || currentStep == .review || currentStep == .confirmation ? .blue : .gray.opacity(0.3)
        case .review:
            return currentStep == .review || currentStep == .confirmation ? .blue : .gray.opacity(0.3)
        case .confirmation:
            return currentStep == .confirmation ? .blue : .gray.opacity(0.3)
        }
    }
}

// MARK: - Portfolio View Model
@Observable
final class PortfolioViewModel {
    let dataManager: BankingDataManager
    var selectedAsset: PortfolioAsset?
    var showChart = false
    
    var assets: [PortfolioAsset] {
        dataManager.assets
    }
    
    var totalValue: Double {
        dataManager.portfolioTotalValue
    }
    
    var totalGainLoss: Double {
        dataManager.portfolioTotalGainLoss
    }
    
    var totalGainLossPercentage: Double {
        let totalCost = dataManager.assets.reduce(0) { $0 + ($1.purchasePrice * $1.quantity) }
        guard totalCost > 0 else { return 0 }
        return ((totalValue - totalCost) / totalCost) * 100
    }
    
    var formattedTotalValue: String {
        String(format: "$%.2f", totalValue)
    }
    
    var formattedGainLoss: String {
        String(format: "%+.2f%%", totalGainLossPercentage)
    }
    
    init(dataManager: BankingDataManager) {
        self.dataManager = dataManager
    }
}

// MARK: - Settings View Model
@Observable
final class SettingsViewModel {
    let dataManager: BankingDataManager
    var selectedMaterial: MaterialType = .regular
    
    enum MaterialType {
        case thin
        case regular
        case thick
        
        var material: Material {
            switch self {
            case .thin: return Material.thin
            case .regular: return Material.regular
            case .thick: return Material.thick
            }
        }
    }
    
    init(dataManager: BankingDataManager) {
        self.dataManager = dataManager
    }
}

// MARK: - Request Money View Model
final class RequestMoneyViewModel: NSObject, ObservableObject {
    @Published var dataManager: BankingDataManager
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var successMessage: String?
    
    init(dataManager: BankingDataManager) {
        self.dataManager = dataManager
    }
    
    func sendRequest(recipientName: String, amount: Double, description: String) {
        guard !recipientName.isEmpty && amount > 0 else {
            errorMessage = "Please enter valid details"
            return
        }
        
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.isLoading = false
            self.successMessage = "Request sent to \(recipientName)"
            self.dataManager.recordRequest(from: recipientName, amount: amount)
        }
    }
}

// MARK: - Request from Contact View Model
final class RequestFromContactViewModel: NSObject, ObservableObject {
    @Published var dataManager: BankingDataManager
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var successMessage: String?
    
    var contacts: [String] {
        [
            "Alice Johnson",
            "Bob Smith",
            "Carol Davis",
            "David Lee",
            "Emma Brown",
            "Frank Wilson",
            "Grace Martinez",
            "Henry Taylor"
        ]
    }
    
    init(dataManager: BankingDataManager) {
        self.dataManager = dataManager
    }
    
    func sendRequest(contactName: String, amount: Double, description: String) {
        guard !contactName.isEmpty && amount > 0 else {
            errorMessage = "Please select a contact and enter amount"
            return
        }
        
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.isLoading = false
            self.successMessage = "Request sent to \(contactName)"
            self.dataManager.recordRequest(from: contactName, amount: amount)
        }
    }
}

// MARK: - Virtual Cards View Model
final class VirtualCardsViewModel: NSObject, ObservableObject {
    @Published var dataManager: BankingDataManager
    @Published var virtualCards: [VirtualCard] = []
    @Published var isLoading = false
    
    init(dataManager: BankingDataManager) {
        self.dataManager = dataManager
        super.init()
        loadVirtualCards()
    }
    
    func loadVirtualCards() {
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.virtualCards = [
                VirtualCard(id: "vc1", cardName: "Shopping", cardNumber: "4532 1234 5678 9010", cvv: "123", expirationDate: "12/26", balance: 5000, isActive: true),
                VirtualCard(id: "vc2", cardName: "Online", cardNumber: "4532 9876 5432 1098", cvv: "456", expirationDate: "08/26", balance: 2500, isActive: true)
            ]
            self.isLoading = false
        }
    }
    
    func createVirtualCard(name: String, dailyLimit: Double, monthlyLimit: Double) {
        let newCard = VirtualCard(
            id: UUID().uuidString,
            cardName: name,
            cardNumber: "4532 \(Int.random(in: 1000...9999)) \(Int.random(in: 1000...9999)) \(Int.random(in: 1000...9999))",
            cvv: "\(Int.random(in: 100...999))",
            expirationDate: "12/26",
            balance: 10000,
            isActive: true
        )
        virtualCards.append(newCard)
    }
    
    func deleteCard(_ id: String) {
        virtualCards.removeAll { $0.id == id }
    }
}

// MARK: - Physical Cards View Model
// MARK: - Physical Cards View Model
final class PhysicalCardsViewModel: NSObject, ObservableObject {
    @Published var dataManager: BankingDataManager
    @Published var physicalCards: [PhysicalCard] = []
    @Published var isLoading = false
    
    init(dataManager: BankingDataManager) {
        self.dataManager = dataManager
        super.init()
        loadPhysicalCards()
    }
    
    func loadPhysicalCards() {
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.physicalCards = [
                PhysicalCard(id: "pc1", cardName: "Main Debit Card", lastFourDigits: "1234", holderName: "John Doe", expiryDate: "12/26", status: "Active", issuedDate: "12/2023"),
                PhysicalCard(id: "pc2", cardName: "Backup Card", lastFourDigits: "5678", holderName: "John Doe", expiryDate: "08/27", status: "Inactive", issuedDate: "08/2024")
            ]
            self.isLoading = false
        }
    }
    
    func orderPhysicalCard(name: String, type: String, address: String) {
        let newCard = PhysicalCard(
            id: UUID().uuidString,
            cardName: name,
            lastFourDigits: "\(Int.random(in: 1000...9999))",
            holderName: "John Doe",
            expiryDate: "12/26",
            status: "Pending",
            issuedDate: Date().formatted()
        )
        physicalCards.append(newCard)
    }
    
    func blockCard(_ id: String) {
        if let index = physicalCards.firstIndex(where: { $0.id == id }) {
            physicalCards[index].status = "Blocked"
        }
    }
    
    func reorderCard(_ id: String) {
        // Placeholder for reorder logic
    }
}

// MARK: - CSV Import/Export View Model
final class CSVImportExportViewModel: NSObject, ObservableObject {
    @Published var dataManager: BankingDataManager
    @Published var isLoading = false
    @Published var successMessage: String?
    @Published var errorMessage: String?
    @Published var exportedCSV: String?
    @Published var showFileImporter = false
    @Published var importedTransactionCount = 0
    
    init(dataManager: BankingDataManager) {
        self.dataManager = dataManager
        super.init()
    }
    
    // MARK: - Export Methods
    func exportTransactions() {
        isLoading = true
        errorMessage = nil
        successMessage = nil
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            let csv = CSVManager.exportTransactionsToCSV(self.dataManager.transactions)
            self.exportedCSV = csv
            self.successMessage = "Successfully exported \(self.dataManager.transactions.count) transactions"
            self.isLoading = false
        }
    }
    
    func exportFullData() {
        isLoading = true
        errorMessage = nil
        successMessage = nil
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            let csv = CSVManager.exportFullDataToCSV(
                account: self.dataManager.account,
                transactions: self.dataManager.transactions
            )
            self.exportedCSV = csv
            self.successMessage = "Successfully exported account data and \(self.dataManager.transactions.count) transactions"
            self.isLoading = false
        }
    }
    
    func copyToClipboard(_ text: String) {
        #if os(iOS)
        UIPasteboard.general.string = text
        #else
        NSPasteboard.general.setString(text, forType: .string)
        #endif
        successMessage = "CSV data copied to clipboard"
    }
    
    // MARK: - Import Methods
    func importTransactionsFromCSV(_ csvContent: String) {
        isLoading = true
        errorMessage = nil
        successMessage = nil
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            switch CSVManager.importTransactionsFromCSV(csvContent) {
            case .success(let transactions):
                self.dataManager.addImportedTransactions(transactions)
                self.importedTransactionCount = transactions.count
                self.successMessage = "Successfully imported \(transactions.count) transactions"
                self.isLoading = false
                
            case .failure(let error):
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        }
    }
    
    func clearMessages() {
        successMessage = nil
        errorMessage = nil
    }
}
