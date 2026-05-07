import SwiftUI

struct PhysicalCardsView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel: PhysicalCardsViewModel
    @State private var showOrderCard = false
    
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
                    Text("Physical Cards")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Spacer()
                    Image(systemName: "square.stack.3d.up.fill")
                        .foregroundColor(.green)
                        .opacity(0)
                }
                .padding(.horizontal)
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Order Card Button
                        Button(action: { showOrderCard = true }) {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                Text("Order New Card")
                                Spacer()
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(LinearGradient(gradient: Gradient(colors: [Color.green, Color.cyan]), startPoint: .leading, endPoint: .trailing))
                            .foregroundColor(.white)
                            .cornerRadius(12)
                        }
                        .padding()
                        
                        // Physical Cards List
                        VStack(spacing: 12) {
                            ForEach(viewModel.physicalCards) { card in
                                PhysicalCardItem(card: card, onBlock: { viewModel.blockCard(card.id) }, onReorder: { viewModel.reorderCard(card.id) })
                            }
                        }
                        .padding()
                        
                        if viewModel.physicalCards.isEmpty {
                            VStack(spacing: 16) {
                                Image(systemName: "square.stack.3d.up")
                                    .font(.system(size: 48))
                                    .foregroundColor(.gray)
                                Text("No Physical Cards")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Text("Order your first physical card")
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
        .sheet(isPresented: $showOrderCard) {
            OrderCardView(viewModel: viewModel, isPresented: $showOrderCard)
        }
    }
}

struct PhysicalCardItem: View {
    let card: PhysicalCard
    let onBlock: () -> Void
    let onReorder: () -> Void
    @State private var showDetails = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(card.cardName)
                        .font(.headline)
                        .foregroundColor(.white)
                    Text("•••• •••• •••• \(String(card.lastFourDigits))")
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
                        .background(card.status == "Active" ? Color.green.opacity(0.2) : Color.orange.opacity(0.2))
                        .foregroundColor(card.status == "Active" ? Color.green : Color.orange)
                        .cornerRadius(4)
                    Text(card.expiryDate)
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
                
                Button(action: { onBlock() }) {
                    HStack(spacing: 4) {
                        Image(systemName: "lock.fill")
                        Text("Block")
                    }
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 6)
                    .background(Color.orange.opacity(0.2))
                    .foregroundColor(.orange)
                    .cornerRadius(6)
                }
                
                Button(action: { onReorder() }) {
                    HStack(spacing: 4) {
                        Image(systemName: "arrow.clockwise")
                        Text("Reorder")
                    }
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 6)
                    .background(Color.purple.opacity(0.2))
                    .foregroundColor(.purple)
                    .cornerRadius(6)
                }
                
                Spacer()
            }
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(12)
        .sheet(isPresented: $showDetails) {
            PhysicalCardDetailsView(card: card, isPresented: $showDetails)
        }
    }
}

struct PhysicalCardDetailsView: View {
    let card: PhysicalCard
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
                    DetailRow(label: "Card Number", value: "•••• •••• •••• \(String(card.lastFourDigits))")
                    DetailRow(label: "Holder Name", value: card.holderName)
                    DetailRow(label: "Expiry Date", value: card.expiryDate)
                    DetailRow(label: "Status", value: card.status)
                    DetailRow(label: "Issued Date", value: card.issuedDate)
                }
                .padding()
                
                Spacer()
            }
        }
    }
}

struct OrderCardView: View {
    @ObservedObject var viewModel: PhysicalCardsViewModel
    @Binding var isPresented: Bool
    @State private var cardName = ""
    @State private var deliveryAddress = ""
    @State private var cardType = "Standard"
    
    let cardTypes = ["Standard", "Premium", "Luxury"]
    
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
                    Text("Order Physical Card")
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
                        TextField("e.g., My Debit Card", text: $cardName)
                            .padding(8)
                            .background(Color.white.opacity(0.05))
                            .cornerRadius(8)
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Card Type")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Picker("Card Type", selection: $cardType) {
                            ForEach(cardTypes, id: \.self) { type in
                                Text(type).tag(type)
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Delivery Address")
                            .font(.caption)
                            .foregroundColor(.gray)
                        TextField("Enter your address", text: $deliveryAddress)
                            .padding(8)
                            .background(Color.white.opacity(0.05))
                            .cornerRadius(8)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Estimated Delivery:")
                                .font(.caption)
                                .foregroundColor(.gray)
                            Text("5-7 business days")
                                .font(.caption)
                                .foregroundColor(.cyan)
                        }
                        HStack {
                            Text("Card Cost:")
                                .font(.caption)
                                .foregroundColor(.gray)
                            Text("Free")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.green)
                        }
                    }
                    .padding()
                    .background(Color.white.opacity(0.05))
                    .cornerRadius(8)
                    
                    Button(action: {
                        viewModel.orderPhysicalCard(name: cardName, type: cardType, address: deliveryAddress)
                        isPresented = false
                    }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("Place Order")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(LinearGradient(gradient: Gradient(colors: [Color.green, Color.cyan]), startPoint: .leading, endPoint: .trailing))
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
    PhysicalCardsView(viewModel: PhysicalCardsViewModel(dataManager: BankingDataManager()))
}
