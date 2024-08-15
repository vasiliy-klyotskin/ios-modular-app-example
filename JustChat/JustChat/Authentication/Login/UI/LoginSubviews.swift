//
//  LoginSubviews.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/13/24.
//

import SwiftUI

struct LoginSubviews {
    let submitButton: (Button.Config) -> Button
    let googleOAuthButton: (Button.Config) -> Button
    let loginInput: (TextField.Config) -> TextField
    let registerButton: (LinkButton.Config) -> LinkButton
    let errorToast: () -> Toast
}
