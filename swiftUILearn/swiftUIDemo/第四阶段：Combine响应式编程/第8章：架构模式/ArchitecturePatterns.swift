//
//  ArchitecturePatterns.swift
//  swiftUIDemo
//
//  Created by AI Assistant
//  Combine架构模式示例
//

import SwiftUI
import Combine

// MARK: - 1. MVVM 示例

class LoginViewModel: ObservableObject {
    // 输入
    @Published var email = ""
    @Published var password = ""
    
    // 输出
    @Published var isLoginEnabled = false
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isLoggedIn = false
    
    private let authService: ArchAuthServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(authService: ArchAuthServiceProtocol = ArchMockAuthService()) {
        self.authService = authService
        setupBindings()
    }
    
    private func setupBindings() {
        // 表单验证
        Publishers.CombineLatest($email, $password)
            .map { email, password in
                !email.isEmpty &&
                email.contains("@") &&
                password.count >= 6
            }
            .assign(to: \.isLoginEnabled, on: self)
            .store(in: &cancellables)
    }
    
    func login() {
        isLoading = true
        errorMessage = nil
        
        authService.login(email: email, password: password)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case .failure(let error) = completion {
                        self?.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] _ in
                    self?.isLoggedIn = true
                }
            )
            .store(in: &cancellables)
    }
}

// MARK: - Mock 服务

protocol ArchAuthServiceProtocol {
    func login(email: String, password: String) -> AnyPublisher<ArchUser, Error>
}

struct ArchMockAuthService: ArchAuthServiceProtocol {
    func login(email: String, password: String) -> AnyPublisher<ArchUser, Error> {
        // 模拟网络延迟
        return Just(ArchUser(id: "1", name: "Test User", email: email))
            .delay(for: .seconds(1.5), scheduler: DispatchQueue.main)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}

struct ArchUser {
    let id: String
    let name: String
    let email: String
}

// MARK: - View

struct LoginViewDemo: View {
    @StateObject private var viewModel = LoginViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("MVVM 登录示例")
                    .font(.largeTitle)
                    .foregroundColor(.blue)
                    .fontWeight(.bold)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("邮箱:")
                        .font(.headline)
                    TextField("请输入邮箱", text: $viewModel.email)
                        .textFieldStyle(.roundedBorder)
                        .textInputAutocapitalization(.never)
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("密码 (至少6位):")
                        .font(.headline)
                    SecureField("请输入密码", text: $viewModel.password)
                        .textFieldStyle(.roundedBorder)
                }
                
                HStack {
                    Spacer()
                    Text(viewModel.isLoginEnabled ? "✅ 可以登录" : "❌ 请完善信息")
                        .foregroundColor(viewModel.isLoginEnabled ? .green : .red)
                    Spacer()
                }
                
                if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                }
                
                Button(action: viewModel.login) {
                    HStack {
                        if viewModel.isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        } else {
                            Text("登录")
                                .fontWeight(.semibold)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                .disabled(!viewModel.isLoginEnabled)
                .padding()
                .background(viewModel.isLoginEnabled ? Color.blue : Color.gray)
                .foregroundColor(.white)
                .cornerRadius(10)
                
                if viewModel.isLoggedIn {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                        Text("🎉 登录成功!")
                    }
                    .foregroundColor(.green)
                    .font(.headline)
                }
            }
            .padding()
        }
    }
}

// MARK: - 2. 状态机示例

enum ArchAppState: Equatable {
    case idle
    case loading
    case loaded([ArchItem])
    case error(String)
    
    static func == (lhs: ArchAppState, rhs: ArchAppState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle), (.loading, .loading):
            return true
        case (.loaded(let lhsItems), .loaded(let rhsItems)):
            return lhsItems == rhsItems
        case (.error(let lhsErr), .error(let rhsErr)):
            return lhsErr == rhsErr
        default:
            return false
        }
    }
}

enum ArchAppAction {
    case load
    case receiveItems([ArchItem])
    case receiveError(String)
    case reset
}

struct ArchItem: Identifiable, Equatable {
    let id = UUID()
    let name: String
}

class StateMachineViewModel: ObservableObject {
    @Published var state: ArchAppState = .idle
    private var cancellables = Set<AnyCancellable>()
    
    func send(_ action: ArchAppAction) {
        switch action {
        case .load:
            state = .loading
            // 模拟加载
            Just([ArchItem(name: "Item 1"), ArchItem(name: "Item 2"), ArchItem(name: "Item 3")])
                .delay(for: .seconds(1.5), scheduler: DispatchQueue.main)
                .sink { [weak self] items in
                    self?.send(.receiveItems(items))
                }
                .store(in: &cancellables)
            
        case .receiveItems(let items):
            state = .loaded(items)
            
        case .receiveError(let message):
            state = .error(message)
            
        case .reset:
            state = .idle
        }
    }
}

struct StateMachineDemo: View {
    @StateObject private var viewModel = StateMachineViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            Text("状态机示例")
                .font(.largeTitle)
                .foregroundColor(.blue)
                .fontWeight(.bold)
            
            // 当前状态显示
            VStack(spacing: 10) {
                Text("当前状态:")
                    .font(.headline)
                
                switch viewModel.state {
                case .idle:
                    Text("🆔 空闲")
                        .foregroundColor(.gray)
                case .loading:
                    HStack {
                        ProgressView()
                        Text("⏳ 加载中...")
                            .foregroundColor(.orange)
                    }
                case .loaded(let items):
                    VStack(spacing: 8) {
                        Text("✅ 加载成功")
                            .foregroundColor(.green)
                        List(items) { item in
                            Text(item.name)
                        }
                        .frame(height: 150)
                        .listStyle(.plain)
                    }
                case .error(let message):
                    Text("❌ 错误: \(message)")
                        .foregroundColor(.red)
                }
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
            
            // 操作按钮
            HStack(spacing: 20) {
                Button("加载数据") {
                    viewModel.send(.load)
                }
                .padding()
                .background(.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .disabled(viewModel.state == .loading)
                
                Button("重置") {
                    viewModel.send(.reset)
                }
                .padding()
                .background(.gray)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
        }
        .padding()
    }
}

// MARK: - 主视图

struct ArchitecturePatternsDemo: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            LoginViewDemo()
                .tabItem {
                    Label("MVVM", systemImage: "person.and.background.dotted")
                }
                .tag(0)
            
            StateMachineDemo()
                .tabItem {
                    Label("状态机", systemImage: "arrow.2.circlepath")
                }
                .tag(1)
        }
    }
}

#Preview {
    ArchitecturePatternsDemo()
}
