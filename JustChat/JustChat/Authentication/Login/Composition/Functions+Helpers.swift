//
//  Functions+Helpers.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/10/24.
//

func weakify<Object: AnyObject>(_ object: Object, _ method: @escaping (Object.Type) -> (Object) -> () -> Void) -> () -> Void {
    return { [weak object] in
        object.map { method(type(of: $0))($0)() }
    }
}

func weakify<Object: AnyObject, A>(_ object: Object, _ method: @escaping (Object.Type) -> (Object) -> (A) -> Void) -> (A) -> Void {
    return { [weak object] a in
        object.map { method(type(of: $0))($0)(a) }
    }
}
