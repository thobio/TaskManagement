//
//  Task.swift
//  TaskManagement
//
//  Created by Thobio Joseph on 10/01/22.
//

import Foundation

struct Task : Identifiable {
    var id = UUID()
    var taskTitle:String
    var taskDescription:String
    var taskDate: Date
}
