//
//  ViewModifier+DemoUtils.swift
//  JustChat
//
//  Created by Василий Клецкин on 9/22/24.
//

import SwiftUI

extension View {
    func run(demoUtils: DemoUtilsFeature) -> some View {
        modifier(DemoUtilsViewModifier(demoUtils: demoUtils))
    }
}

struct DemoUtilsViewModifier: ViewModifier {
    let demoUtils: DemoUtilsFeature
    
    func body(content: Content) -> some View {
        content
            .overlay(content: demoUtils.view)
            .onShake(demoUtils.flow.openDemoUtils)
    }
}
