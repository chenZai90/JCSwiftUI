import SwiftUI

/// MVVM架构示例
/// 本文件演示了SwiftUI中的MVVM架构实现
struct MVVMArchitectureDemo: View {
    //  使用@StateObject创建视图模型
    @StateObject private var viewModel = MVVMTaskViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                //  标题
                Text("MVVM架构")
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
                        MVVMTaskRowView(task: task, toggleCompletion: { 
                            viewModel.toggleTaskCompletion(id: task.id) 
                        })
                    }
                    .onDelete(perform: viewModel.deleteTask)
                }
                
                //  统计信息
                Text("已完成: \(viewModel.completedCount), 总计: \(viewModel.totalCount)")
                    .font(.headline)
                    .padding()
                
                //  MVVM架构说明
                VStack {
                    Text("MVVM架构说明")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("• Model: 数据模型 (MVVMTaskModel)")
                        Text("• View: 视图 (MVVMTaskRowView, MVVMArchitectureDemo)")
                        Text("• ViewModel: 视图模型 (MVVMTaskViewModel)")
                        Text("• 数据流: 用户操作 → 视图模型 → 模型 → 视图更新")
                        Text("• 优点: 更好的代码组织, 可测试性, 关注点分离")
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

/// 任务模型
struct MVVMTaskModel: Identifiable {
    let id: Int
    let title: String
    var isCompleted: Bool
}

/// 任务行视图
struct MVVMTaskRowView: View {
    let task: MVVMTaskModel
    let toggleCompletion: () -> Void
    
    var body: some View {
        HStack {
            Button(action: toggleCompletion) {
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

/// 任务视图模型
class MVVMTaskViewModel: ObservableObject {
    //  发布的属性
    @Published var tasks: [MVVMTaskModel] = [
        MVVMTaskModel(id: 1, title: "学习SwiftUI", isCompleted: false),
        MVVMTaskModel(id: 2, title: "构建MVVM架构", isCompleted: true),
        MVVMTaskModel(id: 3, title: "练习编程", isCompleted: false)
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
            let newTask = MVVMTaskModel(id: tasks.count + 1, title: newTaskTitle, isCompleted: false)
            tasks.append(newTask)
            newTaskTitle = ""
        }
    }
    
    func toggleTaskCompletion(id: Int) {
        if let index = tasks.firstIndex(where: { $0.id == id }) {
            tasks[index].isCompleted.toggle()
        }
    }
    
    func deleteTask(at offsets: IndexSet) {
        tasks.remove(atOffsets: offsets)
    }
}

/// 预览
struct MVVMArchitectureDemo_Previews: PreviewProvider {
    static var previews: some View {
        MVVMArchitectureDemo()
    }
}