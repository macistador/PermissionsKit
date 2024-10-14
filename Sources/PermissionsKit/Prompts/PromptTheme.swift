//
//  File.swift
//  PermissionsKit
//
//  Created by Michel-André Chirita on 11/09/2024.
//

import SwiftUI

public struct PromptTheme {

    // MARK: Colors

    static var colors: Colors = .init()

    public struct Colors {
        var primaryButton: Color
        var secondaryButton: Color
        var disabledButton: Color
        var primaryButtonText: Color
        var primaryText: Color
        var secondaryText: Color
        var primaryBackground: Color
        var secondaryBackground: Color
        var primaryFormBackground: Color
        var secondaryFormBackground: Color

        public init(primaryButton: Color? = nil,
             secondaryButton: Color? = nil,
             disabledButton: Color? = nil,
             primaryButtonText: Color? = nil,
             primaryText: Color? = nil,
             secondaryText: Color? = nil,
             primaryBackground: Color? = nil,
             secondaryBackground: Color? = nil,
             primaryFormBackground: Color? = nil,
             secondaryFormBackground: Color? = nil) {
            self.primaryButton = primaryButton ?? Color.blue
            self.secondaryButton = secondaryButton ?? Color.teal
            self.disabledButton = disabledButton ?? Color(red: 178/255,
                                                          green: 178/255,
                                                          blue: 178/255,
                                                          opacity: 0.5)
            self.primaryButtonText = primaryButtonText ?? Color.white
            self.primaryText = primaryText ?? Color.black
            self.secondaryText = secondaryText ?? Color(red: 51/255,
                                                        green: 51/255,
                                                        blue: 51/255)
            self.primaryBackground = primaryBackground ?? Color.white
            self.secondaryBackground = secondaryBackground ?? Color(red: 229/255,
                                                                    green: 229/255,
                                                                    blue: 229/255)
            self.primaryFormBackground = primaryFormBackground ?? Color(red: 242/255,
                                                                        green: 242/255,
                                                                        blue: 247/255)
            self.secondaryFormBackground = secondaryFormBackground ?? Color(red: 229/255,
                                                                            green: 229/255,
                                                                            blue: 229/255)
        }
    }

    // MARK: Fonts

    static var fonts: Fonts = .init()

    public struct Fonts {
        var titleSize: Double
        var subtitleSize: Double
        var buttonTextSize: Double

        public init(
            titleSize: Double? = nil,
            subtitleSize: Double? = nil,
            buttonTextSize: Double? = nil
        ) {
            self.titleSize = titleSize ?? 25
            self.subtitleSize = subtitleSize ?? 18
            self.buttonTextSize = buttonTextSize ?? 20
        }
    }

    // MARK: Wordings

    static var wordings: Wordings = .init()

    public struct Wordings {
        var authorizeButton: String
        var continueButton: String
        var disabled: String
        var laterButton: String
        var reoptinTitle: String
        var reoptinSubtitle: String
        var settingsButton: String
        var redirectSettingsAlertTitle: String
        var redirectSettingsAlertText: String
        var camera: String
        var contacts: String
        var location: String
        var microphone: String
        var photoLibrary: String
        var pushNotification: String
        var tracking: String

        public init(
            authorizeButton: String? = nil,
            continueButton: String? = nil,
            disabled: String? = nil,
            laterButton: String? = nil,
            reoptinTitle: String? = nil,
            reoptinSubtitle: String? = nil,
            settingsButton: String? = nil,
            redirectSettingsAlertTitle: String? = nil,
            redirectSettingsAlertText: String? = nil,
            camera: String? = nil,
            contacts: String? = nil,
            location: String? = nil,
            microphone: String? = nil,
            photoLibrary: String? = nil,
            pushNotification: String? = nil,
            tracking: String? = nil
        ) {
            self.authorizeButton = authorizeButton ?? "Authorize"
            self.continueButton = continueButton ?? "Continue"
            self.disabled = disabled ?? "Disabled"
            self.laterButton = laterButton ?? "Maybe later"
            self.reoptinTitle = reoptinTitle ?? "Activate"
            self.reoptinSubtitle = reoptinSubtitle ?? "The app wants to access to:"
            self.settingsButton = settingsButton ?? "Open settings"
            self.redirectSettingsAlertTitle = redirectSettingsAlertTitle ?? "Allow access"
            self.redirectSettingsAlertText = redirectSettingsAlertText ?? "For full app functionality, please enable permissions in your ice settings."
            self.camera = camera ?? "Camera"
            self.contacts = contacts ?? "Contacts"
            self.location = location ?? "Location"
            self.microphone = microphone ?? "Microphone"
            self.photoLibrary = photoLibrary ?? "Photo library"
            self.pushNotification = pushNotification ?? "Notifications"
            self.tracking = tracking ?? "Tracking"
        }
    }
}
