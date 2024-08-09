//
//  Functions+Helpers.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/9/24.
//

infix operator <~: FunctionCurryingPrecedence

precedencegroup FunctionCurryingPrecedence {
    associativity: left
    higherThan: AssignmentPrecedence
}

func <~<A, B, C>(_ fun: @escaping (A, B) -> C, a: A) -> (B) -> C {
    curry(fun)(a)
}

public func curry<A, B, C>(_ fun: @escaping (A, B) -> C) -> (A) -> (B) -> C {
    { a in { b in fun(a, b) }}
}
