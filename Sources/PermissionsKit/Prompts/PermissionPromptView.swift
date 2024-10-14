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

    public static func setupTheme(colors: PromptTheme.Colors? = nil,
                                  fonts: PromptTheme.Fonts? = nil,
                                  wordings: PromptTheme.Wordings? = nil) {
        PromptTheme.colors = colors ?? PromptTheme.colors
        PromptTheme.fonts = fonts ?? PromptTheme.fonts
        PromptTheme.wordings = wordings ?? PromptTheme.wordings
    }
}

#Preview {
    PermissionPromptView(.preprompt(reoptinFallback: true),
                         for: .camera,
                         title: "Hey we need this permission !",
                         completion: { _ in })
}
