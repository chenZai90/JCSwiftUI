//
//  StateManagement.swift
//  swiftUIDemo
//
//  基础状态管理示例 - 包含所有SwiftUI状态管理技术
//

import SwiftUI
import Combine

// MARK: - 1. @State：本地视图状态
struct SM_CounterView: View {
    // 使用 @State 声明本地状态
    @State private var count = 0
    
    var body: some View {
        VStack(spacing: 20) {
            // 显示状态值
            Text("Count: \(count)")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            // 修改状态
            Button("Increment") {
                count += 1  // 状态改变，UI 自动更新
            }
            .buttonStyle(.borderedProminent)
            
            Button("Reset") {
                count = 0  // 状态重置
            }
            .buttonStyle(.bordered)
        }
        .padding()
    }
}

// MARK: - 2. @Binding：父子视图双向绑定
// 父视图
struct SM_ParentView: View {
    // 父视图的状态
    @State private var isPlaying = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Parent View")
                .font(.headline)
            
            Text("Is Playing: \(isPlaying ? "Yes" : "No")")
            
            // 使用 $ 符号创建绑定并传递给子视图
            SM_PlayButton(isPlaying: $isPlaying)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
    }
}

// 子视图
struct SM_PlayButton: View {
    // 使用 @Binding 接收父视图的状态引用
    @Binding var isPlaying: Bool
    
    var body: some View {
        Button(isPlaying ? "Pause" : "Play") {
            // 修改绑定值，会同步更新父视图的状态
            isPlaying.toggle()
        }
        .buttonStyle(.borderedProminent)
        .tint(isPlaying ? .red : .green)
        .padding()
        .background(Color.gray.opacity(0.05))
        .cornerRadius(8)
    }
}

// 表单输入示例
struct SM_FormView: View {
    @State private var username = ""
    @State private var email = ""
    
    var body: some View {
        VStack(spacing: 16) {
            Text("User Form")
                .font(.headline)
            
            SM_TextFieldView(
                title: "Username",
                text: $username,
                placeholder: "Enter your username"
            )
            
            SM_TextFieldView(
                title: "Email",
                text: $email,
                placeholder: "Enter your email"
            )
            
            Text("Username: \(username)")
            Text("Email: \(email)")
        }
        .padding()
    }
}

struct SM_TextFieldView: View {
    let title: String
    @Binding var text: String
    let placeholder: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
            
            TextField(
                placeholder,
                text: $text
            )
            .textFieldStyle(.roundedBorder)
        }
    }
}

// MARK: - 3. @StateObject：可观察对象状态
// 可观察对象模型
class SM_UserViewModel: ObservableObject {
    // 使用 @Published 标记需要发布的属性
    @Published var username = ""
    @Published var email = ""
    @Published var isLoggedIn = false
    
    func login() {
        // 模拟登录操作
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.isLoggedIn = true
        }
    }
    
    func logout() {
        username = ""
        email = ""
        isLoggedIn = false
    }
}

struct SM_UserView: View {
    // 使用 @StateObject 管理可观察对象
    @StateObject private var viewModel = SM_UserViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            Text("User Profile")
                .font(.headline)
            
            if viewModel.isLoggedIn {
                Text("Welcome, \(viewModel.username)!")
                    .font(.title)
                Text("Email: \(viewModel.email)")
                
                Button("Logout") {
                    viewModel.logout()
                }
                .buttonStyle(.borderedProminent)
                .tint(.red)
            } else {
                TextField("Username", text: $viewModel.username)
                    .textFieldStyle(.roundedBorder)
                TextField("Email", text: $viewModel.email)
                    .textFieldStyle(.roundedBorder)
                
                Button("Login") {
                    viewModel.login()
                }
                .buttonStyle(.borderedProminent)
                .disabled(viewModel.username.isEmpty || viewModel.email.isEmpty)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
    }
}

// MARK: - 4. @ObservedObject：观察外部对象
// 父视图
struct SM_ParentWithObservedObject: View {
    // 父视图拥有状态对象
    @StateObject private var userViewModel = SM_UserViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Parent View")
                .font(.headline)
            
            // 传递给子视图
            SM_ChildView(viewModel: userViewModel)
        }
        .padding()
    }
}

// 子视图
struct SM_ChildView: View {
    // 使用 @ObservedObject 观察外部对象
    @ObservedObject var viewModel: SM_UserViewModel
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Child View")
                .font(.subheadline)
            
            TextField("Username", text: $viewModel.username)
                .textFieldStyle(.roundedBorder)
            
            TextField("Email", text: $viewModel.email)
                .textFieldStyle(.roundedBorder)
            
            Button("Login") {
                viewModel.login()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
    }
}

// MARK: - 5. @EnvironmentObject：全局环境对象
// 全局状态模型
class SM_AppState: ObservableObject {
    @Published var isDarkMode = false
    @Published var userLanguage = "zh"
    @Published var currentUser: SM_User? = nil
    
    func toggleDarkMode() {
        isDarkMode.toggle()
    }
    
    func changeLanguage(to language: String) {
        userLanguage = language
    }
    
    func login(user: SM_User) {
        currentUser = user
    }
    
    func logout() {
        currentUser = nil
    }
}

// 主视图 - 设置环境对象
struct SM_MainView: View {
    @StateObject private var appState = SM_AppState()
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Main View")
                    .font(.headline)
                
                NavigationLink("Settings", destination: SM_SettingsView())
                NavigationLink("Profile", destination: SM_ProfileView())
            }
            .padding()
        }
        // 通过环境传递对象
        .environmentObject(appState)
    }
}

// 设置视图 - 访问环境对象
struct SM_SettingsView: View {
    // 通过 @EnvironmentObject 访问全局对象
    @EnvironmentObject private var appState: SM_AppState
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Settings")
                .font(.headline)
            
            Toggle("Dark Mode", isOn: $appState.isDarkMode)
            
            Picker("Language", selection: $appState.userLanguage) {
                Text("English").tag("en")
                Text("中文").tag("zh")
                Text("日本語").tag("ja")
            }
            .pickerStyle(.segmented)
        }
        .padding()
        .background(appState.isDarkMode ? Color.black : Color.white)
        .foregroundColor(appState.isDarkMode ? Color.white : Color.black)
    }
}

// 个人资料视图 - 访问环境对象
struct SM_ProfileView: View {
    @EnvironmentObject private var appState: SM_AppState
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Profile")
                .font(.headline)
            
            Text("Current Language: \(appState.userLanguage)")
            Text("Dark Mode: \(appState.isDarkMode ? "On" : "Off")")
        }
        .padding()
        .background(appState.isDarkMode ? Color.black : Color.white)
        .foregroundColor(appState.isDarkMode ? Color.white : Color.black)
    }
}

// MARK: - 6. @Environment：环境值
struct SM_EnvironmentValuesView: View {
    // 访问环境值
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.layoutDirection) private var layoutDirection
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Environment Values")
                .font(.headline)
            
            Text("Color Scheme: \(colorScheme == .dark ? "Dark" : "Light")")
            Text("Layout Direction: \(layoutDirection == .leftToRight ? "LTR" : "RTL")")
            
            // 转换DynamicTypeSize为可读文本
            Text("Dynamic Type Size: \(String(describing: dynamicTypeSize))")
            
            Text("Horizontal Size Class: \(horizontalSizeClass == .regular ? "Regular" : "Compact")")
            
            // 根据环境值调整布局
            if horizontalSizeClass == .regular {
                HStack {
                    Text("Wide Layout")
                    Spacer()
                    Text("More Content")
                }
            } else {
                VStack {
                    Text("Narrow Layout")
                    Text("Content Below")
                }
            }
        }
        .padding()
        .background(colorScheme == .dark ? Color.black : Color.white)
        .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
    }
}

// MARK: - 7. @SceneStorage：场景存储
struct SM_SceneStorageView: View {
    // 使用 @SceneStorage 存储数据
    @SceneStorage("sm_username") private var username = ""
    @SceneStorage("sm_isDarkMode") private var isDarkMode = false
    @SceneStorage("sm_counter") private var counter = 0
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Scene Storage")
                .font(.headline)
            
            TextField("Username", text: $username)
                .textFieldStyle(.roundedBorder)
            
            Toggle("Dark Mode", isOn: $isDarkMode)
            
            VStack {
                Text("Counter: \(counter)")
                HStack {
                    Button("Increment") {
                        counter += 1
                    }
                    .buttonStyle(.bordered)
                    
                    Button("Reset") {
                        counter = 0
                    }
                    .buttonStyle(.bordered)
                }
            }
            
            Text("Note: Data persists across app restarts")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(isDarkMode ? Color.black : Color.white)
        .foregroundColor(isDarkMode ? Color.white : Color.black)
    }
}

// MARK: - 8. @AppStorage：应用存储
struct SM_AppStorageView: View {
    // 使用 @AppStorage 存储数据
    @AppStorage("sm_userName") private var userName = "Guest"
    @AppStorage("sm_appTheme") private var appTheme = "light"
    @AppStorage("sm_notificationsEnabled") private var notificationsEnabled = true
    
    var body: some View {
        VStack(spacing: 20) {
            Text("App Storage")
                .font(.headline)
            
            TextField("User Name", text: $userName)
                .textFieldStyle(.roundedBorder)
            
            Picker("Theme", selection: $appTheme) {
                Text("Light").tag("light")
                Text("Dark").tag("dark")
                Text("Auto").tag("auto")
            }
            .pickerStyle(.segmented)
            
            Toggle("Enable Notifications", isOn: $notificationsEnabled)
            
            Text("Note: Data persists across app reinstalls")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(getThemeColor())
        .foregroundColor(appTheme == "dark" ? Color.white : Color.black)
    }
    
    private func getThemeColor() -> Color {
        switch appTheme {
        case "dark":
            return Color.black
        case "light":
            return Color.white
        default:
            return Color.white
        }
    }
}

// MARK: - 9. @FocusedValue：聚焦值
// 定义聚焦值键
struct SM_EditModeKey: FocusedValueKey {
    typealias Value = Bool
}

// 扩展 FocusedValues
extension FocusedValues {
    var sm_isEditMode: SM_EditModeKey.Value? {
        get { self[SM_EditModeKey.self] }
        set { self[SM_EditModeKey.self] = newValue }
    }
}

struct SM_FocusedValueView: View {
    @State private var isEditMode = false
    @State private var text = "Hello, SwiftUI"
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Focused Value")
                .font(.headline)
            
            // 设置聚焦值
            TextField("Enter text", text: $text)
                .textFieldStyle(.roundedBorder)
                .focusedValue(\.sm_isEditMode, true)
            
            Button("Toggle Edit Mode") {
                isEditMode.toggle()
            }
            .buttonStyle(.borderedProminent)
            
            // 子视图访问聚焦值
            SM_FocusedChildView()
        }
        .padding()
    }
}

struct SM_FocusedChildView: View {
    // 访问聚焦值
    @FocusedValue(\.sm_isEditMode) private var isEditMode
    
    var body: some View {
        VStack {
            Text("Child View")
                .font(.subheadline)
            
            Text("Edit Mode: \(isEditMode ?? false ? "On" : "Off")")
            
            if isEditMode ?? false {
                Text("Editing is enabled!")
                    .foregroundColor(.green)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
    }
}

// MARK: - 10. 完整的状态管理示例应用
// 用户模型
struct SM_User: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let email: String
}

// 待办事项模型
struct SM_TodoItem: Identifiable, Equatable {
    let id = UUID()
    var title: String
    var isCompleted = false
}

// 主应用视图
struct StateManagementDemo: View {
    @StateObject private var appState = SM_AppState()
    @AppStorage("sm_lastLoggedInUser") private var lastLoggedInUser = ""
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // 标题
                    Text("状态管理演示")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    // 主题切换
                    VStack {
                        Text("1. 主题设置")
                            .font(.headline)
                        Toggle("深色模式", isOn: $appState.isDarkMode)
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                    
                    // 用户登录状态
                    VStack {
                        Text("2. 用户登录")
                            .font(.headline)
                        if appState.currentUser != nil {
                            Text("欢迎, \(appState.currentUser?.name ?? "")!")
                            Button("退出登录") {
                                appState.logout()
                                lastLoggedInUser = ""
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.red)
                        } else {
                            SM_LoginView()
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                    
                    // 计数器示例
                    VStack {
                        Text("3. 计数器示例")
                            .font(.headline)
                        SM_CounterView()
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                    
                    // 待办事项示例
                    VStack {
                        Text("4. 待办事项")
                            .font(.headline)
                        SM_TodoApp()
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                    
                    // 环境对象示例
                    VStack {
                        Text("5. 环境对象")
                            .font(.headline)
                        SM_EnvironmentObjectDemo()
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                    
                    // 环境值示例
                    VStack {
                        Text("6. 环境值")
                            .font(.headline)
                        SM_EnvironmentValuesView()
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                    
                    // 场景存储示例
                    VStack {
                        Text("7. 场景存储")
                            .font(.headline)
                        SM_SceneStorageView()
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                    
                    // 应用存储示例
                    VStack {
                        Text("8. 应用存储")
                            .font(.headline)
                        SM_AppStorageView()
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                    
                    // 聚焦值示例
                    VStack {
                        Text("9. 聚焦值")
                            .font(.headline)
                        SM_FocusedValueView()
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                    
                    // 状态管理最佳实践
                    VStack(alignment: .leading) {
                        Text("状态管理最佳实践")
                            .font(.headline)
                        Text("• 使用@State管理视图内部的简单状态")
                        Text("• 使用@Binding实现父子视图双向绑定")
                        Text("• 使用@StateObject管理复杂的可观察对象")
                        Text("• 使用@ObservedObject观察外部传入的对象")
                        Text("• 使用@EnvironmentObject管理全局状态")
                        Text("• 使用@Environment访问系统环境值")
                        Text("• 使用@SceneStorage和@AppStorage实现持久化")
                        Text("• 使用@FocusedValue处理焦点相关状态")
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                }
                .padding()
            }
        }
        .environmentObject(appState)
        .preferredColorScheme(appState.isDarkMode ? .dark : .light)
    }
}

// 登录视图
struct SM_LoginView: View {
    @State private var name = ""
    @State private var email = ""
    @EnvironmentObject private var appState: SM_AppState
    @AppStorage("sm_lastLoggedInUser") private var lastLoggedInUser = ""
    
    var body: some View {
        VStack(spacing: 16) {
            TextField("姓名", text: $name)
                .textFieldStyle(.roundedBorder)
            TextField("邮箱", text: $email)
                .textFieldStyle(.roundedBorder)
            Button("登录") {
                let user = SM_User(name: name, email: email)
                appState.login(user: user)
                lastLoggedInUser = name
            }
            .buttonStyle(.borderedProminent)
            .disabled(name.isEmpty || email.isEmpty)
            
            if !lastLoggedInUser.isEmpty {
                Text("上次登录: \(lastLoggedInUser)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}

// 待办事项应用
struct SM_TodoApp: View {
    @State private var todos: [SM_TodoItem] = [
        SM_TodoItem(title: "学习 SwiftUI 状态管理"),
        SM_TodoItem(title: "完成本章练习"),
        SM_TodoItem(title: "构建示例应用")
    ]
    @State private var newTodoTitle = ""
    
    var body: some View {
        VStack {
            HStack(spacing: 8) {
                TextField("输入新的待办事项", text: $newTodoTitle)
                    .textFieldStyle(.roundedBorder)
                Button("添加") {
                    addTodo()
                }
                .buttonStyle(.borderedProminent)
                .disabled(newTodoTitle.isEmpty)
            }
            List {
                ForEach($todos) { $todo in
                    HStack {
                        Button(action: {
                            todo.isCompleted.toggle()
                        }) {
                            Image(systemName: todo.isCompleted ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(todo.isCompleted ? .green : .gray)
                        }
                        .buttonStyle(.plain)
                        Text(todo.title)
                            .strikethrough(todo.isCompleted, color: .gray)
                            .foregroundColor(todo.isCompleted ? .secondary : .primary)
                        Spacer()
                        Button(action: {
                            deleteTodo(todo)
                        }) {
                            Image(systemName: "trash.fill")
                                .foregroundColor(.red)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .onDelete(perform: deleteItem)
            }
            .frame(height: 200)
        }
    }
    
    private func addTodo() {
        guard !newTodoTitle.isEmpty else { return }
        todos.append(SM_TodoItem(title: newTodoTitle))
        newTodoTitle = ""
    }
    
    private func deleteTodo(_ todo: SM_TodoItem) {
        if let index = todos.firstIndex(where: { $0.id == todo.id }) {
            todos.remove(at: index)
        }
    }
    
    private func deleteItem(at offsets: IndexSet) {
        todos.remove(atOffsets: offsets)
    }
}

// 环境对象演示
struct SM_EnvironmentObjectDemo: View {
    @EnvironmentObject private var appState: SM_AppState
    
    var body: some View {
        VStack(spacing: 10) {
            Text("当前主题: \(appState.isDarkMode ? "深色" : "浅色")")
            Text("登录状态: \(appState.currentUser != nil ? "已登录" : "未登录")")
            if let user = appState.currentUser {
                Text("用户: \(user.name)")
                Text("邮箱: \(user.email)")
            }
            Button("切换主题") {
                appState.toggleDarkMode()
            }
            .buttonStyle(.borderedProminent)
        }
    }
}

#Preview {
    StateManagementDemo()
}
