//
//  MemoryLeakChecker.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/11/24.
//

import Testing

final class MemoryLeakChecker {
    private var blocks: [() -> Void] = []
    
    func addForChecking(_ objects: AnyObject..., sourceLocation: SourceLocation = #_sourceLocation) {
        objects.forEach { object in
            blocks.append({ [weak object] in
                #expect(object == nil, "Object should be nil. Potential memory leak", sourceLocation: sourceLocation)
            })
        }
    }
    
    deinit {
        blocks.forEach { $0() }
    }
}
