//
//  AttPrepromptView.swift
//  PermissionsKit
//
//  Created by Michel-André Chirita on 11/09/2024.
//

import SwiftUI

struct AttPrepromptView: View {

    let text: String
    @State var viewModel: PermissionPromptViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack {
            Spacer()
            
            PromptTitleView(title: "Tracking", subtitle: text)
            
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
                    if hasGrantedPermission {
                        dismiss()
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
        .background(PromptColor.primaryBackground)
        .task {
            if await viewModel.shouldClosePrompt() {
                dismiss()
            }
        }
    }
}

#Preview {
    AttPrepromptView(text: "It would help us improve this application :)",
                     viewModel: PermissionPromptViewModel(permission: .att, promptKind: .preprompt))
}
