//
//  Util_ViewHelpers.swift
//  Yuta Picker
//
//  Created by Nguyen Phuc Loi on 21/03/2024.
//

import Foundation
import SwiftUI

class ViewOperationContextManager {
    static func updateUIAfterFinishedEvent(authRemoteArea: AuthenticationContextProvider, libraryRemoteArea: LibraryViewViewModel, completion: @escaping () -> Void) {
        authRemoteArea.fetchCurrentAccount {
            if let ownerId = authRemoteArea.currentAccount?.id {
                libraryRemoteArea.fetchAllLibrariesByAccountId(ownerId: ownerId) {
                    completion()
                }
            }
        }
    }

    static func setupToast(config: AlertToastConfiguration, isOpenAlertToast: Binding<Bool>, alertToastConfiguration: Binding<AlertToastConfiguration?>, isCompleteEvent: Binding<Bool>) -> some View {
        DispatchQueue.main.async {
            isOpenAlertToast.wrappedValue = true
            alertToastConfiguration.wrappedValue = config
            isCompleteEvent.wrappedValue = true
        }
        return EmptyView()
    }
}



