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
    
    let size: CGSize
    let imageName: String
    
    @Environment(\.self) private var environmentValues
    
    private let particleEmitter = CAEmitterLayer()
    private let imageSize: CGFloat = 10
    private let verticalOffset: CGFloat = -128
    
    func makeUIView(context: Context) -> UIView { .init() }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        guard size.width > 1 && uiView.layer.sublayers == nil else { return }
        particleEmitter.emitterCells = [makeCell()]
        particleEmitter.emitterShape = .line
        particleEmitter.renderMode = .additive
        particleEmitter.emitterPosition = CGPoint(x: size.width / 2, y: verticalOffset)
        particleEmitter.emitterSize = .init(width: size.width, height: 0)
        uiView.layer.addSublayer(particleEmitter)
    }
    
    private func makeCell() -> CAEmitterCell {
        let cell = CAEmitterCell()
        cell.birthRate = 4
        cell.lifetime = 20.0
        cell.velocity = 40
        cell.velocityRange = 50
        cell.emissionLongitude = .pi
        cell.spinRange = 7
        cell.scaleRange = 1
        cell.alphaSpeed = -0.1
        cell.alphaRange = 0.3
        cell.color = UI.color.main.primary.resolve(in: environmentValues).cgColor
        cell.contents = createWhiteImage(size: .init(width: imageSize, height: imageSize))?.cgImage
        return cell
    }
    
    private func createWhiteImage(size: CGSize) -> UIImage? {
        let sparklesImage = UIImage(systemName: imageName)?.withRenderingMode(.alwaysTemplate)
        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { context in
            UIColor.white.set()
            sparklesImage?.draw(in: CGRect(origin: .zero, size: size))
        }
        return image
    }
}

#Preview {
    GeometryReader(content: { geo in
        ParticlesView(size: geo.size, imageName: "sparkles")
            .environment(\.colorScheme, .dark)
    })
}
