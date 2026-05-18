//
//  ReduxFluxArchitecture.swift
//  swiftUIDemo
//
//  Redux-Flux状态管理架构示例
//

import SwiftUI

// MARK: - 状态 (State)

//  任务状态
struct ReduxTaskState {
    var tasks: [ReduxTask]
    var newTaskTitle: String
}

//  任务模型
struct ReduxTask: Identifiable {
    let id: UUID
    let title: String
    var isCompleted: Bool
}

// MARK: - 动作 (Action)

//  任务动作
enum ReduxTaskAction {
    case addTask(String)
    case toggleTaskCompletion(UUID)
    case deleteTask(UUID)
    case updateNewTaskTitle(String)
    case loadTasks([ReduxTask])
}

// MARK: - 减速器 (Reducer)

//  任务减速器
func reduxTaskReducer(state: ReduxTaskState, action: ReduxTaskAction) -> ReduxTaskState {
    var newState = state
    
    switch action {
    case .addTask(let title):
        let newTask = ReduxTask(id: UUID(), title: title, isCompleted: false)
        newState.tasks.append(newTask)
        newState.newTaskTitle = ""
    case .toggleTaskCompletion(let id):
        if let index = newState.tasks.firstIndex(where: { $0.id == id }) {
            newState.tasks[index].isCompleted.toggle()
        }
    case .deleteTask(let id):
        newState.tasks.removeAll { $0.id == id }
    case .updateNewTaskTitle(let title):
        newState.newTaskTitle = title
    case .loadTasks(let tasks):
        newState.tasks = tasks
    }
    
    return newState
}

// MARK: - 存储 (Store)

//  任务存储
class ReduxTaskStore: ObservableObject {
    @Published private(set) var state: ReduxTaskState
    
    init(initialState: ReduxTaskState) {
        self.state = initialState
    }
    
    func dispatch(_ action: ReduxTaskAction) {
        state = reduxTaskReducer(state: state, action: action)
    }
}

// MARK: - 视图 (View)

//  任务行视图
struct ReduxTaskRowView: View {
    let task: ReduxTask
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

//  Redux-Flux架构示例
struct ReduxFluxArchitectureDemo: View {
    //  初始状态
    private let initialState = ReduxTaskState(
        tasks: [
            ReduxTask(id: UUID(), title: "学习SwiftUI", isCompleted: false),
            ReduxTask(id: UUID(), title: "实现Redux-Flux架构", isCompleted: true),
            ReduxTask(id: UUID(), title: "练习编程", isCompleted: false)
        ],
        newTaskTitle: ""
    )
    
    @StateObject private var store = ReduxTaskStore(initialState: ReduxTaskState(tasks: [], newTaskTitle: ""))
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                //  标题
                Text("Redux-Flux状态管理架构")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                
                //  任务输入
                HStack {
                    TextField("输入任务...", text: Binding(
                        get: { store.state.newTaskTitle },
                        set: { store.dispatch(ReduxTaskAction.updateNewTaskTitle($0)) }
                    ))
                    .padding()
                    .border(.gray, width: 1)
                    .cornerRadius(5)
                    
                    Button("添加") {
                        if !store.state.newTaskTitle.isEmpty {
                            store.dispatch(ReduxTaskAction.addTask(store.state.newTaskTitle))
                        }
                    }
                    .padding()
                    .background(.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                
                //  任务列表
                List {
                    ForEach(store.state.tasks) { task in
                        ReduxTaskRowView(task: task) {
                            store.dispatch(ReduxTaskAction.toggleTaskCompletion(task.id))
                        }
                    }
                    .onDelete { offsets in
                        if let index = offsets.first {
                            store.dispatch(ReduxTaskAction.deleteTask(store.state.tasks[index].id))
                        }
                    }
                }
                
                //  Redux-Flux架构说明
                VStack {
                    Text("Redux-Flux架构说明")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("• State: 单一数据源，存储应用状态")
                        Text("• Action: 描述状态变化的动作")
                        Text("• Reducer: 纯函数，根据Action更新State")
                        Text("• Store: 管理状态和分发Action")
                        Text("• 单向数据流: Action → Reducer → State → View")
                        Text("• 优点: 状态可预测, 易于调试, 中心化状态管理")
                    }
                    .padding()
                    .background(.gray.opacity(0.1))
                    .cornerRadius(10)
                }
            }
            .padding()
        }
        .onAppear {
            //  加载初始数据
            store.dispatch(ReduxTaskAction.loadTasks(initialState.tasks))
        }
    }
}

#Preview {
    ReduxFluxArchitectureDemo()
}