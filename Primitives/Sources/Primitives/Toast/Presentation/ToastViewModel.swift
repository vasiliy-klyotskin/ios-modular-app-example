//
//  ToastViewModel.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/7/24.
//

import Combine

public final class ToastViewModel: ObservableObject {
    @Published public var message: String?
    
    public var toastIsPresented: Bool { message != nil }
    
    var onNeedHideAfter: (Int) -> Void = { _ in }
    
    private var secondsUntilToastShouldHide: Int { 5 }
    
    public init() {}
    
    public func processTap() {
        message = nil
    }
    
    public func updateMessage(_ error: String?) {
        message = error
        if error != nil {
            onNeedHideAfter(secondsUntilToastShouldHide)
        }
    }
    
    public func hideAfterDelay() {
        message = nil
    }
}
