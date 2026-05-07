import SwiftUI

@main
struct LiquidGlassBankingApp: App {
    @State private var dataManager = BankingDataManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(dataManager)
        }
    }
}

// MARK: - Main Navigation View
struct ContentView: View {
    @Environment(BankingDataManager.self) var dataManager
    @State private var selectedTab: Tab = .dashboard
    @Environment(\.horizontalSizeClass) var sizeClass
    
    enum Tab {
        case dashboard
        case payment
        case request
        case cards
        case portfolio
        case settings
    }
    
    var body: some View {
        ZStack {
            // Animated background gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(.sRGB, red: 0.1, green: 0.1, blue: 0.2, opacity: 1),
                    Color(.sRGB, red: 0.15, green: 0.1, blue: 0.25, opacity: 1)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            TabView(selection: $selectedTab) {
                DashboardView(viewModel: DashboardViewModel(dataManager: dataManager))
                    .tabItem {
                        Label("Home", systemImage: "house.fill")
                    }
                    .tag(Tab.dashboard)
                
                PaymentFlowView(viewModel: PaymentViewModel(dataManager: dataManager))
                    .tabItem {
                        Label("Send", systemImage: "paperplane.fill")
                    }
                    .tag(Tab.payment)
                
                RequestMenuView()
                    .tabItem {
                        Label("Request", systemImage: "arrow.down.doc.fill")
                    }
                    .tag(Tab.request)
                
                CardsMenuView()
                    .tabItem {
                        Label("Cards", systemImage: "creditcard.fill")
                    }
                    .tag(Tab.cards)
                
                PortfolioView(viewModel: PortfolioViewModel(dataManager: dataManager))
                    .tabItem {
                        Label("Portfolio", systemImage: "chart.line.uptrend.xyaxis")
                    }
                    .tag(Tab.portfolio)
                
                SettingsView(viewModel: SettingsViewModel(dataManager: dataManager))
                    .tabItem {
                        Label("Settings", systemImage: "gearshape.fill")
                    }
                    .tag(Tab.settings)
            }
            #if os(iOS)
            .tabViewStyle(.sidebarAdaptable)
            #endif
        }
        .preferredColorScheme(nil) // Respect system appearance
    }
}

// MARK: - Request Menu View
struct RequestMenuView: View {
    @Environment(BankingDataManager.self) var dataManager
    @State private var showRequestMoney = false
    @State private var showRequestFromContact = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Request Money")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                VStack(spacing: 12) {
                    NavigationLink(destination: RequestMoneyView(viewModel: RequestMoneyViewModel(dataManager: dataManager))) {
                        HStack {
                            Image(systemName: "arrow.down.doc.fill")
                                .font(.system(size: 20))
                                .foregroundColor(.cyan)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Request Payment")
                                    .fontWeight(.semibold)
                                Text("Request money from anyone")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .background(Color.white.opacity(0.05))
                        .cornerRadius(12)
                    }
                    
                    NavigationLink(destination: RequestFromContactView(viewModel: RequestFromContactViewModel(dataManager: dataManager))) {
                        HStack {
                            Image(systemName: "person.fill")
                                .font(.system(size: 20))
                                .foregroundColor(.purple)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Request from Contact")
                                    .fontWeight(.semibold)
                                Text("Select from your contacts")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .background(Color.white.opacity(0.05))
                        .cornerRadius(12)
                    }
                }
                
                Spacer()
            }
            .padding()
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
        }
    }
}

// MARK: - Cards Menu View
struct CardsMenuView: View {
    @Environment(BankingDataManager.self) var dataManager
    @State private var showVirtualCards = false
    @State private var showPhysicalCards = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Manage Cards")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                VStack(spacing: 12) {
                    NavigationLink(destination: VirtualCardsView(viewModel: VirtualCardsViewModel(dataManager: dataManager))) {
                        HStack {
                            Image(systemName: "creditcard.fill")
                                .font(.system(size: 20))
                                .foregroundColor(.blue)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Virtual Cards")
                                    .fontWeight(.semibold)
                                Text("Manage virtual card numbers")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .background(Color.white.opacity(0.05))
                        .cornerRadius(12)
                    }
                    
                    NavigationLink(destination: PhysicalCardsView(viewModel: PhysicalCardsViewModel(dataManager: dataManager))) {
                        HStack {
                            Image(systemName: "square.stack.3d.up.fill")
                                .font(.system(size: 20))
                                .foregroundColor(.green)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Physical Cards")
                                    .fontWeight(.semibold)
                                Text("Order and manage physical cards")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .background(Color.white.opacity(0.05))
                        .cornerRadius(12)
                    }
                }
                
                Spacer()
            }
            .padding()
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
        }
    }
}

#Preview {
    ContentView()
}
