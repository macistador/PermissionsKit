//
//  File.swift
//  PermissionsKit
//
//  Created by Michel-André Chirita on 20/09/2024.
//

import SwiftUI

struct MicrophonePrepromptView: View {
    
    let text: String
    @ObservedObject var viewModel: PermissionPromptViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var waveAnimation1: Bool = true
    @State private var waveAnimation2: Bool = true

    var body: some View {
        VStack {
            Spacer()
            
            PromptTitleView(title: viewModel.permission.title, subtitle: text, withGradient: false)

            ZStack {
                wave(withDelay: 0, binding: $waveAnimation1, shouldRepeat: false)
                wave(withDelay: 3, binding: $waveAnimation2, shouldRepeat: true)
                ZStack {
                    Image(.iconMicrophone)
                        .blur(radius: 10)
                        .scaleEffect(0.9)
                        .offset(y: 5)
                        .opacity(0.5)
                    Image(.iconMicrophone)
                        .shadow(radius: 3)
                }
                .rotationEffect(.degrees(15))
            }
            .padding(.vertical, 60)
            .padding(.bottom)
            
            PromptButton(title: PromptTheme.wordings.authorizeButton, action: {
                Task {
                    let hasGrantedPermission = await viewModel.showPermissionPrompt()
                    if hasGrantedPermission || !viewModel.shouldFallbackToReoptin {
                        if let completion = viewModel.completion {
                            completion(hasGrantedPermission)
                        } else {
                            dismiss()
                        }
                    } else {
                        withAnimation {
                            viewModel.promptKind = .reoptin
                        }
                    }
                }
            }, state: .constant(.enabled))
            
            Spacer()
        }
        .padding()
        .background(PromptTheme.colors.primaryBackground)
        .task {
            if await viewModel.shouldClosePrompt() {
                if let completion = viewModel.completion {
                    completion(true)
                } else {
                    dismiss()
                }
            }
        }
    }
    
    @ViewBuilder
    private func wave(withDelay delay: Double, binding: Binding<Bool>, shouldRepeat: Bool) -> some View {
        Circle()
            .fill(RadialGradient(colors: [.yellow.opacity(0.5), .yellow.opacity(0)], center: .center, startRadius: 0.2, endRadius: 0))
            .frame(width: 1, height: 1)
            .scaleEffect(binding.wrappedValue ? 1000 : 1)
            .opacity(binding.wrappedValue ? 0 : 1)
            .onAppear {
                if !shouldRepeat {
                    withAnimation(.linear(duration: 2)) {
                        binding.wrappedValue = false
                    }
                } else {
                    withAnimation(.linear(duration: 2).delay(delay).repeatForever(autoreverses: false)) {
                        binding.wrappedValue = false
                    }
                }
            }
    }
}

#Preview {
    MicrophonePrepromptView(text: "Sounds make it better",
                            viewModel: PermissionPromptViewModel(permission: .microphone, promptKind: .preprompt(reoptinFallback: false)))
}
