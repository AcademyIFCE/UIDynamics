import UIKit

open class DynamicsViewController: UIViewController {
    
    //MARK: - Dynamic Items
    //Cada UIView já é considerada um UIDynamicItem por Padrão
    public lazy var clockBox: DynamicBox = {
        let view = DynamicBox(frame: .zero)      
        view.layer.borderWidth = 10
        view.layer.borderColor = UIColor.brown.cgColor
        view.layer.cornerRadius = 50
        view.backgroundColor = UIColor.brown.withAlphaComponent(0.8)
        return view
    }()
    
    public lazy var pendulumBar: DynamicBox = {
        let view = DynamicBox(frame: .zero)
        view.layer.borderWidth = 2.5
        view.layer.borderColor = UIColor.gray.cgColor
        view.layer.cornerRadius = 5
        view.backgroundColor = UIColor.gray.withAlphaComponent(0.8)
        return view
    }()
    
    public lazy var pendulum: DynamicCircle = {
        let view = DynamicCircle(frame: .zero)
        view.layer.borderWidth = 5
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.cornerRadius = 50
        view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.8)
        return view
    }()
    
    
    
    //MARK: UIDynamicAnimator
    //UIDynamicAnimator é o responsável por executar e gerenciar todos os UIDynamicBehaviors e os Dynamic Items vinculados a eles.
    public lazy var animator: UIDynamicAnimator = {
        //Instanciando o Animator com a view da DynamicsViewController como referência
        let animator = UIDynamicAnimator(referenceView: self.view)
        animator.setValue(true, forKey: "debugEnabled")
        return animator
    }()
    
    
    
    //MARK: UIDynamicBehaviors
    //Page: UIGravityBehavior 
    public var gravityBehavior: UIGravityBehavior!
    
    //Page: UIAttachmentBehavior
    public var anchoredItemBehavior: UIDynamicItemBehavior!
    public var pinAttachmentBehavior: UIAttachmentBehavior!
    public var fixedAttachmentBehavior: UIAttachmentBehavior!
    
    //Page: UICollisionBehavior
    public var collisionBehavior: UICollisionBehavior!
    
    //Page: UIPushBehavior
    public var instantaneousPushBehavior: UIPushBehavior!
    public var continuousPushBehavior: UIPushBehavior!
    
    //Page: UISnapBehavior
    public var snapBehavior: UISnapBehavior!
    
    //Page: UIFieldBehavior
    public var fieldBehavior: UIFieldBehavior!
    
    
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        setupFrames()
        
        addDynamics()
    }
    
    private func addSubviews() {
        self.view.addSubview(clockBox)
        self.view.addSubview(pendulumBar)
        self.view.addSubview(pendulum)
    }
    
    private func setupFrames() {
        clockBox.frame = CGRect(
            x: view.center.x-200,
            y: view.center.y-100,
            width: 200, 
            height: 200
        )
        pendulumBar.frame = CGRect(
            x: clockBox.frame.midX-5,
            y: clockBox.frame.maxY,
            width: 10,
            height: 150
        )
        pendulum.frame = CGRect(
            x: pendulumBar.frame.midX-50,
            y: pendulumBar.frame.maxY-50,
            width: 100,
            height: 100
        )
    }
    
    open func addDynamics() { } //override me
    
}





//MARK: - Todas as funções de addBehavior utilizadas nas Pages
extension DynamicsViewController {
    
    public func addGravityBehavior(dx: CGFloat, dy: CGFloat) {
        //UIGravityBehavior faz com que os Dynamic Items sejam atraídos para alguma direção
        self.gravityBehavior = UIGravityBehavior(
            items: [ clockBox, pendulumBar, pendulum ]
        )
        //direção da gravidade
        gravityBehavior.gravityDirection = .init(dx: dx, dy: dy)
        //adicionando behavior ao animator, para que ele anime os Dynamic Items
        animator.addBehavior(gravityBehavior)
    }
    
    public func addAttachmentBehavior() {
        //MARK: - Fixando Dynamic Item na Parent View
        //Fixando o clockBox na view
        let clockBoxToViewDynamicBehavior = UIDynamicItemBehavior(items: [ clockBox ])
        clockBoxToViewDynamicBehavior.isAnchored = true
        //Adicionando no animator
        animator.addBehavior(clockBoxToViewDynamicBehavior)
        self.anchoredItemBehavior = clockBoxToViewDynamicBehavior
        
        
        //MARK: - PinAttachment
        //Definindo um UIAttachmentBehavior do tipo pin do pendulumBar para a clockBox
        let pendulumBarToClockBoxAttachmentBehavior = UIAttachmentBehavior.pinAttachment(
            with: pendulumBar, 
            attachedTo: clockBox, 
            attachmentAnchor: CGPoint(
                x: clockBox.frame.midX, 
                y: clockBox.frame.maxY
            )
        )
        //Quanto maior o frictionTorque, mais dificuldade o objeto terá de se mover ao redor do pinAttachment
        pendulumBarToClockBoxAttachmentBehavior.frictionTorque = .zero
        //Adicionando ao Animator
        animator.addBehavior(pendulumBarToClockBoxAttachmentBehavior)
        self.pinAttachmentBehavior = pendulumBarToClockBoxAttachmentBehavior
        
        //MARK: - FixedAttachment
        //Definindo um UIAttachmentBehavior do tipo fixed do pendulumBar para o pendulum
        let pendulumToPendulumBarAttachmentBehavior = UIAttachmentBehavior.fixedAttachment(
            with: pendulum, 
            attachedTo: pendulumBar, 
            attachmentAnchor: CGPoint(
                x: pendulumBar.frame.midX, 
                y: pendulumBar.frame.maxY
            )
        )
        //Adicionando ao Animator
        animator.addBehavior(pendulumToPendulumBarAttachmentBehavior)
        self.fixedAttachmentBehavior = pendulumToPendulumBarAttachmentBehavior
        
        //MARK: - Hora de brincar
        //Modifique a direção da gravidade na função addGravity para ver o pendulo girando
    }
    
    public func addCollisionBehavior() {
        //Definindo um UICollisionBehavior entre o pendulum e o clockBox
        self.collisionBehavior = UICollisionBehavior(
            items: [pendulum, clockBox]
        )
        //Assinando collisionDelegate para detectar começo e fim da colisão, implementado na Page UICollisionBehavior desse playground.
        //collisionBehavior.collisionDelegate = self
        animator.addBehavior(collisionBehavior)
    }
    
    public func addPushBehavior() {
        //Definindo o UIPushBehavior do tipo continuous, que, quando está ativo, continua constantemente puxando o Dynamic Item para a direção ou angulo configurado 
        self.continuousPushBehavior = UIPushBehavior(
            items: [pendulumBar], 
            mode: .continuous 
        )
        continuousPushBehavior.pushDirection = .init(dx: 0, dy: 1)
        continuousPushBehavior.magnitude = 100
        continuousPushBehavior.active = false
        animator.addBehavior(continuousPushBehavior)
        
        //Definindo o UIPushBehavior do tipo instantaneous, que, quando está ativo, impulsiona uma vez o Dynamic Item para a direção ou angulo configurado
        self.instantaneousPushBehavior = UIPushBehavior(
            items: [self.pendulumBar], 
            mode: .instantaneous
        )
        instantaneousPushBehavior.angle = 90
        instantaneousPushBehavior.magnitude = 100
        instantaneousPushBehavior.active = false
        self.animator.addBehavior(instantaneousPushBehavior)
        
        //Código de demonstração
        //Definição do timer para de 3 em 3 segundos alternar entre os dois tipos de Push.
        let crazyPendulum = Timer.scheduledTimer(withTimeInterval: 3, repeats: true, block: { _ in
            if self.continuousPushBehavior.active {
                self.pendulumBar.backgroundColor = .yellow
                self.continuousPushBehavior.active = false 
                self.instantaneousPushBehavior.active = true
            } else {
                self.pendulumBar.backgroundColor = UIColor.gray.withAlphaComponent(0.8)
                self.continuousPushBehavior.active = true 
                self.instantaneousPushBehavior.active = false
            }
        })
        crazyPendulum.fire()
    }
    
    public func addSnapBehavior() {
        //Guardando a posição inicial dos Dynamic Items
        let initialPositionClockBox = self.clockBox.center
        let initialPositionPendulumBar = self.pendulumBar.center
        let initialPositionPendulum = self.pendulum.center
        
        //Movendo os Dynamic Items para fora da área visível da view
        self.clockBox.center.y -= 300
        self.pendulum.center.y -= 300
        self.pendulumBar.center.y -= 300
        
        //Definindo todos um UISnapBehavior para cada Dynamic Item.
        let snapClockBoxBehavior = UISnapBehavior(
            item: self.clockBox, 
            snapTo: initialPositionClockBox
        )
        //Setando o damping de cada UISnapBehavior
        //Quanto mais damping menos o Dynamic Item vai oscilar na chegada ao SnapPoint
        snapClockBoxBehavior.damping = 0.2
        self.animator.addBehavior(snapClockBoxBehavior)
        
        let snapPendulumBarBehavior = UISnapBehavior(
            item: self.pendulumBar, 
            snapTo: initialPositionPendulumBar
        )
        snapPendulumBarBehavior.damping = 0.2
        self.animator.addBehavior(snapPendulumBarBehavior)
        
        let snapPendulumBehavior = UISnapBehavior(
            item: self.pendulum, 
            snapTo: initialPositionPendulum
        )
        snapPendulumBehavior.damping = 0.2
        self.animator.addBehavior(snapPendulumBehavior)
    }
    
}

//MARK: - UICollisionDelegate, implementado na Page UICollisionBehavior desse playground
/*
 extension DynamicsViewController: UICollisionBehaviorDelegate {
    
    //funcão que é chamada no início da colisão do tipo everything
    open func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item1: UIDynamicItem, with item2: UIDynamicItem, at p: CGPoint) {
        pendulum.backgroundColor = UIColor.yellow.withAlphaComponent(0.8)
        gravityBehavior.gravityDirection.dx *= -1
    }
    
    //funcão que é chamada no fim da colisão do tipo everything
    open func collisionBehavior(_ behavior: UICollisionBehavior, endedContactFor item1: UIDynamicItem, with item2: UIDynamicItem) {
        pendulum.backgroundColor = UIColor.gray.withAlphaComponent(0.8)
    }
    
}
 */

