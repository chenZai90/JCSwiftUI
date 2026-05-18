//
//  MVCProject.swift
//  swiftUIDemo
//
//  MVC架构实战项目
//

import SwiftUI

// MARK: - Model (模型)

//  任务模型
struct MVCProjectTask: Identifiable {
    let id: UUID
    var title: String
    var isCompleted: Bool
}

// MARK: - View (视图)

//  MVC架构实战项目
struct MVCProjectDemo: View {
    //  控制器（在SwiftUI中，视图和控制器合二为一）
    @State private var tasks: [MVCProjectTask] = [
        MVCProjectTask(id: UUID(), title: "学习SwiftUI", isCompleted: false),
        MVCProjectTask(id: UUID(), title: "构建MVC架构项目", isCompleted: true),
        MVCProjectTask(id: UUID(), title: "练习编程", isCompleted: false)
    ]
    @State private var newTaskTitle = ""
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                //  标题
                Text("MVC架构实战项目")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                
                //  任务输入
                HStack {
                    TextField("输入任务...", text: $newTaskTitle)
                        .padding()
                        .border(.gray, width: 1)
                        .cornerRadius(5)
                    
                    Button("添加") {
                        addTask()
                    }
                    .padding()
                    .background(.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                
                //  任务列表
                List {
                    ForEach(tasks) { task in
                        MVCProjectTaskRowView(task: task, onToggle: {
                            toggleTaskCompletion(id: task.id)
                        })
                    }
                    .onDelete(perform: deleteTask)
                }
                
                //  统计信息
                Text("已完成: \(completedCount), 总计: \(totalCount)")
                    .font(.headline)
                    .padding()
                
                //  MVC架构说明
                VStack {
                    Text("MVC架构实战项目说明")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("• Model: MVCProjectTask - 数据模型")
                        Text("• View: MVCProjectDemo, MVCTaskRowView - 视图")
                        Text("• Controller: MVCProjectDemo中的状态管理和方法 - 控制器")
                        Text("• 数据流: 用户操作 → 控制器 → 模型 → 视图更新")
                        Text("• 优点: 简单直观，易于理解和实现")
                        Text("• 适用场景: 小型应用或原型开发")
                    }
                    .padding()
                    .background(.gray.opacity(0.1))
                    .cornerRadius(10)
                }
            }
            .padding()
        }
    }
    
    //  计算属性
    var totalCount: Int {
        return tasks.count
    }
    
    var completedCount: Int {
        return tasks.filter { $0.isCompleted }.count
    }
    
    //  控制器方法
    func addTask() {
        if !newTaskTitle.isEmpty {
            let newTask = MVCProjectTask(id: UUID(), title: newTaskTitle, isCompleted: false)
            tasks.append(newTask)
            newTaskTitle = ""
        }
    }
    
    func toggleTaskCompletion(id: UUID) {
        if let index = tasks.firstIndex(where: { $0.id == id }) {
            tasks[index].isCompleted.toggle()
        }
    }
    
    func deleteTask(at offsets: IndexSet) {
        tasks.remove(atOffsets: offsets)
    }
}

//  MVC任务行视图
struct MVCProjectTaskRowView: View {
    let task: MVCProjectTask
    let onToggle: () -> Void
    
    var body: some View {
        HStack {
            Button(action: onToggle) {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(task.isCompleted ? .green : .gray)
            }
            
            Text(task.title)
                .strikethrough(task.isCompleted, color: .gray)
                .foregroundColor(task.isCompleted ? .gray : .black)
            
            Spacer()
        }
    }
}

#Preview {
    MVCProjectDemo()
}