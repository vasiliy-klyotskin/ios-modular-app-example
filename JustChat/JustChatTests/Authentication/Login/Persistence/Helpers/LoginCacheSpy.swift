//
//  LoginCacheSpy.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/11/24.
//

import Foundation

final class LoginCacheSpy {
    private var currentTime: Date = Date()
    
    func getCurrentTime() -> Date {
        currentTime
    }
    
    func simulateTimePassed(seconds: Int) {
        currentTime.addTimeInterval(TimeInterval(seconds))
    }
}
