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
}
