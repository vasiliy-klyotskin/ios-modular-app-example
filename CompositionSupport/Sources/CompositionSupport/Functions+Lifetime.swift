//
//  Functions+WeakCurrying.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/13/24.
//

public func <~<A: AnyObject, B, C>(_ fun: @escaping (Weak<A>, B) -> C, a: A?) -> (B) -> C {
    let a = Weak(a)
    return { b in fun(a, b) }
}

public func <~<A: AnyObject, B, C, D>(_ fun: @escaping (Weak<A>, B, C) -> D, a: A?) -> (B, C) -> D {
    let a = Weak(a)
    return { b, c in fun(a, b, c) }
}

public func <~<A: AnyObject, B, C, D, E>(_ fun: @escaping (Weak<A>, B, C, D) -> E, a: A?) -> (B, C, D) -> E {
    let a = Weak(a)
    return { b, c, d in fun(a, b, c, d) }
}
