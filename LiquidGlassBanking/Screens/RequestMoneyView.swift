import SwiftUI

struct RequestMoneyView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel: RequestMoneyViewModel
    @State private var recipientName = ""
    @State private var amount = ""
    @State private var description = ""
    @State private var selectedAccount = ""
    
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
                    Text("Request Payment")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Spacer()
                    Image(systemName: "arrow.down.doc.fill")
                        .foregroundColor(.cyan)
                        .opacity(0)
                }
                .padding(.horizontal)
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Recipient Name
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Recipient Name")
                                .font(.caption)
                                .foregroundColor(.gray)
                            TextField("Enter recipient name", text: $recipientName)
                                .padding(8)
                                .background(Color.white.opacity(0.05))
                                .cornerRadius(8)
                        }
                        
                        // Amount
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Amount")
                                .font(.caption)
                                .foregroundColor(.gray)
                            HStack {
                                Text("$")
                                    .font(.headline)
                                    .foregroundColor(.cyan)
                                TextField("0.00", text: $amount)
                                    .padding(8)
                                    .background(Color.white.opacity(0.05))
                                    .cornerRadius(8)
                                #if os(iOS)
                                    .keyboardType(.decimalPad)
                                #endif
                            }
                        }
                        
                        // Description
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Description (Optional)")
                                .font(.caption)
                                .foregroundColor(.gray)
                            TextEditor(text: $description)
                                .frame(height: 100)
                                .padding(8)
                                .background(Color.white.opacity(0.05))
                                .cornerRadius(8)
                                .foregroundColor(.white)
                        }
                        
                        Spacer()
                    }
                    .padding()
                }
                
                // Send Button
                Button(action: { viewModel.sendRequest(recipientName: recipientName, amount: Double(amount) ?? 0, description: description) }) {
                    HStack {
                        Image(systemName: "paperplane.fill")
                        Text("Send Request")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(LinearGradient(gradient: Gradient(colors: [Color.cyan, Color.blue]), startPoint: .leading, endPoint: .trailing))
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
                .padding()
            }
        }
    }
}

#Preview {
    RequestMoneyView(viewModel: RequestMoneyViewModel(dataManager: BankingDataManager()))
}
