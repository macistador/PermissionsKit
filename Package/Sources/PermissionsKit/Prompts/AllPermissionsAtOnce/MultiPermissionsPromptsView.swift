//
//  SwiftUIView.swift
//  PermissionsKit
//
//  Created by Michel-André Chirita on 28/09/2024.
//

import SwiftUI

public struct MultiPermissionsPromptsView: View {
    
    private let title: String
    private let subtitle: String
    private let nextAction: ()->Void
    private let skipAction: (()->Void)?
    @StateObject private var viewModel: MultiPermissionsViewModel
    
    public init(permissions: [Permission], title: String = "We need some permissions", subtitle: String = "", nextAction: @escaping ()->Void, skipAction: (()->Void)? = nil) {
        self.title = title
        self.subtitle = subtitle
        self.nextAction = nextAction
        self.skipAction = skipAction
        self._viewModel = StateObject(wrappedValue: MultiPermissionsViewModel(permissions: permissions))
    }
    
    public var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                Spacer()
                
                PromptTitleView(title: title,
                                subtitle: subtitle)
                
                permissions
                    .padding(.bottom)
                
                PromptButton(title: "Continue", action: {
                    nextAction()
                }, state: $viewModel.nextButtonState)
                
                if let skipAction {
                    Button("Skip") { skipAction() }
                        .font(Font.system(size: 18, weight: .semibold))
                        .foregroundStyle(PromptColor.secondaryText)
                        .padding(.top)
                }
                
                Spacer()
            }
        }
        .background(PromptColor.primaryBackground)
        .alert("Allow access", isPresented: $viewModel.showGoToDeviceSettingsAlert, actions: {
            Button("Continue", role: .none) { viewModel.redirectToPermissionSettings() }
        }, message: {
            Text("For full app functionality, please enable permissions in your device settings.")
        })
    }
        
    private var permissions: some View {
        VStack(spacing: 0) {
            ForEach($viewModel.permissionsStates) { $permissionState in
                PermissionLineView(iconName: permissionState.permission.iconName,
                                   title: permissionState.permission.title,
                                   subtitle: permissionState.permission.subtitle,
                                   hasGranted: $permissionState.hasGranted)
            }
        }
    }
}

#Preview {
    MultiPermissionsPromptsView(permissions: [.camera], subtitle: "Grant camera, notifications, and address book access to easily share moments with loved ones") { }
}

extension Permission {
    var subtitle: String {
        switch self {
        case .pushNotification: "Don't miss new friends"
        case .camera: "Take photos to send"
        case .photoLibrary: "Pick photos from your photo library"
        case .contacts: "Find Friends"
        case .tracking: "Help us improve your app experience"
        case .microphone: "Record audio from your mic"
        case .location(let usage): "Use your location"
        }
    }
    
    var iconName: String {
        switch self {
        case .pushNotification: "bell.fill"
        case .camera: "camera.fill"
        case .photoLibrary: "photo.stack.fill"
        case .contacts: "person.3.fill"
        case .tracking: "app.connected.to.app.below.fill"
        case .microphone: "mic.fill"
        case .location: "location.fill"
        }
    }
}
