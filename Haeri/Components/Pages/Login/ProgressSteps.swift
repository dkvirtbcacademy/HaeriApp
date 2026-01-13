//
//  ProgressSteps.swift
//  Haeri
//
//  Created by kv on 10.01.26.
//

import UIKit

class ProgressSteps: UIView {
    private var progressCapsules: [UIView] = []
    
    init(steps: Int) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setupProgressCapsules(count: steps)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupProgressCapsules(count: Int) {
        let capsuleWidth = (80 - CGFloat((count - 1) * 8)) / CGFloat(count)
        
        for i in 0..<count {
            let xPosition = CGFloat(i) * (capsuleWidth + 8)
            
            let capsuleContainer = UIView(frame: CGRect(x: xPosition, y: 0, width: capsuleWidth, height: 3))
            capsuleContainer.backgroundColor = UIColor(named: "StepColor")?.withAlphaComponent(0.3)
            capsuleContainer.layer.cornerRadius = 1.5
            capsuleContainer.clipsToBounds = true
            
            let fillView = UIView(frame: capsuleContainer.bounds)
            fillView.backgroundColor = UIColor(named: "StepColor")
            fillView.layer.anchorPoint = CGPoint(x: 0, y: 0.5)
            fillView.frame = CGRect(x: 0, y: 0, width: capsuleWidth, height: 3)
            fillView.transform = CGAffineTransform(scaleX: i == 0 ? 1 : 0, y: 1)
            
            capsuleContainer.addSubview(fillView)
            addSubview(capsuleContainer)
            
            progressCapsules.append(fillView)
        }
    }
    
    func updateProgress(currentStep: Int) {
        for (index, fillView) in progressCapsules.enumerated() {
            let shouldFill = index < currentStep
            
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
                fillView.transform = CGAffineTransform(scaleX: shouldFill ? 1 : 0, y: 1)
            }
        }
    }
}
