# Liquid Glass Banking App

A pure SwiftUI sample application demonstrating the **Liquid Glass** UI design pattern in a Banking/Finance context. This app showcases interactive glassmorphism effects, smooth animations, Material style variations, and real-world use cases.

## Overview

This app demonstrates how frosted glass effects (glassmorphism) can enhance a modern banking interface while maintaining readability, accessibility, and visual hierarchy. It's built entirely in SwiftUI with no external dependencies.

### Key Features

✨ **Glassmorphism Design**
- Frosted glass cards with transparency and blur
- Semi-transparent overlays with layered depth
- Tinted glass backgrounds for light/dark modes

🎬 **Animations & Interactions**
- Smooth card slide-in/reveal animations
- Interactive tap-to-expand functionality
- Gesture-driven glass effect responses
- Progress indicators with animated transitions
- Balance change animations with spring physics

💳 **Real-World Banking Screens**
- **Dashboard**: Account overview with animated balance cards and transaction feed
- **Payment Flow**: Multi-step fund transfer with interactive glass modals
- **Investment Portfolio**: Stock holdings with interactive charts and details
- **Settings**: Material style showcase and app configuration
- **CSV Import/Export**: Backup and restore transaction data with comprehensive error handling

📊 **Data Management**
- Export transactions to CSV format for backup and analysis
- Import transactions from CSV files with validation
- Type-safe error handling with detailed error messages
- Full account data export with summary information

🎨 **Material Variations**
- `.thin`: Subtle backgrounds, badges, dividers
- `.regular`: Standard cards, forms, navigation (default)
- `.thick`: Primary actions, modals, key information

## Project Structure

```
LiquidGlassBanking/
├── LiquidGlassBankingApp.swift     # Main app entry point & navigation
├── Models/
│   ├── BankingModels.swift          # Account, Transaction, Portfolio data models
│   └── CSVError.swift               # CSV import/export error types
├── Managers/
│   └── CSVManager.swift             # CSV import/export functionality
├── Components/
│   └── GlassComponents.swift        # Reusable glass-effect components
├── ViewModels/
│   └── ScreenViewModels.swift       # View models for screens
└── Screens/
    ├── DashboardView.swift          # Home screen with balance & transactions
    ├── PaymentFlowView.swift        # Multi-step payment wizard
    ├── PortfolioView.swift          # Investment portfolio with charts
    ├── SettingsView.swift           # Settings & Material showcase
    └── CSVImportExportView.swift    # CSV import/export interface
```

## Material Selection Guide

### When to Use `.thin`
- **Badges & Indicators**: Status labels, priority indicators
- **Dividers**: Visual separators between sections
- **Secondary Information**: Subtitle text, timestamps
- **Dense Layouts**: Multiple components in limited space
- **Use Case**: `GlassBadge`, `GlassDivider`, progress indicators

```swift
// Example: Progress step indicator
HStack(spacing: 8) {
    ForEach(0..<4, id: \.self) { index in
        Capsule()
            .fill(stepColor)
            .frame(height: 4)
    }
}
.padding(12)
.background(.thin)  // ← Subtle, non-intrusive
```

### When to Use `.regular`
- **Standard Cards**: Transaction items, account summaries
- **Input Forms**: Text fields, selection fields
- **Lists**: Navigation items, menu options
- **Modal Content**: Dialogs with mixed importance
- **Default Choice**: Use this for most components
- **Use Case**: Most `GlassCard` instances, form fields

```swift
// Example: Transaction card
GlassCard(material: .regular) {  // ← Balanced visibility
    HStack {
        Text("Grocery Store")
        Spacer()
        Text("$124.50")
    }
}
```

### When to Use `.thick`
- **Primary Actions**: Main CTA buttons, confirm buttons
- **Modals & Overlays**: Full-screen modals requiring focus
- **Key Information**: Balance display, important account info
- **High Emphasis**: Critical sections needing prominence
- **Use Case**: Balance cards, confirmation screens, main modals

```swift
// Example: Account balance (primary information)
GlassCard(material: .thick) {  // ← High emphasis
    VStack {
        Text("Current Balance")
        Text("$12,458.50")
            .font(.system(size: 32, weight: .bold))
    }
}
```

## Animation Techniques

### 1. **Card Slide-In with Opacity Fade**
Used for dashboard cards appearing on screen load:

```swift
.offset(y: animateCards ? 0 : 20)  // Slide up 20 points
.opacity(animateCards ? 1 : 0.8)   // Fade in from 80% to 100%
.onAppear {
    withAnimation(.easeOut(duration: 0.6)) {
        animateCards = true
    }
}
```

### 2. **Tap to Expand with Scale Effect**
Interactive cards scale down slightly on tap:

```swift
GlassCard(material: .regular, isInteractive: true) {
    content
}
.scaleEffect(isPressed ? 0.98 : 1.0)  // Scale to 98% on press
.animation(.easeInOut(duration: 0.2), value: isPressed)
```

### 3. **Gesture-Driven Opacity Changes**
Glass intensity responds to user interaction:

```swift
Slider(value: $interactiveOpacity, in: 0...1)
// ...
.opacity(opacity)  // Updates glass transparency
```

### 4. **Smooth Transitions Between Steps**
Payment flow transitions:

```swift
withAnimation(.easeInOut(duration: 0.3)) {
    currentStep = .nextStep
}
```

### 5. **Spring Physics for Success Animation**
Success checkmark with bounce:

```swift
Image(systemName: "checkmark.circle.fill")
    .scaleEffect(0.8)
    .animation(.spring(response: 0.6, dampingFraction: 0.5), value: showSuccess)
```

### 6. **Progress Indicator Color Animation**
Step completion progress:

```swift
Capsule()
    .fill(getStepColor(for: step))  // Animates color
    .animation(.linear(duration: 0.3), value: currentStep)
```

## Building & Running

### Requirements
- Xcode 15.0+
- Swift 5.9+
- iOS 17+ or macOS 14+

### Build Instructions

#### Using Xcode (Recommended)
1. Open the project folder in Xcode:
   ```bash
   open -a Xcode .
   ```
2. Select your target (iOS Simulator or macOS)
3. Press `Cmd + R` to build and run

#### Using Swift Package Manager
```bash
# Build
swift build

# Run (requires Xcode project setup)
swift run
```

### Running on Different Platforms

**iOS Simulator:**
- Select iPhone 15 Pro (or any iOS 17+ simulator)
- Press `Cmd + R`

**macOS:**
- Select "My Mac" as the target
- Press `Cmd + R`

## Key Implementation Details

### 1. **Pure SwiftUI Implementation**
No external dependencies—entirely built with native SwiftUI framework:
- Material blur effects (`.thin`, `.regular`, `.thick`)
- Native animation APIs
- SwiftUI Gestures for interactivity

### 2. **Accessibility & Contrast**
- Glass backgrounds are semitransparent with sufficient contrast
- Text remains readable with proper color choices
- Alternative touch targets for interactive elements

### 3. **Dark & Light Mode Support**
All glass effects automatically adapt to system appearance:
```swift
@Environment(\.colorScheme) var colorScheme
// Colors automatically adjust for light/dark modes
```

### 4. **Modular Components**
Reusable glass components for consistency:
- `GlassCard`: Main container with customizable material
- `GlassModal`: Full-screen overlay with interactive dismiss
- `GlassBadge`: Small indicator with glass effect
- `ExpandableGlassCard`: Interactive expandable cards

### 5. **Real-World Data Models**
- **Account**: Checking account with balance
- **Transaction**: Debit/credit transactions with categories
- **PortfolioAsset**: Stock holdings with gain/loss tracking
- **MockDataStore**: Sample data for all components

## Interaction Patterns

### Dashboard
- **Tap balance card**: Could expand to show account details
- **Tap quick action buttons**: Send money, request funds, manage cards
- **Swipe transactions**: View detailed transaction information

### Payment Flow
- **Multi-step wizard**: Recipient → Amount → Review → Confirm
- **Tap to select**: Recipients, quick amounts
- **Gesture feedback**: Cards scale on interaction
- **Progress visualization**: Shows current step in payment process

### Portfolio
- **Tap asset card**: Expands to show detailed holdings
- **Animated chart**: Holdings distribution with smooth animations
- **Color indicators**: Green for gains, red for losses

### Settings
- **Material comparison**: Tap to switch between material examples
- **Opacity slider**: Interactively adjust glass transparency
- **Tab navigation**: Switch between Materials and General settings
- **Data Management**: Access CSV import/export functionality for transaction data

### CSV Import/Export
- **Export Transactions**: Download all transactions as CSV file
- **Export Full Data**: Backup account summary and all transactions
- **Import Transactions**: Restore transactions from CSV file with validation
- **Error Handling**: Type-safe error reporting with descriptive messages

## Customization

### Changing Material for Components
```swift
// Use .thin for subtle effect
GlassCard(material: .thin) { content }

// Use .regular for standard containers
GlassCard(material: .regular) { content }

// Use .thick for emphasis
GlassCard(material: .thick) { content }
```

### Adjusting Animation Durations
```swift
// Faster animations
withAnimation(.easeInOut(duration: 0.15)) {
    // Changes
}

// Slower animations
withAnimation(.easeOut(duration: 1.0)) {
    // Changes
}
```

### Modifying Colors
Update gradient backgrounds in each view:
```swift
LinearGradient(
    gradient: Gradient(colors: [
        Color.blue.opacity(0.1),
        Color.purple.opacity(0.05)
    ]),
    startPoint: .topLeading,
    endPoint: .bottomTrailing
)
```

## Performance Considerations

1. **Animate with Purpose**: Glass effects with unnecessary animations can reduce performance
2. **Use Appropriate Materials**: `.thick` has more blur overhead than `.thin`
3. **Optimize Gradients**: Complex gradients with many colors may impact performance
4. **Test on Devices**: Simulator performance differs from real devices

## Browser Compatibility

This is a native iOS/macOS app—no web browser deployment.

## CSV Import/Export Implementation

The app includes comprehensive CSV data management:

### Features
- **Export**: Convert transactions to CSV with proper field escaping
- **Import**: Parse CSV with validation and error reporting
- **Data Format**: ID, Title, Description, Amount, Type, Date, Category, Merchant
- **Error Types**: 
  - Empty file detection
  - Format validation (field count)
  - Type parsing (Amount, Type, Date, Category)
  - Detailed line-specific error messages

### Usage
1. Navigate to Settings → General tab
2. Tap "Import/Export CSV"
3. Choose Export or Import
4. For Export: Download CSV file with timestamp
5. For Import: Select CSV file and process with error feedback

## Future Enhancements

- Real API integration for actual banking data
- Touch ID/Face ID authentication
- Transaction filtering and search
- Wire transfer functionality
- Bill pay integration
- Budget tracking with glass-effect charts

## License

This sample app is provided as-is for educational purposes.

## Related Documentation

- [SwiftUI Material Documentation](https://developer.apple.com/documentation/swiftui/material)
- [SwiftUI Animations](https://developer.apple.com/documentation/swiftui/animation)
- [SwiftUI Gestures](https://developer.apple.com/documentation/swiftui/gestures)
- [Glassmorphism Design](https://www.nngroup.com/articles/glassmorphism/)

---

**Created**: April 28, 2026
**Swift Version**: 5.9+
**Minimum Deployment**: iOS 17, macOS 14
