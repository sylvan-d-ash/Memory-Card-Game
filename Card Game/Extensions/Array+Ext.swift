//
//  Array+Ext.swift
//  Card Game
//
//  Created by Sylvan Ash on 17/04/2020.
//  Copyright © 2020 Sylvan Ash. All rights reserved.
//

import Foundation

extension Array {
    public subscript(safe index: Int) -> Element? {
        if index >= count {
            return nil
        }
        return self[index]
    }
}
