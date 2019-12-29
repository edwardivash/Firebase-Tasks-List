//
//  Task.swift
//  ToDoFIRE
//
//  Created by Эдуард on 12/27/19.
//  Copyright © 2019 Eduard Ivash. All rights reserved.
//

import Foundation
import Firebase

struct Task {
    
    let title:String
    let userId:String
    var completed = false
    let ref:DatabaseReference?
    
    init(title:String, userId:String){
        self.title = title
        self.userId = userId
        self.ref = nil
    }
    
    init(snapshot:DataSnapshot){
        let snapShotValue = snapshot.value as! [String:AnyObject]
        title = snapShotValue["title"] as! String
        userId = snapShotValue["userId"] as! String
        completed = snapShotValue["completed"] as! Bool
        ref = snapshot.ref
    }
    
    func convertToDictionary() -> Any {
        return ["title":title, "userId":userId, "completed":completed]
    }
}
