//
//  TestScheduler.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/11/24.
//

import JustChat
import Combine
import Foundation

extension DispatchQueue {
    public static var test: TestSchedulerOf<DispatchQueue> {
        TestScheduler(now: DispatchQueue.SchedulerTimeType(DispatchTime(uptimeNanoseconds: 1)))
    }
}

public typealias TestSchedulerOf<Scheduler> = TestScheduler<Scheduler.SchedulerTimeType, Scheduler.SchedulerOptions> where Scheduler: Combine.Scheduler


public final class TestScheduler<SchedulerTimeType: Strideable, SchedulerOptions>: Scheduler where SchedulerTimeType.Stride: SchedulerTimeIntervalConvertible {
    private var lastSequence: UInt = 0
    public let minimumTolerance: SchedulerTimeType.Stride = .zero
    public private(set) var now: SchedulerTimeType
    private var scheduled: [(sequence: UInt, date: SchedulerTimeType, action: () -> Void)] = []
    
    public init(now: SchedulerTimeType) {
        self.now = now
    }

    public func advance(by duration: SchedulerTimeType.Stride = .zero) {
        advance(to: now.advanced(by: duration))
    }
    
    private func advance(to instant: SchedulerTimeType) {
        while now <= instant {
            scheduled.sort { ($0.date, $0.sequence) < ($1.date, $1.sequence) }
            guard
                let next = scheduled.first,
                instant >= next.date
            else {
                now = instant
                return
            }
            now = next.date
            scheduled.removeFirst()
            next.action()
        }
    }
    
    public func schedule(
        after date: SchedulerTimeType,
        interval: SchedulerTimeType.Stride,
        tolerance _: SchedulerTimeType.Stride,
        options _: SchedulerOptions?,
        _ action: @escaping () -> Void
    ) -> Cancellable {
        let sequence = nextSequence()
        
        func scheduleAction(for date: SchedulerTimeType) -> () -> Void {
            { [weak self] in
                let nextDate = date.advanced(by: interval)
                self?.scheduled.append((sequence, nextDate, scheduleAction(for: nextDate)))
                action()
            }
        }
        
        scheduled.append((sequence, date, scheduleAction(for: date)))
        return AnyCancellable { [weak self] in
            self?.scheduled.removeAll(where: { $0.sequence == sequence })
        }
    }
    
    public func schedule(
        after date: SchedulerTimeType,
        tolerance _: SchedulerTimeType.Stride,
        options _: SchedulerOptions?,
        _ action: @escaping () -> Void
    ) {
        scheduled.append((nextSequence(), date, action))
    }
    
    public func schedule(options _: SchedulerOptions?, _ action: @escaping () -> Void) {
        scheduled.append((nextSequence(), now, action))
    }
    
    private func nextSequence() -> UInt {
        lastSequence += 1
        return lastSequence
    }
}
