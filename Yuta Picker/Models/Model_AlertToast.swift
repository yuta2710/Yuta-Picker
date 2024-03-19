//
//  Model_AlertToast.swift
//  Yuta Picker
//
//  Created by Nguyen Phuc Loi on 19/03/2024.
//

import Foundation
import AlertToast
import SwiftUI

struct AlertToastConfiguration {
    var displayMode: AlertToast.DisplayMode
    var type: AlertToast.AlertType
    var title: String
    var subtitle: String
    
    init(displayMode: AlertToast.DisplayMode?, type: AlertToast.AlertType?, title: String?, subtitle: String?) {
        self.displayMode = displayMode ?? .banner(.slide)
        self.type = type ?? .regular
        self.title = title ?? "N/A"
        self.subtitle = subtitle ?? "N/A"
    }
}
