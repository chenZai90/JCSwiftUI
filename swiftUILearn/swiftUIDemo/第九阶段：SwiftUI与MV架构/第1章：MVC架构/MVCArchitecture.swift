import SwiftUI

/// MVC架构示例
/// 本文件演示了SwiftUI中的MVC架构实现
struct MVCArchitectureDemo: View {
    //  状态管理
    @State private var tasks: [MVCTaskModel] = [
        MVCTaskModel(id: 1, title: "学习SwiftUI", isCompleted: false),
        MVCTaskModel(id: 2, title: "构建MVC架构", isCompleted: true),
        MVCTaskModel(id: 3, title: "练习编程", isCompleted: false)
    ]
    @State private var newTaskTitle = ""
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                //  标题
                Text("MVC架构")
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
                        MVCTaskRowView(task: task, toggleCompletion: { toggleTaskCompletion(id: task.id) })
                    }
                    .onDelete(perform: deleteTask)
                }
                
                //  MVC架构说明
                VStack {
                    Text("MVC架构说明")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("• Model: 数据模型 (MVCTaskModel)")
                        Text("• View: 视图 (MVCTaskRowView, MVCArchitectureDemo)")
                        Text("• Controller: 控制器逻辑 (本文件中的方法)")
                        Text("• 数据流: 用户操作 → 控制器 → 模型 → 视图更新")
                    }
                    .padding()
                    .background(.gray.opacity(0.1))
                    .cornerRadius(10)
                }
            }
            .padding()
        }
    }
    
    //  添加任务
    func addTask() {
        if !newTaskTitle.isEmpty {
            let newTask = MVCTaskModel(id: tasks.count + 1, title: newTaskTitle, isCompleted: false)
            tasks.append(newTask)
            newTaskTitle = ""
        }
    }
    
    //  切换任务完成状态
    func toggleTaskCompletion(id: Int) {
        if let index = tasks.firstIndex(where: { $0.id == id }) {
            tasks[index].isCompleted.toggle()
        }
    }
    
    //  删除任务
    func deleteTask(at offsets: IndexSet) {
        tasks.remove(atOffsets: offsets)
    }
}

/// 任务模型
struct MVCTaskModel: Identifiable {
    let id: Int
    let title: String
    var isCompleted: Bool
}

/// 任务行视图
struct MVCTaskRowView: View {
    let task: MVCTaskModel
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

/// 预览
struct MVCArchitectureDemo_Previews: PreviewProvider {
    static var previews: some View {
        MVCArchitectureDemo()
    }
}