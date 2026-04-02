//
//  AnimetText.swift
//  Base
//
//  Created by Omar Hernandez Gonzalez on 02/03/26.
//

import SwiftUI

/// Usage:
/// AnimetText("hola")
/// AnimetText("DatoFlash",
///           colors: [.red, .orange, .yellow, .green, .blue, .purple],
///           font: .system(size: 44, weight: .heavy, design: .rounded),
///           waveCount: 2)
///
/// ✅ Features:
/// - Optional injected color palette (with sensible defaults)
/// - Optional injected font (size included in the font you pass)
/// - Configurable number of waves (default = 2)
/// - Text stays centered; only wave animation runs and stops
public struct AnimetText: View {
    private let text: String
    private let colors: [Color]
    private let font: Font
    private let waveCount: Int

    private let amplitude: CGFloat
    private let totalDuration: Double
    private let perLetterDelay: Double

    @State private var phase: Double = 0

    public init(
        _ text: String,
        colors: [Color]? = nil,
        font: Font = .system(size: 44, weight: .heavy, design: .rounded),
        waveCount: Int = 4,
        amplitude: CGFloat = 12,
        totalDuration: Double = 1.4,
        perLetterDelay: Double = 0.03
    ) {
        self.text = text
        self.colors = (colors?.isEmpty == false) ? colors! : [
            Color(hex: 0xFFD60A), // Accent (yellow)
            Color(hex: 0xF4A261), // Reward (orange)
            Color(hex: 0x38B000), // Success (green)
            Color(hex: 0x5E60CE), // Brand (indigo)
            Color(hex: 0x7C83FF)  // Brand light
        ]
        self.font = font
        self.waveCount = max(4, waveCount)
        self.amplitude = amplitude
        self.totalDuration = totalDuration
        self.perLetterDelay = perLetterDelay
    }

    public var body: some View {
        let chars = Array(text)

        HStack(spacing: 0) {
            ForEach(chars.indices, id: \.self) { i in
                Text(String(chars[i]))
                    .font(font)
                    .foregroundStyle(colorForLetter(i))
                    .offset(y: yOffset(for: i))
                    .animation(.easeOut(duration: 0.016), value: phase) // smooth display
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .onAppear {
            runWaveOnceAndStop()
        }
        .accessibilityLabel(Text(text))
    }

    // MARK: - Color per letter (palette cycling)
    private func colorForLetter(_ index: Int) -> Color {
        colors[index % colors.count]
    }

    // MARK: - Wave math
    /// phase goes from 0 -> 2π * waveCount, then stops.
    private func yOffset(for index: Int) -> CGFloat {
        // Per-letter phase offset creates the "wave" traveling across letters.
        let letterPhase = phase + Double(index) * 0.45
        return CGFloat(sin(letterPhase)) * amplitude
    }

    private func runWaveOnceAndStop() {
        // Animate phase to complete exactly `waveCount` full sine cycles.
        // One full sine cycle = 2π.
        let target = (2.0 * Double.pi) * Double(waveCount)

        // Optional: stagger feel by briefly ramping in so the first frames aren’t static.
        phase = 0
        withAnimation(.easeInOut(duration: totalDuration)) {
            phase = target
        }

        // After finishing, ensure we land at a stable center (sin(2πk)=0).
        DispatchQueue.main.asyncAfter(deadline: .now() + totalDuration + perLetterDelay) {
            phase = target // keep stable
        }
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
    VStack(spacing: 22) {
        AnimetText(
            "DatoFlash",
            colors: [.pink, .purple, .blue, .green, .yellow],
            font: .system(size: 52, weight: .black, design: .rounded),
            waveCount: 4,
            amplitude: 0,
            totalDuration: 1.8
        )
    }
    .padding()
}
