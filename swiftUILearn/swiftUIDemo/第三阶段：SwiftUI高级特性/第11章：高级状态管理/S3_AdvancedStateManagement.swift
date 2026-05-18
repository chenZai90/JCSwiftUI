//
//  AdvancedStateManagement.swift
//  swiftUIDemo
//
//  高级状态管理示例
//

import SwiftUI

//  高级状态管理示例
struct S3_AdvancedStateManagementDemo: View {
    //  状态管理
    @State private var count = 0
    @State private var user = S3_User(name: "张三", age: 25)
    @State private var isLoggedIn = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                //  标题
                Text("高级状态管理")
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
                
                //  登录状态管理
                VStack {
                    Text("3. 登录状态管理")
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
            }
            .padding()
        }
    }
}

//  用户结构体
struct S3_User {
    var name: String
    var age: Int
}

#Preview {
    S3_AdvancedStateManagementDemo()
}
