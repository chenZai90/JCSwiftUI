//
//  CleanArchitecture.swift
//  swiftUIDemo
//
//  Clean Architecture（整洁架构）示例
//

import SwiftUI

// MARK: - 领域层 (Domain Layer)

//  任务模型（领域实体）- 重命名为CleanTask避免与Swift并发Task冲突
struct CleanTask: Identifiable {
    let id: UUID
    let title: String
    var isCompleted: Bool
}

//  任务仓库协议
protocol CleanTaskRepository {
    func getTasks() -> [CleanTask]
    func addTask(_ task: CleanTask)
    func updateTask(_ task: CleanTask)
    func deleteTask(id: UUID)
}

//  任务用例
class CleanTaskUseCase {
    private let repository: CleanTaskRepository
    
    init(repository: CleanTaskRepository) {
        self.repository = repository
    }
    
    func getTasks() -> [CleanTask] {
        return repository.getTasks()
    }
    
    func addTask(title: String) {
        let task = CleanTask(id: UUID(), title: title, isCompleted: false)
        repository.addTask(task)
    }
    
    func toggleTaskCompletion(id: UUID) {
        let tasks = repository.getTasks()
        if let task = tasks.first(where: { $0.id == id }) {
            var updatedTask = task
            updatedTask.isCompleted.toggle()
            repository.updateTask(updatedTask)
        }
    }
    
    func deleteTask(id: UUID) {
        repository.deleteTask(id: id)
    }
}

// MARK: - 数据层 (Data Layer)

//  内存任务仓库（实现）
class InMemoryCleanTaskRepository: CleanTaskRepository {
    private var tasks: [CleanTask] = [
        CleanTask(id: UUID(), title: "学习SwiftUI", isCompleted: false),
        CleanTask(id: UUID(), title: "实现Clean Architecture", isCompleted: true),
        CleanTask(id: UUID(), title: "练习编程", isCompleted: false)
    ]
    
    func getTasks() -> [CleanTask] {
        return tasks
    }
    
    func addTask(_ task: CleanTask) {
        tasks.append(task)
    }
    
    func updateTask(_ task: CleanTask) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index] = task
        }
    }
    
    func deleteTask(id: UUID) {
        tasks.removeAll { $0.id == id }
    }
}

// MARK: - 表示层 (Presentation Layer)

//  任务视图模型
class CleanTaskViewModel: ObservableObject {
    @Published var tasks: [CleanTask] = []
    @Published var newTaskTitle = ""
    
    private let taskUseCase: CleanTaskUseCase
    
    init(taskUseCase: CleanTaskUseCase) {
        self.taskUseCase = taskUseCase
        loadTasks()
    }
    
    func loadTasks() {
        tasks = taskUseCase.getTasks()
    }
    
    func addTask() {
        if !newTaskTitle.isEmpty {
            taskUseCase.addTask(title: newTaskTitle)
            loadTasks()
            newTaskTitle = ""
        }
    }
    
    func toggleTaskCompletion(id: UUID) {
        taskUseCase.toggleTaskCompletion(id: id)
        loadTasks()
    }
    
    func deleteTask(id: UUID) {
        taskUseCase.deleteTask(id: id)
        loadTasks()
    }
}

//  任务行视图
struct CleanTaskRowView: View {
    let task: CleanTask
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

//  Clean Architecture示例
struct CleanArchitectureDemo: View {
    //  依赖注入
    @StateObject private var viewModel: CleanTaskViewModel
    
    init() {
        let taskUseCase = CleanTaskUseCase(repository: InMemoryCleanTaskRepository())
        _viewModel = StateObject(wrappedValue: CleanTaskViewModel(taskUseCase: taskUseCase))
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                //  标题
                Text("Clean Architecture（整洁架构）")
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
                        CleanTaskRowView(task: task) {
                            viewModel.toggleTaskCompletion(id: task.id)
                        }
                    }
                    .onDelete { offsets in
                        if let index = offsets.first {
                            viewModel.deleteTask(id: viewModel.tasks[index].id)
                        }
                    }
                }
                .frame(height: 250)
                
                //  Clean Architecture说明
                VStack {
                    Text("Clean Architecture架构说明")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("• 领域层 (Domain Layer): 包含业务逻辑和实体")
                        Text("• 数据层 (Data Layer): 处理数据持久化和外部服务")
                        Text("• 表示层 (Presentation Layer): 处理UI和用户交互")
                        Text("• 依赖规则: 内层不依赖外层")
                        Text("• 优点: 高度模块化, 可测试性, 灵活性")
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
    CleanArchitectureDemo()
}
