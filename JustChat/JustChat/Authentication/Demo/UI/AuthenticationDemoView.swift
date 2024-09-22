//
//  AuthenticationDemoView.swift
//  JustChat
//
//  Created by Василий Клецкин on 9/22/24.
//

import SwiftUI

struct AuthenticationDemoView: View {
    @ObservedObject var vm: AuthenticationDemoViewModel
    let authentication: AuthenticationFeature
    let demoUtils: DemoUtilsFeature
    let toast: ToastFeature
    
    var body: some View {
        authentication.view()
            .showToast(toast.view())
            .hideKeyboardOnTap()
            .alert(vm.successTitle, isPresented: $vm.showSuccessAlert) {
                SwiftUI.Button(vm.restartButtonTitle, role: .cancel, action: vm.restart)
            } message: {
                Text(vm.successMessage)
            }
            .run(demoUtils: demoUtils)
    }
}
