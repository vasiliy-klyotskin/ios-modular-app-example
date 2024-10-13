//
//  Weak.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/13/24.
//

public final class Weak<T: AnyObject> {
    public weak var obj: T?
    
    public init(_ obj: T? = nil) {
        self.obj = obj
    }
    
    public func `do`(_ method: @escaping (T.Type) -> (T) -> () -> Void) -> () -> Void {
        {
            if let obj = self.obj { method(T.self)(obj)() }
        }
    }
    
    public func `do`<A>(_ method: @escaping (T.Type) -> (T) -> (A) -> Void) -> (A) -> Void {
        { a in
            if let obj = self.obj { method(T.self)(obj)(a) }
        }
    }
}
