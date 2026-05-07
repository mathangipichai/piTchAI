import SwiftUI

// MARK: - Dashboard Screen
/// Main account overview with glass-effect balance cards and animated transaction feed
struct DashboardView: View {
    @Environment(BankingDataManager.self) var dataManager
    @Environment(\.accessibilityReduceMotion) var reduceMotion
    let viewModel: DashboardViewModel
    @State private var showRequestMenu = false
    @State private var showCardsMenu = false
    @State private var showSettingsMenu = false
    @State private var showActionAlert = false
    @State private var actionMessage = ""
    
    // Request menu states
    @State private var showQRCodeModal = false
    @State private var showRequestLinkSheet = false
    @State private var showContactsSheet = false
    
    // Cards menu states
    @State private var showAddCardSheet = false
    @State private var showCardSettingsSheet = false
    @State private var showVirtualCardSheet = false
    
    var body: some View {
        ZStack {
            // Animated gradient background
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.blue.opacity(0.1),
                    Color.purple.opacity(0.05)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Welcome Back")
                            .font(.title2)
                            .fontWeight(.semibold)
                        Text("Primary Checking Account")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 16)
                    
                    // Balance Card - Uses .thick Material for emphasis (primary component)
                    GlassCard(material: .thick) {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Current Balance")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            Text(viewModel.account.formattedBalance)
                                .font(.system(size: 32, weight: .bold, design: .default))
                            
                            HStack {
                                Text("Updated: \(viewModel.formattedTime)")
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                                Spacer()
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .offset(y: viewModel.animateCards ? 0 : 20)
                    .opacity(viewModel.animateCards ? 1 : 0.8)
                    
                    // Recent Transactions Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Recent Transactions")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .padding(.horizontal, 16)
                        
                        if viewModel.transactions.isEmpty {
                            Text("No transactions yet")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .padding(.horizontal, 16)
                        } else {
                            ForEach(viewModel.transactions, id: \.id) { transaction in
                                TransactionRowView(transaction: transaction)
                                    .transition(.move(edge: .leading).combined(with: .opacity))
                            }
                        }
                    }
                }
                .padding(.vertical, 16)
            }
            .navigationTitle("Dashboard")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        // Request Menu
                        Menu {
                            Button("Request from Contact") {
                                showContactsSheet = true
                            }
                            Button("Request Link") {
                                showRequestLinkSheet = true
                            }
                            Button("QR Code") {
                                showQRCodeModal = true
                            }
                        } label: {
                            Label("Request", systemImage: "arrow.down.doc.fill")
                        }
                        
                        // Cards Menu
                        Menu {
                            Button("Add Card") {
                                showAddCardSheet = true
                            }
                            Button("Card Settings") {
                                showCardSettingsSheet = true
                            }
                            Button("Virtual Card") {
                                showVirtualCardSheet = true
                            }
                        } label: {
                            Label("Cards", systemImage: "creditcard.fill")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
            }
            #endif
        }
        .onAppear {
            if !reduceMotion {
                viewModel.animateOnAppear()
            } else {
                // Instantly show cards without animation for accessibility
                viewModel.animateCards = true
            }
        }
        // Request menu sheets
        .sheet(isPresented: $showQRCodeModal) {
            QRCodeModalView(isPresented: $showQRCodeModal)
        }
        .sheet(isPresented: $showRequestLinkSheet) {
            RequestLinkSheetView(isPresented: $showRequestLinkSheet)
        }
        .sheet(isPresented: $showContactsSheet) {
            ContactsSheetView(isPresented: $showContactsSheet)
        }
        // Cards menu sheets
        .sheet(isPresented: $showAddCardSheet) {
            AddCardSheetView(isPresented: $showAddCardSheet)
        }
        .sheet(isPresented: $showCardSettingsSheet) {
            CardSettingsSheetView(isPresented: $showCardSettingsSheet)
        }
        .sheet(isPresented: $showVirtualCardSheet) {
            VirtualCardSheetView(isPresented: $showVirtualCardSheet)
        }
    }
}

// MARK: - QR Code Modal
struct QRCodeModalView: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.blue.opacity(0.1),
                        Color.purple.opacity(0.05)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 24) {
                    Text("Request Payment QR Code")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    // Placeholder QR Code
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white)
                        .frame(width: 250, height: 250)
                        .overlay(
                            VStack(spacing: 8) {
                                Image(systemName: "qrcode")
                                    .font(.system(size: 80))
                                    .foregroundColor(.black.opacity(0.3))
                                Text("QR Code\n(Scan to request payment)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.center)
                            }
                        )
                    
                    Text("Share this QR code with others to request payment")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                    
                    HStack(spacing: 12) {
                        Button(action: {}) {
                            Text("Back")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding(12)
                        }
                        #if os(iOS)
                        .buttonStyle(.glass)
                        #else
                        .buttonStyle(.automatic)
                        #endif
                        
                        Button(action: { isPresented = false }) {
                            Text("Cancel")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding(12)
                        }
                        #if os(iOS)
                        .buttonStyle(.glass)
                        #else
                        .buttonStyle(.automatic)
                        #endif
                        
                        Button(action: { isPresented = false }) {
                            Text("OK")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding(12)
                        }
                        #if os(iOS)
                        .buttonStyle(.glassProminent)
                        #else
                        .buttonStyle(.automatic)
                        #endif
                    }
                    
                    Spacer()
                }
                .padding(24)
            }
            .navigationTitle("QR Code")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                #if os(iOS)
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        isPresented = false
                    }
                }
                #endif
            }
        }
    }
}

// MARK: - Request Link Sheet
struct RequestLinkSheetView: View {
    @Binding var isPresented: Bool
    @State private var shareLink = "https://pay.banking-app.com/req/abc123def456"
    @State private var copied = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.blue.opacity(0.1),
                        Color.purple.opacity(0.05)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    Text("Share Payment Request Link")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    VStack(spacing: 12) {
                        Text("Link")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        HStack {
                            Text(shareLink)
                                .font(.caption2)
                                .foregroundColor(.secondary)
                                .lineLimit(1)
                            
                            Button(action: {
                                #if os(iOS)
                                UIPasteboard.general.string = shareLink
                                #endif
                                copied = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    copied = false
                                }
                            }) {
                                Image(systemName: copied ? "checkmark" : "doc.on.doc")
                                    .foregroundColor(copied ? .green : .blue)
                            }
                        }
                        .padding(12)
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(8)
                    }
                    
                    HStack(spacing: 12) {
                        Button(action: {}) {
                            Text("Back")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding(12)
                        }
                        #if os(iOS)
                        .buttonStyle(.glass)
                        #else
                        .buttonStyle(.automatic)
                        #endif
                        
                        Button(action: { isPresented = false }) {
                            Text("Cancel")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding(12)
                        }
                        #if os(iOS)
                        .buttonStyle(.glass)
                        #else
                        .buttonStyle(.automatic)
                        #endif
                        
                        Button(action: { isPresented = false }) {
                            Text("OK")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding(12)
                        }
                        #if os(iOS)
                        .buttonStyle(.glassProminent)
                        #else
                        .buttonStyle(.automatic)
                        #endif
                    }
                    
                    Spacer()
                }
                .padding(20)
            }
            .navigationTitle("Request Link")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                #if os(iOS)
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        isPresented = false
                    }
                }
                #endif
            }
        }
    }
}

// MARK: - Contacts Sheet
struct ContactsSheetView: View {
    @Binding var isPresented: Bool
    
    let contacts = ["Alice Johnson", "Bob Smith", "Carol White", "David Brown"]
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.blue.opacity(0.1),
                        Color.purple.opacity(0.05)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 12) {
                    Text("Select Contact")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding(20)
                    
                    List {
                        ForEach(contacts, id: \.self) { contact in
                            Button(action: {}) {
                                HStack {
                                    Circle()
                                        .fill(Color.blue.opacity(0.3))
                                        .frame(width: 40, height: 40)
                                        .overlay(
                                            Text(String(contact.prefix(1)))
                                                .fontWeight(.semibold)
                                                .foregroundColor(.blue)
                                        )
                                    
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(contact)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.primary)
                                        Text("Request payment")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    
                                    Spacer()
                                }
                                .contentShape(Rectangle())
                            }
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .frame(maxHeight: .infinity)
                    
                    HStack(spacing: 12) {
                        Button(action: { isPresented = false }) {
                            Text("Back")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding(12)
                        }
                        #if os(iOS)
                        .buttonStyle(.glass)
                        #else
                        .buttonStyle(.automatic)
                        #endif
                        
                        Button(action: { isPresented = false }) {
                            Text("Cancel")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding(12)
                        }
                        #if os(iOS)
                        .buttonStyle(.glass)
                        #else
                        .buttonStyle(.automatic)
                        #endif
                        
                        Button(action: { isPresented = false }) {
                            Text("OK")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding(12)
                        }
                        #if os(iOS)
                        .buttonStyle(.glassProminent)
                        #else
                        .buttonStyle(.automatic)
                        #endif
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
            }
            .navigationTitle("Request Payment")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                #if os(iOS)
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        isPresented = false
                    }
                }
                #endif
            }
        }
    }
}

// MARK: - Add Card Sheet
struct AddCardSheetView: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.blue.opacity(0.1),
                        Color.purple.opacity(0.05)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    Text("Add New Card")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    VStack(spacing: 16) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Card Number")
                                .font(.caption)
                                .fontWeight(.semibold)
                            TextField("1234 5678 9012 3456", text: .constant(""))
                                .textFieldStyle(.roundedBorder)
                        }
                        
                        HStack(spacing: 12) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Expiry")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                TextField("MM/YY", text: .constant(""))
                                    .textFieldStyle(.roundedBorder)
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("CVV")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                SecureField("***", text: .constant(""))
                                    .textFieldStyle(.roundedBorder)
                            }
                        }
                    }
                    .padding(16)
                    .background(Color.white.opacity(0.05))
                    .cornerRadius(12)
                    
                    HStack(spacing: 12) {
                        Button(action: { isPresented = false }) {
                            Text("Back")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding(12)
                        }
                        #if os(iOS)
                        .buttonStyle(.glass)
                        #else
                        .buttonStyle(.automatic)
                        #endif
                        
                        Button(action: { isPresented = false }) {
                            Text("Cancel")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding(12)
                        }
                        #if os(iOS)
                        .buttonStyle(.glass)
                        #else
                        .buttonStyle(.automatic)
                        #endif
                        
                        Button(action: { isPresented = false }) {
                            Text("Add Card")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding(12)
                        }
                        #if os(iOS)
                        .buttonStyle(.glassProminent)
                        #else
                        .buttonStyle(.automatic)
                        #endif
                    }
                    
                    Spacer()
                }
                .padding(20)
            }
            .navigationTitle("Add Card")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                #if os(iOS)
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        isPresented = false
                    }
                }
                #endif
            }
        }
    }
}

// MARK: - Card Settings Sheet
struct CardSettingsSheetView: View {
    @Binding var isPresented: Bool
    @State private var cardBlocked = false
    @State private var contactlessEnabled = true
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.blue.opacity(0.1),
                        Color.purple.opacity(0.05)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    Text("Card Settings")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    VStack(spacing: 16) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Block Card")
                                    .fontWeight(.semibold)
                                Text("Temporarily block this card")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Toggle("", isOn: $cardBlocked)
                        }
                        
                        Divider()
                        
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Contactless Payments")
                                    .fontWeight(.semibold)
                                Text("Enable contactless transactions")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Toggle("", isOn: $contactlessEnabled)
                        }
                    }
                    .padding(16)
                    .background(Color.white.opacity(0.05))
                    .cornerRadius(12)
                    
                    HStack(spacing: 12) {
                        Button(action: { isPresented = false }) {
                            Text("Back")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding(12)
                        }
                        #if os(iOS)
                        .buttonStyle(.glass)
                        #else
                        .buttonStyle(.automatic)
                        #endif
                        
                        Button(action: { isPresented = false }) {
                            Text("Cancel")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding(12)
                        }
                        #if os(iOS)
                        .buttonStyle(.glass)
                        #else
                        .buttonStyle(.automatic)
                        #endif
                        
                        Button(role: .destructive, action: { isPresented = false }) {
                            Text("Delete Card")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding(12)
                        }
                        #if os(iOS)
                        .buttonStyle(.glassProminent)
                        #else
                        .buttonStyle(.automatic)
                        #endif
                    }
                    
                    Spacer()
                }
                .padding(20)
            }
            .navigationTitle("Card Settings")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                #if os(iOS)
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        isPresented = false
                    }
                }
                #endif
            }
        }
    }
}

// MARK: - Virtual Card Sheet
struct VirtualCardSheetView: View {
    @Binding var isPresented: Bool
    @State private var cardNumber = "4532 •••• •••• 8901"
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.blue.opacity(0.1),
                        Color.purple.opacity(0.05)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 24) {
                    Text("Virtual Card Created")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    // Virtual Card Display
                    RoundedRectangle(cornerRadius: 16)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.purple.opacity(0.4),
                                    Color.blue.opacity(0.4)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(height: 180)
                        .overlay(
                            VStack(alignment: .leading, spacing: 40) {
                                HStack {
                                    Text("Virtual Card")
                                        .fontWeight(.semibold)
                                    Spacer()
                                    Image(systemName: "creditcard.fill")
                                }
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Card Number")
                                        .font(.caption)
                                        .opacity(0.7)
                                    Text(cardNumber)
                                        .fontWeight(.semibold)
                                        .font(.system(.body, design: .monospaced))
                                }
                                
                                HStack {
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("VALID THRU")
                                            .font(.caption2)
                                            .opacity(0.7)
                                        Text("12/26")
                                            .fontWeight(.semibold)
                                    }
                                    Spacer()
                                }
                            }
                            .padding(20)
                            .foregroundColor(.white)
                        )
                    
                    Text("Your virtual card is ready to use for online shopping")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                    
                    HStack(spacing: 12) {
                        Button(action: { isPresented = false }) {
                            Text("Back")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding(12)
                        }
                        #if os(iOS)
                        .buttonStyle(.glass)
                        #else
                        .buttonStyle(.automatic)
                        #endif
                        
                        Button(action: { isPresented = false }) {
                            Text("Cancel")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding(12)
                        }
                        #if os(iOS)
                        .buttonStyle(.glass)
                        #else
                        .buttonStyle(.automatic)
                        #endif
                        
                        Button(action: { isPresented = false }) {
                            Text("Use Card")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding(12)
                        }
                        #if os(iOS)
                        .buttonStyle(.glassProminent)
                        #else
                        .buttonStyle(.automatic)
                        #endif
                    }
                    
                    Spacer()
                }
                .padding(20)
            }
            .navigationTitle("Virtual Card")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                #if os(iOS)
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        isPresented = false
                    }
                }
                #endif
            }
        }
    }
}

// MARK: - Transaction Row Component
struct TransactionRowView: View {
    let transaction: Transaction
    
    var body: some View {
        GlassCard(material: .regular) {
            HStack(spacing: 12) {
                Text(transaction.category.icon)
                    .font(.title2)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(transaction.title)
                        .font(.body)
                        .fontWeight(.semibold)
                    Text(transaction.merchant)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text(transaction.formattedAmount)
                        .font(.body)
                        .fontWeight(.semibold)
                        .foregroundColor(transaction.type == .debit ? .red : .green)
                    Text(transaction.formattedDate)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.horizontal, 16)
    }
}
