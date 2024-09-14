//
//  ParticlesView.swift
//  JustChat
//
//  Created by Василий Клецкин on 9/10/24.
//

import SwiftUI
import UIKit

struct ParticlesView: UIViewRepresentable {
    typealias UIViewType = UIView
    
    let view: UIView = .init()
    let particleEmitter = CAEmitterLayer()
    
    func updateUIView(_ uiView: UIView, context: Context) {
        particleEmitter.emitterPosition = CGPoint(x: 160, y: -100)
        particleEmitter.emitterShape = .line
        particleEmitter.emitterSize = CGSize(width: 600, height: 1)
        particleEmitter.renderMode = .additive
    }
    
    func makeUIView(context: Context) -> UIView {
        let cell = CAEmitterCell()
        cell.birthRate = 8
        cell.lifetime = 20.0
        cell.velocity = 40
        cell.velocityRange = 50
        cell.emissionLongitude = .pi
        cell.spinRange = 5
        cell.scale = 0.5
        cell.scaleRange = 0.25
        cell.color = UIColor.white.cgColor
        cell.alphaSpeed = -0.02
        cell.contents = createWhiteSparklesImage(size: .init(width: 32, height: 32))
        particleEmitter.emitterCells = [cell]
        view.layer.addSublayer(particleEmitter)
        return view
    }
}

func createWhiteSparklesImage(size: CGSize) -> UIImage? {
    let sparklesImage = UIImage(systemName: "sparkles")
    let renderer = UIGraphicsImageRenderer(size: size)
    let image = renderer.image { context in
        UIColor.white.set()
        sparklesImage?.withRenderingMode(.alwaysTemplate).draw(in: CGRect(origin: .zero, size: size))
    }
    return image
}
