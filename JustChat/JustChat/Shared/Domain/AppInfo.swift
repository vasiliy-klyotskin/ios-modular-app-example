//
//  AppInfo.swift
//  JustChat
//
//  Created by Василий Клецкин on 9/19/24.
//

import Foundation

struct AppInfo {
    let bundleId: String
    
    init(bundleId: String? = nil) {
        self.bundleId = bundleId ?? Bundle.main.bundleIdentifier ?? ""
    }
}
