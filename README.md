# PanesExample

A SwiftUI example project demonstrating how to build an Xcode-like three-pane layout with collapsible, resizable sidebars that work across macOS, iOS, and iPadOS.

## Overview

This project provides a clean, reusable implementation of a three-pane interface pattern commonly seen in professional apps like Xcode. It's designed as a learning resource for developers who want to understand how to build complex, responsive layouts in SwiftUI.

## Features

### ✨ Core Functionality

- **Three-Pane Layout**: Left navigator, center editor, and right inspector panes
- **Collapsible Sidebars**: Toggle left and right panes with smooth animations
- **Resizable Panes**: Drag dividers to adjust pane widths with min/max constraints
- **State Persistence**: Pane visibility and sizes are remembered across app launches
- **Cross-Platform**: Works seamlessly on macOS, iPhone, and iPad

### 🎨 UI Features

- Native system colors that adapt to light/dark mode
- Smooth animations for opening/closing panes
- Resize cursor indicators (macOS only)
- Minimum and maximum pane width constraints (150px - 600px)
- Window resizing support with responsive layouts

### 💾 State Management

- Uses `@AppStorage` for automatic persistence to UserDefaults
- Remembers:
  - Left pane open/closed state
  - Right pane open/closed state
  - Custom pane widths

## Requirements

- **Xcode**: 15.0 or later
- **iOS**: 17.0+
- **macOS**: 14.0+
- **Swift**: 5.9+

## Installation

1. Clone the repository:

```bash
git clone https://github.com/yourusername/PanesExample.git
cd PanesExample
```

2. Open the project in Xcode:

```bash
open PanesExample.xcodeproj
```

3. Select your target platform (macOS, iPhone, or iPad) and run!

## How It Works

### Architecture

The project is structured around several key SwiftUI components:

#### `ContentView`

The main view containing the three-pane layout with state management:

```swift
@AppStorage("isLeftPaneVisible") private var isLeftPaneVisible = false
@AppStorage("isRightPaneVisible") private var isRightPaneVisible = false
```

#### `LeftPaneView`

Displays a file navigator similar to Xcode's project navigator.

#### `EditorPaneView`

The center pane showing a mock code editor with line numbers.

#### `RightPaneView`

Shows an inspector panel with file properties and settings.

#### `DividerView`

A custom resizable divider using drag gestures:

- Tracks start width on drag begin
- Updates pane width during drag
- Enforces min/max constraints
- Automatically persists changes via `@AppStorage`

### Platform-Specific Code

The project uses conditional compilation to handle platform differences:

```swift
#if os(macOS)
// macOS-specific code (NSColor, NSCursor)
#else
// iOS/iPadOS-specific code (UIColor)
#endif
```

Platform-specific color extensions ensure the UI looks native on each platform.

### State Persistence

Pane states are automatically saved using SwiftUI's `@AppStorage`:

```swift
@AppStorage("isLeftPaneVisible") private var isLeftPaneVisible = false
```

This leverages UserDefaults to persist state across app launches without any additional code.

## Key Learning Points

### 1. **Resizable Dividers**

Learn how to implement draggable dividers using `DragGesture`:

- Store start width to prevent accumulation bugs
- Use translation values correctly
- Apply constraints (min/max)

### 2. **Conditional Views**

See how to conditionally show/hide views with smooth animations:

```swift
if isLeftPaneVisible {
    LeftPaneView()
}
```

### 3. **Cross-Platform SwiftUI**

Understand how to write code that works across macOS and iOS:

- Platform-specific imports
- Conditional compilation
- Abstract platform differences with extensions

### 4. **State Management**

Learn proper state management patterns:

- `@State` for local view state
- `@AppStorage` for persistent preferences
- `@Binding` for passing state to child views

### 5. **Custom Modifiers**

See how to create reusable view modifiers (like the cursor modifier for macOS).

## Customization

### Changing Default Pane Widths

Edit the constants in `ContentView`:

```swift
@AppStorage("leftPaneWidth") private var leftPaneWidth: Double = 250
@AppStorage("rightPaneWidth") private var rightPaneWidth: Double = 300
```

### Adjusting Min/Max Constraints

Modify these values in `ContentView`:

```swift
let minPaneWidth: Double = 150
let maxPaneWidth: Double = 600
```

### Customizing Colors

Update the platform color extensions to use your own colors:

```swift
extension Color {
    static var platformBackground: Color {
        // Your custom color logic
    }
}
```

## Project Structure

```
PanesExample/
├── PanesExample/
│   ├── PanesExampleApp.swift      # App entry point
│   ├── ContentView.swift           # Main three-pane layout
│   └── Assets.xcassets/           # App assets
├── PanesExample.xcodeproj/        # Xcode project
└── README.md                       # This file
```

## Building for Different Platforms

### macOS

```bash
xcodebuild -project PanesExample.xcodeproj -scheme PanesExample \
  -destination 'platform=macOS' build
```

### iOS Simulator

```bash
xcodebuild -project PanesExample.xcodeproj -scheme PanesExample \
  -destination 'platform=iOS Simulator,name=iPhone 16 Pro' build
```

### iPad Simulator

```bash
xcodebuild -project PanesExample.xcodeproj -scheme PanesExample \
  -destination 'platform=iOS Simulator,name=iPad Pro 13-inch (M4)' build
```

## Common Issues

### Issue: Colors don't look right

**Solution**: Make sure you're using the platform-specific color extensions provided in the project.

### Issue: Pane sizes aren't persisting

**Solution**: Check that you're using `@AppStorage` instead of `@State` for width and visibility properties.

### Issue: Cursor doesn't change on macOS

**Solution**: The cursor modifier is wrapped in `#if os(macOS)` - ensure you're building for macOS.

## Contributing

Contributions are welcome! Here are some ways you can help:

- 🐛 Report bugs
- 💡 Suggest new features
- 📝 Improve documentation
- 🔧 Submit pull requests

Please feel free to open issues or submit PRs!

## Future Enhancements

Some ideas for extending this project:

- [ ] Add keyboard shortcuts (Cmd+0, Cmd+Option+0)
- [ ] Implement pane switching/tabs
- [ ] Add split view support in the editor pane
- [ ] Support for custom toolbar items
- [ ] Drag-and-drop between panes
- [ ] Custom animations and transitions
- [ ] Support for visionOS

## License

This project is released under the MIT License. See LICENSE file for details.

## Author

Created by Doug Diego as a learning resource for the SwiftUI community.

## Acknowledgments

- Inspired by Apple's Xcode interface design
- Built with SwiftUI and modern Swift concurrency

## Learn More

- [SwiftUI Documentation](https://developer.apple.com/documentation/swiftui/)
- [Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/)
- [App Storage Documentation](https://developer.apple.com/documentation/swiftui/appstorage)

---

⭐ If you find this project helpful, please consider giving it a star on GitHub!
