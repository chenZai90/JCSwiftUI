//
//  CustomViews.swift
//  swiftUIDemo
//
//  自定义视图示例
//

import SwiftUI

//  自定义视图示例
struct CustomViewsDemo: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                //  标题
                Text("自定义视图")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                
                //  自定义按钮
                VStack {
                    Text("1. 自定义按钮")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    CustomButton(title: "点击我") {
                        print("自定义按钮被点击")
                    }
                    
                    CustomButton(title: "次要按钮", style: .secondary) {
                        print("次要按钮被点击")
                    }
                }
                .padding()
                .background(.gray.opacity(0.1))
                .cornerRadius(10)
                
                //  自定义卡片
                VStack {
                    Text("2. 自定义卡片")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    CustomCard(
                        title: "欢迎使用SwiftUI",
                        subtitle: "这是一个自定义卡片视图",
                        imageName: "star.fill"
                    )
                    
                    CustomCard(
                        title: "学习SwiftUI",
                        subtitle: "从基础到高级",
                        imageName: "book.fill"
                    )
                }
                .padding()
                .background(.blue.opacity(0.1))
                .cornerRadius(10)
                
                //  自定义进度条
                VStack {
                    Text("3. 自定义进度条")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    CustomProgressBar(progress: 0.3)
                    CustomProgressBar(progress: 0.7, color: .green)
                    CustomProgressBar(progress: 1.0, color: .blue)
                }
                .padding()
                .background(.green.opacity(0.1))
                .cornerRadius(10)
                
                //  自定义徽章
                VStack {
                    Text("4. 自定义徽章")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    HStack(spacing: 20) {
                        CustomBadge(text: "新")
                        CustomBadge(text: "热门", color: .red)
                        CustomBadge(text: "优惠", color: .green)
                    }
                }
                .padding()
                .background(.yellow.opacity(0.1))
                .cornerRadius(10)
                
                //  自定义开关
                VStack {
                    Text("5. 自定义开关")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    CustomToggle(isOn: .constant(true))
                    CustomToggle(isOn: .constant(false))
                }
                .padding()
                .background(.purple.opacity(0.1))
                .cornerRadius(10)
                
                //  自定义列表项
                VStack {
                    Text("6. 自定义列表项")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    CustomListItem(
                        title: "项目1",
                        subtitle: "这是第一个项目",
                        imageName: "circle.fill"
                    )
                    
                    CustomListItem(
                        title: "项目2",
                        subtitle: "这是第二个项目",
                        imageName: "square.fill"
                    )
                }
                .padding()
                .background(.red.opacity(0.1))
                .cornerRadius(10)
            }
            .padding()
        }
    }
}

//  自定义按钮组件
struct CustomButton: View {
    let title: String
    let style: ButtonStyle
    let action: () -> Void
    
    //  按钮样式枚举
    enum ButtonStyle {
        case primary
        case secondary
    }
    
    //  初始化方法
    init(title: String, style: ButtonStyle = .primary, action: @escaping () -> Void) {
        self.title = title
        self.style = style
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .padding()
                .background(style == .primary ? .blue : .gray)
                .foregroundColor(.white)
                .cornerRadius(10)
                .font(.headline)
        }
    }
}

//  自定义卡片组件
struct CustomCard: View {
    let title: String
    let subtitle: String
    let imageName: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: imageName)
                    .font(.largeTitle)
                    .foregroundColor(.blue)
                Spacer()
            }
            Text(title)
                .font(.headline)
                .fontWeight(.bold)
            Text(subtitle)
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding()
        .background(.white)
        .cornerRadius(10)
        .shadow(radius: 5)
        .padding(.horizontal)
    }
}

//  自定义进度条组件
struct CustomProgressBar: View {
    let progress: Double
    let color: Color
    
    init(progress: Double, color: Color = .red) {
        self.progress = min(max(progress, 0), 1) //  确保进度在0-1之间
        self.color = color
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                //  背景
                Rectangle()
                    .fill(.gray.opacity(0.3))
                    .cornerRadius(5)
                
                //  进度条
                Rectangle()
                    .fill(color)
                    .frame(width: geometry.size.width * CGFloat(progress))
                    .cornerRadius(5)
            }
            .frame(height: 20)
        }
        .padding(.horizontal)
    }
}

//  自定义徽章组件
struct CustomBadge: View {
    let text: String
    let color: Color
    
    init(text: String, color: Color = .blue) {
        self.text = text
        self.color = color
    }
    
    var body: some View {
        Text(text)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(color)
            .foregroundColor(.white)
            .cornerRadius(15)
            .font(.subheadline)
            .fontWeight(.bold)
    }
}

//  自定义开关组件
struct CustomToggle: View {
    @Binding var isOn: Bool
    
    var body: some View {
        Button(action: {
            isOn.toggle()
        }) {
            HStack {
                Text(isOn ? "开启" : "关闭")
                    .font(.headline)
                Spacer()
                RoundedRectangle(cornerRadius: 20)
                    .fill(isOn ? .green : .gray)
                    .frame(width: 50, height: 30)
                    .overlay(
                        Circle()
                            .fill(.white)
                            .frame(width: 24, height: 24)
                            .offset(x: isOn ? 10 : -10)
                            .animation(.spring(), value: isOn)
                    )
            }
            .padding()
            .background(.white)
            .cornerRadius(10)
            .shadow(radius: 2)
        }
    }
}

//  自定义列表项组件
struct CustomListItem: View {
    let title: String
    let subtitle: String
    let imageName: String
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: imageName)
                .font(.title)
                .foregroundColor(.blue)
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.headline)
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding()
        .background(.white)
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}

#Preview {
    CustomViewsDemo()
}