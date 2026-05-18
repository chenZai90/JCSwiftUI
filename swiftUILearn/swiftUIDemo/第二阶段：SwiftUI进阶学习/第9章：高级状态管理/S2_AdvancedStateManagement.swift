//
//  S2_AdvancedStateManagement.swift
//  swiftUIDemo
//
//  高级状态管理示例
//

import SwiftUI
import Combine

enum Stage2AdvancedStateManagement {
    struct AdvancedStateManagementDemo: View {
        @StateObject private var viewModel = AdvancedStateViewModel()

        var body: some View {
            ScrollView {
                VStack(spacing: 20) {
                    Text("高级状态管理")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)

                    VStack {
                        Text("1. 视图模型状态管理")
                            .font(.headline)
                            .fontWeight(.semibold)

                        VStack(spacing: 10) {
                            Text("计数器: \(viewModel.counter)")
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

                            Text("状态变化次数: \(viewModel.changeCount)")
                                .font(.body)
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .background(.gray.opacity(0.1))
                        .cornerRadius(10)
                    }
                    .padding()
                    .background(.gray.opacity(0.1))
                    .cornerRadius(10)

                    VStack {
                        Text("2. 环境对象")
                            .font(.headline)
                            .fontWeight(.semibold)

                        EnvironmentObjectExample()
                    }
                    .padding()
                    .background(.blue.opacity(0.1))
                    .cornerRadius(10)

                    VStack {
                        Text("3. 组合状态")
                            .font(.headline)
                            .fontWeight(.semibold)

                        VStack(spacing: 10) {
                            Text("用户名: \(viewModel.username)")
                            Text("邮箱: \(viewModel.email)")
                            Text("是否有效: \(viewModel.isValid ? "有效" : "无效")")
                                .foregroundColor(viewModel.isValid ? .green : .red)

                            TextField("输入用户名", text: $viewModel.username)
                                .padding()
                                .border(.gray, width: 1)
                                .cornerRadius(5)

                            TextField("输入邮箱", text: $viewModel.email)
                                .padding()
                                .border(.gray, width: 1)
                                .cornerRadius(5)
                        }
                        .padding()
                        .background(.white)
                        .cornerRadius(10)
                        .shadow(radius: 2)
                    }
                    .padding()
                    .background(.green.opacity(0.1))
                    .cornerRadius(10)

                    VStack {
                        Text("4. 状态绑定")
                            .font(.headline)
                            .fontWeight(.semibold)

                        StateBindingExample()
                    }
                    .padding()
                    .background(.yellow.opacity(0.1))
                    .cornerRadius(10)

                    VStack {
                        Text("5. 异步状态")
                            .font(.headline)
                            .fontWeight(.semibold)

                        VStack(spacing: 10) {
                            if viewModel.isLoading {
                                ProgressView("加载中...")
                            } else if let data = viewModel.asyncData {
                                Text("加载的数据: \(data)")
                                    .font(.body)
                            } else {
                                Text("点击按钮加载数据")
                                    .font(.body)
                                    .foregroundColor(.gray)
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
                        .background(.purple.opacity(0.1))
                        .cornerRadius(10)
                    }
                    .padding()
                    .background(.purple.opacity(0.1))
                    .cornerRadius(10)
                }
                .padding()
            }
            .environmentObject(viewModel)
        }
    }

    struct EnvironmentObjectExample: View {
        @EnvironmentObject private var viewModel: AdvancedStateViewModel

        var body: some View {
            VStack(spacing: 10) {
                Text("环境对象示例")
                    .font(.headline)
                Text("共享计数器: \(viewModel.counter)")
                    .font(.body)
                Button("通过环境对象加1") {
                    viewModel.increment()
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

    struct StateBindingExample: View {
        @State private var value = 0

        var body: some View {
            VStack(spacing: 10) {
                Text("状态绑定示例")
                    .font(.headline)
                Text("当前值: \(value)")
                    .font(.body)
                BindingChildView(value: $value)
            }
            .padding()
            .background(.white)
            .cornerRadius(10)
            .shadow(radius: 2)
        }
    }

    struct BindingChildView: View {
        @Binding var value: Int

        var body: some View {
            Button("子视图增加") {
                value += 1
            }
            .padding()
            .background(.green)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
    }

    class AdvancedStateViewModel: ObservableObject {
        @Published var counter = 0
        @Published var changeCount = 0
        @Published var username = ""
        @Published var email = ""
        @Published var isLoading = false
        @Published var asyncData: String? = nil

        var isValid: Bool {
            return !username.isEmpty && email.contains("@")
        }

        func increment() {
            counter += 1
            changeCount += 1
        }

        func decrement() {
            counter -= 1
            changeCount += 1
        }

        func loadData() {
            isLoading = true

            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.asyncData = "这是从服务器获取的数据"
                self.isLoading = false
            }
        }
    }
}

#Preview {
    Stage2AdvancedStateManagement.AdvancedStateManagementDemo()
}
