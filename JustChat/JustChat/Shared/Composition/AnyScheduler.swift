//
//  AnyScheduler.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/11/24.
//

import Combine
import Foundation

public struct AnyScheduler<SchedulerTimeType: Strideable, SchedulerOptions>: Scheduler where SchedulerTimeType.Stride: SchedulerTimeIntervalConvertible {
    private let _now: () -> SchedulerTimeType
    private let _minimumTolerance: () -> SchedulerTimeType.Stride
    private let _schedule: (SchedulerOptions?, @escaping () -> Void) -> Void
    private let _scheduleAfter: (SchedulerTimeType, SchedulerTimeType.Stride, SchedulerOptions?, @escaping () -> Void) -> Void
    private let _scheduleAfterInterval: (SchedulerTimeType, SchedulerTimeType.Stride, SchedulerTimeType.Stride, SchedulerOptions?, @escaping () -> Void) -> Cancellable
    
    init<S>(_ scheduler: S) where SchedulerTimeType == S.SchedulerTimeType, SchedulerOptions == S.SchedulerOptions, S: Scheduler {
        _now = { scheduler.now }
        _minimumTolerance = { scheduler.minimumTolerance }
        _schedule = scheduler.schedule(options:_:)
        _scheduleAfter = scheduler.schedule(after:tolerance:options:_:)
        _scheduleAfterInterval = scheduler.schedule(after:interval:tolerance:options:_:)
    }
    
    public var now: SchedulerTimeType { _now() }
    
    public var minimumTolerance: SchedulerTimeType.Stride { _minimumTolerance() }
    
    public func schedule(options: SchedulerOptions?, _ action: @escaping () -> Void) {
        _schedule(options, action)
    }
    
    public func schedule(after date: SchedulerTimeType, tolerance: SchedulerTimeType.Stride, options: SchedulerOptions?, _ action: @escaping () -> Void) {
        _scheduleAfter(date, tolerance, options, action)
    }
    
    public func schedule(after date: SchedulerTimeType, interval: SchedulerTimeType.Stride, tolerance: SchedulerTimeType.Stride, options: SchedulerOptions?, _ action: @escaping () -> Void) -> Cancellable {
        _scheduleAfterInterval(date, interval, tolerance, options, action)
    }
}

public typealias AnySchedulerOf<Scheduler: Combine.Scheduler> = AnyScheduler<Scheduler.SchedulerTimeType, Scheduler.SchedulerOptions>

extension Scheduler {
    public func eraseToAnyScheduler() -> AnyScheduler<SchedulerTimeType, SchedulerOptions> {
        AnyScheduler(self)
    }
}

extension AnySchedulerOf<DispatchQueue> {
    public static var main: Self {
        DispatchQueue.main.eraseToAnyScheduler()
    }
}
