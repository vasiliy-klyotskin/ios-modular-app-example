//
//  Event.swift
//  JustChat
//
//  Created by Василий Клецкин on 9/22/24.
//

func firstly<Message>(_ block: @escaping (Message) -> Void) -> Event<Message> {
    Event(block: block)
}

struct Event<Message> {
    let block: (Message) -> Void
    
    var execute: (Message) -> Void { block }
    
    func then(_ nextBlock: @escaping (Message) -> Void) -> Event<Message> {
        Event { message in
            block(message)
            nextBlock(message)
        }
    }
    
    func map<NewMessage>(_ mapping: @escaping (NewMessage) -> Message) -> Event<NewMessage> {
        Event<NewMessage> { message in
            block(mapping(message))
        }
    }
}
