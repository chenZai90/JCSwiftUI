//
//  MVVMBasics.swift
//  swiftUIDemo
//
//  MVVM架构基础示例
//

import SwiftUI

//  MVVM架构基础示例
struct MVVMBasicsDemo: View {
    //  使用@StateObject创建视图模型
    @StateObject private var viewModel = TodoViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                //  标题
                Text("MVVM架构基础")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                
                //  任务输入
                HStack {
                    TextField("输入任务...", text: $viewModel.newTodo)
                        .padding()
                        .border(.gray, width: 1)
                        .cornerRadius(5)
                    
                    Button("添加") {
                        viewModel.addTodo()
                    }
                    .padding()
                    .background(.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                
                //  任务列表
                List {
                    ForEach(viewModel.todos) {
                        todo in
                        TodoItemView(todo: todo, toggleCompletion: { 
                            viewModel.toggleTodo(id: todo.id)
                        })
                    }
                    .onDelete(perform: viewModel.deleteTodo)
                }
                
                //  统计信息
                Text("已完成: \(viewModel.completedCount), 总计: \(viewModel.totalCount)")
                    .font(.headline)
                    .padding()
            }
            .padding()
            .navigationTitle("任务管理")
        }
    }
}

//  任务项视图
struct TodoItemView: View {
    let todo: Todo
    let toggleCompletion: () -> Void
    
    var body: some View {
        HStack {
            Button(action: toggleCompletion) {
                Image(systemName: todo.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(todo.isCompleted ? .green : .gray)
            }
            
            Text(todo.title)
                .strikethrough(todo.isCompleted, color: .gray)
                .foregroundColor(todo.isCompleted ? .gray : .black)
            
            Spacer()
        }
    }
}

//  任务模型
struct Todo: Identifiable {
    let id = UUID()
    let title: String
    var isCompleted: Bool
}

//  任务视图模型
class TodoViewModel: ObservableObject {
    //  发布的属性
    @Published var todos: [Todo] = []
    @Published var newTodo: String = ""
    
    //  计算属性
    var totalCount: Int {
        return todos.count
    }
    
    var completedCount: Int {
        return todos.filter { $0.isCompleted }.count
    }
    
    //  方法
    func addTodo() {
        if !newTodo.isEmpty {
            let todo = Todo(title: newTodo, isCompleted: false)
            todos.append(todo)
            newTodo = ""
        }
    }
    
    func toggleTodo(id: UUID) {
        if let index = todos.firstIndex(where: { $0.id == id }) {
            todos[index].isCompleted.toggle()
        }
    }
    
    func deleteTodo(at offsets: IndexSet) {
        todos.remove(atOffsets: offsets)
    }
    
    //  初始化
    init() {
        //  添加一些示例数据
        todos = [
            Todo(title: "学习SwiftUI", isCompleted: false),
            Todo(title: "构建MVVM架构", isCompleted: false),
            Todo(title: "练习Combine", isCompleted: true)
        ]
    }
}

#Preview {
    MVVMBasicsDemo()
}