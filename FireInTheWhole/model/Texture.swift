//
//  Texture.swift
//  FireInTheWhole
//
//  Created by dikkini on 15/03/2018.
//  Copyright © 2018 Artur Karapetov. All rights reserved.
//

import UIKit
import SpriteKit

func textureImage(tile:Tile, direction:Direction, action:Action) -> String {
    
    switch tile {
    case .Droid:
        switch action {
        case .Idle:
            switch direction {
            case .N:return "droid_n"
            case .NE:return "droid_ne"
            case .E:return "droid_e"
            case .SE:return "droid_se"
            case .S:return "droid_s"
            case .SW:return "droid_sw"
            case .W:return "droid_w"
            case .NW:return "droid_nw"
            }
        case .Move:
            switch direction {
            case .N:return "droid_n"
            case .NE:return "droid_ne"
            case .E:return "droid_e"
            case .SE:return "droid_se"
            case .S:return "droid_s"
            case .SW:return "droid_sw"
            case .W:return "droid_w"
            case .NW:return "droid_nw"
            }
        }
    case .Ground:
        return "ground"
    case .Wall:
        switch direction {
        case .N:return "wall_n"
        case .NE:return "wall_ne"
        case .E:return "wall_e"
        case .SE:return "wall_se"
        case .S:return "wall_s"
        case .SW:return "wall_sw"
        case .W:return "wall_w"
        case .NW:return "wall_nw"
        }
    }
    
}
