//
//  Functions+Helpers.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/9/24.
//

precedencegroup FunctionCurryingPrecedence {
    associativity: left
    higherThan: AssignmentPrecedence
}

infix operator <~: FunctionCurryingPrecedence

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

func <~<A, B, C, D, E, F>(_ fun: @escaping (A, B, C, D, E) -> F, a: A) -> (B, C, D, E) -> F {
    { b, c, d, e in fun(a, b, c, d, e) }
}

infix operator <?: FunctionCurryingPrecedence

func <?<A: AnyObject, B, C, D>(_ fun: @escaping (A?, B, C) -> D, a: A?) -> (B, C) -> D {
    { [weak a] b, c in fun(a, b, c) }
}
