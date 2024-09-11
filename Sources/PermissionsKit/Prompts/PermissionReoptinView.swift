//
//  PermissionReoptinView.swift
//  PermissionsKit
//
//  Created by Michel-André Chirita on 11/09/2024.
//

import SwiftUI

public struct PermissionReoptinView: View {

    var text: String // "without this permission, the app experience sucks 😥"
    var showDismiss: Bool = true
    @State var viewModel: PermissionPromptViewModel
    var completion: ((Bool) -> ())? = nil
    @State private var animationIsScaled: Bool = false
    @State private var animationToggleIsOn: Bool = false
    @Environment(\.dismiss) private var dismiss

    public var body: some View {
        VStack {
            Spacer()
            
            PromptTitleView(title: "Activate \(viewModel.permission.title)", subtitle: text, enabled: false)

            VStack(alignment: .leading) {
                Text("Frenzy wants to access to:")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(.tertiary)
                    .padding(.top, 10)
                    .padding(.leading, 20)

                VStack(spacing: 0) {
                    PermissionLine(permission: .contacts,
                                   isHighlighted: viewModel.permission == .contacts,
                                   animationIsScaled: viewModel.permission == .contacts ? $animationIsScaled : .constant(false),
                                   toggleIsOn: $animationToggleIsOn)
                        .padding(.top, 5)
                        .zIndex(10)
                    
                    Divider()
                        .opacity(0.5)
                        .zIndex(0)
                    
                    PermissionLine(permission: .camera,
                                   isHighlighted: viewModel.permission == .camera,
                                   animationIsScaled:  viewModel.permission == .camera ? $animationIsScaled : .constant(false),
                                   toggleIsOn: $animationToggleIsOn)
                    .zIndex(10)
                    
                    Divider()
                        .opacity(0.5)
                        .zIndex(0)

//                    PermissionLine(permission: .photoGallery, isHighlighted: false, toggleIsOn: $animationToggleIsOn)
//                    Divider().opacity(0.5)
                    
                    PermissionLine(permission: .pushNotification,
                                   isHighlighted: viewModel.permission == .pushNotification,
                                   animationIsScaled:  viewModel.permission == .pushNotification ? $animationIsScaled : .constant(false),
                                   toggleIsOn: $animationToggleIsOn)
                    .zIndex(10)
                }
                .background(RoundedRectangle(cornerRadius: 10).foregroundStyle(PromptColor.secondaryFormBackground))
                .padding(.horizontal, 10)
                .padding(.bottom, 10)
            }
            .background(RoundedRectangle(cornerRadius: 20).foregroundStyle(PromptColor.primaryFormBackground))
            .padding(.vertical)
            
            PromptButton(title: "Open settings", action: {
                viewModel.redirectToPermissionSettings()
                dismiss()
            }, state: .constant(.enabled))
            
            if showDismiss {
                PromptButton(title: "Maybe later", style: .tertiary(destructive: false), action: {
//                    dismiss()
                    if let completion {
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
        .background(PromptColor.primaryBackground)
        .task {
//            if await viewModel.shouldClosePrompt() {
//                dismiss()
//            }
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
    
    var permission: PermissionPromptViewModel.Permission
    var isHighlighted: Bool
    @Binding var animationIsScaled: Bool
    @Binding var toggleIsOn: Bool
    
    private var placeholderWidth: CGFloat {
       switch permission {
       case .pushNotification: 100
       case .camera: 60
       case .photoGallery: 140
       case .contacts: 80
       case .att: 40
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
                        .foregroundStyle(PromptColor.primaryText)
                    if permission == .pushNotification {
                        Text("Disabled")
                            .font(.system(size: 12))
                            .foregroundStyle(PromptColor.secondaryText)
                    }
                }
            } else {
                RoundedRectangle(cornerRadius: 5)
                    .foregroundStyle(PromptColor.secondaryBackground)
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
                    .foregroundStyle(PromptColor.secondaryBackground)
                    .frame(width: 60)
                    .padding(5)
                    .padding(.trailing)
            }
        }
        .frame(height: 40)
        .padding(.vertical, 10)
        .background(RoundedRectangle(cornerRadius: 10).foregroundStyle(isHighlighted ? PromptColor.secondaryBackground : .clear))
        .scaleEffect(animationIsScaled ? 1.1 : 1.0)
        .shadow(radius: animationIsScaled ? 5 : 0)
    }
}

//#Preview {
//    PermissionReoptinView()
//}
