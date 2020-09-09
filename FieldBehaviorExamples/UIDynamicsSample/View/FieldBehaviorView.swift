//
//  FieldBehaviorView.swift
//  UIDynamicsSample
//
//  Created by Gabriela Bezerra on 09/09/20.
//  Copyright © 2020 Gabriela Bezerra. All rights reserved.
//

import Foundation
import UIKit

class FieldBehaviorView: UIView {
    
    lazy var balls: [DynamicBallLabel] = [
        DynamicBallLabel(frame: .zero),
        DynamicBallLabel(frame: .zero),
        DynamicBallLabel(frame: .zero)
    ]
    
    lazy var titleLabel: UILabel = UILabel(frame: .zero)
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        applyViewCode()
    }
    
}

extension FieldBehaviorView: ViewCodeConfiguration {
    
    func buildHierarchy() {
        self.addSubview(titleLabel)
        balls.forEach { ball in
            self.addSubview(ball)
        }
    }
    
    func setupLayout() {
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 20)
        ])
        
        balls.enumerated().forEach { (index, ball) in
            ball.frame = CGRect(
                x: index % 3 == 0 ? self.frame.minX : (index % 2 == 0 ? self.frame.maxX-100 : self.frame.minX),
                y: index % 3 == 0 ? self.frame.minY : (index % 2 == 0 ? self.frame.minY : self.frame.midY-100),
                width: 100,
                height: 100
            )
            ball.layer.cornerRadius = 50
            ball.clipsToBounds = true
        }
    }
    
    func configureViews() {
        self.backgroundColor = .white
        
        self.titleLabel.textAlignment = .center
        titleLabel.text = "Hello friend"
        titleLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
    }
    
}
