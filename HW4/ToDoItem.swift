//
//  ToDoItem.swift
//  HW4
//
//  Created by Sunggat Aiymbay on 28.06.2018.
//  Copyright © 2018 Sunggat Aiymbay. All rights reserved.
//

import Foundation

class ToDoItem {
    var text: String = ""
    var completed: Bool = false
    // var creationDate: NSDate = NSDate()
    
    init(name:String){
        self.text = name
    }
}
