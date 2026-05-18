//
//  CombineWithSwiftUI.swift
//  swiftUIDemo
//
//  Combine与SwiftUI集成示例
//

import SwiftUI
import Combine

// MARK: - Combine与SwiftUI集成示例
struct CombineWithSwiftUIDemo: View {
    // 状态管理
    @StateObject private var viewModel = CB_UserViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // 标题
                Text("Combine与SwiftUI集成")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                
                // 数据绑定
                VStack {
                    Text("1. 数据绑定")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    TextField("输入用户名", text: $viewModel.username)
                        .padding()
                        .border(.gray, width: 1)
                        .cornerRadius(5)
                    
                    Text("你输入的用户名: \(viewModel.username)")
                        .font(.body)
                        .foregroundColor(.gray)
                }
                .padding()
                .background(.gray.opacity(0.1))
                .cornerRadius(10)
                
                // 异步数据加载
                VStack {
                    Text("2. 异步数据加载")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    if viewModel.isLoading {
                        ProgressView("加载中...")
                    } else if let error = viewModel.error {
                        Text("错误: \(error)")
                            .foregroundColor(.red)
                    } else if let user = viewModel.user {
                        CB_UserCard(user: user)
                    }
                    
                    Button("加载用户数据") {
                        viewModel.loadUser()
                    }
                    .padding()
                    .background(.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding()
                .background(.blue.opacity(0.1))
                .cornerRadius(10)
                
                // 表单验证
                VStack {
                    Text("3. 表单验证")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    TextField("输入邮箱", text: $viewModel.email)
                        .padding()
                        .border(viewModel.isEmailValid ? .green : .red, width: 1)
                        .cornerRadius(5)
                    
                    Text(viewModel.emailValidationMessage)
                        .font(.body)
                        .foregroundColor(viewModel.isEmailValid ? .green : .red)
                }
                .padding()
                .background(.green.opacity(0.1))
                .cornerRadius(10)
                
                // 响应式状态
                VStack {
                    Text("4. 响应式状态")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text("计数器: \(viewModel.count)")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    HStack(spacing: 10) {
                        Button("减1") {
                            viewModel.decrement()
                        }
                        .padding()
                        .background(.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        
                        Button("加1") {
                            viewModel.increment()
                        }
                        .padding()
                        .background(.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                }
                .padding()
                .background(.yellow.opacity(0.1))
                .cornerRadius(10)
            }
            .padding()
        }
    }
}

// MARK: - 用户模型
struct CB_User: Identifiable {
    let id: Int
    let name: String
    let email: String
    let avatar: String
}

// MARK: - 用户卡片视图
struct CB_UserCard: View {
    let user: CB_User
    
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: user.avatar)
                .font(.system(size: 60))
                .foregroundColor(.blue)
            Text(user.name)
                .font(.headline)
                .fontWeight(.bold)
            Text(user.email)
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding()
        .background(.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

// MARK: - 用户视图模型
class CB_UserViewModel: ObservableObject {
    // 发布的属性
    @Published var username = ""
    @Published var email = ""
    @Published var count = 0
    @Published var user: CB_User? = nil
    @Published var isLoading = false
    @Published var error: String? = nil
    
    // 计算属性
    var isEmailValid: Bool {
        return email.contains("@") && email.contains(".")
    }
    
    var emailValidationMessage: String {
        if email.isEmpty {
            return "请输入邮箱"
        } else if isEmailValid {
            return "邮箱格式正确"
        } else {
            return "邮箱格式错误"
        }
    }
    
    // 方法
    func increment() {
        count += 1
    }
    
    func decrement() {
        count -= 1
    }
    
    func loadUser() {
        isLoading = true
        error = nil
        
        // 模拟网络请求
        let future = Future<CB_User, Error> { promise in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                let mockUser = CB_User(
                    id: 1,
                    name: "张三",
                    email: "zhangsan@example.com",
                    avatar: "person.fill"
                )
                promise(.success(mockUser))
            }
        }
        
        future
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                self.isLoading = false
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.error = error.localizedDescription
                }
            }, receiveValue: { user in
                self.user = user
            })
            .store(in: &cancellables)
    }
    
    // 订阅存储
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        // 监听用户名变化
        $username
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .sink { value in
                print("用户名变化: \(value)")
            }
            .store(in: &cancellables)
        
        // 监听邮箱变化
        $email
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .sink { value in
                print("邮箱变化: \(value)")
            }
            .store(in: &cancellables)
    }
}

#Preview {
    CombineWithSwiftUIDemo()
}
