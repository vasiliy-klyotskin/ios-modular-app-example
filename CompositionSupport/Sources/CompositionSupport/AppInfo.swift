//
//  AppInfo.swift
//  JustChat
//
//  Created by Василий Клецкин on 9/19/24.
//

import Foundation

public struct AppInfo {
    public let bundleId: String
    
    public init(bundleId: String? = nil) {
        self.bundleId = bundleId ?? Bundle.main.bundleIdentifier ?? ""
    }
}
