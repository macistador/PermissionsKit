//
//  PushNotifPermissionPrepromptView.swift
//  PermissionsKit
//
//  Created by Michel-André Chirita on 11/09/2024.
//

import SwiftUI

struct PushNotifPrepromptView: View {
    
    struct NotificationMock: Identifiable {
        let id: Int
        let image: ImageResource = .mockUserPicture4
        let title: String
        let subtitle: String
    }
    
    let text: String
    @ObservedObject var viewModel: PermissionPromptViewModel
    @State var notifications: [NotificationMock] = []
    @Environment(\.dismiss) private var dismiss
    private let allNotifications: [NotificationMock] = [
        NotificationMock(id: 0, title: "Ralph", subtitle: "hey 👋 you"),
        NotificationMock(id: 1, title: "Ralph", subtitle: "check out that pics 😁😜"),
        NotificationMock(id: 2, title: "Ralph", subtitle: "how cool was that 🥰😍"),
        NotificationMock(id: 3, title: "Ralph", subtitle: "❤️❤️❤️🔥🔥🔥"),
    ]
    
    var body: some View {
        VStack {
            Spacer()
            PromptTitleView(title: "Accept notifications", subtitle: text)
            
            ZStack {
                ForEach(Array(notifications.enumerated()), id: \.element.id) { index, notif in
                    notificationPreview(image: notif.image, title: notif.title, subtitle: notif.subtitle)
                        .scaleEffect(1.0 - CGFloat(index) * 0.1)
                        .opacity(1.0 - CGFloat(index) * 0.3)
                        .zIndex(10 - Double(index))
                        .offset(y: CGFloat(index) * 10)
                        .transition(.scale.combined(with: .opacity))
                }
            }
            .padding(.vertical)
            .padding(.bottom)
                        
            PromptButton(title: "Authorize", action: {
                Task {
                    let hasGrantedPermission = await viewModel.showPermissionPrompt()
                    if hasGrantedPermission || !viewModel.shouldFallbackToReoptin {
                        if let completion = viewModel.completion {
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
            }, state: .constant(.enabled))
            
            Spacer()
        }
        .padding()
        .background(PromptColor.primaryBackground)
        .task {
            if await viewModel.shouldClosePrompt() {
                if let completion = viewModel.completion {
                    completion(true)
                } else {
                    dismiss()
                }
            }
        }
        .onAppear {
            withAnimation(.bouncy(duration: 0.5)) {
                notifications.insert(allNotifications[0], at: 0)
            }
            withAnimation(.bouncy(duration: 0.5).delay(2.0)) {
                notifications.insert(allNotifications[1], at: 0)
            }
            withAnimation(.bouncy(duration: 0.5).delay(4.0)) {
                notifications.insert(allNotifications[2], at: 0)
            }
            withAnimation(.bouncy(duration: 0.5).delay(6.0)) {
                notifications.insert(allNotifications[3], at: 0)
            }
        }
    }
    
    private func notificationPreview(image: ImageResource, title: String, subtitle: String) -> some View {
        HStack {
            Image(image)
                .resizable()
                .frame(width: 40, height: 40)
                .aspectRatio(1.0, contentMode: .fill)
                .clipShape(RoundedRectangle(cornerRadius: 7))
                .padding(5)
                .padding(.leading)
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.system(size: 14))
                    .fontWeight(.semibold)
                    .foregroundStyle(PromptColor.primaryText)
                Text(subtitle)
                    .font(.system(size: 13))
                    .foregroundStyle(PromptColor.primaryText)
            }
            .padding(5)
            
            Spacer()
            
            Text("now")
                .font(.system(size: 14))
                .foregroundStyle(PromptColor.secondaryText)
                .padding(5)
                .padding(.bottom)
                .padding(.trailing)
        }
        .frame(height: 80)
        .background {
            RoundedRectangle(cornerRadius: 15)
                .foregroundStyle(Material.thin)
        }
    }
}


#Preview {
    PushNotifPrepromptView(text: "It's the only way to get notified when your friends send pics and messages.",
                           viewModel: PermissionPromptViewModel(permission: .pushNotification, promptKind: .preprompt(reoptinFallback: false)))
}
