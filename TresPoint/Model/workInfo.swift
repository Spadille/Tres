//
//  workInfo.swift
//  TresPoint
//
//  Created by Shiyu Zhang on 11/30/17.
//  Copyright © 2017 Shiyu Zhang. All rights reserved.
//

import Foundation


class WorkInfo {
    var startTime:String?
    var totalTime:String?
    var workDetail:String?
    var timestamp:String?
    var isworking:String?
    
    init(dict:[String:String]) {
        startTime = dict["startWorkingTime"]
        workDetail = dict["workDetail"]
        timestamp = dict["timestamp"]
        isworking = dict["isWorking"]
        totalTime = dict["totalWorkingTime"]
    }
}
