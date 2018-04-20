//
// Created by dikkini on 19/04/2018.
// Copyright (c) 2018 Artur Karapetov. All rights reserved.
//

import SpriteKit

class MainMenuScene: BaseScene {

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    let playgroundButton = SKLabelNode()
    let newGameButton = SKLabelNode()

    override init(size: CGSize) {
        super.init(size: size)

        self.backgroundColor = SKColor.white

        self.playgroundButton.fontColor = SKColor.black
        self.playgroundButton.text = "playground"
        self.playgroundButton.position = CGPoint(x: size.width / 2, y: size.height / 2 + 50)

        self.newGameButton.fontColor = SKColor.black
        self.newGameButton.text = "new game"
        self.newGameButton.position = CGPoint(x: size.width / 2, y: size.height / 2  - self.playgroundButton.fontSize * 2 + 50)

        self.addChild(self.playgroundButton)
        self.addChild(self.newGameButton)

    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)

        guard let touch = touches.first else {
            return
        }

        let touchLocation = touch.location(in: self)

        if self.playgroundButton.contains(touchLocation) {
            let reveal = SKTransition.doorsOpenVertical(withDuration: 0.5)
            let scene = PlayGroundScene(size: self.size)
            self.view?.presentScene(scene, transition: reveal)
        }

    }
}