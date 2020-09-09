//
//  ViewCodeConfiguration.swift
//  UIDynamicsSample
//
//  Created by Gabriela Bezerra on 06/09/20.
//  Copyright © 2020 Gabriela Bezerra. All rights reserved.
//

import Foundation

protocol ViewCodeConfiguration {
    func buildHierarchy()
    func setupLayout()
    func configureViews()
}

extension ViewCodeConfiguration {
    
    func configureViews() { }
    
    func applyViewCode() {
        buildHierarchy()
        setupLayout()
        configureViews()
    }
}
