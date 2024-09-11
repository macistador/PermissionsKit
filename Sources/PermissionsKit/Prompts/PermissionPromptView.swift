//
//  PermissionPrepromptView.swift
//  PermissionsKit
//
//  Created by Michel-André Chirita on 11/09/2024.
//

import SwiftUI

public struct PermissionPromptView: View {
    
    var text: String
    @State var viewModel: PermissionPromptViewModel
    var completion: ((Bool) -> ())? = nil

    public var body: some View {
        switch viewModel.promptKind {
        case .preprompt:
            switch viewModel.permission {
            case .pushNotification: PushNotifPrepromptView(text: text, viewModel: viewModel)
            case .camera: CameraPrepromptView(text: text, viewModel: viewModel, completion: completion)
            case .photoGallery: PhotosGalleryPrepromptView(text: text, viewModel: viewModel)
            case .contacts: ContactsPrepromptView(text: text, viewModel: viewModel, completion: completion)
            case .att: AttPrepromptView(text: text, viewModel: viewModel)
            }
            
        case .reoptin:
            PermissionReoptinView(text: text, viewModel: viewModel, completion: completion)
        }
    }
}

#Preview {
    PermissionPromptView(text: "",
                         viewModel: PermissionPromptViewModel(permission: .pushNotification,
                                                              promptKind: .preprompt),
                         completion: { _ in })
}
