import SwiftUI

// MARK: - CSV Import/Export View
struct CSVImportExportView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel: CSVImportExportViewModel
    @State private var showingImportSheet = false
    @State private var importedCSVContent = ""
    @State private var selectedExportOption = 0
    
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
                    Text("Import/Export Data")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Spacer()
                    Image(systemName: "arrow.left.arrow.right")
                        .foregroundColor(.cyan)
                        .opacity(0)
                }
                .padding(.horizontal)
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Status Messages
                        if let successMsg = viewModel.successMessage {
                            HStack(spacing: 12) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                                Text(successMsg)
                                    .font(.caption)
                                    .foregroundColor(.green)
                                Spacer()
                                Button(action: { viewModel.clearMessages() }) {
                                    Image(systemName: "xmark")
                                        .foregroundColor(.green)
                                }
                            }
                            .padding()
                            .background(Color.green.opacity(0.1))
                            .cornerRadius(12)
                            .padding(.horizontal)
                        }
                        
                        if let errorMsg = viewModel.errorMessage {
                            HStack(spacing: 12) {
                                Image(systemName: "exclamationmark.circle.fill")
                                    .foregroundColor(.red)
                                Text(errorMsg)
                                    .font(.caption)
                                    .foregroundColor(.red)
                                Spacer()
                                Button(action: { viewModel.clearMessages() }) {
                                    Image(systemName: "xmark")
                                        .foregroundColor(.red)
                                }
                            }
                            .padding()
                            .background(Color.red.opacity(0.1))
                            .cornerRadius(12)
                            .padding(.horizontal)
                        }
                        
                        // Export Section
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Image(systemName: "arrow.up.doc.fill")
                                    .foregroundColor(.blue)
                                Text("Export Data")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                Spacer()
                            }
                            .foregroundColor(.white)
                            
                            VStack(spacing: 12) {
                                Button(action: { viewModel.exportTransactions() }) {
                                    HStack {
                                        Image(systemName: "document.fill")
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text("Export Transactions")
                                                .fontWeight(.semibold)
                                            Text("Export all transactions to CSV")
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                        }
                                        Spacer()
                                        if viewModel.isLoading {
                                            ProgressView()
                                                .scaleEffect(0.8)
                                        } else {
                                            Image(systemName: "chevron.right")
                                                .foregroundColor(.gray)
                                        }
                                    }
                                    .padding()
                                    .background(Color.white.opacity(0.05))
                                    .cornerRadius(12)
                                }
                                .disabled(viewModel.isLoading)
                                
                                Button(action: { viewModel.exportFullData() }) {
                                    HStack {
                                        Image(systemName: "archivebox.fill")
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text("Export Full Data")
                                                .fontWeight(.semibold)
                                            Text("Account info + transactions")
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                        }
                                        Spacer()
                                        if viewModel.isLoading {
                                            ProgressView()
                                                .scaleEffect(0.8)
                                        } else {
                                            Image(systemName: "chevron.right")
                                                .foregroundColor(.gray)
                                        }
                                    }
                                    .padding()
                                    .background(Color.white.opacity(0.05))
                                    .cornerRadius(12)
                                }
                                .disabled(viewModel.isLoading)
                            }
                            
                            // Show exported CSV
                            if let csv = viewModel.exportedCSV {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Exported CSV Preview")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                    
                                    ScrollView(.horizontal) {
                                        Text(csv)
                                            .font(.system(.caption, design: .monospaced))
                                            .foregroundColor(.cyan)
                                            .padding(12)
                                            .background(Color.black.opacity(0.3))
                                            .cornerRadius(8)
                                    }
                                    .frame(height: 120)
                                    
                                    HStack(spacing: 12) {
                                        Button(action: { viewModel.copyToClipboard(csv) }) {
                                            HStack {
                                                Image(systemName: "doc.on.doc.fill")
                                                Text("Copy")
                                            }
                                            .frame(maxWidth: .infinity)
                                            .padding(10)
                                            .background(Color.blue.opacity(0.2))
                                            .foregroundColor(.blue)
                                            .cornerRadius(8)
                                        }
                                    }
                                }
                                .padding()
                                .background(Color.white.opacity(0.05))
                                .cornerRadius(12)
                            }
                        }
                        .padding(.horizontal)
                        
                        // Import Section
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Image(systemName: "arrow.down.doc.fill")
                                    .foregroundColor(.green)
                                Text("Import Data")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                Spacer()
                            }
                            .foregroundColor(.white)
                            
                            VStack(spacing: 12) {
                                Text("Paste CSV content below and import transactions")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                
                                TextEditor(text: $importedCSVContent)
                                    .frame(height: 150)
                                    .padding(8)
                                    .background(Color.white.opacity(0.05))
                                    .cornerRadius(8)
                                    .foregroundColor(.white)
                                
                                Button(action: {
                                    viewModel.importTransactionsFromCSV(importedCSVContent)
                                    importedCSVContent = ""
                                }) {
                                    HStack {
                                        Image(systemName: "arrowshape.down.fill")
                                        Text("Import Transactions")
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(12)
                                    .background(LinearGradient(
                                        gradient: Gradient(colors: [Color.green, Color.cyan]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    ))
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                                }
                                .disabled(viewModel.isLoading || importedCSVContent.trimmingCharacters(in: .whitespaces).isEmpty)
                            }
                        }
                        .padding()
                        .background(Color.white.opacity(0.05))
                        .cornerRadius(12)
                        .padding(.horizontal)
                        
                        // Info Section
                        VStack(alignment: .leading, spacing: 12) {
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Image(systemName: "info.circle.fill")
                                        .foregroundColor(.cyan)
                                    Text("CSV Format")
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                }
                                .foregroundColor(.white)
                                
                                Text("For import, use the following CSV format:\nID,Title,Description,Amount,Type,Date,Category,Merchant\n\nTypes: debit, credit, transfer\nCategories: groceries, dining, transport, utilities, entertainment, other")
                                    .font(.caption2)
                                    .foregroundColor(.gray)
                                    .lineLimit(10)
                            }
                            .padding()
                            .background(Color.cyan.opacity(0.1))
                            .cornerRadius(8)
                        }
                        .padding(.horizontal)
                        .padding(.bottom)
                    }
                }
            }
        }
    }
}

#Preview {
    CSVImportExportView(viewModel: CSVImportExportViewModel(dataManager: BankingDataManager()))
}
