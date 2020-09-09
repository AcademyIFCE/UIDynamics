import UIKit

public class DynamicBox: UIView {
    public override var collisionBoundsType: UIDynamicItemCollisionBoundsType {
        .rectangle
    }
}

public class DynamicCircle: UIView {
    public override var collisionBoundsType: UIDynamicItemCollisionBoundsType {
        .ellipse
    }
}
