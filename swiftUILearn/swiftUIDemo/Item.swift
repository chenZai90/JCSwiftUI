//
//  Item.swift
//  swiftUIDemo
//
//  Created by jcmac on 2026/4/15.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
