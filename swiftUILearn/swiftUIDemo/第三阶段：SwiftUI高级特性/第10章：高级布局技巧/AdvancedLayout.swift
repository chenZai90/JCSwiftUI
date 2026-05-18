//
//  AdvancedLayout.swift
//  swiftUIDemo
//
//  高级布局技巧示例
//

import SwiftUI

//  高级布局技巧示例
struct AdvancedLayoutDemo: View {
    //  状态管理
    @State private var isExpanded = false
    @State private var columnCount = 2
    @State private var isGridView = true
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                //  标题
                Text("高级布局技巧")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                
                //  网格布局
                VStack {
                    Text("1. 网格布局")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text("当前值: \(Int(columnCount))列")
                        .font(.subheadline)
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: columnCount)) {
                        ForEach(1..<10) { index in
                            Rectangle()
                                .fill(Color.blue.opacity(0.7))
                                .frame(height: 100)
                                .overlay(
                                    Text("Item \(index)")
                                        .foregroundColor(.white)
                                        .font(.headline)
                                )
                                .cornerRadius(10)
                        }
                    }
                    .padding()
                    
                    HStack {
                        Button("2列") {
                            columnCount = 2
                        }
                        .padding()
                        .background(columnCount == 2 ? .blue : .gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        
                        Button("3列") {
                            columnCount = 3
                        }
                        .padding()
                        .background(columnCount == 3 ? .blue : .gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                }
                .padding()
                .background(.gray.opacity(0.1))
                .cornerRadius(10)
                
                //  堆叠布局
                VStack {
                    Text("2. 堆叠布局")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    ZStack {
                        Rectangle()
                            .fill(.red)
                            .frame(width: 200, height: 200)
                            .cornerRadius(10)
                        
                        Rectangle()
                            .fill(.blue)
                            .frame(width: 150, height: 150)
                            .cornerRadius(10)
                        
                        Rectangle()
                            .fill(.green)
                            .frame(width: 100, height: 100)
                            .cornerRadius(10)
                        
                        Text("ZStack")
                            .foregroundColor(.white)
                            .font(.headline)
                            .fontWeight(.bold)
                    }
                }
                .padding()
                .background(.blue.opacity(0.1))
                .cornerRadius(10)
                
                //  嵌套布局
                VStack {
                    Text("3. 嵌套布局")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    HStack {
                        VStack {
                            Text("左侧")
                                .font(.headline)
                            
                            ForEach(1..<4) {
                                Text("项目 \($0)")
                                    .padding()
                                    .background(.blue.opacity(0.2))
                                    .cornerRadius(5)
                                    .padding(2)
                            }
                        }
                        
                        Spacer()
                        
                        VStack {
                            Text("右侧")
                                .font(.headline)
                            
                            Rectangle()
                                .fill(.green.opacity(0.2))
                                .frame(width: 100, height: 150)
                                .overlay(
                                    Text("内容区域")
                                        .foregroundColor(.green)
                                )
                        }
                    }
                    .padding()
                }
                .padding()
                .background(.green.opacity(0.1))
                .cornerRadius(10)
                
                //  自适应布局
                VStack {
                    Text("4. 自适应布局")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    HStack {
                        Text("短文本")
                            .padding()
                            .background(.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        
                        Spacer()
                        
                        Text("这是一段较长的文本内容，用于测试自适应布局")
                            .padding()
                            .background(.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding()
                }
                .padding()
                .background(.yellow.opacity(0.1))
                .cornerRadius(10)
                
                //  动态布局
                VStack {
                    Text("5. 动态布局")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Button("展开/收起") {
                        withAnimation {
                            isExpanded.toggle()
                        }
                    }
                    .padding()
                    .background(.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    
                    if isExpanded {
                        VStack {
                            Text("展开的内容")
                                .font(.headline)
                            
                            Text("这是展开后显示的详细内容，可以包含更多信息和控件。")
                                .padding()
                                .background(.gray.opacity(0.1))
                                .cornerRadius(10)
                        }
                        .padding()
                        .transition(.slide)
                    }
                }
                .padding()
                .background(.purple.opacity(0.1))
                .cornerRadius(10)
                
                //  响应式布局
                VStack {
                    Text("6. 响应式布局")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Button(isGridView ? "切换到列表" : "切换到网格") {
                        withAnimation {
                            isGridView.toggle()
                        }
                    }
                    .padding()
                    .background(.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    
                    if isGridView {
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2)) {
                            ForEach(1..<6) { index in
                                Rectangle()
                                    .fill(Color.blue.opacity(0.7))
                                    .frame(height: 80)
                                    .overlay(
                                        Text("项目 \(index)")
                                            .foregroundColor(.white)
                                    )
                                    .cornerRadius(10)
                            }
                        }
                        .padding()
                    } else {
                        VStack {
                            ForEach(1..<6) { index in
                                HStack {
                                    Rectangle()
                                        .fill(Color.green.opacity(0.7))
                                        .frame(width: 60, height: 60)
                                    
                                    VStack(alignment: .leading) {
                                        Text("项目 \(index)")
                                            .font(.headline)
                                        Text("详细描述")
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }
                                    
                                    Spacer()
                                }
                                .padding()
                                .background(.gray.opacity(0.1))
                                .cornerRadius(10)
                                .padding(2)
                            }
                        }
                        .padding()
                    }
                }
                .padding()
                .background(.red.opacity(0.1))
                .cornerRadius(10)
                
                //  自定义布局
                VStack {
                    Text("7. 自定义布局")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    HStack {
                        ForEach(1..<5) { index in
                            Text("Item \(index)")
                                .padding()
                                .background(Color.blue.opacity(0.5 * Double(index) / 4))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                    .padding()
                }
                .padding()
                .background(.orange.opacity(0.1))
                .cornerRadius(10)
            }
            .padding()
        }
    }
}

#Preview {
    AdvancedLayoutDemo()
}
