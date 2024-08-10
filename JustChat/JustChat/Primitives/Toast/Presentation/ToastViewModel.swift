//
//  ToastViewModel.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/7/24.
//

import Combine

public final class ToastViewModel {
    @Published public var error: String?
    
    var onNeedHideAfter: (Int) -> Void = { _ in }
    
    public func processTap() {
        error = nil
    }
    
    func updateError(_ error: String?) {
        self.error = error
    }
}
