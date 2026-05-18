//
//  AdvancedStateManagementTechniques.swift
//  swiftUIDemo
//
//  高级状态管理技巧示例
//

import SwiftUI

//  高级状态管理技巧示例
struct AdvancedStateManagementTechniquesDemo: View {
    //  状态管理
    @State private var count = 0
    @State private var user = AdvancedUser(name: "张三", age: 25)
    @State private var isLoggedIn = false
    @State private var selectedTab = 0
    
    //  环境对象
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                //  标题
                Text("高级状态管理技巧")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                
                //  基础状态管理
                VStack {
                    Text("1. 基础状态管理")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text("计数: \(count)")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    HStack {
                        Button("增加") {
                            count += 1
                        }
                        .padding()
                        .background(.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        
                        Button("减少") {
                            count -= 1
                        }
                        .padding()
                        .background(.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                }
                .padding()
                .background(.gray.opacity(0.1))
                .cornerRadius(10)
                
                //  结构体状态管理
                VStack {
                    Text("2. 结构体状态管理")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text("姓名: \(user.name)")
                        .font(.subheadline)
                    
                    Text("年龄: \(user.age)")
                        .font(.subheadline)
                    
                    HStack {
                        Button("修改姓名") {
                            user.name = user.name == "张三" ? "李四" : "张三"
                        }
                        .padding()
                        .background(.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        
                        Button("增加年龄") {
                            user.age += 1
                        }
                        .padding()
                        .background(.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                }
                .padding()
                .background(.blue.opacity(0.1))
                .cornerRadius(10)
                
                //  环境变量
                VStack {
                    Text("3. 环境变量")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text("当前主题: \(colorScheme == .dark ? "深色" : "浅色")")
                        .font(.subheadline)
                    
                    Rectangle()
                        .fill(colorScheme == .dark ? .white : .black)
                        .frame(width: 100, height: 100)
                        .cornerRadius(10)
                        .overlay(
                            Text("主题示例")
                                .foregroundColor(colorScheme == .dark ? .black : .white)
                        )
                }
                .padding()
                .background(.green.opacity(0.1))
                .cornerRadius(10)
                
                //  登录状态管理
                VStack {
                    Text("4. 登录状态管理")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    if isLoggedIn {
                        VStack {
                            Text("欢迎回来！")
                                .font(.title)
                                .fontWeight(.bold)
                            
                            Button("退出登录") {
                                isLoggedIn = false
                            }
                            .padding()
                            .background(.red)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                    } else {
                        VStack {
                            Text("请登录")
                                .font(.title)
                                .fontWeight(.bold)
                            
                            Button("登录") {
                                isLoggedIn = true
                            }
                            .padding()
                            .background(.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                    }
                }
                .padding()
                .background(.yellow.opacity(0.1))
                .cornerRadius(10)
                
                //  标签页状态管理
                VStack {
                    Text("5. 标签页状态管理")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    HStack {
                        Button("标签1") {
                            selectedTab = 0
                        }
                        .padding()
                        .background(selectedTab == 0 ? .blue : .gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        
                        Button("标签2") {
                            selectedTab = 1
                        }
                        .padding()
                        .background(selectedTab == 1 ? .blue : .gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        
                        Button("标签3") {
                            selectedTab = 2
                        }
                        .padding()
                        .background(selectedTab == 2 ? .blue : .gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    
                    VStack {
                        if selectedTab == 0 {
                            Text("标签1内容")
                                .font(.title)
                                .fontWeight(.bold)
                        } else if selectedTab == 1 {
                            Text("标签2内容")
                                .font(.title)
                                .fontWeight(.bold)
                        } else {
                            Text("标签3内容")
                                .font(.title)
                                .fontWeight(.bold)
                        }
                    }
                    .padding()
                    .background(.gray.opacity(0.1))
                    .cornerRadius(10)
                    .padding(.top, 10)
                }
                .padding()
                .background(.purple.opacity(0.1))
                .cornerRadius(10)
                
                //  复杂状态管理
                VStack {
                    Text("6. 复杂状态管理")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    ComplexStateView()
                }
                .padding()
                .background(.red.opacity(0.1))
                .cornerRadius(10)
            }
            .padding()
        }
    }
}

//  用户结构体
struct AdvancedUser {
    var name: String
    var age: Int
}

//  复杂状态管理视图
struct ComplexStateView: View {
    @State private var items = ["项目1", "项目2", "项目3"]
    @State private var newItem = ""
    
    var body: some View {
        VStack {
            HStack {
                TextField("输入新项目", text: $newItem)
                    .padding()
                    .border(.gray)
                    .cornerRadius(5)
                
                Button("添加") {
                    if !newItem.isEmpty {
                        items.append(newItem)
                        newItem = ""
                    }
                }
                .padding()
                .background(.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            
            List {
                ForEach(items, id: \.self) {
                    Text($0)
                }
                .onDelete(perform: deleteItems)
            }
            .frame(height: 200)
        }
    }
    
    func deleteItems(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
    }
}

#Preview {
    AdvancedStateManagementTechniquesDemo()
}
