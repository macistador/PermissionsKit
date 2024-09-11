//
//  CameraPrepromptView.swift
//  PermissionsKit
//
//  Created by Michel-André Chirita on 11/09/2024.
//

import SwiftUI

struct CameraPrepromptView: View {
    
    let text: String
    @State var viewModel: PermissionPromptViewModel
    var completion: ((Bool) -> ())? = nil
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack {
            Spacer()
            
            PromptTitleView(title: "Camera access", subtitle: text, enabled: false)
            
            ZStack {
                ZStack {
                    Image(.iconCamera)
                        .blur(radius: 10)
                        .scaleEffect(0.9)
                        .offset(y: 5)
                        .opacity(0.5)
                    Image(.iconCamera)
                        .shadow(radius: 3)
                }
                .rotationEffect(.degrees(15))
            }
            .padding(.vertical, 60)
            .padding(.bottom)
            
            PromptButton(title: "Authorize", action: {
                Task {
                    let hasGrantedPermission = await viewModel.showPermissionPrompt()
                    await MainActor.run {
                        if hasGrantedPermission {
                            if let completion {
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
                }
            }, state: .constant(.enabled))
            
            Spacer()
        }
        .padding()
        .background(PromptColor.primaryBackground)
        .task {
            if await viewModel.shouldClosePrompt() {
                dismiss()
            }
        }
    }
}

#Preview {
    CameraPrepromptView(text: "1 image is better than 1000 words",
                        viewModel: PermissionPromptViewModel(permission: .camera, promptKind: .preprompt))
}
