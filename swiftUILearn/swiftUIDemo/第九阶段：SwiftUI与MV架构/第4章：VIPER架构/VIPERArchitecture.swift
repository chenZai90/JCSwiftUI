//
//  VIPERArchitecture.swift
//  swiftUIDemo
//
//  VIPER架构示例
//

import SwiftUI

// MARK: - Entity (实体)

//  任务实体
struct ViperTask: Identifiable {
    let id: UUID
    let title: String
    var isCompleted: Bool
}

// MARK: - Interactor (交互器)

//  任务仓库协议
protocol ViperTaskRepository {
    func getTasks() -> [ViperTask]
    func addTask(_ task: ViperTask)
    func updateTask(_ task: ViperTask)
    func deleteTask(id: UUID)
}

//  内存任务仓库
class ViperInMemoryTaskRepository: ViperTaskRepository {
    private var tasks: [ViperTask] = [
        ViperTask(id: UUID(), title: "学习SwiftUI", isCompleted: false),
        ViperTask(id: UUID(), title: "实现VIPER架构", isCompleted: true),
        ViperTask(id: UUID(), title: "练习编程", isCompleted: false)
    ]
    
    func getTasks() -> [ViperTask] {
        return tasks
    }
    
    func addTask(_ task: ViperTask) {
        tasks.append(task)
    }
    
    func updateTask(_ task: ViperTask) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index] = task
        }
    }
    
    func deleteTask(id: UUID) {
        tasks.removeAll { $0.id == id }
    }
}

//  任务交互器
class ViperTaskInteractor {
    private let repository: ViperTaskRepository
    
    init(repository: ViperTaskRepository) {
        self.repository = repository
    }
    
    func getTasks() -> [ViperTask] {
        return repository.getTasks()
    }
    
    func addTask(title: String) {
        let task = ViperTask(id: UUID(), title: title, isCompleted: false)
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

// MARK: - Presenter ( presenter )

//  任务 presenter
class ViperTaskPresenter: ObservableObject {
    @Published var tasks: [ViperTask] = []
    @Published var newTaskTitle = ""
    
    private let interactor: ViperTaskInteractor
    
    init(interactor: ViperTaskInteractor) {
        self.interactor = interactor
        loadTasks()
    }
    
    func loadTasks() {
        tasks = interactor.getTasks()
    }
    
    func addTask() {
        if !newTaskTitle.isEmpty {
            interactor.addTask(title: newTaskTitle)
            loadTasks()
            newTaskTitle = ""
        }
    }
    
    func toggleTaskCompletion(id: UUID) {
        interactor.toggleTaskCompletion(id: id)
        loadTasks()
    }
    
    func deleteTask(id: UUID) {
        interactor.deleteTask(id: id)
        loadTasks()
    }
}

// MARK: - View (视图)

//  任务行视图
struct ViperTaskRowView: View {
    let task: ViperTask
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

//  VIPER架构示例
struct VIPERArchitectureDemo: View {
    //  依赖注入
    @StateObject private var presenter: ViperTaskPresenter
    
    init() {
        let interactor = ViperTaskInteractor(repository: ViperInMemoryTaskRepository())
        _presenter = StateObject(wrappedValue: ViperTaskPresenter(interactor: interactor))
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                //  标题
                Text("VIPER架构")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                
                //  任务输入
                HStack {
                    TextField("输入任务...", text: $presenter.newTaskTitle)
                        .padding()
                        .border(.gray, width: 1)
                        .cornerRadius(5)
                    
                    Button("添加") {
                        presenter.addTask()
                    }
                    .padding()
                    .background(.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                
                //  任务列表
                List {
                    ForEach(presenter.tasks) { task in
                        ViperTaskRowView(task: task) {
                            presenter.toggleTaskCompletion(id: task.id)
                        }
                    }
                    .onDelete { offsets in
                        if let index = offsets.first {
                            presenter.deleteTask(id: presenter.tasks[index].id)
                        }
                    }
                }
                
                //  VIPER架构说明
                VStack {
                    Text("VIPER架构说明")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("• View: 负责UI展示和用户交互")
                        Text("• Interactor: 处理业务逻辑和数据操作")
                        Text("• Presenter: 协调View和Interactor之间的通信")
                        Text("• Entity: 数据实体")
                        Text("• Router: 负责导航")
                        Text("• 优点: 职责分离清晰, 可测试性强")
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

// MARK: - Router (路由器)

//  简单的路由器实现
class ViperTaskRouter {
    static func navigateToDetailView(task: ViperTask) -> some View {
        return ViperTaskDetailView(task: task)
    }
}

//  任务详情视图
struct ViperTaskDetailView: View {
    let task: ViperTask
    
    var body: some View {
        VStack(spacing: 20) {
            Text("任务详情")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("标题: \(task.title)")
                .font(.headline)
            Text("状态: \(task.isCompleted ? "已完成" : "未完成")")
                .font(.body)
                .foregroundColor(task.isCompleted ? .green : .red)
        }
        .padding()
    }
}

#Preview {
    VIPERArchitectureDemo()
}