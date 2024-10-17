//
//  Functions+Currying.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/13/24.
//

precedencegroup FunctionCurryingPrecedence {
    associativity: left
    higherThan: AssignmentPrecedence
}

infix operator <~: FunctionCurryingPrecedence

public func <~<A, B>(_ fun: @escaping (A) -> B, a: A) -> () -> B {
    { fun(a) }
}

public func <~<A, B, C>(_ fun: @escaping (A, B) -> C, a: A) -> (B) -> C {
    { b in fun(a, b) }
}

public func <~<A, B, C, D>(_ fun: @escaping (A, B, C) -> D, a: A) -> (B, C) -> D {
    { b, c in fun(a, b, c) }
}

public func <~<A, B, C, D, E>(_ fun: @escaping (A, B, C, D) -> E, a: A) -> (B, C, D) -> E {
    { b, c, d in fun(a, b, c, d) }
}

public func <~<A, B, C, D, E, F>(_ fun: @escaping (A, B, C, D, E) -> F, a: A) -> (B, C, D, E) -> F {
    { b, c, d, e in fun(a, b, c, d, e) }
}

public func <~<A, B, C, D, E, F, G>(_ fun: @escaping (A, B, C, D, E, F) -> G, a: A) -> (B, C, D, E, F) -> G {
    { b, c, d, e, f in fun(a, b, c, d, e, f) }
}
