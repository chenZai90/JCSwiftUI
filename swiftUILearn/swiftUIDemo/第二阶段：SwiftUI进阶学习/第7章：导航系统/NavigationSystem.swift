//
//  NavigationSystem.swift
//  swiftUIDemo
//
//  导航系统示例
//

import SwiftUI

//  导航系统示例
struct NavigationSystemDemo: View {
    //  状态管理
    @State private var isDetailViewPresented = false
    @State private var selectedItem: String? = nil
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                //  标题
                Text("导航系统")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                
                //  导航链接
                VStack {
                    Text("1. 导航链接")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    NavigationLink("跳转到详情页") {
                        NavSystemDetailView()
                    }
                    .padding()
                    .background(.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding()
                .background(.gray.opacity(0.1))
                .cornerRadius(10)
                
                //  带值的导航链接
                VStack {
                    Text("2. 带值的导航链接")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    HStack(spacing: 10) {
                        NavigationLink("项目1") {
                            NavSystemDetailView(item: "项目1")
                        }
                        .padding()
                        .background(.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        
                        NavigationLink("项目2") {
                            NavSystemDetailView(item: "项目2")
                        }
                        .padding()
                        .background(.purple)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                }
                .padding()
                .background(.blue.opacity(0.1))
                .cornerRadius(10)
                
                //  程序化导航
                VStack {
                    Text("3. 程序化导航")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Button("以编程方式导航") {
                        isDetailViewPresented = true
                    }
                    .padding()
                    .background(.yellow)
                    .foregroundColor(.black)
                    .cornerRadius(10)
                    
                    NavigationLink(isActive: $isDetailViewPresented) {
                        NavSystemDetailView()
                    } label: {
                        EmptyView()
                    }
                }
                .padding()
                .background(.green.opacity(0.1))
                .cornerRadius(10)
                
                //  嵌套导航
                VStack {
                    Text("4. 嵌套导航")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    NavigationLink("进入嵌套导航") {
                        NavNestedNavigationView()
                    }
                    .padding()
                    .background(.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding()
                .background(.yellow.opacity(0.1))
                .cornerRadius(10)
                
                //  导航栏配置
                VStack {
                    Text("5. 导航栏配置")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text("导航栏可以通过navigationTitle和navigationBarItems配置")
                        .font(.body)
                        .multilineTextAlignment(.center)
                }
                .padding()
                .background(.purple.opacity(0.1))
                .cornerRadius(10)
            }
            .padding()
            .navigationTitle("导航系统示例")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

//  详情视图
struct NavSystemDetailView: View {
    let item: String?
    
    init(item: String? = nil) {
        self.item = item
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text("详情页面")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            if let item = item {
                Text("选中的项目: \(item)")
                    .font(.headline)
            } else {
                Text("这是一个详情页面")
                    .font(.headline)
            }
            
            Text("通过导航链接或编程方式进入此页面")
                .font(.body)
                .foregroundColor(.gray)
            
            Button("返回") {
                //  自动处理返回
            }
            .padding()
            .background(.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
        .navigationTitle("详情")
    }
}

//  嵌套导航视图
struct NavNestedNavigationView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("嵌套导航")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            NavigationLink("进入更深层级") {
                NavDeepDetailView()
            }
            .padding()
            .background(.green)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
        .navigationTitle("嵌套导航")
    }
}

//  深层详情视图
struct NavDeepDetailView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("深层详情页面")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("这是嵌套导航的深层页面")
                .font(.body)
                .foregroundColor(.gray)
        }
        .padding()
        .navigationTitle("深层详情")
    }
}

#Preview {
    NavigationSystemDemo()
}
