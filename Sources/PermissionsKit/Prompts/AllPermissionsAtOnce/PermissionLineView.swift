//
//  SwiftUIView.swift
//  PermissionsKit
//
//  Created by Michel-André Chirita on 28/09/2024.
//

import SwiftUI

struct PermissionLineView: View {

//    var icon: ImageResource
    var iconName: String
    var title: String
    var subtitle: String
    @Binding var hasGranted: Bool
        
    var body: some View {
        HStack(spacing: 20) {
            HStack {
                Spacer()
                if #available(iOS 17.0, *) {
//                    Image(icon)
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: 60)
                    Image(systemName: iconName)
                        .font(.system(size: 23))
                        .symbolRenderingMode(.hierarchical)
                        .foregroundStyle(Color.accentColor)
                        .symbolEffect(hasGranted ? .bounce.up : .bounce.down, value: hasGranted)
                } else {
                    Image(systemName: iconName)
                        .font(.system(size: 23))
                        .foregroundStyle(PromptTheme.colors.primaryText)
                }
                Spacer()
            }
            .opacity(hasGranted ? 0.5 : 1)
            .frame(width: 50)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(PromptTheme.colors.primaryText)
                Text(subtitle)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(PromptTheme.colors.primaryText)
            }
            .opacity(hasGranted ? 0.5 : 1)

            Spacer()

            Toggle("", isOn: $hasGranted)
                .frame(width: 50)
                .tint(PromptTheme.colors.primaryButton)
                .disabled(hasGranted)
                .padding(.trailing)
        }
        .padding(10)
        .background {
            RoundedRectangle(cornerRadius: 25)
                .foregroundStyle(PromptTheme.colors.secondaryBackground)
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
    }
}

#Preview {
    @State var hasGranted: Bool = true
//    return PermissionLineView(icon: ImageResource.iconPushNotifications, title: "Camera", subtitle: "Send photos", hasGranted: $hasGranted)
    return PermissionLineView(iconName: "camera.fill", title: "Camera", subtitle: "Send photos ", hasGranted: $hasGranted)
}
