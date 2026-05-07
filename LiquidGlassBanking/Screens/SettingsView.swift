import SwiftUI

// MARK: - Settings & Material Showcase Screen
/// Comparison of Material styles with explanations and interactive examples
struct SettingsView: View {
    let viewModel: SettingsViewModel
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.accessibilityReduceMotion) var reduceMotion
    @State private var selectedTab: SettingsTab = .general
    
    enum SettingsTab {
        case materials
        case general
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.purple.opacity(0.1),
                        Color.pink.opacity(0.05)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Tab selection - Uses .regular Material
                        HStack(spacing: 0) {
                            Button(action: { selectedTab = .materials }) {
                                Text("Materials")
                                    .fontWeight(.semibold)
                                    .frame(maxWidth: .infinity)
                                    .padding(12)
                                    .background(selectedTab == .materials ? Color.blue.opacity(0.2) : Color.clear)
                                    .cornerRadius(8)
                            }
                            
                            Button(action: { selectedTab = .general }) {
                                Text("General")
                                    .fontWeight(.semibold)
                                    .frame(maxWidth: .infinity)
                                    .padding(12)
                                    .background(selectedTab == .general ? Color.blue.opacity(0.2) : Color.clear)
                                    .cornerRadius(8)
                            }
                        }
                        .padding(6)
                        .background(Material.regular)
                        .cornerRadius(10)
                        .padding(.horizontal, 16)
                        
                        // Tab content
                        if selectedTab == .materials {
                            MaterialsTabContent()
                        } else {
                            GeneralTabContent()
                        }
                    }
                    .padding(.vertical, 16)
                }
            }
            .navigationTitle("Settings")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
        }
    }
}

// MARK: - Materials Tab Content
struct MaterialsTabContent: View {
    @Environment(\.accessibilityReduceMotion) var reduceMotion
    @State private var interactiveOpacity = 1.0
    @State private var selectedMaterial: MaterialType = .regular
    
    enum MaterialType {
        case thin
        case regular
        case thick
    }
    
    var body: some View {
        VStack(spacing: 20) {
            // Header
            VStack(alignment: .leading, spacing: 8) {
                Text("Glass Material Styles")
                    .font(.title2)
                    .fontWeight(.semibold)
                Text("Understand when to use each material type for optimal UX")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)
            
            // Interactive Opacity Control
            VStack(spacing: 12) {
                Text("Interactive Material Preview")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Slider(value: $interactiveOpacity, in: 0...1)
                    .padding(.horizontal, 16)
                
                HStack(spacing: 12) {
                    ForEach([0.3, 0.6, 1.0], id: \.self) { opacity in
                        Button(action: { interactiveOpacity = opacity }) {
                            Text(String(format: "%.0f%%", opacity * 100))
                                .font(.caption)
                                .fontWeight(.semibold)
                                .padding(8)
                                .background(interactiveOpacity == opacity ? Color.blue.opacity(0.3) : Color.gray.opacity(0.2))
                                .cornerRadius(6)
                        }
                    }
                    Spacer()
                }
                .padding(.horizontal, 16)
            }
            
            // Material Examples with Interactive Demonstration
            VStack(spacing: 16) {
                // THIN Material Example
                MaterialExampleCard(
                    title: "Material.thin",
                    description: "Use for: Subtle backgrounds, dense layouts, non-intrusive indicators",
                    examples: [
                        ("Badges", "Indicators"),
                        ("Progress", "Secondary info"),
                        ("Dividers", "Separators")
                    ],
                    isSelected: selectedMaterial == .thin,
                    material: .thin,
                    opacity: interactiveOpacity
                )
                .onTapGesture {
                    if reduceMotion {
                        selectedMaterial = .thin
                    } else {
                        withAnimation(.easeInOut) {
                            selectedMaterial = .thin
                        }
                    }
                }
                
                // REGULAR Material Example
                MaterialExampleCard(
                    title: "Material.regular",
                    description: "Use for: Standard cards, forms, balanced visibility (DEFAULT)",
                    examples: [
                        ("Cards", "Containers"),
                        ("Input Fields", "Modals"),
                        ("Lists", "Navigation")
                    ],
                    isSelected: selectedMaterial == .regular,
                    material: .regular,
                    opacity: interactiveOpacity
                )
                .onTapGesture {
                    if reduceMotion {
                        selectedMaterial = .regular
                    } else {
                        withAnimation(.easeInOut) {
                            selectedMaterial = .regular
                        }
                    }
                }
                
                // THICK Material Example
                MaterialExampleCard(
                    title: "Material.thick",
                    description: "Use for: Primary actions, modals, high emphasis components",
                    examples: [
                        ("Buttons", "Primary CTA"),
                        ("Modals", "Overlays"),
                        ("Headers", "Key info")
                    ],
                    isSelected: selectedMaterial == .thick,
                    material: .thick,
                    opacity: interactiveOpacity
                )
                .onTapGesture {
                    if reduceMotion {
                        selectedMaterial = .thick
                    } else {
                        withAnimation(.easeInOut) {
                            selectedMaterial = .thick
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
            
            // Animation Techniques Section
            VStack(spacing: 12) {
                Text("Animation & Interaction Techniques")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 16)
                
                GlassCard(material: .regular) {
                    VStack(alignment: .leading, spacing: 8) {
                        TechniqueItem(
                            icon: "square.and.arrow.up",
                            title: "Tap Expansion",
                            description: "Cards scale to 0.98 on tap for feedback"
                        )
                        Divider()
                        TechniqueItem(
                            icon: "arrow.up.and.down",
                            title: "Slide Transitions",
                            description: "Content slides in from edges with opacity fade"
                        )
                        Divider()
                        TechniqueItem(
                            icon: "hand.raised",
                            title: "Gesture Response",
                            description: "Glass effects respond to long-press and drag"
                        )
                        Divider()
                        TechniqueItem(
                            icon: "waveform",
                            title: "Smooth Easing",
                            description: "EaseInOut timing for natural feel (0.2-0.6s)"
                        )
                    }
                }
                .padding(.horizontal, 16)
            }
        }
    }
}

// MARK: - Material Example Card
struct MaterialExampleCard: View {
    let title: String
    let description: String
    let examples: [(String, String)]
    let isSelected: Bool
    let material: Material
    let opacity: Double
    
    var body: some View {
        GlassCard(
            material: isSelected ? .thick : material,
            isInteractive: true
        ) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(title)
                            .font(.headline)
                            .fontWeight(.semibold)
                        Text(description)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    if isSelected {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.blue)
                    }
                }
                
                GlassDivider()
                
                VStack(spacing: 8) {
                    ForEach(examples, id: \.0) { example in
                        HStack {
                            Text(example.0)
                                .font(.caption)
                                .fontWeight(.semibold)
                            Spacer()
                            GlassBadge(
                                text: example.1,
                                icon: "checkmark",
                                backgroundColor: .blue
                            )
                        }
                    }
                }
            }
        }
        .opacity(opacity)
    }
}

// MARK: - Technique Item
struct TechniqueItem: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.body)
                .foregroundColor(.blue)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .fontWeight(.semibold)
                Text(description)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
    }
}

// MARK: - General Tab Content
struct GeneralTabContent: View {
    @Environment(BankingDataManager.self) var dataManager
    
    var body: some View {
        VStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text("App Settings")
                    .font(.title2)
                    .fontWeight(.semibold)
                Text("Configure your banking app preferences")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)
            
            // Settings sections
            SettingsSectionView(title: "Notifications") {
                SettingsToggleItem(label: "Push Notifications", value: .constant(true))
                SettingsToggleItem(label: "Transaction Alerts", value: .constant(true))
                SettingsToggleItem(label: "Security Alerts", value: .constant(true))
            }
            
            SettingsSectionView(title: "Security") {
                SettingsItem(label: "Biometric Login", value: "Face ID")
                SettingsItem(label: "PIN Protection", value: "Enabled")
                SettingsItem(label: "Session Timeout", value: "15 minutes")
            }
            
            // Data Management section
            VStack(alignment: .leading, spacing: 8) {
                Text("Data Management")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                NavigationLink(destination: CSVImportExportView(viewModel: CSVImportExportViewModel(dataManager: dataManager))) {
                    HStack {
                        Image(systemName: "arrow.left.arrow.right")
                            .foregroundColor(.green)
                            .frame(width: 24)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Import/Export CSV")
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                            Text("Backup or restore your transaction data")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                    }
                    .padding(12)
                    .background(Color.white.opacity(0.05))
                    .cornerRadius(8)
                }
            }
            .padding(.horizontal, 16)
            
            SettingsSectionView(title: "About") {
                SettingsItem(label: "App Version", value: "1.0.0")
                SettingsItem(label: "Build", value: "Build 2026.04.28")
                SettingsItem(label: "Last Updated", value: "Apr 28, 2026")
            }
        }
        .padding(.horizontal, 16)
    }
}

// MARK: - Settings Components
struct SettingsSectionView<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
            
            GlassCard(material: .regular) {
                content
            }
        }
    }
}

struct SettingsItem: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.body)
            Spacer()
            Text(value)
                .font(.body)
                .foregroundColor(.secondary)
        }
        .padding(12)
    }
}

struct SettingsToggleItem: View {
    let label: String
    @Binding var value: Bool
    
    var body: some View {
        HStack {
            Text(label)
                .font(.body)
            Spacer()
            Toggle("", isOn: $value)
        }
        .padding(12)
    }
}
