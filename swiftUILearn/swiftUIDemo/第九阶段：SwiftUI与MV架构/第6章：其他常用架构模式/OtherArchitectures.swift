//
//  OtherArchitectures.swift
//  swiftUIDemo
//
//  其他常用架构模式示例
//

import SwiftUI

// MARK: - 架构模式演示

//  其他常用架构模式示例
struct OtherArchitecturesDemo: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                //  标题
                Text("其他常用架构模式")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                
                //  MVP架构
                VStack {
                    Text("1. MVP架构")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    MVPDemo()
                }
                .padding()
                .background(.gray.opacity(0.1))
                .cornerRadius(10)
                
                //  混合架构
                VStack {
                    Text("2. 混合架构")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    HybridArchitectureDemo()
                }
                .padding()
                .background(.blue.opacity(0.1))
                .cornerRadius(10)
                
                //  架构模式比较
                VStack {
                    Text("3. 架构模式比较")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    ArchitectureComparisonView()
                }
                .padding()
                .background(.green.opacity(0.1))
                .cornerRadius(10)
                
                //  架构选择指南
                VStack(alignment: .leading, spacing: 10) {
                    Text("4. 架构选择指南")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text("• 小型应用: 直接使用@State和@Binding")
                    Text("• 中型应用: MVVM或MVP")
                    Text("• 大型应用: Clean Architecture或VIPER")
                    Text("• 状态复杂: Redux-Flux")
                    Text("• 团队协作: 选择结构清晰的架构")
                    Text("• 性能要求: 考虑架构的运行效率")
                }
                .padding()
                .background(.yellow.opacity(0.1))
                .cornerRadius(10)
            }
            .padding()
        }
    }
}

// MARK: - MVP架构

//  任务模型
struct MVPTask: Identifiable {
    let id: UUID
    let title: String
    var isCompleted: Bool
}

//  任务演示者
class MVPTaskPresenter: ObservableObject {
    @Published var tasks: [MVPTask] = [
        MVPTask(id: UUID(), title: "学习SwiftUI", isCompleted: false),
        MVPTask(id: UUID(), title: "实现MVP架构", isCompleted: true),
        MVPTask(id: UUID(), title: "练习编程", isCompleted: false)
    ]
    @Published var newTaskTitle = ""
    
    func addTask(title: String) {
        if !title.isEmpty {
            let newTask = MVPTask(id: UUID(), title: title, isCompleted: false)
            tasks.append(newTask)
            newTaskTitle = ""
        }
    }
    
    func toggleTaskCompletion(id: UUID) {
        if let index = tasks.firstIndex(where: { $0.id == id }) {
            tasks[index].isCompleted.toggle()
        }
    }
    
    func deleteTask(id: UUID) {
        tasks.removeAll { $0.id == id }
    }
}

//  MVP任务行视图
struct MVPTaskRowView: View {
    let task: MVPTask
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

//  MVP架构示例
struct MVPDemo: View {
    @StateObject private var presenter = MVPTaskPresenter()
    
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                TextField("输入任务...", text: $presenter.newTaskTitle)
                    .padding()
                    .border(.gray, width: 1)
                    .cornerRadius(5)
                
                Button("添加") {
                    presenter.addTask(title: presenter.newTaskTitle)
                }
                .padding()
                .background(.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            
            List {
                ForEach(presenter.tasks) { task in
                    MVPTaskRowView(task: task) {
                        presenter.toggleTaskCompletion(id: task.id)
                    }
                }
                .onDelete { offsets in
                    if let index = offsets.first {
                        presenter.deleteTask(id: presenter.tasks[index].id)
                    }
                }
            }
            
            VStack(alignment: .leading, spacing: 5) {
                Text("MVP架构说明:")
                    .font(.headline)
                Text("• Model: 数据模型")
                Text("• View: 负责UI展示")
                Text("• Presenter: 处理业务逻辑，协调View和Model")
                Text("• 优点: 职责分离，可测试性较好")
            }
            .padding()
            .background(.white)
            .cornerRadius(10)
            .shadow(radius: 2)
        }
    }
}

// MARK: - 混合架构

//  混合架构示例
struct HybridArchitectureDemo: View {
    @State private var counter = 0
    @State private var isDarkMode = false
    
    var body: some View {
        VStack(spacing: 10) {
            Text("混合架构示例")
                .font(.headline)
            
            //  简单状态管理 (@State)
            VStack {
                Text("计数器: \(counter)")
                    .font(.title)
                HStack {
                    Button("减1") { counter -= 1 }
                        .padding()
                        .background(.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    Button("加1") { counter += 1 }
                        .padding()
                        .background(.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            
            //  环境变量
            VStack {
                Text("深色模式: \(isDarkMode ? "开启" : "关闭")")
                Toggle("深色模式", isOn: $isDarkMode)
            }
            
            VStack(alignment: .leading, spacing: 5) {
                Text("混合架构说明:")
                    .font(.headline)
                Text("• 结合多种架构模式的优点")
                Text("• 简单状态使用@State")
                Text("• 复杂状态使用MVVM或Redux")
                Text("• 全局状态使用环境对象")
                Text("• 优点: 灵活性高，适应不同场景")
            }
            .padding()
            .background(.white)
            .cornerRadius(10)
            .shadow(radius: 2)
        }
    }
}

// MARK: - 架构比较

//  架构比较视图
struct ArchitectureComparisonView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("架构模式比较")
                .font(.headline)
            
            //  MVC
            VStack(alignment: .leading) {
                Text("MVC")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                Text("• 优点: 简单直观，易于理解")
                Text("• 缺点: 控制器可能变得臃肿")
                Text("• 适用: 小型应用")
            }
            
            //  MVVM
            VStack(alignment: .leading) {
                Text("MVVM")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                Text("• 优点: 分离关注点，可测试性好")
                Text("• 缺点: 增加代码量")
                Text("• 适用: 中型应用")
            }
            
            //  Clean Architecture
            VStack(alignment: .leading) {
                Text("Clean Architecture")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                Text("• 优点: 高度模块化，可测试性强")
                Text("• 缺点: 复杂度高，学习曲线陡")
                Text("• 适用: 大型应用")
            }
            
            //  VIPER
            VStack(alignment: .leading) {
                Text("VIPER")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                Text("• 优点: 职责分离清晰")
                Text("• 缺点: 代码量大幅增加")
                Text("• 适用: 大型团队项目")
            }
            
            //  Redux-Flux
            VStack(alignment: .leading) {
                Text("Redux-Flux")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                Text("• 优点: 状态可预测，易于调试")
                Text("• 缺点: 样板代码多")
                Text("• 适用: 状态复杂的应用")
            }
        }
        .padding()
        .background(.white)
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}

#Preview {
    OtherArchitecturesDemo()
}