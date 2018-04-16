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
   
    
    override init(type: TileType, action: TileAction, position2D: CGPoint, direction: TileDirection, imagePrefix: String? = nil, canMove: Bool? = false) {
        super.init(type: type, action: action, position2D: position2D, direction: direction, imagePrefix: imagePrefix, canMove: canMove)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initFireBullet() -> SKSpriteNode{
        let texture = SKTexture(imageNamed: "droid_e.png")
        let arrowNode = SKSpriteNode(texture: texture, color: .clear, size: CGSize(width:10, height:10))
        
        arrowNode.position = CGPoint(x:0, y:0)
        arrowNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        self.addChild(arrowNode)
        return arrowNode
    }
    
    func fire(targetTile: Tile) {
        let arrowNode = initFireBullet()
        // calculate tile direction base on turn's degrees
        let deltaY = targetTile.position2D.y - self.position2D.y
        let deltaX = targetTile.position2D.x - self.position2D.x
        let degrees = atan2(deltaX, deltaY) * (180.0 / CGFloat(Double.pi))
        let newDirection = self.compassDirection(degrees: degrees)
        self.changeDirection(direction: newDirection)

// Animation TEST. Problems with pictures?
//
//        var animationTexture = SKTexture(imageNamed:"iso_3d_droid_e.png")
//        var animationTexture2 = SKTexture(imageNamed:"iso_3d_droid_e_ANIM.png")
//        let frames = [animationTexture,animationTexture2, animationTexture]
//
//        self.run(SKAction.animate(with: frames, timePerFrame: 1))
//        Fire
        let relativeY = targetTile.position.y - self.position.y
        let relativeX = targetTile.position.x - self.position.x
       
        let move = SKAction.move(to:CGPoint(x: relativeX, y: relativeY), duration: 0.5)
        let remove = SKAction.removeFromParent()

        let sequence = SKAction.sequence([move, remove])

        arrowNode.run(sequence){
            //Action after fire
            targetTile.run(SKAction.fadeOut(withDuration: 0.2)){
                targetTile.run(SKAction.fadeIn(withDuration: 0.2))
            }
        }
        
    }
}
