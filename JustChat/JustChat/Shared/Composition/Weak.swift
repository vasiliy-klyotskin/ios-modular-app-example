//
//  Weak.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/13/24.
//

struct Weak<T: AnyObject> {
    weak var obj: T?
    
    init(_ obj: T? = nil) {
        self.obj = obj
    }
    
    func `do`(_ method: @escaping (T.Type) -> (T) -> () -> Void) -> () -> Void {
        { [weak obj] in
            if let obj { method(T.self)(obj)() }
        }
    }
    
    func `do`<A>(_ method: @escaping (T.Type) -> (T) -> (A) -> Void) -> (A) -> Void {
        { [weak obj] a in
            if let obj { method(T.self)(obj)(a) }
        }
    }
}
