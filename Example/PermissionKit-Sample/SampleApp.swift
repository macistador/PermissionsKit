//
//  SampleApp.swift
//  Sample
//
//  Created by Michel-André Chirita on 11/09/2024.
//

import SwiftUI
import PermissionsKit

@main
struct SampleApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    setupPermissionPromptTheme()
                }
        }
    }
    
    private func setupPermissionPromptTheme() {
        PermissionPromptView.setupTheme(primaryButton: Color.primaryButton,
                                        secondaryButton: Color.secondaryButton,
                                        disabledButton: Color.disabledButton,
                                        primaryButtonText: Color.primaryButtonText,
                                        primaryText: Color.primaryText,
                                        secondaryText: Color.secondaryText,
                                        primaryBackground: Color.primaryBackground,
                                        secondaryBackground: Color.secondaryBackground,
                                        primaryFormBackground: Color.primaryFormBackground,
                                        secondaryFormBackground: Color.secondaryFormBackground)
    }
}
