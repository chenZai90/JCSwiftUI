//
//  ModernStateManagement.swift
//  swiftUIDemo
//
//  现代状态管理 (iOS 17+) 示例
//

import SwiftUI

// MARK: - 现代状态管理主视图
struct S3_ModernStateManagementDemo: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("现代状态管理 (iOS 17+)")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                
                VStack {
                    Text("1. @Observable 宏 (iOS 17+)")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    ObservableExample()
                }
                .padding()
                .background(.blue.opacity(0.1))
                .cornerRadius(10)
                
                VStack {
                    Text("2. @Bindable 属性包装器")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    BindableExample()
                }
                .padding()
                .background(.green.opacity(0.1))
                .cornerRadius(10)
                
                VStack {
                    Text("3. @State 与 @Binding 的增强")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    StateBindingEnhancedExample()
                }
                .padding()
                .background(.purple.opacity(0.1))
                .cornerRadius(10)
                
                VStack {
                    Text("4. 环境对象与环境值")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    EnvironmentExample()
                }
                .padding()
                .background(.orange.opacity(0.1))
                .cornerRadius(10)
                
                VStack {
                    Text("5. 异步状态管理")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    AsyncStateExample()
                }
                .padding()
                .background(.red.opacity(0.1))
                .cornerRadius(10)
                
                VStack {
                    Text("6. 性能优化最佳实践")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    PerformanceOptimizationExample()
                }
                .padding()
                .background(.yellow.opacity(0.1))
                .cornerRadius(10)
            }
            .padding()
        }
    }
}

// MARK: - 1. @Observable 宏示例

@Observable
class S3UserProfile {
    var name = "张三"
    var email = "zhangsan@example.com"
    var age = 25
    var isPremium = false
    
    var isValid: Bool {
        !name.isEmpty && email.contains("@")
    }
    
    var displayName: String {
        isPremium ? "⭐️ \(name)" : name
    }
}

struct ObservableExample: View {
    @State private var userProfile = S3UserProfile()
    
    var body: some View {
        VStack(spacing: 12) {
            Text("用户资料")
                .font(.title2)
                .fontWeight(.bold)
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("显示名称:")
                        .fontWeight(.semibold)
                    Text(userProfile.displayName)
                }
                
                HStack {
                    Text("有效性:")
                        .fontWeight(.semibold)
                    Text(userProfile.isValid ? "✅ 有效" : "❌ 无效")
                        .foregroundColor(userProfile.isValid ? .green : .red)
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.white)
            .cornerRadius(8)
            .shadow(radius: 2)
            
            Divider()
            
            VStack(spacing: 10) {
                TextField("姓名", text: $userProfile.name)
                    .textFieldStyle(.roundedBorder)
                
                TextField("邮箱", text: $userProfile.email)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.emailAddress)
                
                Stepper("年龄: \(userProfile.age)", value: $userProfile.age, in: 0...120)
                
                Toggle("高级会员", isOn: $userProfile.isPremium)
                    .tint(.blue)
            }
            .padding()
            .background(.white)
            .cornerRadius(8)
            .shadow(radius: 2)
        }
        .padding()
    }
}

// MARK: - 2. @Bindable 属性包装器示例

@Observable
class S3TaskManager {
    var tasks: [S3Task] = [
        S3Task(title: "学习SwiftUI", isCompleted: false),
        S3Task(title: "完成作业", isCompleted: true),
        S3Task(title: "复习笔记", isCompleted: false)
    ]
    
    var completedCount: Int {
        tasks.filter { $0.isCompleted }.count
    }
    
    var progress: Double {
        tasks.isEmpty ? 0 : Double(completedCount) / Double(tasks.count)
    }
}

@Observable
class S3Task: Identifiable {
    let id = UUID()
    var title: String
    var isCompleted: Bool
    
    init(title: String, isCompleted: Bool) {
        self.title = title
        self.isCompleted = isCompleted
    }
}

struct BindableExample: View {
    @State private var taskManager = S3TaskManager()
    
    var body: some View {
        VStack(spacing: 12) {
            VStack {
                HStack {
                    Text("任务进度:")
                        .fontWeight(.semibold)
                    Spacer()
                    Text("\(taskManager.completedCount)/\(taskManager.tasks.count)")
                }
                
                ProgressView(value: taskManager.progress)
                    .tint(.green)
            }
            .padding()
            .background(.white)
            .cornerRadius(8)
            .shadow(radius: 2)
            
            List {
                ForEach(taskManager.tasks) { task in
                    TaskRow(task: task)
                }
                .onDelete { offsets in
                    taskManager.tasks.remove(atOffsets: offsets)
                }
            }
            .frame(height: 200)
            .listStyle(.plain)
            
            HStack {
                TextField("新任务", text: .constant(""))
                    .textFieldStyle(.roundedBorder)
                    .disabled(true)
                
                Button("添加") {
                    let newTask = S3Task(title: "新任务", isCompleted: false)
                    taskManager.tasks.append(newTask)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
        }
        .padding()
    }
}

struct TaskRow: View {
    let task: S3Task
    
    var body: some View {
        HStack {
            Button {
                task.isCompleted.toggle()
            } label: {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(task.isCompleted ? .green : .gray)
                    .font(.title2)
            }
            
            TextField("任务", text: .init(get: { task.title }, set: { task.title = $0 }))
                .strikethrough(task.isCompleted)
                .foregroundColor(task.isCompleted ? .gray : .primary)
            
            Spacer()
        }
        .padding(.vertical, 8)
    }
}

// MARK: - 3. @State 与 @Binding 的增强示例

struct StateBindingEnhancedExample: View {
    @State private var counter = 0
    @State private var text = ""
    @State private var selectedColor = Color.blue
    
    var body: some View {
        VStack(spacing: 12) {
            CounterDisplay(count: $counter)
            
            Divider()
            
            TextEditorView(text: $text)
            
            Divider()
            
            S3ColorPickerView(selectedColor: $selectedColor)
        }
        .padding()
    }
}

struct CounterDisplay: View {
    @Binding var count: Int
    
    var body: some View {
        VStack(spacing: 10) {
            Text("计数器: \(count)")
                .font(.title)
                .fontWeight(.bold)
            
            HStack(spacing: 20) {
                Button {
                    count -= 1
                } label: {
                    Image(systemName: "minus.circle.fill")
                        .font(.largeTitle)
                        .foregroundColor(.red)
                }
                
                Button {
                    count += 1
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.largeTitle)
                        .foregroundColor(.green)
                }
                
                Button {
                    count = 0
                } label: {
                    Image(systemName: "arrow.counterclockwise.circle.fill")
                        .font(.largeTitle)
                        .foregroundColor(.blue)
                }
            }
        }
        .padding()
        .background(.white)
        .cornerRadius(8)
        .shadow(radius: 2)
    }
}

struct TextEditorView: View {
    @Binding var text: String
    
    var body: some View {
        VStack(spacing: 10) {
            Text("文本编辑器")
                .font(.headline)
            
            TextEditor(text: $text)
                .frame(height: 100)
                .border(Color.gray.opacity(0.3))
                .cornerRadius(8)
            
            HStack {
                Text("字符数: \(text.count)")
                    .font(.caption)
                    .foregroundColor(.gray)
                Spacer()
                Button("清空") {
                    text = ""
                }
                .font(.caption)
            }
        }
        .padding()
        .background(.white)
        .cornerRadius(8)
        .shadow(radius: 2)
    }
}

struct S3ColorPickerView: View {
    @Binding var selectedColor: Color
    
    let colors: [(name: String, color: Color)] = [
        ("蓝色", .blue),
        ("绿色", .green),
        ("红色", .red),
        ("橙色", .orange),
        ("紫色", .purple),
        ("粉色", .pink)
    ]
    
    var body: some View {
        VStack(spacing: 10) {
            Text("颜色选择器")
                .font(.headline)
            
            RoundedRectangle(cornerRadius: 10)
                .fill(selectedColor)
                .frame(height: 60)
                .shadow(radius: 3)
            
            HStack(spacing: 10) {
                ForEach(colors, id: \.name) { colorItem in
                    Button {
                        selectedColor = colorItem.color
                    } label: {
                        Circle()
                            .fill(colorItem.color)
                            .frame(width: 40, height: 40)
                            .overlay(
                                Circle()
                                    .stroke(selectedColor == colorItem.color ? Color.black : Color.clear, lineWidth: 3)
                            )
                    }
                }
            }
        }
        .padding()
        .background(.white)
        .cornerRadius(8)
        .shadow(radius: 2)
    }
}

// MARK: - 4. 环境对象与环境值示例

@Observable
class S3ThemeManager {
    var isDarkMode = false
    var accentColor: Color = .blue
    var fontSize: Double = 16
}

struct ThemeKey: EnvironmentKey {
    static let defaultValue = S3ThemeManager()
}

extension EnvironmentValues {
    var themeManager: S3ThemeManager {
        get { self[ThemeKey.self] }
        set { self[ThemeKey.self] = newValue }
    }
}

struct EnvironmentExample: View {
    @State private var themeManager = S3ThemeManager()
    
    var body: some View {
        VStack(spacing: 12) {
            ThemeSettingsView()
                .environment(themeManager)
            
            Divider()
            
            ThemePreviewView()
                .environment(themeManager)
        }
        .padding()
    }
}

struct ThemeSettingsView: View {
    @Environment(S3ThemeManager.self) private var themeManager
    
    var body: some View {
        VStack(spacing: 10) {
            Text("主题设置")
                .font(.headline)
            
            Toggle("深色模式", isOn: .init(get: { themeManager.isDarkMode }, set: { themeManager.isDarkMode = $0 }))
                .tint(.blue)
            
            HStack {
                Text("强调色:")
                    .fontWeight(.semibold)
                Spacer()
                HStack(spacing: 10) {
                    ForEach([Color.blue, .green, .orange, .purple], id: \.self) { color in
                        Button {
                            themeManager.accentColor = color
                        } label: {
                            Circle()
                                .fill(color)
                                .frame(width: 30, height: 30)
                                .overlay(
                                    Circle()
                                        .stroke(themeManager.accentColor == color ? .black : .clear, lineWidth: 2)
                                )
                        }
                    }
                }
            }
            
            HStack {
                Text("字体大小:")
                    .fontWeight(.semibold)
                Spacer()
                Stepper("\(Int(themeManager.fontSize))pt", value: .init(get: { themeManager.fontSize }, set: { themeManager.fontSize = $0 }), in: 12...24)
            }
        }
        .padding()
        .background(.white)
        .cornerRadius(8)
        .shadow(radius: 2)
    }
}

struct ThemePreviewView: View {
    @Environment(S3ThemeManager.self) private var themeManager
    
    var body: some View {
        VStack(spacing: 10) {
            Text("主题预览")
                .font(.headline)
            
            VStack(spacing: 8) {
                Text("标题文字")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(themeManager.accentColor)
                
                Text("这是一段示例文本，用于展示主题效果。")
                    .font(.system(size: themeManager.fontSize))
                
                Button("按钮示例") {
                    
                }
                .padding()
                .background(themeManager.accentColor)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            .padding()
            .background(themeManager.isDarkMode ? Color(white: 0.2) : Color(white: 0.95))
            .foregroundColor(themeManager.isDarkMode ? .white : .primary)
            .cornerRadius(8)
        }
        .padding()
        .background(.white)
        .cornerRadius(8)
        .shadow(radius: 2)
    }
}

// MARK: - 5. 异步状态管理示例

@Observable
class S3DataLoader {
    var isLoading = false
    var data: [String] = []
    var errorMessage: String?
    
    func loadData() async {
        isLoading = true
        errorMessage = nil
        
        do {
            try await Task.sleep(nanoseconds: 2 * 1_000_000_000)
            
            data = [
                "数据项 1",
                "数据项 2",
                "数据项 3",
                "数据项 4",
                "数据项 5"
            ]
        } catch {
            errorMessage = "加载失败: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    func reset() {
        data = []
        errorMessage = nil
        isLoading = false
    }
}

struct AsyncStateExample: View {
    @State private var dataLoader = S3DataLoader()
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Button("加载数据") {
                    Task {
                        await dataLoader.loadData()
                    }
                }
                .padding()
                .background(.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
                .disabled(dataLoader.isLoading)
                
                Button("重置") {
                    dataLoader.reset()
                }
                .padding()
                .background(.red)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            
            if dataLoader.isLoading {
                VStack(spacing: 10) {
                    ProgressView("加载中...")
                    Text("请稍候，正在获取数据...")
                        .foregroundColor(.gray)
                }
                .padding()
            } else if let error = dataLoader.errorMessage {
                VStack(spacing: 10) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.largeTitle)
                        .foregroundColor(.red)
                    Text(error)
                        .foregroundColor(.red)
                }
                .padding()
            } else if !dataLoader.data.isEmpty {
                List(dataLoader.data, id: \.self) { item in
                    Text(item)
                        .padding(.vertical, 8)
                }
                .frame(height: 200)
                .listStyle(.plain)
            } else {
                VStack(spacing: 10) {
                    Image(systemName: "tray")
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                    Text("暂无数据，点击加载数据按钮")
                        .foregroundColor(.gray)
                }
                .padding()
            }
        }
        .padding()
        .background(.white)
        .cornerRadius(8)
        .shadow(radius: 2)
    }
}

// MARK: - 6. 性能优化最佳实践示例

@Observable
class S3ListViewModel {
    var items: [S3ListItem] = []
    
    init() {
        generateItems()
    }
    
    func generateItems() {
        items = (1...100).map { index in
            S3ListItem(
                id: index,
                title: "项目 \(index)",
                description: "这是项目 \(index) 的详细描述信息",
                isFavorite: index % 5 == 0
            )
        }
    }
    
    func toggleFavorite(for id: Int) {
        if let index = items.firstIndex(where: { $0.id == id }) {
            items[index].isFavorite.toggle()
        }
    }
}

struct S3ListItem: Identifiable {
    let id: Int
    let title: String
    let description: String
    var isFavorite: Bool
}

struct PerformanceOptimizationExample: View {
    @State private var viewModel = S3ListViewModel()
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("性能优化列表示例")
                        .font(.headline)
                    Text("使用 @Observable 和标识符实现高效更新")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                Spacer()
                Button("刷新") {
                    viewModel.generateItems()
                }
                .padding(.horizontal, 15)
                .padding(.vertical, 8)
                .background(.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            
            List {
                ForEach(viewModel.items) { item in
                    ListItemRow(item: item, onToggleFavorite: {
                        viewModel.toggleFavorite(for: item.id)
                    })
                }
            }
            .frame(height: 250)
            .listStyle(.plain)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("最佳实践要点:")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Text("• 使用 @Observable 代替 @Published 减少开销")
                    .font(.caption)
                Text("• 使用 Identifiable 协议确保正确的视图更新")
                    .font(.caption)
                Text("• 合理使用 @State 和 @Bindable 避免过度传递")
                    .font(.caption)
                Text("• 利用惰性容器视图提高列表性能")
                    .font(.caption)
                Text("• 将复杂计算移至计算属性或专用方法")
                    .font(.caption)
            }
            .padding()
            .background(.gray.opacity(0.05))
            .cornerRadius(8)
        }
        .padding()
    }
}

struct ListItemRow: View {
    let item: S3ListItem
    let onToggleFavorite: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.headline)
                Text(item.description)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Button {
                onToggleFavorite()
            } label: {
                Image(systemName: item.isFavorite ? "star.fill" : "star")
                    .foregroundColor(item.isFavorite ? .yellow : .gray)
            }
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    S3_ModernStateManagementDemo()
}
