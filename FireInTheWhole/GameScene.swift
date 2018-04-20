//
// Created by dikkini on 20/04/2018.
// Copyright (c) 2018 Artur Karapetov. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class GameScene: BaseScene {

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var tileService: TileService

    override init(size: CGSize) {
        self.tileService = TileService(tileSize: (width: GameLogic.tileSize.width, height: GameLogic.tileSize.height),
                mapRows: GameLogic.mapRows, mapCols: GameLogic.mapRows)
        super.init(size: size)
    }

    override func didMove(to view: SKView) {
        self.menuButton.fontColor = .white
        self.menuButton.position = CGPoint(x: -(self.size.width / 2 - 50), y: self.size.height / 2 - 25)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)

        guard let touch = touches.first else {
            return
        }

    }
}
