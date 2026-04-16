//
//  DeclarativeUI.swift
//  swiftUIDemo
//
//  声明式UI基础示例
//

import SwiftUI

//  声明式UI基础示例
struct DeclarativeUIDemo: View {
    //  状态管理
    @State private var isTapped = false
    @State private var count = 0
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                //  标题
                Text("声明式UI基础")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                
                //  声明式UI概念
                Text("声明式UI是一种编程范式，你只需描述UI应该是什么样子，而不需要关心如何实现它。")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding()
                
                //  示例1：简单的文本和按钮
                VStack {
                    Text("示例1：简单的按钮点击")
                        .font(.headline)
                    
                    Button(action: {
                        //  点击按钮时的操作
                        isTapped.toggle()
                    }) {
                        //  按钮的外观
                        Text(isTapped ? "已点击" : "点击我")
                            .padding()
                            .background(isTapped ? .green : .blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
                    //  根据状态显示不同内容
                    if isTapped {
                        Text("你点击了按钮！")
                            .foregroundColor(.green)
                            .font(.subheadline)
                    }
                }
                .padding()
                .background(.gray.opacity(0.1))
                .cornerRadius(10)
                
                //  示例2：计数器
                VStack {
                    Text("示例2：计数器")
                        .font(.headline)
                    
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
                .background(.blue.opacity(0.1))
                .cornerRadius(10)
                
                //  声明式vs命令式对比
                VStack(alignment: .leading, spacing: 10) {
                    Text("声明式vs命令式：")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text("命令式（传统UIKit）:")
                    Text("button.setTitle(\"点击我\", for: .normal)")
                    Text("button.backgroundColor = .blue")
                    Text("button.addTarget(self, action: #selector(tap), for: .touchUpInside)")
                    
                    Text("\n声明式（SwiftUI）:")
                    Text("Button(\"点击我\") {\n    // 点击操作\n}")
                    Text("    .background(.blue)")
                    Text("    .foregroundColor(.white)")
                }
                .padding()
                .background(.green.opacity(0.1))
                .cornerRadius(10)
                
                //  示例3：信息卡片
                VStack {
                    Text("示例3：信息卡片")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    InfoCardView(
                        title: "SwiftUI 简介",
                        subtitle: "现代 UI 框架",
                        description: "SwiftUI 是一个声明式 UI 框架，允许开发者使用 Swift 语言创建跨 Apple 平台的用户界面。它提供了简洁、直观的语法，使 UI 开发变得更加高效。",
                        iconName: "star.fill",
                        iconColor: .yellow
                    )
                    
                    InfoCardView(
                        title: "声明式编程",
                        subtitle: "现代编程范式",
                        description: "声明式编程让开发者只需要描述界面的样子，而不需要关心如何实现。系统会自动处理视图的创建、更新和销毁。",
                        iconName: "code",
                        iconColor: .blue
                    )
                    
                    InfoCardView(
                        title: "跨平台",
                        subtitle: "一次编写，多处运行",
                        description: "SwiftUI 支持 iOS、iPadOS、macOS、watchOS 和 tvOS，让你的代码可以在所有 Apple 平台上运行。",
                        iconName: "globe",
                        iconColor: .green
                    )
                }
                .padding()
                .background(.gray.opacity(0.1))
                .cornerRadius(10)
            }
            .padding()
        }
    }
}

/// 信息卡片视图
struct InfoCardView: View {
    // 卡片数据
    let title: String
    let subtitle: String
    let description: String
    let iconName: String
    let iconColor: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // 图标和标题区域
            HStack(alignment: .center, spacing: 12) {
                // 图标
                Circle()
                    .fill(iconColor.opacity(0.1))
                    .frame(width: 48, height: 48)
                    .overlay {
                        Image(systemName: iconName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                            .foregroundColor(iconColor)
                    }
                
                //  标题和副标题
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .fontWeight(.semibold)
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            
            // 描述文本
            Text(description)
                .font(.body)
                .foregroundColor(.primary)
                .lineLimit(nil) // 不限制行数
        }
        .padding(16) // 卡片内边距
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
        )
        .padding(.horizontal, 16) // 卡片外边距
    }
}

#Preview {
    DeclarativeUIDemo()
}