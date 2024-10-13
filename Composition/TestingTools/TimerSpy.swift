//
//  TimerSpy.swift
//  JustChat
//
//  Created by Василий Клецкин on 9/3/24.
//

import Foundation

public typealias MakeTimer = (_ interval: TimeInterval, _ repeats: Bool, _ block: @escaping (Timer) -> Void) -> Timer

public final class TimerSpy {
    private var timePassed: TimeInterval = 0
    private var timeInterval: TimeInterval = 0
    private var repeats: Bool = false
    private var hasFiredOnce: Bool = false
    private var block: (Timer) -> Void = { _ in }
    private var timer: Timer = .init()
    
    public init() {}
    
    public func make() -> MakeTimer {
        let timer = Timer()
        self.timer = timer
        return { timeInterval, repeats, block in
            self.timeInterval = timeInterval
            self.repeats = repeats
            self.block = block
            return timer
        }
    }
    
    public func simulateTimePassed(seconds: Int) {
        if timeInterval <= 0 { return }
        if hasFiredOnce && !repeats { return }
        
        timePassed += TimeInterval(seconds)
        let timesToFire = Int(timePassed / timeInterval)
        for _ in 0..<timesToFire {
            block(timer)
            hasFiredOnce = true
            if !repeats {
                break
            }
        }
        timePassed -= TimeInterval(timesToFire) * timeInterval
    }
}
