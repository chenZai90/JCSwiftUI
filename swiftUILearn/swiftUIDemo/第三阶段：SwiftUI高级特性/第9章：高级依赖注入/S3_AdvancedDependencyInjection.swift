//
//  S3_AdvancedDependencyInjection.swift
//  swiftUIDemo
//
//  高级依赖注入示例
//

import SwiftUI

// MARK: - 高级依赖注入主视图
struct S3_AdvancedDependencyInjectionDemo: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("高级依赖注入")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                
                VStack {
                    Text("1. 初始化器注入")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    InitializerInjectionView()
                }
                .padding()
                .background(.blue.opacity(0.1))
                .cornerRadius(10)
                
                VStack {
                    Text("2. 环境注入（iOS 17+）")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    EnvironmentInjectionView()
                }
                .padding()
                .background(.green.opacity(0.1))
                .cornerRadius(10)
                
                VStack {
                    Text("3. 单例模式注入")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    SingletonInjectionView()
                }
                .padding()
                .background(.purple.opacity(0.1))
                .cornerRadius(10)
                
                VStack {
                    Text("4. 工厂模式注入")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    FactoryInjectionView()
                }
                .padding()
                .background(.orange.opacity(0.1))
                .cornerRadius(10)
                
                VStack {
                    Text("5. 容器依赖注入")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    ContainerInjectionView()
                }
                .padding()
                .background(.red.opacity(0.1))
                .cornerRadius(10)
                
                VStack {
                    Text("6. 测试依赖注入")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    TestInjectionView()
                }
                .padding()
                .background(.yellow.opacity(0.1))
                .cornerRadius(10)
            }
            .padding()
        }
    }
}

// MARK: - 1. 初始化器注入

// 数据服务协议
protocol DataServiceProtocol {
    func fetchData() async throws -> [String]
    func saveData(_ data: String) async throws
}

// 真实数据服务
class RealDataService: DataServiceProtocol {
    func fetchData() async throws -> [String] {
        try await Task.sleep(nanoseconds: 1 * 1_000_000_000)
        return ["数据项 1", "数据项 2", "数据项 3"]
    }
    
    func saveData(_ data: String) async throws {
        try await Task.sleep(nanoseconds: 500_000_000)
        print("已保存数据: \(data)")
    }
}

// 初始化器注入视图模型
class InitializerViewModel: ObservableObject {
    @Published var items: [String] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let dataService: DataServiceProtocol
    
    // 通过初始化器注入依赖
    init(dataService: DataServiceProtocol) {
        self.dataService = dataService
    }
    
    func loadData() {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let data = try await dataService.fetchData()
                await MainActor.run {
                    self.items = data
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }
}

// 初始化器注入视图
struct InitializerInjectionView: View {
    @StateObject private var viewModel: InitializerViewModel
    
    // 在初始化时注入依赖
    init(dataService: DataServiceProtocol = RealDataService()) {
        _viewModel = StateObject(wrappedValue: InitializerViewModel(dataService: dataService))
    }
    
    var body: some View {
        VStack(spacing: 10) {
            if viewModel.isLoading {
                ProgressView("加载中...")
            } else if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
            } else {
                List(viewModel.items, id: \.self) { item in
                    Text(item)
                }
                .frame(height: 150)
                .listStyle(.plain)
            }
            
            Button("加载数据") {
                viewModel.loadData()
            }
            .padding()
            .background(.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
        .background(.white)
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}

// MARK: - 2. 环境注入（iOS 17+）

// 主题服务协议
protocol ThemeServiceProtocol {
    var primaryColor: Color { get }
    var secondaryColor: Color { get }
    var isDarkMode: Bool { get }
    
    func setPrimaryColor(_ color: Color)
    func toggleDarkMode()
}

// 主题服务实现
@Observable
class ThemeService: ThemeServiceProtocol {
    var primaryColor: Color = .blue
    var secondaryColor: Color = .gray
    var isDarkMode: Bool = false
    
    func setPrimaryColor(_ color: Color) {
        primaryColor = color
    }
    
    func toggleDarkMode() {
        isDarkMode.toggle()
    }
}

// 环境键定义
struct ThemeServiceKey: EnvironmentKey {
    static let defaultValue: ThemeServiceProtocol = ThemeService()
}

extension EnvironmentValues {
    var themeService: ThemeServiceProtocol {
        get { self[ThemeServiceKey.self] }
        set { self[ThemeServiceKey.self] = newValue }
    }
}

// 环境注入视图
struct EnvironmentInjectionView: View {
    @State private var themeService = ThemeService()
    
    var body: some View {
        VStack(spacing: 10) {
            S3ThemeSettingsView()
                .environment(themeService)
            
            Divider()
            
            S3ThemePreviewView()
                .environment(themeService)
        }
        .padding()
        .background(.white)
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}

// 主题设置子视图
struct S3ThemeSettingsView: View {
    @Environment(ThemeService.self) private var themeService
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("主题设置")
                .font(.headline)
                .fontWeight(.bold)
            
            Toggle("深色模式", isOn: .init(get: { themeService.isDarkMode }, set: { themeService.isDarkMode = $0 }))
            
            HStack {
                Text("主题色")
                Spacer()
                ColorPicker("", selection: .init(get: { themeService.primaryColor }, set: { themeService.primaryColor = $0 }))
            }
            
            HStack {
                Circle()
                    .fill(themeService.primaryColor)
                    .frame(width: 30, height: 30)
                Text("当前主题色")
                    .foregroundColor(themeService.primaryColor)
            }
        }
        .padding()
    }
}

// 主题预览子视图
struct S3ThemePreviewView: View {
    @Environment(ThemeService.self) private var themeService
    
    var body: some View {
        VStack(spacing: 10) {
            Text("主题预览")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(themeService.primaryColor)
            
            Button("示例按钮") {
                
            }
            .padding()
            .background(themeService.primaryColor)
            .foregroundColor(.white)
            .cornerRadius(10)
            
            Text("这是预览文本")
                .padding()
                .background(themeService.isDarkMode ? Color.gray.opacity(0.3) : Color.gray.opacity(0.1))
                .cornerRadius(8)
        }
        .padding()
    }
}

// MARK: - 3. 单例模式注入

// 用户管理服务（单例）
class UserManager: ObservableObject {
    static let shared = UserManager()
    
    @Published var currentUser: S3User?
    @Published var isLoggedIn: Bool = false
    
    private init() {}
    
    func login(username: String, password: String) async throws {
        try await Task.sleep(nanoseconds: 500_000_000)
        currentUser = S3User(id: UUID(), username: username, email: "\(username)@example.com")
        isLoggedIn = true
    }
    
    func logout() {
        currentUser = nil
        isLoggedIn = false
    }
}

// 用户模型
struct S3User: Identifiable {
    let id: UUID
    let username: String
    let email: String
}

// 单例注入视图
struct SingletonInjectionView: View {
    @StateObject private var userManager = UserManager.shared
    @State private var username = ""
    @State private var password = ""
    @State private var isLoggingIn = false
    
    var body: some View {
        VStack(spacing: 10) {
            if userManager.isLoggedIn, let user = userManager.currentUser {
                VStack(spacing: 10) {
                    Image(systemName: "person.circle.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.blue)
                    
                    Text("欢迎回来，\(user.username)!")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text(user.email)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    Button("退出登录") {
                        userManager.logout()
                    }
                    .padding()
                    .background(.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
            } else {
                VStack(spacing: 10) {
                    TextField("用户名", text: $username)
                        .textFieldStyle(.roundedBorder)
                    
                    SecureField("密码", text: $password)
                        .textFieldStyle(.roundedBorder)
                    
                    Button(isLoggingIn ? "登录中..." : "登录") {
                        Task {
                            isLoggingIn = true
                            try? await userManager.login(username: username, password: password)
                            isLoggingIn = false
                        }
                    }
                    .disabled(username.isEmpty || password.isEmpty || isLoggingIn)
                    .padding()
                    .background(.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
            }
        }
        .padding()
        .background(.white)
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}

// MARK: - 4. 工厂模式注入

// 通知服务协议
protocol NotificationServiceProtocol {
    func sendNotification(title: String, message: String)
    func getNotifications() -> [NotificationItem]
}

// 通知项模型
struct NotificationItem: Identifiable {
    let id = UUID()
    let title: String
    let message: String
    let timestamp: Date
}

// 本地通知服务
class LocalNotificationService: NotificationServiceProtocol {
    private var notifications: [NotificationItem] = []
    
    func sendNotification(title: String, message: String) {
        let notification = NotificationItem(
            title: title,
            message: message,
            timestamp: Date()
        )
        notifications.insert(notification, at: 0)
        print("本地通知: \(title) - \(message)")
    }
    
    func getNotifications() -> [NotificationItem] {
        notifications
    }
}

// 远程通知服务
class RemoteNotificationService: NotificationServiceProtocol {
    private var notifications: [NotificationItem] = []
    
    func sendNotification(title: String, message: String) {
        let notification = NotificationItem(
            title: title,
            message: message,
            timestamp: Date()
        )
        notifications.insert(notification, at: 0)
        print("远程通知: \(title) - \(message)")
    }
    
    func getNotifications() -> [NotificationItem] {
        notifications
    }
}

// 通知服务工厂
class NotificationServiceFactory {
    static func createService(type: ServiceType) -> NotificationServiceProtocol {
        switch type {
        case .local:
            return LocalNotificationService()
        case .remote:
            return RemoteNotificationService()
        }
    }
    
    enum ServiceType {
        case local
        case remote
    }
}

// 工厂注入视图
struct FactoryInjectionView: View {
    @State private var selectedServiceType: NotificationServiceFactory.ServiceType = .local
    @State private var notificationService: NotificationServiceProtocol = LocalNotificationService()
    @State private var title = ""
    @State private var message = ""
    
    var body: some View {
        VStack(spacing: 10) {
            Picker("通知服务类型", selection: $selectedServiceType) {
                Text("本地服务").tag(NotificationServiceFactory.ServiceType.local)
                Text("远程服务").tag(NotificationServiceFactory.ServiceType.remote)
            }
            .pickerStyle(.segmented)
            .onChange(of: selectedServiceType) { _, newValue in
                notificationService = NotificationServiceFactory.createService(type: newValue)
            }
            
            TextField("通知标题", text: $title)
                .textFieldStyle(.roundedBorder)
            
            TextField("通知内容", text: $message)
                .textFieldStyle(.roundedBorder)
            
            Button("发送通知") {
                notificationService.sendNotification(title: title, message: message)
                title = ""
                message = ""
            }
            .disabled(title.isEmpty || message.isEmpty)
            .padding()
            .background(.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            
            Divider()
            
            Text("通知列表")
                .font(.headline)
            
            let notifications = notificationService.getNotifications()
            if notifications.isEmpty {
                Text("暂无通知")
                    .foregroundColor(.gray)
            } else {
                List(notifications.prefix(5)) { notification in
                    VStack(alignment: .leading, spacing: 5) {
                        Text(notification.title)
                            .font(.headline)
                        Text(notification.message)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                .frame(height: 150)
                .listStyle(.plain)
            }
        }
        .padding()
        .background(.white)
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}

// MARK: - 5. 容器依赖注入

// 依赖容器
class DIContainer {
    static let shared = DIContainer()
    
    private var dependencies: [String: Any] = [:]
    
    // 注册依赖
    func register<T>(_ type: T.Type, dependency: T) {
        let key = String(describing: type)
        dependencies[key] = dependency
    }
    
    // 解析依赖
    func resolve<T>(_ type: T.Type) -> T? {
        let key = String(describing: type)
        return dependencies[key] as? T
    }
}

// 网络服务
protocol NetworkServiceProtocol {
    func request(url: String) async throws -> Data
}

class NetworkService: NetworkServiceProtocol {
    func request(url: String) async throws -> Data {
        try await Task.sleep(nanoseconds: 500_000_000)
        return "网络请求返回数据".data(using: .utf8) ?? Data()
    }
}

// 缓存服务
protocol CacheServiceProtocol {
    func get(key: String) -> String?
    func set(key: String, value: String)
}

class CacheService: CacheServiceProtocol {
    private var cache: [String: String] = [:]
    
    func get(key: String) -> String? {
        cache[key]
    }
    
    func set(key: String, value: String) {
        cache[key] = value
    }
}

// 容器注入视图模型
class ContainerViewModel: ObservableObject {
    @Published var data: String = ""
    @Published var isLoading = false
    
    private let networkService: NetworkServiceProtocol?
    private let cacheService: CacheServiceProtocol?
    
    init(container: DIContainer = .shared) {
        self.networkService = container.resolve(NetworkServiceProtocol.self)
        self.cacheService = container.resolve(CacheServiceProtocol.self)
    }
    
    func loadData() {
        isLoading = true
        
        Task {
            if let cached = cacheService?.get(key: "data") {
                await MainActor.run {
                    self.data = "缓存数据: \(cached)"
                    self.isLoading = false
                }
                return
            }
            
            do {
                let networkData = try await networkService?.request(url: "https://example.com")
                let dataString = String(data: networkData ?? Data(), encoding: .utf8) ?? ""
                cacheService?.set(key: "data", value: dataString)
                
                await MainActor.run {
                    self.data = "网络数据: \(dataString)"
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.data = "错误: \(error.localizedDescription)"
                    self.isLoading = false
                }
            }
        }
    }
}

// 容器注入视图
struct ContainerInjectionView: View {
    @StateObject private var viewModel: ContainerViewModel
    
    init() {
        let container = DIContainer.shared
        container.register(NetworkServiceProtocol.self, dependency: NetworkService())
        container.register(CacheServiceProtocol.self, dependency: CacheService())
        _viewModel = StateObject(wrappedValue: ContainerViewModel(container: container))
    }
    
    var body: some View {
        VStack(spacing: 10) {
            Text("依赖容器示例")
                .font(.headline)
            
            if viewModel.isLoading {
                ProgressView("加载中...")
            } else if !viewModel.data.isEmpty {
                Text(viewModel.data)
                    .padding()
                    .background(.gray.opacity(0.1))
                    .cornerRadius(10)
            }
            
            Button("加载数据") {
                viewModel.loadData()
            }
            .padding()
            .background(.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
        .background(.white)
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}

// MARK: - 6. 测试依赖注入

// 模拟数据服务（用于测试）
class MockDataService: DataServiceProtocol {
    var mockData: [String]
    var shouldThrowError: Bool
    
    init(mockData: [String] = [], shouldThrowError: Bool = false) {
        self.mockData = mockData
        self.shouldThrowError = shouldThrowError
    }
    
    func fetchData() async throws -> [String] {
        if shouldThrowError {
            throw NSError(domain: "TestError", code: 1, userInfo: [NSLocalizedDescriptionKey: "模拟错误"])
        }
        return mockData
    }
    
    func saveData(_ data: String) async throws {
        print("模拟保存数据: \(data)")
    }
}

// 测试注入视图
struct TestInjectionView: View {
    @State private var useMockService = false
    @State private var shouldShowError = false
    
    var body: some View {
        VStack(spacing: 10) {
            Text("测试依赖注入")
                .font(.headline)
            
            Toggle("使用模拟服务", isOn: $useMockService)
            
            if useMockService {
                Toggle("模拟错误", isOn: $shouldShowError)
            }
            
            // 根据条件注入不同的服务
            if useMockService {
                InitializerInjectionView(
                    dataService: MockDataService(
                        mockData: ["测试数据 1", "测试数据 2", "测试数据 3"],
                        shouldThrowError: shouldShowError
                    )
                )
            } else {
                InitializerInjectionView()
            }
            
            VStack(alignment: .leading, spacing: 5) {
                Text("测试说明:")
                    .font(.subheadline)
                    .fontWeight(.bold)
                Text("• 使用模拟服务可以在测试时控制返回的数据")
                    .font(.caption)
                Text("• 可以模拟错误场景进行测试")
                    .font(.caption)
                Text("• 不需要真实网络请求，提高测试速度")
                    .font(.caption)
            }
            .padding()
            .background(.gray.opacity(0.1))
            .cornerRadius(8)
        }
        .padding()
        .background(.white)
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}

#Preview {
    S3_AdvancedDependencyInjectionDemo()
}
