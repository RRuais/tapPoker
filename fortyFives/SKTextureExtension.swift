//
//  SKTextureExtension.swift
//  fortyFives
//
//  Created by Rich Ruais on 10/3/17.
//  Copyright © 2017 Rich Ruais. All rights reserved.
//

import Foundation
import SpriteKit

extension SKTexture {
    var name:String? {
        let comps = description.components(separatedBy: "'")
        return comps.count > 1 ? comps[1] : nil
    }
}
