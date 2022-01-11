//
//  Home.swift
//  TaskManagement
//
//  Created by Thobio Joseph on 10/01/22.
//

import SwiftUI

struct Home: View {
    
    @StateObject var taskModel :TaskViewModel = TaskViewModel()
    @Namespace var animation
    var body: some View {
        ScrollView(.vertical, showsIndicators: false){
            LazyVStack(spacing:15,pinnedViews: [.sectionHeaders]) {
                Section{
                    ScrollView(.horizontal,showsIndicators: false){
                        HStack(spacing:10){
                            ForEach(taskModel.currentWeek ,id: \.self) { day in
                                VStack(spacing:10) {
                                    Text(taskModel.extractDateFormate(date: day, formate: "dd"))
                                        .font(.system(size: 15))
                                        .fontWeight(.semibold)
                                    Text(taskModel.extractDateFormate(date: day, formate: "EEE"))
                                        .font(.system(size: 14))
                                    Circle()
                                        .fill(.white)
                                        .frame(width: 8, height: 8)
                                        .opacity(taskModel.isToday(date: day) ? 1 : 0)
                                }
                                .foregroundStyle(taskModel.isToday(date: day) ? .primary :.secondary)
                                .foregroundColor(taskModel.isToday(date: day) ? .white : .black)
                                .frame(width: 50, height: 90)
                                .background(
                                    ZStack {
                                        if taskModel.isToday(date: day) {
                                            Capsule().fill(.black).matchedGeometryEffect(id: "CURRENTDAY", in: animation)
                                        }
                                    }
                                )
                                .contentShape(Capsule())
                                .onTapGesture {
                                    withAnimation {
                                        taskModel.currentDay = day
                                    }
                                }
                            }
                        }.padding(.horizontal)
                    }
                    TaskView()
                }header: {
                    HeaderView()
                }
            }
        }.ignoresSafeArea(.container,edges: .top)
    }
    
    func TaskView() ->some View {
        LazyVStack(spacing:25){
            if let tasks = taskModel.filteredTask {
                if tasks.isEmpty {
                    Text("No tasks found!!")
                        .font(.system(size: 15))
                        .fontWeight(.light)
                        .offset(y: 100)
                }else{
                    ForEach(tasks){ task in
                        TaskCardView(task: task)
                    }
                }
            }else{
                ProgressView().offset(x: 100)
            }
        }
        .padding()
        .padding(.top)
        .onChange(of: taskModel.currentDay) { newValue in
            taskModel.filteredTaksToday()
        }
    }
    
    func TaskCardView(task:Task) -> some View {
        HStack(alignment: .top, spacing: 30) {
            VStack {
                Circle().fill(taskModel.isCurrentHour(date: task.taskDate) ? .black : .clear)
                    .frame(width: 15, height: 15)
                    .background(
                        Circle()
                            .stroke(.black,lineWidth: 1)
                            .padding(-3)
                    )
                Rectangle()
                    .fill(.black)
                    .frame(width: 3)
            }
            
            VStack {
                HStack(alignment: .top, spacing: 10) {
                    VStack (alignment: .leading, spacing: 12) {
                        Text(task.taskTitle).font(.title2.bold())
                        Text(task.taskDescription).font(.caption).foregroundStyle(.secondary)
                    }.hLeading()
                    Text(task.taskDate.formatted(date: .omitted, time: .shortened))
                }
                
                if (taskModel.isCurrentHour(date: task.taskDate)) {
                    HStack(spacing:0) {
                        HStack(spacing:-10) {
                            ForEach(["user1","user2","user3"], id:\.self){ user in
                                Image(user)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 45, height: 45)
                                    .clipShape(Circle())
                                    .background(
                                        Circle().stroke(.black,lineWidth: 5)
                                    )
                            }
                        }.hLeading()
                        Button {
                            
                        } label: {
                            Image(systemName: "checkmark").foregroundStyle(.black).padding(10).background(Color.white,in: RoundedRectangle(cornerRadius:10))
                        }
                    }.padding(10)
                }
                
            }.foregroundColor(taskModel.isCurrentHour(date: task.taskDate) ? .white : .black)
                .padding(taskModel.isCurrentHour(date: task.taskDate) ? 15 : 0)
                .padding(.bottom,taskModel.isCurrentHour(date: task.taskDate) ? 0 : 10)
                .hLeading()
                .background(
                    Color("Black").cornerRadius(25).opacity(taskModel.isCurrentHour(date: task.taskDate) ? 1 : 0)
                )
        }.hLeading()
    }
    
    func HeaderView()->some View {
        HStack(spacing:10) {
            VStack(alignment: .leading, spacing: 10) {
                Text(Date().formatted(date: .abbreviated, time: .omitted))
                    .foregroundColor(.gray)
                Text("Today").font(.largeTitle.bold())
            }.hLeading()
            Button {
                
            } label: {
                Image("profile")
                    .resizable()
                    .aspectRatio(contentMode:.fill)
                    .frame(width: 45, height: 45)
                    .clipShape(Circle())
            }
            
        }.padding()
            .padding(.top,getSafeArea().top)
            .background(.white)
    }
}

extension View {
    
    func hLeading() -> some View {
        self.frame(maxWidth:.infinity, alignment: .leading)
    }
    func hTrailing() -> some View {
        self.frame(maxWidth:.infinity, alignment: .trailing)
    }
    func hCenter() -> some View {
        self.frame(maxWidth:.infinity, alignment: .center)
    }
    
    func getSafeArea()->UIEdgeInsets {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else{
            return .zero
        }
        guard let safeArea = screen.windows.first?.safeAreaInsets else {
            return .zero
        }
        return safeArea
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
