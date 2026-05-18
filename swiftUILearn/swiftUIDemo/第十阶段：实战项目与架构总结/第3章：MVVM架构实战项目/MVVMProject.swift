//
//  MVVMProject.swift
//  swiftUIDemo
//
//  MVVM架构实战项目
//

import SwiftUI

// MARK: - Model (模型)

//  任务模型
struct MVVMProjectTask: Identifiable {
    let id: UUID
    var title: String
    var isCompleted: Bool
}

// MARK: - ViewModel (视图模型)

//  任务视图模型
class MVVMProjectViewModel: ObservableObject {
    @Published var tasks: [MVVMProjectTask] = [
        MVVMProjectTask(id: UUID(), title: "学习SwiftUI", isCompleted: false),
        MVVMProjectTask(id: UUID(), title: "构建MVVM架构项目", isCompleted: true),
        MVVMProjectTask(id: UUID(), title: "练习编程", isCompleted: false)
    ]
    @Published var newTaskTitle = ""
    
    //  计算属性
    var totalCount: Int {
        return tasks.count
    }
    
    var completedCount: Int {
        return tasks.filter { $0.isCompleted }.count
    }
    
    //  方法
    func addTask() {
        if !newTaskTitle.isEmpty {
            let newTask = MVVMProjectTask(id: UUID(), title: newTaskTitle, isCompleted: false)
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

// MARK: - View (视图)

//  MVVM任务行视图
struct MVVMProjectTaskRowView: View {
    let task: MVVMProjectTask
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

//  MVVM架构实战项目
struct MVVMProjectDemo: View {
    //  使用@StateObject创建视图模型
    @StateObject private var viewModel = MVVMProjectViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                //  标题
                Text("MVVM架构实战项目")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                
                //  任务输入
                HStack {
                    TextField("输入任务...", text: $viewModel.newTaskTitle)
                        .padding()
                        .border(.gray, width: 1)
                        .cornerRadius(5)
                    
                    Button("添加") {
                        viewModel.addTask()
                    }
                    .padding()
                    .background(.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                
                //  任务列表
                List {
                    ForEach(viewModel.tasks) { task in
                        MVVMProjectTaskRowView(task: task) {
                            viewModel.toggleTaskCompletion(id: task.id)
                        }
                    }
                    .onDelete(perform: viewModel.deleteTask)
                }
                
                //  统计信息
                Text("已完成: \(viewModel.completedCount), 总计: \(viewModel.totalCount)")
                    .font(.headline)
                    .padding()
                
                //  MVVM架构说明
                VStack {
                    Text("MVVM架构实战项目说明")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("• Model: MVVMProjectTask - 数据模型")
                        Text("• View: MVVMProjectDemo, MVVMProjectTaskRowView - 视图")
                        Text("• ViewModel: MVVMProjectViewModel - 视图模型")
                        Text("• 数据流: 用户操作 → 视图模型 → 模型 → 视图更新")
                        Text("• 优点: 分离关注点，可测试性好，代码组织清晰")
                        Text("• 适用场景: 中型应用，团队协作")
                    }
                    .padding()
                    .background(.gray.opacity(0.1))
                    .cornerRadius(10)
                }
            }
            .padding()
        }
    }
}

#Preview {
    MVVMProjectDemo()
}