//
//  SwiftUIView.swift
//  PermissionsKit
//
//  Created by Michel-André Chirita on 11/09/2024.
//

import SwiftUI

struct PromptButton: View {
    
    enum State {
        case enabled
        case disabled
        case loading
    }
    
    enum Style {
        case primary(destructive: Bool)
        case secondary(destructive: Bool)
        case tertiary(destructive: Bool)

        var backgroundColor: Color {
            switch self {
            case .primary(let isDestructive): isDestructive ? .red : PromptTheme.colors.primaryButton
            case .secondary: .clear
            case .tertiary: .clear
            }
        }
        
        var disabledBackgroundColor: Color {
            switch self {
            case .primary: PromptTheme.colors.disabledButton
            case .secondary: .clear
            case .tertiary: .clear
            }
        }
        
        var borderColor: Color {
            switch self {
            case .primary: .black
            case .secondary(let isDestructive): isDestructive ? .red : PromptTheme.colors.secondaryButton
            case .tertiary: .clear
            }
        }
        
        var disabledBorderColor: Color {
            switch self {
            case .primary: .black
            case .secondary: PromptTheme.colors.disabledButton
            case .tertiary: .clear
            }
        }
        
        var textColor: Color {
            switch self {
            case .primary: PromptTheme.colors.primaryButtonText
            case .secondary(let isDestructive): isDestructive ? .red : PromptTheme.colors.primaryButtonText
            case .tertiary(let isDestructive): isDestructive ? .red : PromptTheme.colors.primaryText
            }
        }
        
        var disabledTextColor: Color {
            switch self {
            case .primary: PromptTheme.colors.primaryBackground.opacity(0.5)
            case .secondary: PromptTheme.colors.disabledButton
            case .tertiary: PromptTheme.colors.disabledButton
            }
        }
        
        var minimumHeight: Double {
            switch self {
            case .primary: 65
            case .secondary: 65
            case .tertiary: 30
            }
        }
        
        var maximumHeight: Double {
            switch self {
            case .primary: 65
            case .secondary: 65
            case .tertiary: 30
            }
        }
    }
    
    var title: String
    var fontSize: Double = PromptTheme.fonts.buttonTextSize
    var style: Style = .primary(destructive: false)
    var action: () -> Void
    @Binding var state: State
    
    var body: some View {
        HStack {
            Spacer()
            Button {
                action()
                let hapticImpact = UIImpactFeedbackGenerator(style: .medium)
                hapticImpact.impactOccurred()
            } label: {
                ZStack {
                    Capsule()
                        .fill(state == .enabled ? style.borderColor : style.disabledBorderColor)
                        .offset(y: 5)
                    Capsule()
                        .fill(state == .enabled ? style.backgroundColor : style.disabledBackgroundColor)
                        .overlay {
                            if state == .loading {
                                ProgressView()
                            }
                            else {
                                Text(title)
                                    .font(.system(size: fontSize, weight: .bold))
                                    .textCase(.uppercase)
                                    .foregroundStyle(state == .enabled ? style.textColor : style.disabledTextColor)
                            }
                        }
                }
                .padding([.horizontal, .top])
            }
            .disabled(state != .enabled)
            .frame(minHeight: style.minimumHeight, maxHeight: style.maximumHeight)
            .padding(.horizontal, 40)
            Spacer()
        }
    }
    
}

#Preview {
    PromptButton(title: "Ok", action: { }, state: .constant(.enabled))
}
