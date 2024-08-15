//
//  ToastViewModel.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/7/24.
//

import Combine

final class ToastViewModel: ObservableObject {
    @Published var message: String?
    
    var toastIsPresented: Bool { message != nil }
    
    var onNeedHideAfter: (Int) -> Void = { _ in }
    
    private var secondsUntilToastShouldHide: Int { 5 }
    
    func processTap() {
        message = nil
    }
    
    func updateMessage(_ error: String?) {
        self.message = error
        if error != nil {
            onNeedHideAfter(secondsUntilToastShouldHide)
        }
    }
    
    func hideAfterDelay() {
        message = nil
    }
}
