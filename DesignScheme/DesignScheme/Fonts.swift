//
//  Fonts.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/16/24.
//

import SwiftUI

public struct Fonts {
    public let bold: Kinds = .init(
        largeTitle: Font.system(.largeTitle, design: design, weight: bold),
        title: Font.system(.title, design: design, weight: bold),
        title2: Font.system(.title2, design: design, weight: bold),
        title3: Font.system(.title3, design: design, weight: bold),
        headline: Font.system(.headline, design: design, weight: bold),
        body: Font.system(.body, design: design, weight: bold),
        caption: Font.system(.caption, design: design, weight: bold)
    )
    
    public let plain: Kinds = .init(
        largeTitle: Font.system(.largeTitle, design: design, weight: plain),
        title: Font.system(.title, design: design, weight: plain),
        title2: Font.system(.title2, design: design, weight: plain),
        title3: Font.system(.title3, design: design, weight: plain),
        headline: Font.system(.headline, design: design, weight: plain),
        body: Font.system(.body, design: design, weight: plain),
        caption: Font.system(.caption, design: design, weight: plain)
    )

    public struct Kinds {
        public let largeTitle: Font
        public let title: Font
        public let title2: Font
        public let title3: Font
        public let headline: Font
        public let body: Font
        public let caption: Font
    }
    
    private static let bold: Font.Weight = .bold
    private static let plain: Font.Weight = .regular
    private static let design: Font.Design = .default
}
