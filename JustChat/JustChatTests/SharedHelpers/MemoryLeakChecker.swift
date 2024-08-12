//
//  MemoryLeakChecker.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/11/24.
//

import Testing

final class MemoryLeakChecker {
    private var blocks: [() -> Void] = []
    
    func addForChecking(_ object: AnyObject, location: SourceLocation = #_sourceLocation) {
        blocks.append({ [weak object] in
            #expect(object == nil, "Object should be nil. Potential memory leak", sourceLocation: location)
        })
    }
    
    deinit {
        blocks.forEach { $0() }
    }
}
