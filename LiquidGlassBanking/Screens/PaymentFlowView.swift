import SwiftUI

// MARK: - Payment Flow Screen
/// Glass modals for fund transfers with interactive confirmation screens
struct PaymentFlowView: View {
    @Environment(\.dismiss) var dismiss
    @Bindable var viewModel: PaymentViewModel
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.green.opacity(0.1),
                        Color.teal.opacity(0.05)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    // Progress indicator - Uses .thin Material for subtle progress visualization
                    HStack(spacing: 8) {
                        ForEach(0..<4, id: \.self) { index in
                            Capsule()
                                .fill(
                                    viewModel.getStepColor(for: PaymentViewModel.PaymentStep(rawValue: index) ?? .selectRecipient)
                                )
                                .frame(height: 4)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Material.thin)
                    .cornerRadius(8)
                    .padding(.horizontal, 16)
                    
                    // Step content
                    ScrollView {
                        switch viewModel.currentStep {
                        case .selectRecipient:
                            SelectRecipientStep(viewModel: viewModel)
                        case .enterAmount:
                            EnterAmountStep(viewModel: viewModel)
                        case .review:
                            ReviewPaymentStep(viewModel: viewModel)
                        case .confirmation:
                            ConfirmationStep(viewModel: viewModel)
                        }
                    }
                    
                    Spacer()
                }
                .padding(.vertical, 16)
            }
            .navigationTitle("Send Money")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            #if os(iOS)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                    }
                }
            }
            #endif
        }
    }
}

// MARK: - Step 1: Select Recipient
struct SelectRecipientStep: View {
    @Bindable var viewModel: PaymentViewModel
    
    var body: some View {
        VStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Select Recipient")
                    .font(.title2)
                    .fontWeight(.semibold)
                Text("Choose who you want to send money to")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)
            
            VStack(spacing: 10) {
                ForEach(viewModel.recipients, id: \.0) { recipient in
                    GlassCard(material: viewModel.selectedRecipient == recipient.0 ? .regular : .thin, isInteractive: true) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(recipient.0)
                                    .font(.body)
                                    .fontWeight(.semibold)
                                Text(recipient.1)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            if viewModel.selectedRecipient == recipient.0 {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                    .onTapGesture {
                        withAnimation(.easeInOut) {
                            viewModel.selectedRecipient = recipient.0
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
            
            Spacer()
            
            Button(action: { viewModel.nextStep() }) {
                Text("Continue")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
            }
            #if os(iOS)
            .buttonStyle(.glassProminent)
            #else
            .buttonStyle(.automatic)
            #endif
            .disabled(!viewModel.canContinue)
            .opacity(viewModel.canContinue ? 1.0 : 0.6)
            .padding(.horizontal, 16)
        }
    }
}

// MARK: - Step 2: Enter Amount
struct EnterAmountStep: View {
    @Bindable var viewModel: PaymentViewModel
    
    var body: some View {
        VStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Enter Amount")
                    .font(.title2)
                    .fontWeight(.semibold)
                Text("How much do you want to send to \(viewModel.selectedRecipient)?")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)
            
            // Amount input - Uses .regular Material
            GlassCard(material: .regular) {
                VStack(spacing: 12) {
                    HStack(spacing: 4) {
                        Text("$")
                            .font(.title)
                            .fontWeight(.semibold)
                        TextField("0.00", text: Binding(
                            get: { viewModel.amount },
                            set: { viewModel.amount = $0 }
                        ))
                            .font(.title)
                            #if os(iOS)
                            .keyboardType(.decimalPad)
                            #endif
                    }
                }
            }
            .padding(.horizontal, 16)
            
            // Available balance info
            GlassCard(material: .thin) {
                HStack {
                    Text("Available Balance")
                        .foregroundColor(.secondary)
                    Spacer()
                    Text(String(format: "$%.2f", viewModel.availableBalance))
                        .fontWeight(.semibold)
                }
            }
            .padding(.horizontal, 16)
            
            // Quick amount buttons
            VStack(alignment: .leading, spacing: 8) {
                Text("Quick amounts")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 16)
                
                HStack(spacing: 10) {
                    ForEach(["25", "50", "100", "500"], id: \.self) { quickAmount in
                        Button(action: {
                            viewModel.amount = quickAmount
                        }) {
                            Text("$\(quickAmount)")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .padding(8)
                        }
                        #if os(iOS)
                        .buttonStyle(.glass)
                        #else
                        .buttonStyle(.automatic)
                        #endif
                    }
                    Spacer()
                }
                .padding(.horizontal, 16)
            }
            
            Spacer()
            
            HStack(spacing: 12) {
                Button(action: { viewModel.previousStep() }) {
                    Text("Back")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                }
                #if os(iOS)
                .buttonStyle(.glass)
                #else
                .buttonStyle(.automatic)
                #endif
                
                Button(action: { viewModel.nextStep() }) {
                    Text("Review")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                }
                #if os(iOS)
                .buttonStyle(.glassProminent)
                #else
                .buttonStyle(.automatic)
                #endif
                .disabled(!viewModel.canContinue)
                .opacity(viewModel.canContinue ? 1.0 : 0.6)
            }
            .padding(.horizontal, 16)
        }
    }
}

// MARK: - Step 3: Review Payment
struct ReviewPaymentStep: View {
    @Bindable var viewModel: PaymentViewModel
    
    var body: some View {
        VStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Review & Confirm")
                    .font(.title2)
                    .fontWeight(.semibold)
                Text("Please verify the details before confirming")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)
            
            // Review card - Uses .thick Material for emphasis
            GlassCard(material: .thick) {
                VStack(spacing: 16) {
                    HStack {
                        Text("Recipient")
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(viewModel.selectedRecipient)
                            .fontWeight(.semibold)
                    }
                    
                    GlassDivider()
                    
                    HStack {
                        Text("Amount")
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("$\(viewModel.amount)")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.green)
                    }
                    
                    GlassDivider()
                    
                    HStack {
                        Text("Fee")
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("Free")
                            .fontWeight(.semibold)
                    }
                }
            }
            .padding(.horizontal, 16)
            
            // Terms
            HStack(spacing: 8) {
                Image(systemName: "info.circle.fill")
                    .font(.caption)
                    .foregroundColor(.blue)
                Text("This transfer will arrive in 1-2 business days")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
            }
            .padding(.horizontal, 16)
            
            Spacer()
            
            HStack(spacing: 12) {
                Button(action: { viewModel.previousStep() }) {
                    Text("Edit")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                }
                #if os(iOS)
                .buttonStyle(.glass)
                #else
                .buttonStyle(.automatic)
                #endif
                
                Button(action: { viewModel.processPayment() }) {
                    Text("Confirm")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                }
                #if os(iOS)
                .buttonStyle(.glassProminent)
                #else
                .buttonStyle(.automatic)
                #endif
            }
            .padding(.horizontal, 16)
        }
    }
}

// MARK: - Step 4: Processing & Success
struct ConfirmationStep: View {
    @Bindable var viewModel: PaymentViewModel
    
    var body: some View {
        VStack(spacing: 16) {
            if viewModel.isProcessing {
                VStack(spacing: 20) {
                    Text("Processing...")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    // Animated progress indicator
                    ProgressView()
                        .scaleEffect(1.5)
                    
                    Text("Your transfer is being processed")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .frame(maxHeight: .infinity, alignment: .center)
                .padding(40)
            } else if viewModel.paymentSuccess {
                VStack(spacing: 20) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.green)
                        .transition(.scale.combined(with: .opacity))
                    
                    Text("Transfer Successful!")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    VStack(spacing: 8) {
                        Text("Your money has been sent to \(viewModel.selectedRecipient)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Text("Amount: $\(viewModel.amount)")
                            .font(.caption)
                            .fontWeight(.semibold)
                    }
                    
                    // Display updated balance
                    VStack(spacing: 8) {
                        Text("New Balance")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(String(format: "$%.2f", viewModel.availableBalance))
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.green)
                    }
                    .padding(.vertical, 12)
                    .frame(maxWidth: .infinity)
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(8)
                    
                    Spacer()
                    
                    NavigationLink(destination: DashboardView(viewModel: DashboardViewModel(dataManager: BankingDataManager()))) {
                        Text("Back to Dashboard")
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
                .frame(maxHeight: .infinity, alignment: .center)
                .padding(40)
            }
        }
    }
}
