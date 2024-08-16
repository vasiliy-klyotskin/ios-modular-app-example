//
//  Radius.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/16/24.
//

import Foundation

struct Radius {
    let shadow = Shadow()
    let corner = Corner()
    
    struct Shadow {
        let sm: CGFloat = 2
        let md: CGFloat = 4
        let lg: CGFloat = 8
    }
    
    struct Corner {
        let sm: CGFloat = 12
        let md: CGFloat = 16
        let lg: CGFloat = 20
    }
}
