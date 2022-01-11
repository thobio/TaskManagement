//
//  TaskViewModel.swift
//  TaskManagement
//
//  Created by Thobio Joseph on 10/01/22.
//

import SwiftUI

class TaskViewModel:ObservableObject {
    @Published var storeTask: [Task] = [
        Task(taskTitle:"Meeting", taskDescription:"Discuss team task for the day", taskDate:.init(timeIntervalSince1970:1641913380)),
        Task(taskTitle: "Icon set", taskDescription:"Edit icons for team task for next week", taskDate:.init(timeIntervalSince1970:1641878360)),
        Task(taskTitle: "Prototype", taskDescription: "wake and send prototype", taskDate:.init(timeIntervalSince1970:1641878360)),
        Task(taskTitle: "Check asset", taskDescription: "Start checking the assets", taskDate:.init(timeIntervalSince1970:1641878323)),
        Task(taskTitle: "Team party", taskDescription: "Make fun with team mates", taskDate:.init(timeIntervalSince1970:1641878323)),
        Task(taskTitle: "Client Meeting", taskDescription: "Explain project to clinet", taskDate:.init(timeIntervalSince1970:1641878323)),
        Task(taskTitle: "Next Project", taskDescription: "Discuss next project with team", taskDate:.init(timeIntervalSince1970:1641896864)),
        Task(taskTitle: "App Proposal", taskDescription: "Meet client for next App Proposal", taskDate:.init(timeIntervalSince1970:1641878323))]
    
    @Published var currentWeek: [Date] = []
    @Published var currentDay: Date  = Date()
    @Published var filteredTask:[Task]?
    
    init(){
        fetchCurrentWeekDay()
        filteredTaksToday()
    }
    
    func fetchCurrentWeekDay(){
        let today = Date()
        let calender = Calendar.current
        let weekDay = calender.dateInterval(of: .weekOfMonth, for: today)
        
        guard let firstWeekDay = weekDay?.start else{
            return
        }
        (1...7).forEach { day in
            if let weekday = calender.date(byAdding: .day, value: day, to: firstWeekDay) {
                currentWeek.append(weekday)
            }
        }
    }
    
    func filteredTaksToday(){
        DispatchQueue.global(qos: .userInteractive).async { [self] in
            let calender = Calendar.current
            let filitered = storeTask.filter { task in
                return calender.isDate(task.taskDate, inSameDayAs: currentDay)
            }.sorted { task1, task2 in
                return task2.taskDate < task1.taskDate
            }
            DispatchQueue.main.async {
                withAnimation {
                    self.filteredTask = filitered
                }
            }
        }
    }
    
    func extractDateFormate(date:Date,formate:String) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = formate
        return formatter.string(from: date)
    }
    
    func isToday(date:Date)->Bool{
        let calender = Calendar.current
        return calender.isDate(currentDay, inSameDayAs: date)
    }
    
    func isCurrentHour(date:Date) -> Bool {
        let calender = Calendar.current
        let hour = calender.component(.hour, from: date)
        let currentHour = calender.component(.hour, from: Date())
        return hour == currentHour
    }
}
