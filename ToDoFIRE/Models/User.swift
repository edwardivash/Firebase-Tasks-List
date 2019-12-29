//
//  User.swift
//  ToDoFIRE
//
//  Created by Эдуард on 12/27/19.
//  Copyright © 2019 Eduard Ivash. All rights reserved.
//

import Foundation
import Firebase

struct Userr {
    
    let uid:String
    let email:String
    
    init(user:User){
        self.uid = user.uid
        self.email = user.email!
    }
}






