//
//  SwiftUIView.swift
//  PermissionsKit
//
//  Created by Michel-André Chirita on 20/09/2024.
//

import SwiftUI

struct DefaultPrepromptView: View {
    
    let text: String
    @ObservedObject var viewModel: PermissionPromptViewModel
    @State private var animationStep1: Bool = false
    @State private var animationStep2: Bool = false
    @State private var animationStep3: Bool = false
    @State private var animationStep4: Bool = false
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack {
            Spacer()

            PromptTitleView(title: viewModel.permission.title, subtitle: text)
            
            ZStack {
                if viewModel.permission.images.count >= 4 {
                    Image(viewModel.permission.images[0])
                        .resizable()
                        .frame(width: 60, height: 60)
                        .clipShape(Circle())
                        .opacity(animationStep1 ? 1.0 : 0.8)
                        .scaleEffect(animationStep1 ? 1.2 : 0.8)
                        .rotationEffect(.degrees(animationStep1 ? 30 : 0))
                        .offset(x: animationStep1 ? 50 : 0, y: animationStep1 ? 90 : 0)
                    Image(viewModel.permission.images[1])
                        .resizable()
                        .frame(width: 60, height: 60)
                        .clipShape(Circle())
                        .opacity(animationStep2 ? 1.0 : 0.8)
                        .scaleEffect(animationStep2 ? 1.2 : 0.8)
                        .rotationEffect(.degrees(animationStep2 ? -40 : 0))
                        .offset(x: animationStep2 ? -100 : 0, y: animationStep2 ? -40 : 0)
                    Image(viewModel.permission.images[2])
                        .resizable()
                        .frame(width: 60, height: 60)
                        .clipShape(Circle())
                        .opacity(animationStep3 ? 1.0 : 0.8)
                        .scaleEffect(animationStep3 ? 1.2 : 0.8)
                        .rotationEffect(.degrees(animationStep3 ? -20 : 0))
                        .offset(x: animationStep3 ? -80 : 0, y: animationStep3 ? 50 : 0)
                    Image(viewModel.permission.images[3])
                        .resizable()
                        .frame(width: 60, height: 60)
                        .clipShape(Circle())
                        .opacity(animationStep4 ? 1.0 : 0.8)
                        .scaleEffect(animationStep4 ? 1.2 : 0.8)
                        .rotationEffect(.degrees(animationStep4 ? -30 : 0))
                        .offset(x: animationStep4 ? 80 : 0, y: animationStep4 ? -60 : 0)
                }
                ZStack {
                    Image(viewModel.permission.icon)
                        .blur(radius: 10)
                        .scaleEffect(0.7)
                        .offset(y: 10)
                        .opacity(0.3)
                    Image(viewModel.permission.icon)
                        .shadow(radius: 3)
                }
                .rotationEffect(.degrees(5))
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
        .onAppear {
            withAnimation(.easeInOut(duration: 0.4).delay(1.0).repeatForever(autoreverses: true).delay(0.5)) {
                animationStep1 = true
            }
            withAnimation(.easeInOut(duration: 0.3).delay(1.0).repeatForever(autoreverses: true).delay(0.7)) {
                animationStep2 = true
            }
            withAnimation(.easeInOut(duration: 0.5).delay(1.0).repeatForever(autoreverses: true).delay(0.9)) {
                animationStep3 = true
            }
            withAnimation(.easeInOut(duration: 0.3).delay(1.0).repeatForever(autoreverses: true).delay(1.1)) {
                animationStep4 = true
            }
        }
    }
}

#Preview {
    DefaultPrepromptView(text: "Invite friends from your address book",
                  viewModel: PermissionPromptViewModel(permission: .contacts, promptKind: .preprompt(reoptinFallback: false)))
}
