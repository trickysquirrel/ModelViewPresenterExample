//
//  DispatchQueue+Main.swift
//  Example
//
//  Created by Richard Moult on 11/10/17.
//  Copyright © 2017 Richard Moult. All rights reserved.
//

import Foundation

extension DispatchQueue {

    static func mainAsync(_ block:@escaping ()->()) {
        if Thread.isMainThread {
            block()
        }
        else {
            DispatchQueue.main.async {
                block()
            }
        }
    }

    static func mainSync(_ block:@escaping ()->()) {
        if Thread.isMainThread {
            block()
        }
        else {
            DispatchQueue.main.sync {
                block()
            }
        }
    }

}
