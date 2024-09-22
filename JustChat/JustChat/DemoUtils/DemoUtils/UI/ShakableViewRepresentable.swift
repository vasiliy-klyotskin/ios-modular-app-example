//
//  ShakableViewRepresentable.swift
//  JustChat
//
//  Created by Василий Клецкин on 9/22/24.
//

import SwiftUI

struct ShakableViewRepresentable: UIViewControllerRepresentable {
    let onShake: () -> ()

    class ShakeableViewController: UIViewController {
        var onShake: (() -> ())?

        override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
            if motion == .motionShake {
                onShake?()
            }
        }
    }

    func makeUIViewController(context: Context) -> ShakeableViewController {
        let controller = ShakeableViewController()
        controller.onShake = onShake
        return controller
    }
    
    func updateUIViewController(_ uiViewController: ShakeableViewController, context: Context) {
        uiViewController.onShake = onShake
    }
}

extension View {
    func onShake(_ block: @escaping () -> Void) -> some View {
        overlay(
            ShakableViewRepresentable(onShake: block).allowsHitTesting(false)
        )
    }
}
