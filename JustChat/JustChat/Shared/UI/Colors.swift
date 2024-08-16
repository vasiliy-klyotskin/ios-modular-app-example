//
//  Colors.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/16/24.
//

import SwiftUI

struct Colors {
    let main = Main()
    let text = Text()
    let status = Status()
    let background = Background()
    let surface = Surface()
    let shadow = Shadow()
    let separator = Separator()
    
    struct Main{
        let primary = Color.mainPrimary
        let secondary = Color.mainSecondary
    }
    
    struct Text {
        let primary = Color.textPrimary
        let secondary = Color.textSecondary
        let primaryInverted = Color.textPrimaryInverted
        let secondaryInverted = Color.textSecondaryInverted
        let placeholder = Color.textPlaceholder
    }
    
    struct Status {
        let error = Color.statusError
    }
    
    struct Separator {
        let primary = Color.separatorPrimary
    }
    
    struct Background {
        let primary = Color.backgroundPrimary
    }
    
    struct Surface {
        let primary = Color.surfacePrimary
        let secondary = Color.surfaceSecondary
    }
    
    struct Shadow {
        let primary = Color.shadowPrimary
    }
}
