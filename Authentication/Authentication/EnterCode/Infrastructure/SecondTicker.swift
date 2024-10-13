//
//  SecondTicker.swift
//  JustChat
//
//  Created by Василий Клецкин on 9/14/24.
//

import Foundation

public typealias MakeTimer = (_ interval: TimeInterval, _ repeats: Bool, _ block: @escaping (Timer) -> Void) -> Timer

final class SecondTicker {
    var onTick: () -> Void = {}
    
    private let timeinterval: TimeInterval = 1
    private let makeTimer: MakeTimer
    
    private var timer: Timer?
    
    init(makeTimer: @escaping MakeTimer = { _, _, _ in Timer() }) {
        self.makeTimer = makeTimer
    }
    
    func start() {
        timer = makeTimer(timeinterval, true) { [weak self] _ in
            self?.onTick()
        }
    }
    
    func invalidate() {
        timer?.invalidate()
        timer = nil
    }
    
    func isTicking() -> Bool {
        timer != nil
    }
}

extension Timer {
    public static func scheduledOnMainRunLoop(interval: TimeInterval, repeats: Bool, block: @escaping (Timer) -> Void) -> Timer {
        let timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: repeats, block: block)
        RunLoop.main.add(timer, forMode: .common)
        return timer
    }
}
