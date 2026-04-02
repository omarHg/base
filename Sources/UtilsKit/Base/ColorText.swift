//
//  ColorText.swift
//  Base
//
//  Created by Omar Hernandez Gonzalez on 02/03/26.
//

import SwiftUI

/// Usage:
/// ColorText("hola")
/// ColorText("DatoFlash", font: .system(size: 42, weight: .heavy, design: .rounded))
/// ColorText("hola", colors: [.red, .orange, .yellow, .green, .blue, .purple])
///
/// ✅ Features:
/// - Colors each letter (cycles through palette)
/// - Optional injected Font (default included)
/// - Optional injected color palette (default included)
public struct ColorText: View {
    private let text: String
    private let font: Font
    private let colors: [Color]
    
    public init(
        _ text: String,
        font: Font = .system(size: 44, weight: .heavy, design: .rounded),
        colors: [Color]? = nil
    ) {
        self.text = text
        if let colors, !colors.isEmpty {
            self.colors = colors
        } else {
            self.colors = [
                Color(hex: 0xFFD60A), // yellow
                Color(hex: 0xF4A261), // orange
                Color(hex: 0x38B000), // green
                Color(hex: 0x5E60CE), // indigo
                Color(hex: 0x7C83FF), // light indigo
                Color(hex: 0xFF5A6A)  // pink/red
            ]
        }
        self.font = font
    }
    
    public var body: some View {
        let chars = Array(text)
        
        HStack(spacing: 0) {
            ForEach(chars.indices, id: \.self) { i in
                Text(String(chars[i]))
                    .font(font)
                    .foregroundStyle(colors[i % colors.count])
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .accessibilityLabel(Text(text))
    }
}

// MARK: - Hex helper

private extension Color {
    init(hex: UInt32, alpha: Double = 1.0) {
        let r = Double((hex >> 16) & 0xFF) / 255.0
        let g = Double((hex >> 8) & 0xFF) / 255.0
        let b = Double(hex & 0xFF) / 255.0
        self.init(.sRGB, red: r, green: g, blue: b, opacity: alpha)
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 18) {
        ColorText("hola")
        ColorText("DatoFlash", font: .system(size: 52, weight: .black, design: .rounded))
        ColorText("colores", colors: [.red, .orange, .yellow, .green, .blue, .purple])
    }
    .padding()
}
