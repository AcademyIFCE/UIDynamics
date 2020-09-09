//
//  DynamicItems.swift
//  UIDynamicsSample
//
//  Created by Gabriela Bezerra on 04/09/20.
//  Copyright © 2020 Gabriela Bezerra. All rights reserved.
//

import UIKit

public class DynamicBallLabel: UILabel {
    override public var collisionBoundsType: UIDynamicItemCollisionBoundsType {
        .ellipse
    }
    
    public override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        self.numberOfLines = 2
        self.backgroundColor = .systemPurple
        self.textAlignment = .center
        self.textColor = .white
        self.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        self.isUserInteractionEnabled = true
    }
}
