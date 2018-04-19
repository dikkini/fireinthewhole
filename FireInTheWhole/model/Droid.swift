//
//  Droid.swift
//  FireInTheWhole
//
//  Created by  beop on 14/04/2018.
//  Copyright © 2018 Artur Karapetov. All rights reserved.
//

import Foundation
import SpriteKit

class Droid: Character, Fire {

    internal var damage: Int = 1

    init(type: TileType, action: TileAction, position2D: CGPoint, direction: TileDirection,
                  imagePrefix: String? = nil, canMove: Bool? = false, canFire: Bool? = true) {
        super.init(type: type, action: action, position2D: position2D, direction: direction, imagePrefix: imagePrefix,
                canMove: canMove, canFire: canFire)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initFireBullet() -> SKSpriteNode {
        let texture = SKTexture(imageNamed: "droid_e")
        let arrowNode = SKSpriteNode(texture: texture, color: .clear, size: texture.size())

        arrowNode.position = CGPoint(x: 0, y: 0)
        arrowNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)

        self.addChild(arrowNode)
        return arrowNode
    }

    func fire(targetTile: Character) {
        let arrowNode = initFireBullet()
        // calculate tile direction base on turn's degrees

        let newDirection = self.compassDirection(newPoint2D: targetTile.position2D, prevPoint2D: self.position2D)
        self.changeDirection(direction: newDirection)

        // TODO animation
        let relativeY = targetTile.position.y - self.position.y
        let relativeX = targetTile.position.x - self.position.x

        let move = SKAction.move(to: CGPoint(x: relativeX, y: relativeY), duration: 0.5)
        let remove = SKAction.removeFromParent()

        let sequence = SKAction.sequence([move, remove])

        arrowNode.run(sequence) {
            //Action after fire
            targetTile.run(SKAction.fadeOut(withDuration: 0.2)) {
                targetTile.run(SKAction.fadeIn(withDuration: 0.2)) {
                    targetTile.takeDamage(damage: self.damage)
                }
            }
        }

    }
}
