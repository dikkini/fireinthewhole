//
// Created by dikkini on 19/04/2018.
// Copyright (c) 2018 Artur Karapetov. All rights reserved.
//

import SpriteKit
import UIKit

class BaseScene: SKScene {

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var blockUI: Bool = false

    let menuButton = SKLabelNode()

    override init(size: CGSize) {
        super.init(size: size)

        self.menuButton.fontColor = SKColor.black
        self.menuButton.text = "menu"
        self.menuButton.zPosition = 99999

        self.menuButton.position = CGPoint(x: self.size.width / 10, y: self.size.height / 15)

        self.addChild(self.menuButton)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.blockUI {return}

        guard let touch = touches.first else {
            return
        }

        let touchLocation = touch.location(in: self)
        print(touchLocation.debugDescription)

        if self.menuButton.contains(touchLocation) {
            let reveal = SKTransition.fade(withDuration: 0.5)
            let scene = MainMenuScene(size: self.size)
            self.view?.presentScene(scene, transition: reveal)
        }

    }
}