//
//  SwiftUIView.swift
//  PermissionsKit
//
//  Created by Michel-André Chirita on 11/09/2024.
//

import SwiftUI

struct PromptTitleView: View {
    
    var title: String
    var subtitle: String?
    var alignment: HorizontalAlignment = .center
    var withGradient: Bool = true
    @State private var animate: Bool = false

    var body: some View {
        VStack(alignment: alignment, spacing: 5) {
            Text(title)
                .font(.system(size: PromptTheme.fonts.titleSize + (withGradient ? 7 : 0), weight: .black, design: .rounded))
                .textCase(.uppercase)
                .multilineTextAlignment(.center)
                .foregroundStyle(PromptTheme.colors.primaryText)
                .overlay {
                    if withGradient {
                        RadialGradient(colors: [Color.accentColor, Color.accentColor], center: UnitPoint(x: animate ? 0.3 : 0.8, y: animate ? 0.4 : 0.7), startRadius: 20, endRadius: 200)
                            .animation(.easeInOut(duration: 3.0).repeatForever(autoreverses: true), value: animate)
                            .mask {
                                Text(title)
                                    .textCase(.uppercase)
                                    .font(.system(size: PromptTheme.fonts.titleSize + (withGradient ? 7 : 0), weight: .black, design: .rounded))
                                    .multilineTextAlignment(.center)
                                    .foregroundStyle(PromptTheme.colors.primaryText)
                            }
                    }
                }
            if let subtitle {
                Text(subtitle)
                    .font(.system(size: PromptTheme.fonts.subtitleSize, weight: .bold, design: .rounded))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(PromptTheme.colors.primaryText)
            }
        }
        .padding()
        .onAppear {
            animate = true
        }
    }
}

#Preview {
    PromptTitleView(title: "My best title")
}
