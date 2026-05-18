//
//  S3_AdvancedDataPersistence.swift
//  swiftUIDemo
//
//  高级数据持久化示例
//

import SwiftUI

// MARK: - 高级数据持久化主视图
struct S3_AdvancedDataPersistenceDemo: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("高级数据持久化")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                
                VStack {
                    Text("1. UserDefaults 数据存储")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    UserDefaultsView()
                }
                .padding()
                .background(.blue.opacity(0.1))
                .cornerRadius(10)
                
                VStack {
                    Text("2. FileManager 文件存储")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    FileManagerView()
                }
                .padding()
                .background(.green.opacity(0.1))
                .cornerRadius(10)
                
                VStack {
                    Text("3. @AppStorage 属性包装器")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    AppStorageView()
                }
                .padding()
                .background(.purple.opacity(0.1))
                .cornerRadius(10)
                
                VStack {
                    Text("4. @SceneStorage 场景存储")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    SceneStorageView()
                }
                .padding()
                .background(.orange.opacity(0.1))
                .cornerRadius(10)
                
                VStack {
                    Text("5. Keychain 安全存储")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    KeychainView()
                }
                .padding()
                .background(.red.opacity(0.1))
                .cornerRadius(10)
                
                VStack {
                    Text("6. Codable 数据编码/解码")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    CodableView()
                }
                .padding()
                .background(.yellow.opacity(0.1))
                .cornerRadius(10)
            }
            .padding()
        }
    }
}

// MARK: - 1. UserDefaults 数据存储

// UserDefaults 管理类
class UserDefaultsManager: ObservableObject {
    static let shared = UserDefaultsManager()
    
    private let defaults = UserDefaults.standard
    
    // 键定义
    private enum Keys {
        static let username = "username"
        static let theme = "theme"
        static let notificationsEnabled = "notificationsEnabled"
        static let fontSize = "fontSize"
    }
    
    var username: String {
        get { defaults.string(forKey: Keys.username) ?? "" }
        set { defaults.set(newValue, forKey: Keys.username) }
    }
    
    var theme: String {
        get { defaults.string(forKey: Keys.theme) ?? "light" }
        set { defaults.set(newValue, forKey: Keys.theme) }
    }
    
    var notificationsEnabled: Bool {
        get { defaults.bool(forKey: Keys.notificationsEnabled) }
        set { defaults.set(newValue, forKey: Keys.notificationsEnabled) }
    }
    
    var fontSize: Double {
        get { defaults.double(forKey: Keys.fontSize) }
        set { defaults.set(newValue, forKey: Keys.fontSize) }
    }
    
    func reset() {
        defaults.removeObject(forKey: Keys.username)
        defaults.removeObject(forKey: Keys.theme)
        defaults.removeObject(forKey: Keys.notificationsEnabled)
        defaults.removeObject(forKey: Keys.fontSize)
    }
}

// UserDefaults 视图
struct UserDefaultsView: View {
    @StateObject private var defaultsManager = UserDefaultsManager.shared
    @State private var username = ""
    @State private var selectedTheme = "light"
    @State private var notificationsEnabled = false
    @State private var fontSize = 16.0
    
    init() {
        let manager = UserDefaultsManager.shared
        _username = State(initialValue: manager.username)
        _selectedTheme = State(initialValue: manager.theme)
        _notificationsEnabled = State(initialValue: manager.notificationsEnabled)
        _fontSize = State(initialValue: manager.fontSize)
    }
    
    var body: some View {
        VStack(spacing: 10) {
            TextField("用户名", text: $username)
                .textFieldStyle(.roundedBorder)
                .onChange(of: username) { _, newValue in
                    defaultsManager.username = newValue
                }
            
            Picker("主题", selection: $selectedTheme) {
                Text("浅色").tag("light")
                Text("深色").tag("dark")
                Text("蓝色").tag("blue")
            }
            .pickerStyle(.segmented)
            .onChange(of: selectedTheme) { _, newValue in
                defaultsManager.theme = newValue
            }
            
            Toggle("启用通知", isOn: $notificationsEnabled)
                .onChange(of: notificationsEnabled) { _, newValue in
                    defaultsManager.notificationsEnabled = newValue
                }
            
            VStack(alignment: .leading, spacing: 5) {
                Text("字体大小: \(Int(fontSize))")
                Slider(value: $fontSize, in: 12...24, step: 2)
                    .onChange(of: fontSize) { _, newValue in
                        defaultsManager.fontSize = newValue
                    }
            }
            
            Divider()
            
            VStack(alignment: .leading, spacing: 5) {
                Text("当前存储的数据:")
                    .font(.headline)
                Text("用户名: \(defaultsManager.username)")
                Text("主题: \(defaultsManager.theme)")
                Text("通知: \(defaultsManager.notificationsEnabled ? "开启" : "关闭")")
                Text("字体大小: \(Int(defaultsManager.fontSize))")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(.gray.opacity(0.1))
            .cornerRadius(8)
            
            Button("重置所有数据") {
                defaultsManager.reset()
                username = ""
                selectedTheme = "light"
                notificationsEnabled = false
                fontSize = 16.0
            }
            .padding()
            .background(.red)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
        .background(.white)
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}

// MARK: - 2. FileManager 文件存储

// FileManager 管理类
class FileStorageManager {
    static let shared = FileStorageManager()
    
    private let fileManager = FileManager.default
    
    // 获取文档目录路径
    private var documentsDirectory: URL {
        fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    // 保存文本到文件
    func saveText(_ text: String, filename: String) throws {
        let fileURL = documentsDirectory.appendingPathComponent(filename)
        try text.write(to: fileURL, atomically: true, encoding: .utf8)
    }
    
    // 从文件读取文本
    func loadText(filename: String) throws -> String {
        let fileURL = documentsDirectory.appendingPathComponent(filename)
        return try String(contentsOf: fileURL, encoding: .utf8)
    }
    
    // 保存数据到文件
    func saveData(_ data: Data, filename: String) throws {
        let fileURL = documentsDirectory.appendingPathComponent(filename)
        try data.write(to: fileURL, options: .atomic)
    }
    
    // 从文件读取数据
    func loadData(filename: String) throws -> Data {
        let fileURL = documentsDirectory.appendingPathComponent(filename)
        return try Data(contentsOf: fileURL)
    }
    
    // 删除文件
    func deleteFile(filename: String) throws {
        let fileURL = documentsDirectory.appendingPathComponent(filename)
        try fileManager.removeItem(at: fileURL)
    }
    
    // 检查文件是否存在
    func fileExists(filename: String) -> Bool {
        let fileURL = documentsDirectory.appendingPathComponent(filename)
        return fileManager.fileExists(atPath: fileURL.path)
    }
    
    // 获取所有文件列表
    func listFiles() throws -> [String] {
        try fileManager.contentsOfDirectory(atPath: documentsDirectory.path)
    }
}

// FileManager 视图
struct FileManagerView: View {
    @State private var textContent = "在此输入文本内容..."
    @State private var filename = "notes.txt"
    @State private var savedContent = ""
    @State private var showMessage = ""
    @State private var showAlert = false
    
    var body: some View {
        VStack(spacing: 10) {
            TextField("文件名", text: $filename)
                .textFieldStyle(.roundedBorder)
            
            TextEditor(text: $textContent)
                .frame(height: 100)
                .border(.gray, width: 1)
                .cornerRadius(8)
            
            HStack(spacing: 10) {
                Button("保存文件") {
                    saveFile()
                }
                .padding()
                .background(.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                
                Button("读取文件") {
                    loadFile()
                }
                .padding()
                .background(.green)
                .foregroundColor(.white)
                .cornerRadius(10)
                
                Button("删除文件") {
                    deleteFile()
                }
                .padding()
                .background(.red)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            
            if !savedContent.isEmpty {
                Divider()
                VStack(alignment: .leading, spacing: 5) {
                    Text("读取的内容:")
                        .font(.headline)
                    Text(savedContent)
                        .padding()
                        .background(.gray.opacity(0.1))
                        .cornerRadius(8)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            if !showMessage.isEmpty {
                Text(showMessage)
                    .foregroundColor(showMessage.contains("成功") ? .green : .red)
            }
        }
        .padding()
        .background(.white)
        .cornerRadius(10)
        .shadow(radius: 2)
    }
    
    private func saveFile() {
        do {
            try FileStorageManager.shared.saveText(textContent, filename: filename)
            showMessage = "保存成功!"
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                showMessage = ""
            }
        } catch {
            showMessage = "保存失败: \(error.localizedDescription)"
        }
    }
    
    private func loadFile() {
        do {
            savedContent = try FileStorageManager.shared.loadText(filename: filename)
            textContent = savedContent
            showMessage = "读取成功!"
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                showMessage = ""
            }
        } catch {
            showMessage = "读取失败: \(error.localizedDescription)"
            savedContent = ""
        }
    }
    
    private func deleteFile() {
        do {
            try FileStorageManager.shared.deleteFile(filename: filename)
            showMessage = "删除成功!"
            savedContent = ""
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                showMessage = ""
            }
        } catch {
            showMessage = "删除失败: \(error.localizedDescription)"
        }
    }
}

// MARK: - 3. @AppStorage 属性包装器

// @AppStorage 视图
struct AppStorageView: View {
    @AppStorage("username") private var username = ""
    @AppStorage("userTheme") private var userTheme = "light"
    @AppStorage("isDarkMode") private var isDarkMode = false
    @AppStorage("fontSize") private var fontSize = 16.0
    @AppStorage("autoSaveEnabled") private var autoSaveEnabled = true
    
    var body: some View {
        VStack(spacing: 10) {
            TextField("用户名", text: $username)
                .textFieldStyle(.roundedBorder)
            
            Picker("主题选择", selection: $userTheme) {
                Text("浅色").tag("light")
                Text("深色").tag("dark")
                Text("蓝色").tag("blue")
                Text("绿色").tag("green")
            }
            .pickerStyle(.segmented)
            
            Toggle("深色模式", isOn: $isDarkMode)
            
            VStack(alignment: .leading, spacing: 5) {
                Text("字体大小: \(Int(fontSize))")
                Slider(value: $fontSize, in: 12...24, step: 2)
            }
            
            Toggle("自动保存", isOn: $autoSaveEnabled)
            
            Divider()
            
            VStack(alignment: .leading, spacing: 5) {
                Text("@AppStorage 实时数据:")
                    .font(.headline)
                Text("用户名: \(username.isEmpty ? "未设置" : username)")
                Text("主题: \(userTheme)")
                Text("深色模式: \(isDarkMode ? "开启" : "关闭")")
                Text("字体大小: \(Int(fontSize))")
                Text("自动保存: \(autoSaveEnabled ? "开启" : "关闭")")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
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

// MARK: - 4. @SceneStorage 场景存储

// @SceneStorage 视图
struct SceneStorageView: View {
    @SceneStorage("selectedTab") private var selectedTab = 0
    @SceneStorage("draftText") private var draftText = ""
    @SceneStorage("scrollPosition") private var scrollPosition = 0.0
    @SceneStorage("isExpanded") private var isExpanded = false
    
    var body: some View {
        VStack(spacing: 10) {
            Picker("选项卡", selection: $selectedTab) {
                Text("首页").tag(0)
                Text("设置").tag(1)
                Text("帮助").tag(2)
            }
            .pickerStyle(.segmented)
            
            TextField("草稿内容", text: $draftText)
                .textFieldStyle(.roundedBorder)
            
            VStack(alignment: .leading, spacing: 5) {
                Toggle("展开详情", isOn: $isExpanded)
                
                if isExpanded {
                    Text("这是展开的详细内容，即使应用重新启动，展开状态也会保持。")
                        .padding()
                        .background(.blue.opacity(0.1))
                        .cornerRadius(8)
                }
            }
            
            Divider()
            
            VStack(alignment: .leading, spacing: 5) {
                Text("@SceneStorage 当前状态:")
                    .font(.headline)
                Text("选中选项卡: \(selectedTab)")
                Text("草稿文本: \(draftText.isEmpty ? "无" : draftText)")
                Text("展开状态: \(isExpanded ? "展开" : "收起")")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(.gray.opacity(0.1))
            .cornerRadius(8)
            
            Text("注意: @SceneStorage 用于保存场景特定的临时状态，会在场景恢复时重新加载。")
                .font(.caption)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
        .padding()
        .background(.white)
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}

// MARK: - 5. Keychain 安全存储

// Keychain 管理类
class KeychainManager {
    static let shared = KeychainManager()
    
    private enum Keys {
        static let password = "userPassword"
        static let apiKey = "apiKey"
        static let token = "authToken"
    }
    
    // 保存密码到 Keychain
    func savePassword(_ password: String, account: String = "default") -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account,
            kSecAttrService as String: Keys.password,
            kSecValueData as String: password.data(using: .utf8)!,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlockedThisDeviceOnly
        ]
        
        SecItemDelete(query as CFDictionary)
        
        let status = SecItemAdd(query as CFDictionary, nil)
        return status == errSecSuccess
    }
    
    // 从 Keychain 读取密码
    func getPassword(account: String = "default") -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account,
            kSecAttrService as String: Keys.password,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var data: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &data)
        
        guard status == errSecSuccess, let passwordData = data as? Data else {
            return nil
        }
        
        return String(data: passwordData, encoding: .utf8)
    }
    
    // 保存 API Key
    func saveAPIKey(_ apiKey: String) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "apiKeyAccount",
            kSecAttrService as String: Keys.apiKey,
            kSecValueData as String: apiKey.data(using: .utf8)!,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlockedThisDeviceOnly
        ]
        
        SecItemDelete(query as CFDictionary)
        
        let status = SecItemAdd(query as CFDictionary, nil)
        return status == errSecSuccess
    }
    
    // 获取 API Key
    func getAPIKey() -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "apiKeyAccount",
            kSecAttrService as String: Keys.apiKey,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var data: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &data)
        
        guard status == errSecSuccess, let apiKeyData = data as? Data else {
            return nil
        }
        
        return String(data: apiKeyData, encoding: .utf8)
    }
    
    // 删除 Keychain 项目
    func deleteItem(account: String, service: String) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account,
            kSecAttrService as String: service
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess
    }
}

// Keychain 视图
struct KeychainView: View {
    @State private var password = ""
    @State private var apiKey = ""
    @State private var savedPassword = ""
    @State private var savedAPIKey = ""
    @State private var message = ""
    
    var body: some View {
        VStack(spacing: 10) {
            SecureField("密码", text: $password)
                .textFieldStyle(.roundedBorder)
            
            HStack(spacing: 10) {
                Button("保存密码") {
                    savePassword()
                }
                .padding()
                .background(.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                
                Button("读取密码") {
                    loadPassword()
                }
                .padding()
                .background(.green)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            
            Divider()
            
            TextField("API Key", text: $apiKey)
                .textFieldStyle(.roundedBorder)
            
            HStack(spacing: 10) {
                Button("保存 API Key") {
                    saveAPIKey()
                }
                .padding()
                .background(.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                
                Button("读取 API Key") {
                    loadAPIKey()
                }
                .padding()
                .background(.green)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            
            Divider()
            
            VStack(alignment: .leading, spacing: 5) {
                Text("Keychain 存储的数据:")
                    .font(.headline)
                Text("密码: \(savedPassword.isEmpty ? "未保存" : "已保存 (\(savedPassword.count) 字符)")")
                Text("API Key: \(savedAPIKey.isEmpty ? "未保存" : "已保存 (\(savedAPIKey.count) 字符)")")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(.gray.opacity(0.1))
            .cornerRadius(8)
            
            if !message.isEmpty {
                Text(message)
                    .foregroundColor(message.contains("成功") ? .green : .red)
            }
            
            Text("Keychain 提供安全的加密存储，适合保存密码、密钥等敏感信息。")
                .font(.caption)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
        .padding()
        .background(.white)
        .cornerRadius(10)
        .shadow(radius: 2)
    }
    
    private func savePassword() {
        if KeychainManager.shared.savePassword(password) {
            message = "密码保存成功!"
            savedPassword = password
        } else {
            message = "密码保存失败!"
        }
        clearMessage()
    }
    
    private func loadPassword() {
        if let password = KeychainManager.shared.getPassword() {
            savedPassword = password
            self.password = password
            message = "密码读取成功!"
        } else {
            message = "未找到保存的密码!"
        }
        clearMessage()
    }
    
    private func saveAPIKey() {
        if KeychainManager.shared.saveAPIKey(apiKey) {
            message = "API Key 保存成功!"
            savedAPIKey = apiKey
        } else {
            message = "API Key 保存失败!"
        }
        clearMessage()
    }
    
    private func loadAPIKey() {
        if let apiKey = KeychainManager.shared.getAPIKey() {
            savedAPIKey = apiKey
            self.apiKey = apiKey
            message = "API Key 读取成功!"
        } else {
            message = "未找到保存的 API Key!"
        }
        clearMessage()
    }
    
    private func clearMessage() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            message = ""
        }
    }
}

// MARK: - 6. Codable 数据编码/解码

// 数据模型
struct UserProfile: Codable, Identifiable {
    let id: UUID
    var name: String
    var email: String
    var age: Int
    var address: Address
    var preferences: Preferences
    
    init(id: UUID = UUID(), name: String, email: String, age: Int, address: Address, preferences: Preferences) {
        self.id = id
        self.name = name
        self.email = email
        self.age = age
        self.address = address
        self.preferences = preferences
    }
}

struct Address: Codable {
    var street: String
    var city: String
    var zipCode: String
    var country: String
}

struct Preferences: Codable {
    var theme: String
    var notificationsEnabled: Bool
    var language: String
}

// Codable 管理器
class CodableStorageManager {
    static let shared = CodableStorageManager()
    
    private let fileManager = FileStorageManager.shared
    private let profileFilename = "userProfile.json"
    
    // 保存用户配置
    func saveProfile(_ profile: UserProfile) throws {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        encoder.dateEncodingStrategy = .iso8601
        
        let data = try encoder.encode(profile)
        try fileManager.saveData(data, filename: profileFilename)
    }
    
    // 加载用户配置
    func loadProfile() throws -> UserProfile? {
        guard fileManager.fileExists(filename: profileFilename) else {
            return nil
        }
        
        let data = try fileManager.loadData(filename: profileFilename)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        return try decoder.decode(UserProfile.self, from: data)
    }
    
    // 将对象转换为 JSON 字符串
    func toJSONString<T: Codable>(_ object: T) -> String? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        guard let data = try? encoder.encode(object) else {
            return nil
        }
        
        return String(data: data, encoding: .utf8)
    }
}

// Codable 视图
struct CodableView: View {
    @State private var userProfile = UserProfile(
        name: "张三",
        email: "zhangsan@example.com",
        age: 25,
        address: Address(street: "科技路1号", city: "北京", zipCode: "100000", country: "中国"),
        preferences: Preferences(theme: "light", notificationsEnabled: true, language: "zh")
    )
    @State private var jsonPreview = ""
    @State private var message = ""
    
    var body: some View {
        VStack(spacing: 10) {
            GroupBox("基本信息") {
                VStack(spacing: 8) {
                    TextField("姓名", text: $userProfile.name)
                        .textFieldStyle(.roundedBorder)
                    TextField("邮箱", text: $userProfile.email)
                        .textFieldStyle(.roundedBorder)
                    Stepper("年龄: \(userProfile.age)", value: $userProfile.age, in: 1...100)
                }
            }
            
            GroupBox("地址") {
                VStack(spacing: 8) {
                    TextField("街道", text: $userProfile.address.street)
                        .textFieldStyle(.roundedBorder)
                    TextField("城市", text: $userProfile.address.city)
                        .textFieldStyle(.roundedBorder)
                    TextField("邮编", text: $userProfile.address.zipCode)
                        .textFieldStyle(.roundedBorder)
                    TextField("国家", text: $userProfile.address.country)
                        .textFieldStyle(.roundedBorder)
                }
            }
            
            GroupBox("偏好设置") {
                VStack(spacing: 8) {
                    Picker("主题", selection: $userProfile.preferences.theme) {
                        Text("浅色").tag("light")
                        Text("深色").tag("dark")
                    }
                    .pickerStyle(.segmented)
                    Toggle("通知", isOn: $userProfile.preferences.notificationsEnabled)
                    Picker("语言", selection: $userProfile.preferences.language) {
                        Text("中文").tag("zh")
                        Text("英文").tag("en")
                    }
                    .pickerStyle(.segmented)
                }
            }
            
            HStack(spacing: 10) {
                Button("预览 JSON") {
                    previewJSON()
                }
                .padding()
                .background(.purple)
                .foregroundColor(.white)
                .cornerRadius(10)
                
                Button("保存配置") {
                    saveProfile()
                }
                .padding()
                .background(.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                
                Button("加载配置") {
                    loadProfile()
                }
                .padding()
                .background(.green)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            
            if !jsonPreview.isEmpty {
                GroupBox("JSON 预览") {
                    ScrollView {
                        Text(jsonPreview)
                            .font(.system(.caption, design: .monospaced))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .frame(height: 150)
                }
            }
            
            if !message.isEmpty {
                Text(message)
                    .foregroundColor(message.contains("成功") ? .green : .red)
            }
        }
        .padding()
        .background(.white)
        .cornerRadius(10)
        .shadow(radius: 2)
    }
    
    private func previewJSON() {
        if let json = CodableStorageManager.shared.toJSONString(userProfile) {
            jsonPreview = json
        } else {
            message = "JSON 生成失败!"
        }
    }
    
    private func saveProfile() {
        do {
            try CodableStorageManager.shared.saveProfile(userProfile)
            message = "配置保存成功!"
        } catch {
            message = "保存失败: \(error.localizedDescription)"
        }
        clearMessage()
    }
    
    private func loadProfile() {
        do {
            if let profile = try CodableStorageManager.shared.loadProfile() {
                userProfile = profile
                message = "配置加载成功!"
                jsonPreview = CodableStorageManager.shared.toJSONString(profile) ?? ""
            } else {
                message = "没有找到保存的配置!"
            }
        } catch {
            message = "加载失败: \(error.localizedDescription)"
        }
        clearMessage()
    }
    
    private func clearMessage() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            message = ""
        }
    }
}

#Preview {
    S3_AdvancedDataPersistenceDemo()
}
