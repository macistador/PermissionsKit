//
//  PermissionPrepromptView.swift
//  PermissionsKit
//
//  Created by Michel-André Chirita on 11/09/2024.
//

import SwiftUI

public enum PromptKind {
    case preprompt(reoptinFallback: Bool)
    case reoptin
}

public struct PermissionPromptView: View {
    
    private var text: String
    @StateObject var viewModel: PermissionPromptViewModel
    
    public init(_ promptKind: PromptKind, for permission: Permission, title: String, completion: ((Bool) -> ())? = nil) {
        self.text = title
        self._viewModel = StateObject(wrappedValue: PermissionPromptViewModel(permission: permission, promptKind: promptKind, completion: completion))
    }

    public var body: some View {
        switch viewModel.promptKind {
        case .preprompt:
            switch viewModel.permission {
            case .pushNotification: PushNotifPrepromptView(text: text, viewModel: viewModel)
            case .microphone: MicrophonePrepromptView(text: text, viewModel: viewModel)
            case .location: LocationPrepromptView(text: text, viewModel: viewModel)
            default: DefaultPrepromptView(text: text, viewModel: viewModel)
            }
            
        case .reoptin:
            PermissionReoptinView(text: text, viewModel: viewModel)
        }
    }
    
    public static func setupTheme(primaryButton: Color,
                           secondaryButton: Color,
                           disabledButton: Color,
                           primaryButtonText: Color,
                           primaryText: Color,
                           secondaryText: Color,
                           primaryBackground: Color,
                           secondaryBackground: Color,
                           primaryFormBackground: Color,
                           secondaryFormBackground: Color) {
        PromptColor.primaryButton = primaryButton
        PromptColor.secondaryButton = secondaryButton
        PromptColor.disabledButton = disabledButton
        PromptColor.primaryButtonText = primaryButtonText
        PromptColor.primaryText = primaryText
        PromptColor.secondaryText = secondaryText
        PromptColor.primaryBackground = primaryBackground
        PromptColor.secondaryBackground = secondaryBackground
        PromptColor.primaryFormBackground = primaryFormBackground
        PromptColor.secondaryFormBackground = secondaryFormBackground
    }
}

#Preview {
    PermissionPromptView(.preprompt(reoptinFallback: true),
                         for: .camera,
                         title: "Hey we need this permission !",
                         completion: { _ in })
}
