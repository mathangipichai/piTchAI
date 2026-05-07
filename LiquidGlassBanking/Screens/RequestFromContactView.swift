import SwiftUI

struct RequestFromContactView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel: RequestFromContactViewModel
    @State private var selectedContact: String = ""
    @State private var amount = ""
    @State private var description = ""
    @State private var searchText = ""
    
    var filteredContacts: [String] {
        if searchText.isEmpty {
            return viewModel.contacts
        }
        return viewModel.contacts.filter { $0.lowercased().contains(searchText.lowercased()) }
    }
    
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
                    Text("Request from Contact")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Spacer()
                    Image(systemName: "person.fill")
                        .foregroundColor(.purple)
                        .opacity(0)
                }
                .padding(.horizontal)
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Search
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                            TextField("Search contacts", text: $searchText)
                                .padding(8)
                                .background(Color.white.opacity(0.05))
                                .cornerRadius(8)
                        }
                        .padding(.horizontal)
                        
                        // Contact List
                        VStack(spacing: 12) {
                            ForEach(filteredContacts, id: \.self) { contact in
                                Button(action: { selectedContact = contact }) {
                                    HStack {
                                        Circle()
                                            .fill(LinearGradient(gradient: Gradient(colors: [Color.cyan, Color.blue]), startPoint: .topLeading, endPoint: .bottomTrailing))
                                            .frame(width: 44, height: 44)
                                            .overlay {
                                                Text(String(contact.prefix(1)))
                                                    .font(.headline)
                                                    .foregroundColor(.white)
                                            }
                                        
                                        Text(contact)
                                            .foregroundColor(.white)
                                        
                                        Spacer()
                                        
                                        if selectedContact == contact {
                                            Image(systemName: "checkmark.circle.fill")
                                                .foregroundColor(.cyan)
                                        }
                                    }
                                    .padding()
                                    .background(selectedContact == contact ? Color.cyan.opacity(0.1) : Color.white.opacity(0.05))
                                    .cornerRadius(12)
                                }
                            }
                        }
                        .padding()
                        
                        if !selectedContact.isEmpty {
                            Divider()
                            
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
                            .padding()
                            
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
                            .padding()
                        }
                        
                        Spacer()
                    }
                }
                
                // Send Button
                if !selectedContact.isEmpty {
                    Button(action: { viewModel.sendRequest(contactName: selectedContact, amount: Double(amount) ?? 0, description: description) }) {
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
}

#Preview {
    RequestFromContactView(viewModel: RequestFromContactViewModel(dataManager: BankingDataManager()))
}
