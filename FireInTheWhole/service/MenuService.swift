//
// Created by dikkini on 20/04/2018.
// Copyright (c) 2018 Artur Karapetov. All rights reserved.
//

import Foundation
import SpriteKit

class MenuService {

    let menuLayer: SKNode = SKNode()
    var menuPosition: CGPoint

    init(menuPosition: CGPoint) {
        self.menuPosition = menuPosition
    }

    func setup(scene: SKScene) {
        self.menuLayer.name = "action_menu"
        self.menuLayer.position = self.menuPosition
        self.menuLayer.zPosition = 999

        scene.addChild(self.menuLayer)
    }

    func showActionMenu(char: Character) {
        self.hideActionMenu()
        
        if char.canFire {
            let fireButton = SKSpriteNode(imageNamed: "fire_button")
            fireButton.name = "fire_btn"
            fireButton.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            fireButton.position = CGPoint(x: 0, y: 0)
            fireButton.zPosition = 100

            menuLayer.addChild(fireButton)
        }

        // ...
        // more more buttons
        // ...
    }

    func hideActionMenu() {
        self.menuLayer.removeAllChildren()
    }
}