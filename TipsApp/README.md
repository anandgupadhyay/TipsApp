# Tips App – SwiftUI Learning Project

Tips App is a modern, open-source tip calculator built with SwiftUI and SwiftData. It is designed as a learning project for developers who want to explore best practices in SwiftUI, data persistence, and app architecture.

## Features

- **Calculate Tips Easily:** Enter your bill amount and instantly see tip and total calculations.
- **Customizable Tip Options:** Choose from common tip percentages, quick tip buttons ($5, $10, $20), or enter a custom tip amount.
- **Split Bill:** Adjust the number of people to split the bill and see per-person amounts.
- **Experience-Based Tips:** Select service experience (Excellent, Good, Average, Poor) to auto-set tip percentage.
- **Payment Methods:** Choose how you paid (Cash, Card, QR, Digital Wallet, etc.).
- **QR Payment:** Scan a QR code for payment (demo implementation).
- **History:** View, search, and filter your past tip calculations.
- **Edit & Share:** Edit saved calculations or share them via message, email, or social media. Export as PDF/CSV.
- **Notes:** Add notes to any calculation for future reference.

## Screenshots

*Add screenshots here if available.*

## Getting Started

1. **Clone the repository:**
   ```bash
   git clone <repo-url>
   ```
2. **Open in Xcode:**
   Open `TipsApp.xcodeproj` in Xcode 15 or later.
3. **Build & Run:**
   Select a simulator or device and run the app.

## Project Structure

- `TipsApp/Models/` – Data models (e.g., `TipCalculation.swift`)
- `TipsApp/Views/` – All SwiftUI views (calculator, history, detail, edit, share, QR scanner)
- `TipsApp/ContentView.swift` – Main entry point, loads the calculator
- `TipsAppApp.swift` – App lifecycle and model container

## How to Use

1. **Calculate a Tip:**
   - Enter the bill amount.
   - Select a tip percentage, quick tip, or enter a custom tip.
   - Adjust the number of people to split the bill.
   - Choose your payment method and service experience.
   - Add notes if desired.
   - Tap "Save Calculation" to store it in history.
2. **View History:**
   - Tap the clock icon to view, search, filter, edit, or share past calculations.
3. **Pay via QR:**
   - Select QR as payment method to open the QR scanner (demo only).

## Learning Highlights

- SwiftUI best practices: modular views, state management, navigation
- SwiftData for persistence
- Custom UI components and theming
- QR code scanning (demo)
- Sharing and exporting data
- Accessibility and UX considerations

## Contributing

Contributions are welcome! Please open issues or pull requests for improvements, bug fixes, or new features.

## License

MIT License. See [LICENSE](LICENSE) for details.

---

*This project is for educational purposes and is not intended for production use. Payment and QR features are for demonstration only.* 