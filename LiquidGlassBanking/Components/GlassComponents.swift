import SwiftUI

// MARK: - Glass Card Component
/// A reusable card component with glassmorphism effect.
/// Material Selection:
/// - .thin: Used for subtle backgrounds, less obstructive (recommended for dense layouts)
/// - .regular: Standard choice for balanced visibility (default for most components)
/// - .thick: Used for emphasis and high importance (recommended for primary actions)
struct GlassCard<Content: View>: View {
    let material: Material
    let content: Content
    var cornerRadius: CGFloat = 16
    var padding: CGFloat = 16
    var isInteractive: Bool = false
    @State private var isPressed = false
    
    init(
        material: Material = .regular,
        cornerRadius: CGFloat = 16,
        padding: CGFloat = 16,
        isInteractive: Bool = false,
        @ViewBuilder content: () -> Content
    ) {
        self.material = material
        self.cornerRadius = cornerRadius
        self.padding = padding
        self.isInteractive = isInteractive
        self.content = content()
    }
    
    var body: some View {
        content
            .padding(padding)
            .background(material)
            .cornerRadius(cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
            )
            .scaleEffect(isPressed && isInteractive ? 0.98 : 1.0)
            .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
            .animation(.easeInOut(duration: 0.2), value: isPressed)
    }
}

// MARK: - Glass Modal View
/// An interactive glass overlay modal with dismiss capability.
/// Material: .thick is used here for emphasis and to ensure content is readable over background
struct GlassModal<Content: View>: View {
    @State private var isPresented: Bool
    let title: String
    let content: Content
    var onDismiss: () -> Void = {}
    
    init(
        isPresented: Bool,
        title: String,
        onDismiss: @escaping () -> Void = {},
        @ViewBuilder content: () -> Content
    ) {
        self._isPresented = State(initialValue: isPresented)
        self.title = title
        self.onDismiss = onDismiss
        self.content = content()
    }
    
    var body: some View {
        ZStack {
            if isPresented {
                // Dimmed background with animation
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .transition(.opacity)
                    .onTapGesture {
                        dismissModal()
                    }
                
                // Glass modal card - uses .thick Material for emphasis
                VStack(spacing: 16) {
                    HStack {
                        Text(title)
                            .font(.headline)
                            .fontWeight(.semibold)
                        Spacer()
                        Button(action: dismissModal) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.title2)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    content
                    
                    Spacer()
                }
                .padding(20)
                .background(Material.thick)
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white.opacity(0.3), lineWidth: 1.5)
                )
                .padding(20)
                .shadow(color: Color.black.opacity(0.25), radius: 16, x: 0, y: 8)
                .transition(.scale.combined(with: .opacity))
            }
        }
        .animation(.easeInOut(duration: 0.3), value: isPresented)
    }
    
    private func dismissModal() {
        isPresented = false
        onDismiss()
    }
}

// MARK: - Glass Badge
/// A small badge component with glass effect for status indicators.
/// Material: .thin is ideal here for subtle, non-intrusive indicators
struct GlassBadge: View {
    let text: String
    let icon: String?
    let backgroundColor: Color
    var material: Material = .thin
    
    var body: some View {
        HStack(spacing: 6) {
            if let icon = icon {
                Image(systemName: icon)
                    .font(.caption)
            }
            Text(text)
                .font(.caption2)
                .fontWeight(.semibold)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(backgroundColor.opacity(0.3))
        .background(material)
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.white.opacity(0.2), lineWidth: 0.5)
        )
    }
}

// MARK: - Glass Divider
/// A frosted glass divider for visual separation.
/// Material: .thin for a subtle separator that doesn't dominate the layout
struct GlassDivider: View {
    var axis: Axis.Set = .horizontal
    var material: Material = .thin
    
    var body: some View {
        if axis == .horizontal {
            Divider()
                .overlay(Color.white.opacity(0.2))
                .frame(height: 1)
                .background(material)
        } else {
            Divider()
                .overlay(Color.white.opacity(0.2))
                .frame(width: 1)
                .background(material)
        }
    }
}

// MARK: - Expandable Glass Card
/// Interactive expandable card with glass effect and animation.
/// Demonstrates gesture-driven opacity and blur changes
struct ExpandableGlassCard: View {
    let title: String
    let subtitle: String
    let content: String
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .fontWeight(.semibold)
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .rotationEffect(.degrees(isExpanded ? 90 : 0))
            }
            .padding(16)
            .contentShape(Rectangle())
            .onTapGesture {
                withAnimation(.easeInOut(duration: 0.3)) {
                    isExpanded.toggle()
                }
            }
            
            if isExpanded {
                GlassDivider()
                
                Text(content)
                    .font(.body)
                    .lineLimit(nil)
                    .padding(16)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .background(Material.regular) // .regular Material for balanced visibility
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.2), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
    }
}

// MARK: - Material Comparison View (for Settings/Material Showcase)
/// Demonstrates the three Material options side-by-side with explanations
struct MaterialShowcase: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Material Styles Guide")
                .font(.title2)
                .fontWeight(.semibold)
            
            // Thin Material Example
            VStack(alignment: .leading, spacing: 8) {
                Text("Material.thin")
                    .font(.headline)
                Text("Use for: Subtle backgrounds, dense layouts, non-intrusive indicators")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                HStack {
                    Text("Light frosted glass effect")
                        .padding(12)
                        .background(Material.thin)
                        .cornerRadius(8)
                    Spacer()
                }
            }
            .padding(12)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
            
            // Regular Material Example
            VStack(alignment: .leading, spacing: 8) {
                Text("Material.regular")
                    .font(.headline)
                Text("Use for: Standard cards, forms, balanced visibility (DEFAULT)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                HStack {
                    Text("Standard blur intensity")
                        .padding(12)
                        .background(Material.regular)
                        .cornerRadius(8)
                    Spacer()
                }
            }
            .padding(12)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
            
            // Thick Material Example
            VStack(alignment: .leading, spacing: 8) {
                Text("Material.thick")
                    .font(.headline)
                Text("Use for: Primary actions, modals, high emphasis components")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                HStack {
                    Text("Heavy frosted glass effect")
                        .padding(12)
                        .background(Material.thick)
                        .cornerRadius(8)
                    Spacer()
                }
            }
            .padding(12)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
            
            Spacer()
        }
        .padding(16)
    }
}
