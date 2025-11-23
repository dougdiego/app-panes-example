//
//  ContentView.swift
//  PanesExample
//
//  Created by Doug Diego on 10/13/25.
//

import SwiftUI

#if os(macOS)
import AppKit
#endif

// MARK: - Platform Colors
extension Color {
    static var platformBackground: Color {
        #if os(macOS)
        return Color(NSColor.controlBackgroundColor)
        #else
        return Color(uiColor: .systemGroupedBackground)
        #endif
    }
    
    static var platformWindowBackground: Color {
        #if os(macOS)
        return Color(NSColor.windowBackgroundColor)
        #else
        return Color(uiColor: .systemBackground)
        #endif
    }
    
    static var platformTextBackground: Color {
        #if os(macOS)
        return Color(NSColor.textBackgroundColor)
        #else
        return Color(uiColor: .systemBackground)
        #endif
    }
    
    static var platformSeparator: Color {
        #if os(macOS)
        return Color(NSColor.separatorColor)
        #else
        return Color(uiColor: .separator)
        #endif
    }
}

struct ContentView: View {
    @AppStorage("isLeftPaneVisible") private var isLeftPaneVisible = false
    @AppStorage("isRightPaneVisible") private var isRightPaneVisible = false
    @AppStorage("leftPaneWidth") private var leftPaneWidth: Double = 250
    @AppStorage("rightPaneWidth") private var rightPaneWidth: Double = 300
    
    let minPaneWidth: Double = 150
    let maxPaneWidth: Double = 600
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                // Left Pane
                if isLeftPaneVisible {
                    LeftPaneView()
                        .frame(width: leftPaneWidth)
                        .background(Color.platformBackground)
                    
                    // Left Divider
                    DividerView(width: $leftPaneWidth, minWidth: minPaneWidth, maxWidth: maxPaneWidth)
                }
                
                // Center Pane (Editor)
                VStack(spacing: 0) {
                    // Toolbar
                    ToolbarView(
                        isLeftPaneVisible: $isLeftPaneVisible,
                        isRightPaneVisible: $isRightPaneVisible
                    )
                    .frame(height: 40)
                    .background(Color.platformWindowBackground)
                    
                    Divider()
                    
                    // Editor Content
                    EditorPaneView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                
                // Right Pane
                if isRightPaneVisible {
                    // Right Divider
                    DividerView(width: $rightPaneWidth, minWidth: minPaneWidth, maxWidth: maxPaneWidth, isRightPane: true)
                    
                    RightPaneView()
                        .frame(width: rightPaneWidth)
                        .background(Color.platformBackground)
                }
            }
        }
        .frame(minWidth: 400, minHeight: 300)
    }
}

// MARK: - Toolbar View
struct ToolbarView: View {
    @Binding var isLeftPaneVisible: Bool
    @Binding var isRightPaneVisible: Bool
    
    var body: some View {
        HStack {
            // Left sidebar toggle
            Button(action: {
                withAnimation(.easeInOut(duration: 0.2)) {
                    isLeftPaneVisible.toggle()
                }
            }) {
                Image(systemName: "sidebar.left")
                    .foregroundColor(isLeftPaneVisible ? .accentColor : .secondary)
            }
            .buttonStyle(.plain)
            .help("Toggle Left Sidebar")
            
            Spacer()
            
            Text("ContentView.swift")
                .font(.headline)
            
            Spacer()
            
            // Right sidebar toggle
            Button(action: {
                withAnimation(.easeInOut(duration: 0.2)) {
                    isRightPaneVisible.toggle()
                }
            }) {
                Image(systemName: "sidebar.right")
                    .foregroundColor(isRightPaneVisible ? .accentColor : .secondary)
            }
            .buttonStyle(.plain)
            .help("Toggle Right Sidebar")
        }
        .padding(.horizontal, 12)
    }
}

// MARK: - Left Pane View
struct LeftPaneView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Navigator header
            HStack {
                Text("Navigator")
                    .font(.headline)
                    .foregroundColor(.secondary)
                Spacer()
            }
            .padding(12)
            .background(Color.platformBackground)
            
            Divider()
            
            // Navigator content
            ScrollView {
                VStack(alignment: .leading, spacing: 4) {
                    NavigatorItemView(icon: "folder", name: "PanesExample", level: 0)
                    NavigatorItemView(icon: "folder", name: "PanesExample", level: 1, isExpanded: true)
                    NavigatorItemView(icon: "folder.fill", name: "Assets", level: 2)
                    NavigatorItemView(icon: "swift", name: "ContentView", level: 2, isSelected: true)
                    NavigatorItemView(icon: "swift", name: "PanesExampleApp", level: 2)
                }
                .padding(8)
            }
        }
    }
}

// MARK: - Navigator Item View
struct NavigatorItemView: View {
    let icon: String
    let name: String
    let level: Int
    var isExpanded: Bool = false
    var isSelected: Bool = false
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .foregroundColor(isSelected ? .white : .accentColor)
                .frame(width: 16)
            Text(name)
                .font(.system(size: 12))
                .foregroundColor(isSelected ? .white : .primary)
        }
        .padding(.leading, CGFloat(level * 16 + 4))
        .padding(.vertical, 2)
        .padding(.horizontal, 4)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(isSelected ? Color.accentColor : Color.clear)
        .cornerRadius(4)
    }
}

// MARK: - Editor Pane View
struct EditorPaneView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                ForEach(1...25, id: \.self) { lineNumber in
                    HStack(alignment: .top, spacing: 12) {
                        // Line numbers
                        Text("\(lineNumber)")
                            .font(.system(size: 12, design: .monospaced))
                            .foregroundColor(.secondary)
                            .frame(width: 30, alignment: .trailing)
                        
                        // Code content
                        Text(getCodeLine(for: lineNumber))
                            .font(.system(size: 12, design: .monospaced))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 1)
                    .background(lineNumber == 23 ? Color.accentColor.opacity(0.15) : Color.clear)
                }
            }
            .padding(.vertical, 8)
        }
        .background(Color.platformTextBackground)
    }
    
    func getCodeLine(for line: Int) -> String {
        switch line {
        case 1: return "//"
        case 2: return "//  ContentView.swift"
        case 3: return "//  PanesExample"
        case 4: return "//"
        case 5: return "//  Created by Doug Diego on 10/13/25."
        case 6: return "//"
        case 7: return ""
        case 8: return "import SwiftUI"
        case 9: return ""
        case 10: return "struct ContentView: View {"
        case 11: return "    var body: some View {"
        case 12: return "        VStack {"
        case 13: return "            Image(systemName: \"globe\")"
        case 14: return "                .imageScale(.large)"
        case 15: return "                .foregroundStyle(.tint)"
        case 16: return "            Text(\"Hello, world!\")"
        case 17: return "        }"
        case 18: return "        .padding()"
        case 19: return "    }"
        case 20: return "}"
        case 21: return ""
        case 22: return "#Preview {"
        case 23: return "    ContentView()"
        case 24: return "}"
        case 25: return ""
        default: return ""
        }
    }
}

// MARK: - Right Pane View
struct RightPaneView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Inspector header
            HStack {
                Text("Inspector")
                    .font(.headline)
                    .foregroundColor(.secondary)
                Spacer()
            }
            .padding(12)
            .background(Color.platformBackground)
            
            Divider()
            
            // Inspector content
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    InspectorSection(title: "Identity and Type") {
                        InspectorRow(label: "Name", value: "ContentView.swift")
                        InspectorRow(label: "Type", value: "Default - Swift Source")
                        InspectorRow(label: "Location", value: "Relative to Group")
                    }
                    
                    InspectorSection(title: "Target Membership") {
                        HStack {
                            Image(systemName: "app")
                                .foregroundColor(.secondary)
                            VStack(alignment: .leading) {
                                Text("PanesExample")
                                    .font(.system(size: 12))
                                Text("Default")
                                    .font(.system(size: 10))
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    
                    InspectorSection(title: "Text Settings") {
                        InspectorRow(label: "Text Encoding", value: "No Explicit Encoding")
                        InspectorRow(label: "Line Endings", value: "No Explicit Line Endings")
                        InspectorRow(label: "Indent Using", value: "Spaces")
                    }
                }
                .padding(12)
            }
        }
    }
}

// MARK: - Inspector Section
struct InspectorSection<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(.secondary)
                .textCase(.uppercase)
            
            content
        }
    }
}

// MARK: - Inspector Row
struct InspectorRow: View {
    let label: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(label)
                .font(.system(size: 10))
                .foregroundColor(.secondary)
            Text(value)
                .font(.system(size: 12))
        }
    }
}

// MARK: - Divider View (Resizable)
struct DividerView: View {
    @Binding var width: Double
    let minWidth: Double
    let maxWidth: Double
    var isRightPane: Bool = false
    
    @State private var isDragging = false
    @State private var startWidth: Double = 0
    
    var body: some View {
        Rectangle()
            .fill(Color.platformSeparator)
            .frame(width: 1)
            .overlay(
                Rectangle()
                    .fill(Color.clear)
                    .frame(width: 8)
                    .contentShape(Rectangle())
            )
            #if os(macOS)
            .cursor(.resizeLeftRight)
            #endif
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        if !isDragging {
                            isDragging = true
                            startWidth = width
                        }
                        // For right pane, reverse the direction (drag left = bigger)
                        let translation = isRightPane ? -value.translation.width : value.translation.width
                        let newWidth = startWidth + translation
                        width = min(max(newWidth, minWidth), maxWidth)
                    }
                    .onEnded { _ in
                        isDragging = false
                    }
            )
    }
}

// MARK: - Cursor Modifier
#if os(macOS)
extension View {
    func cursor(_ cursor: NSCursor) -> some View {
        self.onContinuousHover { phase in
            switch phase {
            case .active:
                cursor.push()
            case .ended:
                NSCursor.pop()
            }
        }
    }
}
#endif

#Preview {
    ContentView()
        .frame(width: 1000, height: 600)
}
