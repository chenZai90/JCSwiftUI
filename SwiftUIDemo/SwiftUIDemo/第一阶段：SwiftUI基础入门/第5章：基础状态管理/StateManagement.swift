//
//  StateManagement.swift
//  swiftUIDemo
//
//  基础状态管理示例
//

import SwiftUI

//  基础状态管理示例
struct StateManagementDemo: View {
    //  1. @State - 用于管理视图内部的简单状态
    @State private var count = 0
    
    //  2. @State - 用于管理布尔值状态
    @State private var isDarkMode = false
    
    //  3. @State - 用于管理字符串状态
    @State private var textInput = ""
    
    //  4. @State - 用于管理数组状态
    @State private var items = ["项目1", "项目2", "项目3"]
    
    //  5. @State - 用于管理枚举状态
    @State private var selectedTab = Tab.home
    
    //  标签枚举
    enum Tab {
        case home
        case settings
        case profile
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                //  标题
                Text("基础状态管理")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                
                //  状态管理介绍
                Text("状态管理是SwiftUI的核心概念，用于管理视图的可变数据。")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding()
                
                //  @State示例 - 计数器
                VStack {
                    Text("1. @State - 计数器示例")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text("计数: \(count)")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    HStack(spacing: 10) {
                        Button("减1") {
                            count -= 1
                        }
                        .padding()
                        .background(.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        
                        Button("加1") {
                            count += 1
                        }
                        .padding()
                        .background(.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                }
                .padding()
                .background(.gray.opacity(0.1))
                .cornerRadius(10)
                
                //  @State示例 - 暗黑模式切换
                VStack {
                    Text("2. @State - 暗黑模式切换")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Toggle("启用暗黑模式", isOn: $isDarkMode)
                        .padding()
                    
                    Text("当前模式: \(isDarkMode ? "暗黑模式" : "浅色模式")")
                        .font(.subheadline)
                }
                .padding()
                .background(isDarkMode ? Color.black : Color.white)
                .foregroundColor(isDarkMode ? Color.white : Color.black)
                .cornerRadius(10)
                
                //  @State示例 - 文本输入
                VStack {
                    Text("3. @State - 文本输入")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    TextField("请输入文本...", text: $textInput)
                        .padding()
                        .border(.gray, width: 1)
                        .cornerRadius(5)
                    
                    Text("你输入的内容: \(textInput)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding()
                .background(.blue.opacity(0.1))
                .cornerRadius(10)
                
                //  @State示例 - 数组操作
                VStack {
                    Text("4. @State - 数组操作")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    List {
                        ForEach(items, id: \.self) {
                            Text($0)
                        }
                        .onDelete(perform: deleteItem)
                    }
                    .frame(height: 150)
                    
                    Button("添加项目") {
                        items.append("项目\(items.count + 1)")
                    }
                    .padding()
                    .background(.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding()
                .background(.green.opacity(0.1))
                .cornerRadius(10)
                
                //  @State示例 - 标签切换
                VStack {
                    Text("5. @State - 标签切换")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    HStack {
                        Button("首页") {
                            selectedTab = .home
                        }
                        .padding()
                        .background(selectedTab == .home ? .blue : .gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        
                        Button("设置") {
                            selectedTab = .settings
                        }
                        .padding()
                        .background(selectedTab == .settings ? .blue : .gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        
                        Button("个人") {
                            selectedTab = .profile
                        }
                        .padding()
                        .background(selectedTab == .profile ? .blue : .gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    
                    Text("当前选中: \(tabTitle)")
                        .font(.subheadline)
                        .padding()
                }
                .padding()
                .background(.yellow.opacity(0.1))
                .cornerRadius(10)
                
                //  状态管理最佳实践
                VStack(alignment: .leading, spacing: 10) {
                    Text("状态管理最佳实践：")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text("• 使用@State管理视图内部的简单状态")
                    Text("• 状态变量应标记为private")
                    Text("• 复杂状态应使用@StateObject或@ObservedObject")
                    Text("• 避免在body中直接修改状态")
                    Text("• 使用withAnimation包裹状态更新以实现动画效果")
                }
                .padding()
                .background(.purple.opacity(0.1))
                .cornerRadius(10)
            }
            .padding()
        }
    }
    
    //  根据选中的标签返回标题
    var tabTitle: String {
        switch selectedTab {
        case .home:
            return "首页"
        case .settings:
            return "设置"
        case .profile:
            return "个人"
        }
    }
    
    //  删除数组元素的方法
    private func deleteItem(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
    }
}

#Preview {
    StateManagementDemo()
}