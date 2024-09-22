//
//  OAuthViewModel.swift
//  JustChat
//
//  Created by Василий Клецкин on 9/15/24.
//

import Combine

final class OAuthViewModel: ObservableObject {
    var onNeedStartGoogleSignIn: () -> Void = {}
    
    @Published private(set) var isLoadingIndicatorVisible = false
    
    let toast: ToastViewModel
    
    init(toast: ToastViewModel) {
        self.toast = toast
    }

    func displayLoadingStart() {
        isLoadingIndicatorVisible = true
    }
    
    func displayLoadingFinish() {
        isLoadingIndicatorVisible = false
    }
    
    func displayError(_ error: OAuthError) {
        toast.updateMessage(error.message)
    }
    
    func startGoogleSignIn() {
        toast.updateMessage(nil)
        onNeedStartGoogleSignIn()
    }
}
