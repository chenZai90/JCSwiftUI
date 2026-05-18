//
//  S2_ModernStateManagement.swift
//  swiftUIDemo
//
//  现代状态管理 (iOS 17+) 示例
//

import SwiftUI

enum Stage2ModernStateManagement {
    struct ModernStateManagementDemo: View {
        @State private var counter = 0
        @State private var username = ""
        @State private var isDarkMode = false

        @StateObject private var settings = AppSettings()

        var body: some View {
            ScrollView {
                VStack(spacing: 20) {
                    Text("现代状态管理 (iOS 17+)")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)

                    VStack {
                        Text("1. @State和@Binding增强")
                            .font(.headline)
                            .fontWeight(.semibold)

                        VStack(spacing: 10) {
                            Text("计数器: \(counter)")
                                .font(.title)
                                .fontWeight(.bold)

                            HStack(spacing: 10) {
                                Button("减1") {
                                    counter -= 1
                                }
                                .padding()
                                .background(.red)
                                .foregroundColor(.white)
                                .cornerRadius(10)

                                Button("加1") {
                                    counter += 1
                                }
                                .padding()
                                .background(.green)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                            }

                            TextField("输入用户名", text: $username)
                                .padding()
                                .border(.gray, width: 1)
                                .cornerRadius(5)

                            Text("你好, \(username.isEmpty ? "陌生人" : username)!")
                                .font(.body)
                        }
                        .padding()
                        .background(.gray.opacity(0.1))
                        .cornerRadius(10)
                    }
                    .padding()
                    .background(.gray.opacity(0.1))
                    .cornerRadius(10)

                    VStack {
                        Text("2. @ObservedObject (iOS 13+)")
                            .font(.headline)
                            .fontWeight(.semibold)

                        VStack(spacing: 10) {
                            Toggle("深色模式", isOn: $settings.isDarkMode)
                            Toggle("通知", isOn: $settings.notificationsEnabled)
                            Toggle("自动更新", isOn: $settings.autoUpdate)

                            Text("设置状态:")
                                .font(.headline)
                            Text("深色模式: \(settings.isDarkMode ? "开启" : "关闭")")
                            Text("通知: \(settings.notificationsEnabled ? "开启" : "关闭")")
                            Text("自动更新: \(settings.autoUpdate ? "开启" : "关闭")")
                        }
                        .padding()
                        .background(.white)
                        .cornerRadius(10)
                        .shadow(radius: 2)
                    }
                    .padding()
                    .background(.blue.opacity(0.1))
                    .cornerRadius(10)

                    VStack {
                        Text("3. Observable宏")
                            .font(.headline)
                            .fontWeight(.semibold)

                        ObservableExample()
                    }
                    .padding()
                    .background(.green.opacity(0.1))
                    .cornerRadius(10)

                    VStack {
                        Text("4. 状态转移")
                            .font(.headline)
                            .fontWeight(.semibold)

                        StateTransferExample()
                    }
                    .padding()
                    .background(.yellow.opacity(0.1))
                    .cornerRadius(10)

                    VStack(alignment: .leading, spacing: 10) {
                        Text("5. 现代状态管理最佳实践")
                            .font(.headline)
                            .fontWeight(.semibold)

                        Text("• 使用@State管理简单的视图状态")
                        Text("• 使用@StateObject和@Observable管理复杂状态")
                        Text("• 使用@Bindable创建双向绑定")
                        Text("• 合理使用环境对象进行状态共享")
                        Text("• 避免过度使用全局状态")
                        Text("• 保持状态逻辑清晰和可测试")
                    }
                    .padding()
                    .background(.purple.opacity(0.1))
                    .cornerRadius(10)
                }
                .padding()
            }
        }
    }

    class AppSettings: ObservableObject {
        @Published var isDarkMode = false
        @Published var notificationsEnabled = true
        @Published var autoUpdate = true
    }

    @Observable
    class UserViewModel {
        var name = ""
        var email = ""
        var age = 18

        var isValid: Bool {
            return !name.isEmpty && email.contains("@")
        }
    }

    struct ObservableExample: View {
        @State private var viewModel = UserViewModel()

        var body: some View {
            VStack(spacing: 10) {
                TextField("姓名", text: $viewModel.name)
                    .padding()
                    .border(.gray, width: 1)
                    .cornerRadius(5)

                TextField("邮箱", text: $viewModel.email)
                    .padding()
                    .border(.gray, width: 1)
                    .cornerRadius(5)

                Stepper("年龄: \(viewModel.age)", value: $viewModel.age, in: 0...100)

                Text("是否有效: \(viewModel.isValid ? "有效" : "无效")")
                    .foregroundColor(viewModel.isValid ? .green : .red)
            }
            .padding()
            .background(.white)
            .cornerRadius(10)
            .shadow(radius: 2)
        }
    }

    struct StateTransferExample: View {
        @State private var showDetail = false
        @State private var selectedItem = ""

        var body: some View {
            VStack(spacing: 10) {
                Button("显示详情") {
                    selectedItem = "示例项目"
                    showDetail = true
                }
                .padding()
                .background(.blue)
                .foregroundColor(.white)
                .cornerRadius(10)

                if showDetail {
                    DetailView(item: $selectedItem, isVisible: $showDetail)
                        .padding()
                        .background(.white)
                        .cornerRadius(10)
                        .shadow(radius: 2)
                }
            }
        }
    }

    struct DetailView: View {
        @Binding var item: String
        @Binding var isVisible: Bool

        var body: some View {
            VStack(spacing: 10) {
                Text("详情视图")
                    .font(.headline)
                TextField("项目名称", text: $item)
                    .padding()
                    .border(.gray, width: 1)
                    .cornerRadius(5)
                Button("关闭") {
                    isVisible = false
                }
                .padding()
                .background(.red)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
        }
    }
}

#Preview {
    Stage2ModernStateManagement.ModernStateManagementDemo()
}
