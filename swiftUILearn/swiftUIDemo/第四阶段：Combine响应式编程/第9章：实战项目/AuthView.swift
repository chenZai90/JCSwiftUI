//
//  NewsProAuthView.swift
//  swiftUIDemo
//
//  Created by AI Assistant
//  NewsPro - 认证视图
//

import SwiftUI
import Combine

// MARK: - 认证视图
struct NewsProAuthView: View {
    @StateObject private var viewModel = NewsProAuthViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                // 背景渐变
                LinearGradient(
                    colors: [.blue.opacity(0.3), .purple.opacity(0.3)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Logo区域
                    NewsProAuthHeaderView()
                    
                    // 表单区域
                    NewsProAuthFormView(viewModel: viewModel)
                    
                    Spacer()
                }
            }
            .alert("错误", isPresented: $viewModel.showError) {
                Button("确定") {}
            } message: {
                Text(viewModel.errorMessage)
            }
        }
    }
}

// MARK: - 头部视图
struct NewsProAuthHeaderView: View {
    var body: some View {
        VStack(spacing: 16) {
            // App图标
            ZStack {
                Circle()
                    .fill(.blue)
                    .frame(width: 100, height: 100)
                
                Image(systemName: "newspaper.fill")
                    .font(.system(size: 50))
                    .foregroundColor(.white)
            }
            
            Text("NewsPro")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("专业新闻阅读平台")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(.top, 60)
        .padding(.bottom, 40)
    }
}

// MARK: - 认证表单视图
struct NewsProAuthFormView: View {
    @ObservedObject var viewModel: NewsProAuthViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            // 登录/注册切换
            Picker("认证方式", selection: $viewModel.authMode) {
                Text("登录").tag(NewsProAuthMode.login)
                Text("注册").tag(NewsProAuthMode.register)
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            
            // 表单字段
            VStack(spacing: 16) {
                // 邮箱
                NewsProAuthTextField(
                    icon: "envelope.fill",
                    placeholder: "邮箱地址",
                    text: $viewModel.email,
                    keyboardType: .emailAddress
                )
                
                // 密码
                NewsProAuthSecureField(
                    icon: "lock.fill",
                    placeholder: "密码",
                    text: $viewModel.password
                )
                
                // 注册时显示确认密码
                if viewModel.authMode == .register {
                    NewsProAuthSecureField(
                        icon: "lock.shield.fill",
                        placeholder: "确认密码",
                        text: $viewModel.confirmPassword
                    )
                    
                    // 用户名
                    NewsProAuthTextField(
                        icon: "person.fill",
                        placeholder: "用户名",
                        text: $viewModel.username
                    )
                }
            }
            .padding(.horizontal)
            
            // 忘记密码链接
            if viewModel.authMode == .login {
                HStack {
                    Spacer()
                    Button("忘记密码？") {
                        viewModel.showForgotPassword = true
                    }
                    .font(.footnote)
                    .foregroundColor(.blue)
                }
                .padding(.horizontal)
            }
            
            // 提交按钮
            Button {
                viewModel.submit()
            } label: {
                HStack {
                    if viewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    } else {
                        Text(viewModel.authMode == .login ? "登录" : "注册")
                            .fontWeight(.semibold)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(viewModel.isFormValid ? Color.blue : Color.gray)
                .foregroundColor(.white)
                .cornerRadius(12)
            }
            .disabled(!viewModel.isFormValid || viewModel.isLoading)
            .padding(.horizontal)
            
            // 示例账号提示
            if viewModel.authMode == .login {
                VStack(spacing: 8) {
                    Text("示例账号")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    HStack(spacing: 20) {
                        Button {
                            viewModel.useDemoAccount()
                        } label: {
                            VStack(spacing: 4) {
                                Text("普通用户")
                                    .font(.caption)
                                    .fontWeight(.medium)
                                Text("user@example.com")
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(.blue.opacity(0.1))
                            .cornerRadius(8)
                        }
                        
                        Button {
                            viewModel.useAdminAccount()
                        } label: {
                            VStack(spacing: 4) {
                                Text("管理员")
                                    .font(.caption)
                                    .fontWeight(.medium)
                                Text("admin@example.com")
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(.purple.opacity(0.1))
                            .cornerRadius(8)
                        }
                    }
                }
                .padding(.top, 20)
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(20)
        .padding(.horizontal)
        .sheet(isPresented: $viewModel.showForgotPassword) {
            NewsProForgotPasswordView()
        }
    }
}

// MARK: - 自定义输入框
struct NewsProAuthTextField: View {
    let icon: String
    let placeholder: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 24)
            
            TextField(placeholder, text: $text)
                .keyboardType(keyboardType)
                .textInputAutocapitalization(.never)
        }
        .padding()
        .background(.gray.opacity(0.1))
        .cornerRadius(12)
    }
}

struct NewsProAuthSecureField: View {
    let icon: String
    let placeholder: String
    @Binding var text: String
    @State private var isSecure = true
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 24)
            
            if isSecure {
                SecureField(placeholder, text: $text)
            } else {
                TextField(placeholder, text: $text)
            }
            
            Button {
                isSecure.toggle()
            } label: {
                Image(systemName: isSecure ? "eye.slash.fill" : "eye.fill")
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(.gray.opacity(0.1))
        .cornerRadius(12)
    }
}

// MARK: - 忘记密码视图
struct NewsProForgotPasswordView: View {
    @Environment(\.dismiss) var dismiss
    @State private var email = ""
    @State private var isLoading = false
    @State private var showSuccess = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                Image(systemName: "envelope.badge.shield.half.filled")
                    .font(.system(size: 80))
                    .foregroundColor(.blue)
                
                VStack(spacing: 12) {
                    Text("重置密码")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("请输入您的邮箱地址，我们将发送重置密码链接给您")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                
                NewsProAuthTextField(
                    icon: "envelope.fill",
                    placeholder: "邮箱地址",
                    text: $email,
                    keyboardType: .emailAddress
                )
                .padding(.horizontal)
                
                Button {
                    resetPassword()
                } label: {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    } else {
                        Text("发送重置链接")
                            .fontWeight(.semibold)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(email.isEmpty ? Color.gray : Color.blue)
                .foregroundColor(.white)
                .cornerRadius(12)
                .disabled(email.isEmpty || isLoading)
                .padding(.horizontal)
                
                Spacer()
            }
            .padding(.top, 40)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("关闭") {
                        dismiss()
                    }
                }
            }
            .alert("成功", isPresented: $showSuccess) {
                Button("确定") {
                    dismiss()
                }
            } message: {
                Text("重置密码链接已发送到您的邮箱")
            }
        }
    }
    
    private func resetPassword() {
        isLoading = true
        // 模拟网络请求
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            isLoading = false
            showSuccess = true
        }
    }
}

// MARK: - ViewModel
class NewsProAuthViewModel: ObservableObject {
    @Published var authMode: NewsProAuthMode = .login
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var username = ""
    @Published var isLoading = false
    @Published var showError = false
    @Published var errorMessage = ""
    @Published var showForgotPassword = false
    
    private var cancellables = Set<AnyCancellable>()
    
    var isFormValid: Bool {
        let isEmailValid = email.contains("@") && email.contains(".")
        let isPasswordValid = password.count >= 6
        
        if authMode == .login {
            return isEmailValid && isPasswordValid
        } else {
            let isConfirmValid = confirmPassword == password && !confirmPassword.isEmpty
            let isUsernameValid = !username.isEmpty
            return isEmailValid && isPasswordValid && isConfirmValid && isUsernameValid
        }
    }
    
    func submit() {
        isLoading = true
        
        if authMode == .login {
            login()
        } else {
            register()
        }
    }
    
    private func login() {
        NewsProAuthService.shared.login(email: email, password: password)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case .failure(let error) = completion {
                        self?.errorMessage = error.localizedDescription
                        self?.showError = true
                    }
                },
                receiveValue: { _ in
                    // 登录成功，AppState会自动处理
                }
            )
            .store(in: &cancellables)
    }
    
    private func register() {
        NewsProAuthService.shared.register(email: email, password: password, name: username)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case .failure(let error) = completion {
                        self?.errorMessage = error.localizedDescription
                        self?.showError = true
                    }
                },
                receiveValue: { _ in
                    // 注册成功，自动登录
                }
            )
            .store(in: &cancellables)
    }
    
    func useDemoAccount() {
        email = "user@example.com"
        password = "password123"
    }
    
    func useAdminAccount() {
        email = "admin@example.com"
        password = "admin123"
    }
}

enum NewsProAuthMode {
    case login, register
}

#Preview {
    NewsProAuthView()
}
