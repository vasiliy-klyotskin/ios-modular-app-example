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

func <~<A, B>(_ fun: @escaping (A) -> B, a: A) -> () -> B {
    { fun(a) }
}

func <~<A, B, C>(_ fun: @escaping (A, B) -> C, a: A) -> (B) -> C {
    { b in fun(a, b) }
}

func <~<A, B, C, D>(_ fun: @escaping (A, B, C) -> D, a: A) -> (B, C) -> D {
    { b, c in fun(a, b, c) }
}

func <~<A, B, C, D, E>(_ fun: @escaping (A, B, C, D) -> E, a: A) -> (B, C, D) -> E {
    { b, c, d in fun(a, b, c, d) }
}
