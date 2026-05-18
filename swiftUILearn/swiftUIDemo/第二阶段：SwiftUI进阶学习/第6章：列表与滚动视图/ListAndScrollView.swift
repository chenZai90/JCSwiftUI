//
//  ListAndScrollView.swift
//  swiftUIDemo
//
//  列表与滚动视图示例
//

import SwiftUI

//  列表与滚动视图示例
struct ListAndScrollViewDemo: View {
    //  状态管理
    @State private var items = Array(1...50)
    @State private var isLoading = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                //  标题
                Text("列表与滚动视图")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                
                //  基本列表
                VStack {
                    Text("1. 基本列表")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    List {
                        ForEach(items.prefix(10), id: \.self) {
                            item in
                            Text("项目 \(item)")
                        }
                    }
                    .frame(height: 200)
                    .cornerRadius(10)
                }
                .padding()
                .background(.gray.opacity(0.1))
                .cornerRadius(10)
                
                //  滚动视图
                VStack {
                    Text("2. 滚动视图")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    ScrollView(.horizontal) {
                        HStack(spacing: 10) {
                            ForEach(1..<6) {
                                index in
                                Rectangle()
                                    .fill(Color.blue.opacity(0.5))
                                    .frame(width: 150, height: 100)
                                    .cornerRadius(10)
                                    .overlay(
                                        Text("水平项目 \(index)")
                                            .foregroundColor(.white)
                                            .font(.headline)
                                    )
                            }
                        }
                        .padding()
                    }
                    .frame(height: 120)
                    .border(.gray, width: 1)
                    .cornerRadius(10)
                }
                .padding()
                .background(.blue.opacity(0.1))
                .cornerRadius(10)
                
                //  懒加载列表
                VStack {
                    Text("3. 懒加载列表")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    ScrollView {
                        LazyVStack {
                            ForEach(items, id: \.self) {
                                item in
                                Text("懒加载项目 \(item)")
                                    .padding()
                                    .background(.gray.opacity(0.1))
                                    .cornerRadius(5)
                                    .padding(.vertical, 2)
                            }
                        }
                        .padding()
                    }
                    .frame(height: 200)
                    .border(.gray, width: 1)
                    .cornerRadius(10)
                }
                .padding()
                .background(.green.opacity(0.1))
                .cornerRadius(10)
                
                //  分组列表
                VStack {
                    Text("4. 分组列表")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    List {
                        Section(header: Text("水果")) {
                            Text("苹果")
                            Text("香蕉")
                            Text("橙子")
                        }
                        
                        Section(header: Text("蔬菜")) {
                            Text("西红柿")
                            Text("黄瓜")
                            Text("土豆")
                        }
                    }
                    .frame(height: 200)
                    .cornerRadius(10)
                }
                .padding()
                .background(.yellow.opacity(0.1))
                .cornerRadius(10)
                
                //  列表性能
                VStack {
                    Text("5. 列表性能")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Button("加载更多项目") {
                        isLoading = true
                        //  模拟网络请求
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            items.append(contentsOf: Array(items.count + 1...items.count + 50))
                            isLoading = false
                        }
                    }
                    .padding()
                    .background(.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    
                    if isLoading {
                        ProgressView("加载中...")
                    }
                    
                    Text("当前项目数量: \(items.count)")
                        .font(.body)
                }
                .padding()
                .background(.purple.opacity(0.1))
                .cornerRadius(10)
            }
            .padding()
        }
    }
}

#Preview {
    ListAndScrollViewDemo()
}