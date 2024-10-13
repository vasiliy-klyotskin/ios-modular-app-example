//
//  Colors.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/16/24.
//

import SwiftUI

public struct Colors {
    public let main = Main()
    public let text = Text()
    public let status = Status()
    public let background = Background()
    public let surface = Surface()
    public let shadow = Shadow()
    public let separator = Separator()
    
    public struct Main{
        public let primary = Color.mainPrimary
        public let secondary = Color.mainSecondary
    }
    
    public struct Text {
        public let primary = Color.textPrimary
        public let secondary = Color.textSecondary
        public let primaryInverted = Color.textPrimaryInverted
        public let secondaryInverted = Color.textSecondaryInverted
        public let placeholder = Color.textPlaceholder
    }
    
    public struct Status {
        public let error = Color.statusError
    }
    
    public struct Separator {
        public let primary = Color.separatorPrimary
    }
    
    public struct Background {
        public let primary = Color.backgroundPrimary
    }
    
    public struct Surface {
        public let primary = Color.surfacePrimary
        public let secondary = Color.surfaceSecondary
    }
    
    public struct Shadow {
        public let primary = Color.shadowPrimary
    }
}
