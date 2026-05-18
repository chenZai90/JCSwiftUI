//
//  PerformanceAnalysis.swift
//  swiftUIDemo
//
//  性能分析示例
//

import SwiftUI

//  性能分析示例
struct PerformanceAnalysisDemo: View {
    //  状态管理
    @State private var items: [Int] = Array(1...1000)
    @State private var isLoading = false
    @State private var renderTime = 0.0
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                //  标题
                Text("性能分析")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                
                //  渲染性能
                VStack {
                    Text("1. 渲染性能")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text("渲染时间: \(renderTime, specifier: "%.3f")秒")
                        .font(.body)
                    
                    Button("渲染1000个项目") {
                        measureRenderTime()
                    }
                    .padding()
                    .background(.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding()
                .background(.gray.opacity(0.1))
                .cornerRadius(10)
                
                //  列表性能
                VStack {
                    Text("2. 列表性能")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text("项目数量: \(items.count)")
                        .font(.body)
                    
                    Button("添加1000个项目") {
                        addItems()
                    }
                    .padding()
                    .background(.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    
                    Button("清空项目") {
                        clearItems()
                    }
                    .padding()
                    .background(.red)
                    .foregroundColor(.white)
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
                    
                    //  使用LazyVStack提高性能
                    ScrollView {
                        LazyVStack {
                            ForEach(items, id: \.self) {
                                item in
                                Text("项目 \(item)")
                                    .padding()
                                    .background(.gray.opacity(0.1))
                                    .cornerRadius(5)
                                    .padding(.vertical, 2)
                            }
                        }
                    }
                    .frame(height: 300)
                    .border(.gray, width: 1)
                    .cornerRadius(10)
                }
                .padding()
                .background(.green.opacity(0.1))
                .cornerRadius(10)
                
                //  性能提示
                VStack(alignment: .leading, spacing: 10) {
                    Text("4. 性能优化提示")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text("• 使用LazyVStack和LazyHStack处理大量数据")
                    Text(#"• 使用id:\.self或稳定的标识符提高列表性能"#)
                    Text("• 避免在body中进行复杂计算")
                    Text("• 使用@StateObject而不是@ObservedObject提高性能")
                    Text("• 合理使用动画，避免过度动画")
                    Text("• 使用Memoization缓存计算结果")
                }
                .padding()
                .background(.yellow.opacity(0.1))
                .cornerRadius(10)
            }
            .padding()
        }
    }
    
    //  测量渲染时间
    func measureRenderTime() {
        let start = Date()
        isLoading = true
        
        //  模拟渲染过程
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let end = Date()
            renderTime = end.timeIntervalSince(start)
            isLoading = false
        }
    }
    
    //  添加项目
    func addItems() {
        items.append(contentsOf: Array(items.count + 1...items.count + 1000))
    }
    
    //  清空项目
    func clearItems() {
        items.removeAll()
    }
}

#Preview {
    PerformanceAnalysisDemo()
}