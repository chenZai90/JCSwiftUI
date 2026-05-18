//
//  ResponsiveLayout.swift
//  swiftUIDemo
//
//  响应式布局示例
//

import SwiftUI

//  响应式布局示例
struct ResponsiveLayoutDemo: View {
    //  环境变量 - 用于获取屏幕尺寸
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                //  标题
                Text("响应式布局")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                
                //  屏幕尺寸信息
                VStack {
                    Text("1. 屏幕尺寸信息")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text("水平尺寸类: \(horizontalSizeClass == .compact ? "紧凑" : "常规")")
                    Text("垂直尺寸类: \(verticalSizeClass == .compact ? "紧凑" : "常规")")
                }
                .padding()
                .background(.gray.opacity(0.1))
                .cornerRadius(10)
                
                //  自适应布局
                VStack {
                    Text("2. 自适应布局")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    //  根据水平尺寸类调整布局
                    if horizontalSizeClass == .compact {
                        //  紧凑模式 - 垂直布局
                        VStack(spacing: 10) {
                            Color.red
                                .frame(height: 100)
                                .cornerRadius(10)
                            Color.green
                                .frame(height: 100)
                                .cornerRadius(10)
                            Color.blue
                                .frame(height: 100)
                                .cornerRadius(10)
                        }
                    } else {
                        //  常规模式 - 水平布局
                        HStack(spacing: 10) {
                            Color.red
                                .frame(height: 100)
                                .cornerRadius(10)
                            Color.green
                                .frame(height: 100)
                                .cornerRadius(10)
                            Color.blue
                                .frame(height: 100)
                                .cornerRadius(10)
                        }
                    }
                }
                .padding()
                .background(.blue.opacity(0.1))
                .cornerRadius(10)
                
                //  动态网格布局
                VStack {
                    Text("3. 动态网格布局")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    //  根据水平尺寸类调整网格列数
                    let columns = horizontalSizeClass == .compact ? [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ] : [
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ]
                    
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(1..<9) {
                            Color(hue: Double($0)/10, saturation: 0.8, brightness: 0.8)
                                .frame(height: 100)
                                .cornerRadius(10)
                                .overlay(
                                    Text("\($0)")
                                        .foregroundColor(.white)
                                        .font(.headline)
                                )
                        }
                    }
                }
                .padding()
                .background(.green.opacity(0.1))
                .cornerRadius(10)
                
                //  几何读取器
                VStack {
                    Text("4. 几何读取器")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    GeometryReader { geometry in
                        VStack {
                            Text("屏幕宽度: \(geometry.size.width, specifier: "%.0f")")
                            Text("屏幕高度: \(geometry.size.height, specifier: "%.0f")")
                            
                            Rectangle()
                                .fill(.purple)
                                .frame(width: geometry.size.width * 0.8, height: 100)
                                .cornerRadius(10)
                        }
                    }
                    .frame(height: 200)
                }
                .padding()
                .background(.yellow.opacity(0.1))
                .cornerRadius(10)
                
                //  安全区域
                VStack {
                    Text("5. 安全区域")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text("使用ignoresSafeArea可以忽略安全区域")
                        .font(.subheadline)
                    
                    Color.blue
                        .frame(height: 100)
                        .ignoresSafeArea(edges: .top)
                        .cornerRadius(10)
                }
                .padding()
                .background(.purple.opacity(0.1))
                .cornerRadius(10)
                
                //  自适应文本
                VStack {
                    Text("6. 自适应文本")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text("这是一段自适应文本，会根据屏幕宽度自动换行")
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .padding()
                        .background(.gray.opacity(0.1))
                        .cornerRadius(10)
                }
                .padding()
                .background(.red.opacity(0.1))
                .cornerRadius(10)
                
                //  条件内容
                VStack {
                    Text("7. 条件内容")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    if horizontalSizeClass == .compact {
                        Text("当前是手机模式，显示手机专用内容")
                            .font(.body)
                            .padding()
                            .background(.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    } else {
                        Text("当前是平板模式，显示平板专用内容")
                            .font(.body)
                            .padding()
                            .background(.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding()
                .background(.orange.opacity(0.1))
                .cornerRadius(10)
                
                //  动态间距
                VStack {
                    Text("8. 动态间距")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    //  根据水平尺寸类调整间距
                    let spacing = horizontalSizeClass == .compact ? 10.0 : 20.0
                    
                    VStack(spacing: spacing) {
                        Color.red
                            .frame(height: 50)
                            .cornerRadius(10)
                        Color.green
                            .frame(height: 50)
                            .cornerRadius(10)
                        Color.blue
                            .frame(height: 50)
                            .cornerRadius(10)
                    }
                }
                .padding()
                .background(.gray.opacity(0.1))
                .cornerRadius(10)
            }
            .padding()
        }
    }
}

#Preview {
    ResponsiveLayoutDemo()
}