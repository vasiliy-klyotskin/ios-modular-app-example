//
//  UIConstants.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/15/24.
//

import SwiftUI

struct UI {
    static let font = Fonts()
    static let spacing = Spacing()
    static let color = Colors()
    static let radius = Radius()
    static let opacity = Opacity()
    static let elevation = Elevation()
}

struct Fonts {
    let headline = Font.system(size: 24, weight: .bold)
    let subheadline = Font.system(size: 20, weight: .semibold)
    let body = Font.system(size: 16, weight: .regular)
    let caption = Font.system(size: 12, weight: .light)
    let footnote = Font.system(size: 10, weight: .regular)
}

struct Spacing {
    let xs: CGFloat = 4
    let sm: CGFloat = 8
    let md: CGFloat = 16
    let lg: CGFloat = 24
    let xl: CGFloat = 32
}

struct Opacity {
    let xs: Double = 0.3
    let md: Double = 0.5
    let lg: Double = 0.8
}

struct Radius {
    let shadow = Shadow()
    let color = Corner()
    
    struct Shadow {
        let xs: CGFloat = 1
        let sm: CGFloat = 2
        let md: CGFloat = 4
        let lg: CGFloat = 8
        let xl: CGFloat = 12
    }
    
    struct Corner {
        let xs: CGFloat = 8
        let sm: CGFloat = 12
        let md: CGFloat = 16
        let lg: CGFloat = 20
        let xl: CGFloat = 24
    }
}

struct Elevation {
    let sm: CGFloat = 1
    let md: CGFloat = 3
    let lg: CGFloat = 6
    let xl: CGFloat = 10
}

struct Colors {
    let main = Main()
    let text = Text()
    let status = Status()
    let background = Background()
    let surface = Surface()
    let shadow = Shadow()
    
    struct Main{
        let primary = Color.mainPrimary
        let secondary = Color.mainSecondary
        let tertiary = Color.mainTertiary
        let quaternary = Color.mainQuaternary
    }
    
    struct Text {
        let primary = Color.textPrimary
        let secondary = Color.textSecondary
        let primaryInverted = Color.textPrimaryInverted
        let secondaryInverted = Color.textSecondaryInverted
    }
    
    struct Status {
        let ok = Color.statusOK
        let warning = Color.statusError
        let error = Color.statusError
    }
    
    struct Background {
        let primary = Color.backgroundPrimary
        let secondary = Color.backgroundSecondary
    }
    
    struct Surface {
        let primary = Color.surfacePrimary
        let secondary = Color.surfaceSecondary
    }
    
    struct Shadow {
        let primary = Color.shadowPrimary
    }
}
