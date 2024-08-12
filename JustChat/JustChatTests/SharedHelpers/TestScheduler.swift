//
//  TestScheduler.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/11/24.
//

import JustChat
import Combine
import Foundation

final class TestScheduler<SchedulerTimeType: Strideable, SchedulerOptions>: Scheduler where SchedulerTimeType.Stride: SchedulerTimeIntervalConvertible {
    private var lastSequence: UInt = 0
    let minimumTolerance: SchedulerTimeType.Stride = .zero
    private(set) var now: SchedulerTimeType
    private var scheduled: [(sequence: UInt, date: SchedulerTimeType, action: () -> Void)] = []
    
    init(now: SchedulerTimeType) {
        self.now = now
    }

    func advance(by duration: SchedulerTimeType.Stride = .zero) {
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
    
    func schedule(
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
    
    func schedule(
        after date: SchedulerTimeType,
        tolerance _: SchedulerTimeType.Stride,
        options _: SchedulerOptions?,
        _ action: @escaping () -> Void
    ) {
        scheduled.append((nextSequence(), date, action))
    }
    
    func schedule(options _: SchedulerOptions?, _ action: @escaping () -> Void) {
        scheduled.append((nextSequence(), now, action))
    }
    
    private func nextSequence() -> UInt {
        lastSequence += 1
        return lastSequence
    }
}

typealias TestSchedulerOf<Scheduler> = TestScheduler<Scheduler.SchedulerTimeType, Scheduler.SchedulerOptions> where Scheduler: Combine.Scheduler

extension DispatchQueue {
    static var test: TestSchedulerOf<DispatchQueue> {
        TestScheduler(now: DispatchQueue.SchedulerTimeType(DispatchTime(uptimeNanoseconds: 1)))
    }
}
