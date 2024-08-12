//
//  ToastViewModel.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/7/24.
//

import Combine

public final class ToastViewModel {
    @Published public var error: String?
    
    public var toastIsPresented: Bool { error != nil }
    
    var onNeedHideAfter: (Int) -> Void = { _ in }
    
    private var secondsUntilToastShouldHide: Int { 5 }
    
    public func processTap() {
        error = nil
    }
    
    func updateError(_ error: String?) {
        self.error = error
        if error != nil {
            onNeedHideAfter(secondsUntilToastShouldHide)
        }
    }
    
    func hideAfterDelay() {
        error = nil
    }
}
