//
//  LayoutSystem.swift
//  swiftUIDemo
//
//  基础布局系统示例
//

import SwiftUI

//  基础布局系统示例
struct LayoutSystemDemo: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                //  标题
                Text("基础布局系统")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                
                //  VStack - 垂直堆栈
                VStack {
                    Text("1. VStack - 垂直堆栈")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    //  基本用法
                    VStack(spacing: 10) {
                        Text("基本垂直栈")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        VStack {
                            Text("第一行")
                            Text("第二行")
                            Text("第三行")
                        }
                        .padding()
                        .background(.gray.opacity(0.1))
                        .cornerRadius(8)
                    }
                    
                    //  带对齐的垂直栈
                    VStack(spacing: 10) {
                        Text("带对齐的垂直栈")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        HStack(spacing: 20) {
                            VStack(alignment: .leading) {
                                Text("左对齐")
                                Text("这是一行更长的文本")
                                Text("短文本")
                            }
                            .padding()
                            .background(.blue.opacity(0.1))
                            .cornerRadius(8)
                            
                            VStack(alignment: .center) {
                                Text("居中对齐")
                                Text("这是一行更长的文本")
                                Text("短文本")
                            }
                            .padding()
                            .background(.green.opacity(0.1))
                            .cornerRadius(8)
                            
                            VStack(alignment: .trailing) {
                                Text("右对齐")
                                Text("这是一行更长的文本")
                                Text("短文本")
                            }
                            .padding()
                            .background(.yellow.opacity(0.1))
                            .cornerRadius(8)
                        }
                    }
                }
                .padding()
                .background(.gray.opacity(0.1))
                .cornerRadius(10)
                
                //  HStack - 水平堆栈
                VStack {
                    Text("2. HStack - 水平堆栈")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    //  基本用法
                    VStack(spacing: 10) {
                        Text("基本水平栈")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        HStack {
                            Text("左侧")
                            Text("中间")
                            Text("右侧")
                        }
                        .padding()
                        .background(.gray.opacity(0.1))
                        .cornerRadius(8)
                    }
                    
                    //  带对齐的水平栈
                    VStack(spacing: 10) {
                        Text("带对齐的水平栈")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        VStack(spacing: 10) {
                            HStack(alignment: .top) {
                                Text("顶部对齐")
                                Text("这是一行\n多行文本")
                                Text("短文本")
                            }
                            .padding()
                            .background(.blue.opacity(0.1))
                            .cornerRadius(8)
                            
                            HStack(alignment: .center) {
                                Text("居中对齐")
                                Text("这是一行\n多行文本")
                                Text("短文本")
                            }
                            .padding()
                            .background(.green.opacity(0.1))
                            .cornerRadius(8)
                            
                            HStack(alignment: .bottom) {
                                Text("底部对齐")
                                Text("这是一行\n多行文本")
                                Text("短文本")
                            }
                            .padding()
                            .background(.yellow.opacity(0.1))
                            .cornerRadius(8)
                        }
                    }
                    
                    //  带Spacer的水平栈
                    VStack(spacing: 10) {
                        Text("带Spacer的水平栈")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        HStack {
                            Text("左侧")
                            Spacer()
                            Text("右侧")
                        }
                        .padding()
                        .background(.gray.opacity(0.1))
                        .cornerRadius(8)
                    }
                }
                .padding()
                .background(.blue.opacity(0.1))
                .cornerRadius(10)
                
                //  ZStack - 层叠堆栈
                VStack {
                    Text("3. ZStack - 层叠堆栈")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    //  基本用法
                    VStack(spacing: 10) {
                        Text("基本层叠")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        ZStack {
                            Color.blue
                            Text("前景文本")
                                .foregroundColor(.white)
                                .font(.largeTitle)
                        }
                        .frame(height: 100)
                        .cornerRadius(8)
                    }
                    
                    //  带对齐的层叠
                    VStack(spacing: 10) {
                        Text("带对齐的层叠")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        HStack(spacing: 20) {
                            ZStack(alignment: .topLeading) {
                                Rectangle()
                                    .fill(.gray.opacity(0.2))
                                    .frame(width: 100, height: 100)
                                Text("左上")
                                    .padding(5)
                            }
                            
                            ZStack(alignment: .center) {
                                Rectangle()
                                    .fill(.gray.opacity(0.2))
                                    .frame(width: 100, height: 100)
                                Text("居中")
                            }
                            
                            ZStack(alignment: .bottomTrailing) {
                                Rectangle()
                                    .fill(.gray.opacity(0.2))
                                    .frame(width: 100, height: 100)
                                Text("右下")
                                    .padding(5)
                            }
                        }
                    }
                    
                    //  实际应用：带徽章的图标
                    VStack(spacing: 10) {
                        Text("实际应用：带徽章的图标")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        ZStack(alignment: .topTrailing) {
                            Image(systemName: "bell")
                                .font(.system(size: 32))
                            
                            Circle()
                                .fill(Color.red)
                                .frame(width: 20, height: 20)
                                .overlay {
                                    Text("3")
                                        .font(.system(size: 12))
                                        .foregroundColor(.white)
                                }
                                .offset(x: 5, y: -5)
                        }
                    }
                }
                .padding()
                .background(.green.opacity(0.1))
                .cornerRadius(10)
                
                //  布局修饰符
                VStack {
                    Text("4. 布局修饰符")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    //  frame修饰符
                    VStack(spacing: 10) {
                        Text("frame修饰符")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        HStack(spacing: 10) {
                            Text("固定大小")
                                .frame(width: 100, height: 50)
                                .background(.yellow)
                                .cornerRadius(8)
                            
                            Text("填充")
                                .frame(maxWidth: .infinity, maxHeight: 50)
                                .background(.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                    }
                    
                    //  padding修饰符
                    VStack(spacing: 10) {
                        Text("padding修饰符")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        HStack(spacing: 10) {
                            Text("无内边距")
                                .background(.yellow)
                                .cornerRadius(8)
                            
                            Text("有内边距")
                                .padding()
                                .background(.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                    }
                    
                    //  offset修饰符
                    VStack(spacing: 10) {
                        Text("offset修饰符")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        ZStack {
                            Text("基础位置")
                                .background(.yellow)
                                .cornerRadius(8)
                            
                            Text("偏移位置")
                                .offset(x: 50, y: 20)
                                .background(.red)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                    }
                }
                .padding()
                .background(.yellow.opacity(0.1))
                .cornerRadius(10)
                
                //  容器布局
                VStack {
                    Text("5. 容器布局")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    //  ScrollView
                    VStack(spacing: 10) {
                        Text("ScrollView - 水平滚动")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        ScrollView(.horizontal, showsIndicators: true) {
                            HStack(spacing: 15) {
                                ForEach(1..<10) {
                                    Rectangle()
                                        .fill(Color(hue: Double($0)/10, saturation: 0.8, brightness: 0.8))
                                        .frame(width: 100, height: 100)
                                        .overlay(
                                            Text("\($0)")
                                                .foregroundColor(.white)
                                                .font(.headline)
                                        )
                                }
                            }
                            .padding()
                        }
                        .frame(height: 150)
                        .background(.gray.opacity(0.1))
                        .cornerRadius(8)
                    }
                    
                    //  LazyVStack
                    VStack(spacing: 10) {
                        Text("LazyVStack - 延迟加载")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        ScrollView {
                            LazyVStack(spacing: 10) {
                                ForEach(1..<20) {
                                    Text("项目 \($0)")
                                        .padding()
                                        .background(Color(hue: Double($0)/20, saturation: 0.8, brightness: 0.8))
                                        .foregroundColor(.white)
                                        .cornerRadius(8)
                                }
                            }
                            .padding()
                        }
                        .frame(height: 200)
                        .background(.gray.opacity(0.1))
                        .cornerRadius(8)
                    }
                }
                .padding()
                .background(.purple.opacity(0.1))
                .cornerRadius(10)
                
                //  实战案例导航
                VStack {
                    Text("6. 实战案例")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    NavigationLink(destination: LoginView()) {
                        Text("登录页面")
                            .foregroundColor(.blue)
                            .underline()
                    }
                    .padding()
                    
                    NavigationLink(destination: ProductDetailView()) {
                        Text("产品详情页")
                            .foregroundColor(.blue)
                            .underline()
                    }
                    .padding()
                }
                .padding()
                .background(.red.opacity(0.1))
                .cornerRadius(10)
            }
            .padding()
        }
    }
}

/// 登录页面视图
struct LoginView: View {
    // 状态变量
    @State private var username = ""
    @State private var password = ""
    @State private var showPassword = false
    
    var body: some View {
        ZStack {
            // 背景
            LinearGradient(
                colors: [.blue.opacity(0.1), .purple.opacity(0.1)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 24) {
                // 应用图标和标题
                VStack(spacing: 12) {
                    Image(systemName: "lock.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 80, height: 80)
                        .foregroundColor(.blue)
                    
                    Text("欢迎回来")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("请登录以继续")
                        .foregroundColor(.secondary)
                }
                
                // 输入区域
                VStack(spacing: 16) {
                    // 用户名输入框
                    TextField(
                        "用户名",
                        text: $username,
                        prompt: Text("请输入用户名")
                    )
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)
                    
                    // 密码输入框
                    ZStack(alignment: .trailing) {
                        if showPassword {
                            TextField(
                                "密码",
                                text: $password,
                                prompt: Text("请输入密码")
                            )
                        } else {
                            SecureField(
                                "密码",
                                text: $password,
                                prompt: Text("请输入密码")
                            )
                        }
                        
                        Button(action: {
                            showPassword.toggle()
                        }) {
                            Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                                .foregroundColor(.secondary)
                                .padding(.trailing, 16)
                        }
                    }
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)
                    
                    // 忘记密码
                    HStack {
                        Spacer()
                        Button("忘记密码?") {
                            print("忘记密码")
                        }
                        .foregroundColor(.blue)
                        .padding(.trailing)
                    }
                }
                
                // 登录按钮
                Button("登录") {
                    print("登录")
                }
                .buttonStyle(.borderedProminent)
                .tint(.blue)
                .padding(.horizontal)
                .frame(maxWidth: .infinity)
                
                // 注册链接
                HStack {
                    Text("还没有账号?")
                    Button("立即注册") {
                        print("注册")
                    }
                    .foregroundColor(.blue)
                }
                
                Spacer()
            }
            .padding(.top, 60)
        }
        .navigationTitle("登录")
        .navigationBarTitleDisplayMode(.inline)
    }
}

/// 产品详情页视图
struct ProductDetailView: View {
    // 状态变量
    @State private var selectedColor = "红色"
    @State private var selectedSize = "M"
    @State private var quantity = 1
    
    // 产品数据
    let productName = "SwiftUI 高级教程"
    let productPrice = "¥99.00"
    let productDescription = "本教程涵盖了 SwiftUI 的高级特性，包括动画、手势、布局和性能优化等内容。通过实际项目案例，帮助你掌握 SwiftUI 的核心概念和最佳实践。"
    let colors = ["红色", "蓝色", "黑色"]
    let sizes = ["S", "M", "L", "XL"]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // 产品图片
                ZStack {
                    Color.gray.opacity(0.1)
                        .frame(height: 300)
                    
                    Image(systemName: "book.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 150, height: 150)
                        .foregroundColor(.blue)
                }
                
                // 产品信息
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text(productName)
                            .font(.title)
                            .fontWeight(.bold)
                        Spacer()
                        Text(productPrice)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.red)
                    }
                    
                    // 产品描述
                    Text(productDescription)
                        .foregroundColor(.secondary)
                        .lineLimit(nil)
                    
                    // 颜色选择
                    Text("颜色")
                        .font(.headline)
                    HStack(spacing: 10) {
                        ForEach(colors, id: \.self) {
                            color in
                            Button(action: {
                                selectedColor = color
                            }) {
                                Text(color)
                                    .padding(8)
                                    .background(selectedColor == color ? Color.blue : Color.gray.opacity(0.1))
                                    .foregroundColor(selectedColor == color ? .white : .primary)
                                    .cornerRadius(4)
                            }
                        }
                    }
                    
                    // 尺寸选择
                    Text("尺寸")
                        .font(.headline)
                    HStack(spacing: 10) {
                        ForEach(sizes, id: \.self) {
                            size in
                            Button(action: {
                                selectedSize = size
                            }) {
                                Text(size)
                                    .padding(8)
                                    .background(selectedSize == size ? Color.blue : Color.gray.opacity(0.1))
                                    .foregroundColor(selectedSize == size ? .white : .primary)
                                    .cornerRadius(4)
                            }
                        }
                    }
                    
                    // 数量选择
                    Text("数量")
                        .font(.headline)
                    HStack {
                        Button(action: {
                            if quantity > 1 {
                                quantity -= 1
                            }
                        }) {
                            Image(systemName: "minus.circle")
                                .font(.system(size: 24))
                        }
                        
                        Text("\(quantity)")
                            .font(.headline)
                            .padding(.horizontal, 20)
                        
                        Button(action: {
                            quantity += 1
                        }) {
                            Image(systemName: "plus.circle")
                                .font(.system(size: 24))
                        }
                    }
                }
                .padding()
                
                // 购买按钮
                Button("加入购物车") {
                    print("加入购物车")
                }
                .buttonStyle(.borderedProminent)
                .tint(.blue)
                .padding(.horizontal)
                .frame(maxWidth: .infinity)
                .padding(.bottom, 30)
            }
        }
        .navigationTitle("产品详情")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    LayoutSystemDemo()
}
