//
//  DataBinding.swift
//  swiftUIDemo
//
//  数据绑定示例
//

import SwiftUI

//  数据绑定示例
struct DataBindingDemo: View {
    //  使用@StateObject创建视图模型
    @StateObject private var viewModel = DBUserProfileViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                //  标题
                Text("数据绑定")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                
                //  用户信息表单
                VStack(spacing: 15) {
                    Text("用户信息表单")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    TextField("姓名", text: $viewModel.user.name)
                        .padding()
                        .border(.gray, width: 1)
                        .cornerRadius(5)
                    
                    TextField("邮箱", text: $viewModel.user.email)
                        .padding()
                        .border(.gray, width: 1)
                        .cornerRadius(5)
                    
                    TextField("年龄", text: Binding(
                        get: { String(viewModel.user.age) },
                        set: { if let age = Int($0) { viewModel.user.age = age } }
                    ))
                    .padding()
                    .border(.gray, width: 1)
                    .cornerRadius(5)
                    .keyboardType(.numberPad)
                    
                    Toggle("是否激活", isOn: $viewModel.user.isActive)
                }
                .padding()
                .background(.gray.opacity(0.1))
                .cornerRadius(10)
                
                //  实时预览
                VStack {
                    Text("实时预览")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    DBUserProfileCard(user: viewModel.user)
                }
                .padding()
                .background(.blue.opacity(0.1))
                .cornerRadius(10)
                
                //  表单验证
                VStack {
                    Text("表单验证")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text(viewModel.validationMessage)
                        .font(.body)
                        .foregroundColor(viewModel.isFormValid ? .green : .red)
                    
                    Button("保存") {
                        viewModel.saveUser()
                    }
                    .padding()
                    .background(viewModel.isFormValid ? .green : .gray)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .disabled(!viewModel.isFormValid)
                }
                .padding()
                .background(.green.opacity(0.1))
                .cornerRadius(10)
                
                //  响应式状态
                VStack {
                    Text("响应式状态")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text("表单修改次数: \(viewModel.changeCount)")
                        .font(.body)
                }
                .padding()
                .background(.yellow.opacity(0.1))
                .cornerRadius(10)
            }
            .padding()
        }
    }
}

//  用户模型
struct DBUser {
    var name: String
    var email: String
    var age: Int
    var isActive: Bool
}

//  用户资料卡片
struct DBUserProfileCard: View {
    let user: DBUser
    
    var body: some View {
        VStack(spacing: 10) {
            Text("用户资料")
                .font(.headline)
                .fontWeight(.bold)
            
            Text("姓名: \(user.name)")
            Text("邮箱: \(user.email)")
            Text("年龄: \(user.age)")
            Text("状态: \(user.isActive ? "激活" : "未激活")")
                .foregroundColor(user.isActive ? .green : .red)
        }
        .padding()
        .background(.white)
        .cornerRadius(10)
        .shadow(radius: 3)
    }
}

//  用户资料视图模型
class DBUserProfileViewModel: ObservableObject {
    //  发布的属性
    @Published var user: DBUser
    @Published var changeCount = 0
    
    //  计算属性
    var isFormValid: Bool {
        return !user.name.isEmpty && 
               user.email.contains("@") && 
               user.age > 0
    }
    
    var validationMessage: String {
        if user.name.isEmpty {
            return "请输入姓名"
        } else if !user.email.contains("@") {
            return "请输入有效的邮箱"
        } else if user.age <= 0 {
            return "请输入有效的年龄"
        } else {
            return "表单验证通过"
        }
    }
    
    //  方法
    func saveUser() {
        print("保存用户: \(user)")
    }
    
    //  初始化
    init() {
        user = DBUser(
            name: "张三",
            email: "zhangsan@example.com",
            age: 30,
            isActive: true
        )
        
        //  监听用户属性变化
        $user
            .sink {
                _ in
                self.changeCount += 1
            }
            .store(in: &cancellables)
    }
    
    //  订阅存储
    private var cancellables = Set<AnyCancellable>()
}

//  导入Combine以使用AnyCancellable
import Combine

#Preview {
    DataBindingDemo()
}