//
//  RenderingOptimization.swift
//  swiftUIDemo
//
//  渲染优化示例
//

import SwiftUI

//  渲染优化示例
struct RenderingOptimizationDemo: View {
    //  状态管理
    @State private var isToggled = false
    @State private var counter = 0
    @State private var selectedItem = 0
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                //  标题
                Text("渲染优化")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                
                //  视图分离
                VStack {
                    Text("1. 视图分离")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    //  将复杂视图分离为子视图
                    ComplexView()
                }
                .padding()
                .background(.gray.opacity(0.1))
                .cornerRadius(10)
                
                //  条件渲染
                VStack {
                    Text("2. 条件渲染")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Toggle("显示详情", isOn: $isToggled)
                    
                    if isToggled {
                        //  只在需要时渲染
                        DetailView()
                    }
                }
                .padding()
                .background(.blue.opacity(0.1))
                .cornerRadius(10)
                
                //  列表优化
                VStack {
                    Text("3. 列表优化")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Button("更新计数器") {
                        counter += 1
                    }
                    .padding()
                    .background(.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    
                    Text("计数器: \(counter)")
                        .font(.body)
                    
                    //  使用ForEach的id参数提高性能
                    ScrollView {
                        ForEach(0..<100, id: \.self) {
                            index in
                            ListItemView(index: index, counter: counter)
                        }
                    }
                    .frame(height: 200)
                    .border(.gray, width: 1)
                    .cornerRadius(10)
                }
                .padding()
                .background(.green.opacity(0.1))
                .cornerRadius(10)
                
                //  避免不必要的计算
                VStack {
                    Text("4. 避免不必要的计算")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Picker("选择项目", selection: $selectedItem) {
                        ForEach(0..<5) {
                            Text("项目 \($0)")
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    //  使用计算属性而不是在body中直接计算
                    Text("计算结果: \(computedValue)")
                        .font(.body)
                }
                .padding()
                .background(.yellow.opacity(0.1))
                .cornerRadius(10)
                
                //  渲染优化提示
                VStack(alignment: .leading, spacing: 10) {
                    Text("5. 渲染优化提示")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text("• 将复杂视图分解为更小的子视图")
                    Text("• 使用@ViewBuilder创建可组合的视图")
                    Text("• 避免在body中进行昂贵的计算")
                    Text("• 使用Equatable协议避免不必要的重渲染")
                    Text("• 合理使用@State和@Binding")
                }
                .padding()
                .background(.purple.opacity(0.1))
                .cornerRadius(10)
            }
            .padding()
        }
    }
    
    //  计算属性，避免在body中直接计算
    var computedValue: Int {
        //  模拟昂贵的计算
        var result = 0
        for _ in 0..<100000 {
            result += selectedItem
        }
        return result
    }
}

//  复杂视图
struct ComplexView: View {
    var body: some View {
        VStack(spacing: 10) {
            Text("复杂视图示例")
                .font(.headline)
            ForEach(0..<5) {
                index in
                Text("子视图 \(index)")
                    .padding()
                    .background(.blue.opacity(0.1))
                    .cornerRadius(5)
            }
        }
        .padding()
        .background(.white)
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}

//  详情视图
struct DetailView: View {
    var body: some View {
        VStack(spacing: 10) {
            Text("详细信息")
                .font(.headline)
            Text("这是一个详细信息视图，只在需要时渲染")
            Text("这样可以提高应用的性能")
        }
        .padding()
        .background(.green.opacity(0.1))
        .cornerRadius(10)
    }
}

//  列表项视图
struct ListItemView: View {
    let index: Int
    let counter: Int
    
    var body: some View {
        Text("项目 \(index) - 计数器: \(counter)")
            .padding()
            .background(.gray.opacity(0.1))
            .cornerRadius(5)
    }
}

#Preview {
    RenderingOptimizationDemo()
}