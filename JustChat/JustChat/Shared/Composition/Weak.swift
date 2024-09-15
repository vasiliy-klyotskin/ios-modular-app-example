//
//  Weak.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/13/24.
//

final class Weak<T: AnyObject> {
    weak var obj: T?
    
    init(_ obj: T? = nil) {
        self.obj = obj
    }
    
    func `do`(_ method: @escaping (T.Type) -> (T) -> () -> Void) -> () -> Void {
        {
            if let obj = self.obj { method(T.self)(obj)() }
        }
    }
    
    func `do`<A>(_ method: @escaping (T.Type) -> (T) -> (A) -> Void) -> (A) -> Void {
        { a in
            if let obj = self.obj { method(T.self)(obj)(a) }
        }
    }
}
