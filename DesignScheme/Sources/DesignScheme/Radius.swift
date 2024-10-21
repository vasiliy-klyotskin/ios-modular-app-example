//
//  Radius.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/16/24.
//

import Foundation

public struct Radius: Sendable {
    public let shadow = Shadow()
    public let corner = Corner()
    
    public struct Shadow: Sendable {
        public let sm: CGFloat = 2
        public let md: CGFloat = 4
        public let lg: CGFloat = 8
    }
    
    public struct Corner: Sendable {
        public let sm: CGFloat = 12
        public let md: CGFloat = 16
        public let lg: CGFloat = 20
    }
}
