import SwiftUI

struct VirtualCardsView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel: VirtualCardsViewModel
    @State private var showCreateCard = false
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(.sRGB, red: 0.1, green: 0.1, blue: 0.2, opacity: 1),
                    Color(.sRGB, red: 0.15, green: 0.1, blue: 0.25, opacity: 1)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 24) {
                // Header
                HStack {
                    Button(action: { presentationMode.wrappedValue.dismiss() }) {
                        HStack(spacing: 8) {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                        .foregroundColor(.cyan)
                    }
                    Spacer()
                    Text("Virtual Cards")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Spacer()
                    Image(systemName: "creditcard.fill")
                        .foregroundColor(.blue)
                        .opacity(0)
                }
                .padding(.horizontal)
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Create Card Button
                        Button(action: { showCreateCard = true }) {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                Text("Create Virtual Card")
                                Spacer()
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(LinearGradient(gradient: Gradient(colors: [Color.cyan, Color.blue]), startPoint: .leading, endPoint: .trailing))
                            .foregroundColor(.white)
                            .cornerRadius(12)
                        }
                        .padding()
                        
                        // Virtual Cards List
                        VStack(spacing: 12) {
                            ForEach(viewModel.virtualCards) { card in
                                VirtualCardItem(card: card, onDelete: { viewModel.deleteCard(card.id) })
                            }
                        }
                        .padding()
                        
                        if viewModel.virtualCards.isEmpty {
                            VStack(spacing: 16) {
                                Image(systemName: "creditcard")
                                    .font(.system(size: 48))
                                    .foregroundColor(.gray)
                                Text("No Virtual Cards")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Text("Create your first virtual card to get started")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.center)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(40)
                        }
                        
                        Spacer()
                    }
                }
            }
        }
        .sheet(isPresented: $showCreateCard) {
            CreateVirtualCardView(viewModel: viewModel, isPresented: $showCreateCard)
        }
    }
}

struct VirtualCardItem: View {
    let card: VirtualCard
    let onDelete: () -> Void
    @State private var showDetails = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(card.cardName)
                        .font(.headline)
                        .foregroundColor(.white)
                    Text(card.cardNumber)
                        .font(.caption)
                        .foregroundColor(.gray)
                        .tracking(2)
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 4) {
                    Text(card.status)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(card.isActive ? Color.green.opacity(0.2) : Color.red.opacity(0.2))
                        .foregroundColor(card.isActive ? Color.green : Color.red)
                        .cornerRadius(4)
                    Text("$\(String(format: "%.2f", card.balance))")
                        .font(.caption)
                        .foregroundColor(.cyan)
                }
            }
            
            HStack(spacing: 12) {
                Button(action: { showDetails = true }) {
                    HStack(spacing: 4) {
                        Image(systemName: "eye.fill")
                        Text("Details")
                    }
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 6)
                    .background(Color.blue.opacity(0.2))
                    .foregroundColor(.blue)
                    .cornerRadius(6)
                }
                
                Button(action: { onDelete() }) {
                    HStack(spacing: 4) {
                        Image(systemName: "trash.fill")
                        Text("Delete")
                    }
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 6)
                    .background(Color.red.opacity(0.2))
                    .foregroundColor(.red)
                    .cornerRadius(6)
                }
                
                Spacer()
            }
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(12)
        .sheet(isPresented: $showDetails) {
            VirtualCardDetailsView(card: card, isPresented: $showDetails)
        }
    }
}

struct VirtualCardDetailsView: View {
    let card: VirtualCard
    @Binding var isPresented: Bool
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(.sRGB, red: 0.1, green: 0.1, blue: 0.2, opacity: 1),
                    Color(.sRGB, red: 0.15, green: 0.1, blue: 0.25, opacity: 1)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack {
                HStack {
                    Text("Card Details")
                        .font(.headline)
                        .foregroundColor(.white)
                    Spacer()
                    Button("Done") {
                        isPresented = false
                    }
                    .foregroundColor(.cyan)
                }
                .padding()
                
                VStack(alignment: .leading, spacing: 16) {
                    DetailRow(label: "Card Name", value: card.cardName)
                    DetailRow(label: "Card Number", value: card.cardNumber)
                    DetailRow(label: "CVV", value: card.cvv)
                    DetailRow(label: "Expiration", value: card.expirationDate)
                    DetailRow(label: "Balance", value: "$\(String(format: "%.2f", card.balance))")
                    DetailRow(label: "Status", value: card.status)
                }
                .padding()
                
                Spacer()
            }
        }
    }
}

struct DetailRow: View {
    let label: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.caption)
                .foregroundColor(.gray)
            Text(value)
                .font(.headline)
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(8)
    }
}

struct CreateVirtualCardView: View {
    @ObservedObject var viewModel: VirtualCardsViewModel
    @Binding var isPresented: Bool
    @State private var cardName = ""
    @State private var dailyLimit = ""
    @State private var monthlyLimit = ""
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(.sRGB, red: 0.1, green: 0.1, blue: 0.2, opacity: 1),
                    Color(.sRGB, red: 0.15, green: 0.1, blue: 0.25, opacity: 1)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack {
                HStack {
                    Text("Create Virtual Card")
                        .font(.headline)
                        .foregroundColor(.white)
                    Spacer()
                    Button("Cancel") {
                        isPresented = false
                    }
                    .foregroundColor(.cyan)
                }
                .padding()
                
                VStack(spacing: 16) {
                    VStack(alignment: .leading) {
                        Text("Card Name")
                            .font(.caption)
                            .foregroundColor(.gray)
                        TextField("e.g., Shopping", text: $cardName)
                            .padding(8)
                            .background(Color.white.opacity(0.05))
                            .cornerRadius(8)
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Daily Limit")
                            .font(.caption)
                            .foregroundColor(.gray)
                        TextField("$0.00", text: $dailyLimit)
                            .padding(8)
                            .background(Color.white.opacity(0.05))
                            .cornerRadius(8)
                        #if os(iOS)
                            .keyboardType(.decimalPad)
                        #endif
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Monthly Limit")
                            .font(.caption)
                            .foregroundColor(.gray)
                        TextField("$0.00", text: $monthlyLimit)
                            .padding(8)
                            .background(Color.white.opacity(0.05))
                            .cornerRadius(8)
                        #if os(iOS)
                            .keyboardType(.decimalPad)
                        #endif
                    }
                    
                    Button(action: {
                        viewModel.createVirtualCard(name: cardName, dailyLimit: Double(dailyLimit) ?? 1000, monthlyLimit: Double(monthlyLimit) ?? 10000)
                        isPresented = false
                    }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("Create Card")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(LinearGradient(gradient: Gradient(colors: [Color.cyan, Color.blue]), startPoint: .leading, endPoint: .trailing))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                }
                .padding()
                
                Spacer()
            }
        }
    }
}

#Preview {
    VirtualCardsView(viewModel: VirtualCardsViewModel(dataManager: BankingDataManager()))
}
