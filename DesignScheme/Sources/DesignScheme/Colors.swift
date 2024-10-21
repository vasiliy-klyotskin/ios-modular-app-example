//
//  Colors.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/16/24.
//

import SwiftUI

public struct Colors: Sendable {
    public let main = Main()
    public let text = Text()
    public let status = Status()
    public let background = Background()
    public let surface = Surface()
    public let shadow = Shadow()
    public let separator = Separator()
    
    public struct Main: Sendable {
        public let primary = Color("mainPrimary", bundle: .module)
        public let secondary = Color("mainSecondary", bundle: .module)
    }
    
    public struct Text: Sendable {
        public let primary = Color("textPrimary", bundle: .module)
        public let secondary = Color("textSecondary", bundle: .module)
        public let primaryInverted = Color("textPrimaryInverted", bundle: .module)
        public let secondaryInverted = Color("textSecondaryInverted", bundle: .module)
        public let placeholder = Color("textPlaceholder", bundle: .module)
    }
    
    public struct Status: Sendable {
        public let error = Color("statusError", bundle: .module)
    }
    
    public struct Separator: Sendable {
        public let primary = Color("separatorPrimary", bundle: .module)
    }
    
    public struct Background: Sendable {
        public let primary = Color("backgroundPrimary", bundle: .module)
    }
    
    public struct Surface: Sendable {
        public let primary = Color("surfacePrimary", bundle: .module)
        public let secondary = Color("surfaceSecondary", bundle: .module)
    }
    
    public struct Shadow: Sendable {
        public let primary = Color("shadowPrimary", bundle: .module)
    }
}
