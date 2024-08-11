//
//  MemoryLeakChecker.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/11/24.
//

import Testing

final class MemoryLeakChecker {
    private var blocks: [() -> Void] = []
    
    func addForChecking(_ object: AnyObject) {
        blocks.append({ [weak object] in
            #expect(object == nil, "Object should be nil. Potential memory leak")
        })
    }
    
    func check() {
        blocks.forEach { $0() }
    }
}
