//
//  ToastViewModel.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/7/24.
//

import Combine

final class ToastViewModel: ObservableObject {
    @Published var error: String?
    
    var toastIsPresented: Bool { error != nil }
    
    var onNeedHideAfter: (Int) -> Void = { _ in }
    
    init(error: String? = nil) {
        self.error = error
    }
    
    private var secondsUntilToastShouldHide: Int { 5 }
    
    func processTap() {
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
