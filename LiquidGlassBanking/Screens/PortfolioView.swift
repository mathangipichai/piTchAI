import SwiftUI

// MARK: - Investment Portfolio Screen
/// Layered glass components showing stocks/assets with hover/tap interactions
struct PortfolioView: View {
    let viewModel: PortfolioViewModel
    @Environment(\.accessibilityReduceMotion) var reduceMotion
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.orange.opacity(0.1),
                    Color.yellow.opacity(0.05)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Investment Portfolio")
                            .font(.title2)
                            .fontWeight(.semibold)
                        Text("Manage your investments")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 16)
                    
                    // Portfolio Summary - Uses .thick Material for emphasis
                    GlassCard(material: .thick) {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Total Value")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            HStack(alignment: .firstTextBaseline, spacing: 8) {
                                Text(viewModel.formattedTotalValue)
                                    .font(.system(size: 28, weight: .bold, design: .default))
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    HStack(spacing: 4) {
                                        Image(systemName: viewModel.totalGainLoss >= 0 ? "arrow.up.right" : "arrow.down.left")
                                            .font(.caption)
                                        Text(viewModel.formattedGainLoss)
                                            .font(.caption)
                                            .fontWeight(.semibold)
                                    }
                                    .foregroundColor(viewModel.totalGainLoss >= 0 ? .green : .red)
                                    
                                    Text("Today")
                                        .font(.caption2)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .transition(.move(edge: .top))
                    
                    // Simple bar chart representation - Uses .regular Material
                    GlassCard(material: .regular) {
                        VStack(spacing: 12) {
                            Text("Holdings Distribution")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            VStack(spacing: 10) {
                                ForEach(viewModel.assets, id: \.id) { asset in
                                    HStack(spacing: 8) {
                                        Text(asset.symbol)
                                            .font(.caption)
                                            .fontWeight(.semibold)
                                            .frame(width: 50, alignment: .leading)
                                        
                                        GeometryReader { geometry in
                                            Capsule()
                                                .fill(
                                                    LinearGradient(
                                                        gradient: Gradient(colors: [.blue, .cyan]),
                                                        startPoint: .leading,
                                                        endPoint: .trailing
                                                    )
                                                )
                                                .frame(width: geometry.size.width * CGFloat(asset.currentValue / viewModel.totalValue))
                                        }
                                        .frame(height: 6)
                                        
                                        Text(String(format: "%.0f%%", (asset.currentValue / viewModel.totalValue) * 100))
                                            .font(.caption)
                                            .fontWeight(.semibold)
                                            .frame(width: 35, alignment: .trailing)
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    
                    // Portfolio Holdings List
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Holdings")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .padding(.horizontal, 16)
                        
                        VStack(spacing: 10) {
                            ForEach(viewModel.assets, id: \.id) { asset in
                                PortfolioAssetCardView(
                                    asset: asset,
                                    isSelected: viewModel.selectedAsset?.id == asset.id,
                                    onTap: {
                                        if reduceMotion {
                                            if viewModel.selectedAsset?.id == asset.id {
                                                viewModel.selectedAsset = nil
                                            } else {
                                                viewModel.selectedAsset = asset
                                            }
                                        } else {
                                            withAnimation(.easeInOut(duration: 0.3)) {
                                                if viewModel.selectedAsset?.id == asset.id {
                                                    viewModel.selectedAsset = nil
                                                } else {
                                                    viewModel.selectedAsset = asset
                                                }
                                            }
                                        }
                                    }
                                )
                                .padding(.horizontal, 16)
                                
                                if viewModel.selectedAsset?.id == asset.id {
                                    AssetDetailsView(asset: asset)
                                        .padding(.horizontal, 16)
                                        .transition(.move(edge: .top).combined(with: .opacity))
                                }
                            }
                        }
                    }
                }
                .padding(.vertical, 16)
            }
            .navigationTitle("Portfolio")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
        }
        .onAppear {
            if !reduceMotion {
                withAnimation(.easeOut(duration: 0.6)) {
                    viewModel.showChart = true
                }
            } else {
                viewModel.showChart = true
            }
        }
    }
}

// MARK: - Portfolio Asset Card View
struct PortfolioAssetCardView: View {
    let asset: PortfolioAsset
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        GlassCard(material: isSelected ? .thick : .regular, isInteractive: true) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(asset.symbol)
                            .font(.body)
                            .fontWeight(.semibold)
                        Text(asset.name)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text(asset.formattedValue)
                            .font(.body)
                            .fontWeight(.semibold)
                        Text("\(asset.quantity, format: .number) shares")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                if isSelected {
                    GlassDivider()
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Price")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text(String(format: "$%.2f", asset.currentPrice))
                                .font(.body)
                                .fontWeight(.semibold)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 4) {
                            Text("Gain/Loss")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text(asset.formattedGainLoss)
                                .font(.body)
                                .fontWeight(.semibold)
                                .foregroundColor(asset.gainLoss >= 0 ? .green : .red)
                        }
                    }
                }
            }
        }
        .onTapGesture(perform: onTap)
    }
}

// MARK: - Asset Details View
struct AssetDetailsView: View {
    let asset: PortfolioAsset
    
    var body: some View {
        GlassCard(material: .thin) {
            VStack(spacing: 12) {
                HStack {
                    Text("Purchase Price")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text(String(format: "$%.2f", asset.purchasePrice))
                        .font(.caption)
                        .fontWeight(.semibold)
                }
                
                HStack {
                    Text("Current Price")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text(String(format: "$%.2f", asset.currentPrice))
                        .font(.caption)
                        .fontWeight(.semibold)
                }
                
                HStack {
                    Text("Total Gain/Loss")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text(String(format: "$%+.2f", asset.gainLoss))
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(asset.gainLoss >= 0 ? .green : .red)
                }
            }
        }
    }
}
