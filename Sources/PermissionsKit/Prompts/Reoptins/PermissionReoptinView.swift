//
//  PermissionReoptinView.swift
//  PermissionsKit
//
//  Created by Michel-André Chirita on 11/09/2024.
//

import SwiftUI

public struct PermissionReoptinView: View {

    var text: String
    var showDismiss: Bool = true
    @ObservedObject var viewModel: PermissionPromptViewModel
    @State private var animationIsScaled: Bool = false
    @State private var animationToggleIsOn: Bool = false
    @Environment(\.dismiss) private var dismiss

    public var body: some View {
        VStack {
            Spacer()

            PromptTitleView(title: PromptTheme.wordings.reoptinTitle + viewModel.permission.title,
                            subtitle: text,
                            withGradient: false)

            VStack(alignment: .leading) {
                Text(PromptTheme.wordings.reoptinSubtitle)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(.tertiary)
                    .padding(.top, 10)
                    .padding(.leading, 20)

                VStack(spacing: 0) {
                    PermissionLine(permission: .contacts,
                                   isHighlighted: viewModel.permission.isContacts,
                                   animationIsScaled: viewModel.permission.isContacts ? $animationIsScaled : .constant(false),
                                   toggleIsOn: $animationToggleIsOn)
                        .padding(.top, 5)
                        .zIndex(10)
                    
                    Divider()
                        .opacity(0.5)
                        .zIndex(0)
                    
                    PermissionLine(permission: .camera,
                                   isHighlighted: viewModel.permission.isCamera,
                                   animationIsScaled: viewModel.permission.isCamera ? $animationIsScaled : .constant(false),
                                   toggleIsOn: $animationToggleIsOn)
                    .zIndex(10)
                    
                    Divider()
                        .opacity(0.5)
                        .zIndex(0)
                    
                    if ![.contacts, .camera, .pushNotification].contains(viewModel.permission) {
                        PermissionLine(permission: viewModel.permission,
                                       isHighlighted: true,
                                       animationIsScaled: $animationIsScaled,
                                       toggleIsOn: $animationToggleIsOn)
                        .zIndex(10)
                        Divider()
                            .opacity(0.5)
                            .zIndex(0)
                    }
                    
                    PermissionLine(permission: .pushNotification,
                                   isHighlighted: viewModel.permission.isPushNotification,
                                   animationIsScaled:  viewModel.permission.isPushNotification ? $animationIsScaled : .constant(false),
                                   toggleIsOn: $animationToggleIsOn)
                    .zIndex(10)
                }
                .background(RoundedRectangle(cornerRadius: 10).foregroundStyle(PromptTheme.colors.secondaryFormBackground))
                .padding(.horizontal, 10)
                .padding(.bottom, 10)
            }
            .background(RoundedRectangle(cornerRadius: 20).foregroundStyle(PromptTheme.colors.primaryFormBackground))
            .padding(.vertical)
            
            PromptButton(title: PromptTheme.wordings.settingsButton, action: {
                viewModel.redirectToPermissionSettings()
            }, state: .constant(.enabled))
            
            if showDismiss {
                PromptButton(title: PromptTheme.wordings.laterButton, style: .tertiary(destructive: false), action: {
                    if let completion = viewModel.completion {
                        completion(false)
                    } else {
                        dismiss()
                    }
                }, state: .constant(.enabled))
                .opacity(0.5)
            }
        
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
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            Task {
                if await viewModel.shouldClosePrompt() {
                    if let completion = viewModel.completion {
                        completion(true)
                    } else {
                        dismiss()
                    }
                }
            }
        }
        .onAppear {
            withAnimation(.bouncy(duration: 0.5, extraBounce: 0.4).delay(1.0)) {
                animationIsScaled = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                animationToggleIsOn = true
            }
        }
    }
}

private struct PermissionLine: View {
    
    var permission: Permission
    var isHighlighted: Bool
    @Binding var animationIsScaled: Bool
    @Binding var toggleIsOn: Bool
    
    private var placeholderWidth: CGFloat {
       switch permission {
       case .pushNotification: 100
       case .camera: 60
       case .photoLibrary: 140
       case .contacts: 80
       case .tracking: 40
       case .microphone: 40
       case .location: 40
       }
   }
    
    var body: some View {
        HStack {
            Image(permission.icon)
                .resizable()
                .aspectRatio(1, contentMode: .fit)
                .padding(5)
                .padding(.leading)
            
            if isHighlighted {
                VStack(alignment: .leading) {
                    Text(permission.title)
                        .font(.system(size: 14))
                        .foregroundStyle(PromptTheme.colors.primaryText)
                    if permission.isPushNotification {
                        Text(PromptTheme.wordings.disabled)
                            .font(.system(size: 12))
                            .foregroundStyle(PromptTheme.colors.secondaryText)
                    }
                }
            } else {
                RoundedRectangle(cornerRadius: 5)
                    .foregroundStyle(PromptTheme.colors.secondaryBackground)
                    .frame(width: placeholderWidth)
                    .padding(5)
            }
            
            Spacer()
            
            /*if permission == .pushNotification {
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundStyle(.secondaryText)
                    .padding(5)
                    .padding(.trailing)
            } else*/ if isHighlighted {
                Toggle("", isOn: $toggleIsOn)
                    .allowsHitTesting(false)
                    .padding(5)
                    .padding(.trailing)
            } else {
                RoundedRectangle(cornerRadius: 5)
                    .foregroundStyle(PromptTheme.colors.secondaryBackground)
                    .frame(width: 60)
                    .padding(5)
                    .padding(.trailing)
            }
        }
        .frame(height: 40)
        .padding(.vertical, 10)
        .background(RoundedRectangle(cornerRadius: 10).foregroundStyle(isHighlighted ? PromptTheme.colors.secondaryBackground : .clear))
        .scaleEffect(animationIsScaled ? 1.1 : 1.0)
        .shadow(radius: animationIsScaled ? 5 : 0)
    }
}

#Preview {
    PermissionReoptinView(text: "", viewModel: PermissionPromptViewModel(permission: .tracking, promptKind: .reoptin))
        .preferredColorScheme(.dark)
}
