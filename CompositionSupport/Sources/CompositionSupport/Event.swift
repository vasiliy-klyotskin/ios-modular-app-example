//
//  Event.swift
//  JustChat
//
//  Created by Василий Клецкин on 9/22/24.
//

public func firstly<Message>(_ block: @escaping (Message) -> Void) -> Event<Message> {
    Event(block: block)
}

public struct Event<Message> {
    private let block: (Message) -> Void
    
    public var execute: (Message) -> Void { block }
    
    public init(block: @escaping (Message) -> Void) {
        self.block = block
    }

    public func then(_ nextBlock: @escaping (Message) -> Void) -> Event<Message> {
        Event { message in
            block(message)
            nextBlock(message)
        }
    }
    
    public func map<NewMessage>(_ mapping: @escaping (NewMessage) -> Message) -> Event<NewMessage> {
        Event<NewMessage> { message in
            block(mapping(message))
        }
    }
}
