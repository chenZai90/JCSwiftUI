//
//  Introduction.swift
//  swiftUIDemo
//
//  SwiftUI简介与开发环境搭建示例
//

import SwiftUI

//  SwiftUI简介示例
struct SwiftUIIntroduction: View {
    var body: some View {
        //  垂直堆栈布局
        VStack(spacing: 20) {
            //  标题
            Text("SwiftUI简介")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.blue)
            
            //  简介文本
            Text("SwiftUI是苹果在WWDC 2019推出的声明式UI框架，用于构建iOS、iPadOS、macOS、watchOS和tvOS的用户界面。")
                .font(.body)
                .multilineTextAlignment(.center)
                .padding()
            
            //  开发环境要求
            VStack(alignment: .leading, spacing: 10) {
                Text("开发环境要求：")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Text("• Xcode 11或更高版本")
                Text("• macOS Catalina 10.15或更高版本")
                Text("• iOS 13或更高版本")
                Text("• Swift 5.1或更高版本")
            }
            .padding()
            .background(.gray.opacity(0.1))
            .cornerRadius(10)
            
            //  优势列表
            VStack(alignment: .leading, spacing: 10) {
                Text("SwiftUI的优势：")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Text("• 声明式语法，代码更简洁易读")
                Text("• 实时预览，所见即所得")
                Text("• 跨平台支持，一套代码多平台运行")
                Text("• 与Combine框架无缝集成")
                Text("• 自动适配暗黑模式")
            }
            .padding()
            .background(.blue.opacity(0.1))
            .cornerRadius(10)
            
            //  简单示例
            Text("简单示例")
                .font(.headline)
                .fontWeight(.semibold)
            
            
            // 先设置背景，再添加内边距
            Text("先设置背景，再添加内边距")
                .background(Color.blue)
                .padding()

            // 先添加内边距，再设置背景
            Text("先添加内边距，再设置背景")
                .padding()
                .background(Color.blue)

            
            //  一个简单的SwiftUI视图示例
            HStack(spacing: 20) {
                Circle()
                    .fill(.red)
                    .frame(width: 50, height: 50)
                
                Text("Hello, SwiftUI!")
                    .font(.title)
                    .fontWeight(.bold)
            }
            .padding()
            .background(.green.opacity(0.1))
            .cornerRadius(10.0)
        }
        .padding()
    }
}

#Preview {
    SwiftUIIntroduction()
}
