//
//  FieldBehaviorViewController.swift
//  UIDynamicsSample
//
//  Created by Gabriela Bezerra on 08/09/20.
//  Copyright © 2020 Gabriela Bezerra. All rights reserved.
//

import UIKit

class FieldBehaviorViewController: UIViewController {
    
    private let fieldView: FieldBehaviorView = FieldBehaviorView()
    private let model: FieldBehaviorModel = FieldBehaviorModel()
    
    lazy var animator: UIDynamicAnimator = {
        let animator = UIDynamicAnimator(referenceView: view)
        animator.setValue(true, forKey: "debugEnabled")
        return animator
    }()
    
    private var collisionBehavior: UICollisionBehavior!
    private var pushBehavior: UIPushBehavior!
    private var snapBehavior: UISnapBehavior!
    private var customDynamicItemBehavior: UIDynamicItemBehavior!

    private var dragFieldBehavior: UIFieldBehavior!
    private var springFieldBehavior: UIFieldBehavior!
    private var noiseFieldBehavior: UIFieldBehavior!
    private var turbulenceField: UIFieldBehavior!
    private var linearGravityField: UIFieldBehavior!
    private var radialGravityField: UIFieldBehavior!
    private var velocityField: UIFieldBehavior!
    private var magneticField: UIFieldBehavior!
    private var electricField: UIFieldBehavior!
    private var vortexField: UIFieldBehavior!
    
    override func loadView() {
        super.loadView()
        self.view = fieldView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fieldView.balls.enumerated().forEach { index, ball in
            ball.text = "\(model.users[index].owner)\nR$ \(model.users[index].amount)"
            
            let pan = UIPanGestureRecognizer(target: self, action: #selector(FieldBehaviorViewController.pan))
            ball.addGestureRecognizer(pan)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addDynamics()
    }
    
    //MARK: - Pan Gesture Recognizer Action
    @objc func pan(_ panGesture: UIPanGestureRecognizer) {
        switch panGesture.state {
        case .began:
            animator.removeAllBehaviors()
        case .changed:
            panGesture.view!.center = panGesture.location(in: view)
        case .ended:
            addDynamics()
        default:
            break
        }
    }
    
    func addDynamics() {
        addCollisionBehavior()
        
        //MARK: - Drag Field
//        fieldView.titleLabel.text = "Drag Field"
//
//        addPushBehavior(dx: 0, dy: 1)
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            self.addDragFieldBehavior(dx: 0, dy: 1)
//
//            for ball in self.fieldView.balls {
//                self.dragFieldBehavior.addItem(ball)
//            }
//        }
        
        //MARK: - Radial Gravity Field
//        fieldView.titleLabel.text = "Radial Gravity Field"
//        addPushBehavior(dx: 0, dy: 1)
//
//        self.addGravityFieldBehavior()
//
//        for ball in self.fieldView.balls {
//            radialGravityField.addItem(ball)
//        }
        
        //MARK: - Noise Field
//        fieldView.titleLabel.text = "Noise Field"
//
//        self.addNoiseFieldBehavior()
//
//        for ball in self.fieldView.balls {
//            self.noiseFieldBehavior.addItem(ball)
//        }
        
        //MARK: - Turbulence Field
//        fieldView.titleLabel.text = "Turbulence Field"
//
//        addPushBehavior(dx: 0, dy: 1)
//        self.addTurbulenceFieldBehavior()
//
//        for ball in self.fieldView.balls {
//            self.turbulenceField.addItem(ball)
//        }
        
        //MARK: - Vortex Field
//        fieldView.titleLabel.text = "Vortex Field"
//
//        addPushBehavior(dx: 0, dy: 1)
//
//        self.addVortexField()
//
//        for ball in self.fieldView.balls {
//            self.vortexField.addItem(ball)
//        }
        
        //MARK: - Nubank Field
        fieldView.titleLabel.text = "Nubank Field"
        
        addSpringFieldBehavior(dx: 0, dy: 0)
        addElectricFieldBehavior()
        addMagneticFieldBehavior()
        
        for (index, ball) in fieldView.balls.enumerated() {
            
            springFieldBehavior.addItem(ball)
            electricField.addItem(ball)
            magneticField.addItem(ball)
            self.addCustomDynamicItemBehavior(ball, charge: index % 2 == 0 ? -1 : 1)
            
        }
        
        
    }
    
}

//MARK: - UIFieldBehaviors
extension FieldBehaviorViewController {
    
    func addMagneticFieldBehavior() {
        magneticField = UIFieldBehavior.magneticField()
        
        magneticField.strength = -5
        magneticField.position = view.center
        
        animator.addBehavior(magneticField)
    }
    
    func addElectricFieldBehavior() {
        electricField = UIFieldBehavior.electricField()
        
        electricField.strength = -5
        electricField.position = view.center
        
        animator.addBehavior(electricField)
    }
    
    func addSpringFieldBehavior(dx: CGFloat, dy: CGFloat) {
        springFieldBehavior = UIFieldBehavior.springField()
        
        springFieldBehavior.position = self.view.center
        springFieldBehavior.region = UIRegion(size: self.view.bounds.size)
        springFieldBehavior.direction = CGVector(dx: dx, dy: dy)
        springFieldBehavior.strength = 100
        springFieldBehavior.falloff = 0
        
        animator.addBehavior(springFieldBehavior)
    }
    
    func addVortexField() {
        vortexField = UIFieldBehavior.vortexField()
        
        vortexField.region = UIRegion(radius: 200)
        vortexField.position = self.view.center
        vortexField.strength = 5
        
        animator.addBehavior(vortexField)
    }
    
    func addTurbulenceFieldBehavior() {
        turbulenceField = UIFieldBehavior.turbulenceField(smoothness: 0.1, animationSpeed: 0.6)
        
        turbulenceField.strength = 10
        turbulenceField.position = self.view.center
        turbulenceField.region = UIRegion(radius: 500)
        
        animator.addBehavior(turbulenceField)
    }
    
    func addNoiseFieldBehavior() {
        noiseFieldBehavior = UIFieldBehavior.noiseField(smoothness: 0.95, animationSpeed: 0.6)
        
        noiseFieldBehavior.strength = 1
        noiseFieldBehavior.position = self.view.center
        noiseFieldBehavior.region = UIRegion(radius: 500)
        
        animator.addBehavior(noiseFieldBehavior)
    }
    
    func addGravityFieldBehavior() {
        radialGravityField = UIFieldBehavior.radialGravityField(position: self.view.center)
        
        radialGravityField.region = UIRegion(radius: 400)
        radialGravityField.strength = 10
        radialGravityField.minimumRadius = 50
        
        animator.addBehavior(radialGravityField)
    }
    
    func addDragFieldBehavior(dx: CGFloat, dy: CGFloat) {
        self.dragFieldBehavior = UIFieldBehavior.dragField()
        
        dragFieldBehavior.position = self.view.center
        dragFieldBehavior.region = UIRegion(size: self.view.bounds.size)
        dragFieldBehavior.direction = CGVector(dx: dx, dy: dy)
        
        animator.addBehavior(dragFieldBehavior)
    }
    
}


//MARK: - Other Dynamic Behaviors
extension FieldBehaviorViewController {
    
    func addCustomDynamicItemBehavior(_ item: UIDynamicItem, charge: CGFloat) {
        customDynamicItemBehavior = UIDynamicItemBehavior()
        
        customDynamicItemBehavior.allowsRotation = false
        
        customDynamicItemBehavior.charge = charge
        customDynamicItemBehavior.elasticity = 0.2
        customDynamicItemBehavior.friction = 10
        customDynamicItemBehavior.resistance = 10
        customDynamicItemBehavior.density = 0.5
        
        customDynamicItemBehavior.addItem(item)
        
        self.animator.addBehavior(customDynamicItemBehavior)
    }
    
    func addSnapBehavior(_ item: UIDynamicItem,snapPoint: CGPoint) {
        snapBehavior = UISnapBehavior(item: item, snapTo: snapPoint)
        snapBehavior.damping = 0
        animator.addBehavior(snapBehavior)
    }
    
    func addPushBehavior(dx: CGFloat, dy: CGFloat) {
        pushBehavior = UIPushBehavior(items: fieldView.balls, mode: .instantaneous)
        pushBehavior.pushDirection = .init(dx: dx, dy: dy)
        pushBehavior.magnitude = 1
        pushBehavior.active = true
        self.animator.addBehavior(pushBehavior)
    }
    
    func addCollisionBehavior() {
        collisionBehavior = UICollisionBehavior(items: fieldView.balls)
        collisionBehavior.translatesReferenceBoundsIntoBoundary = true
        self.animator.addBehavior(collisionBehavior)
    }
}
