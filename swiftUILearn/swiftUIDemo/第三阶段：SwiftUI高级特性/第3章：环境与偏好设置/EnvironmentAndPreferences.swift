//
//  EnvironmentAndPreferences.swift
//  swiftUIDemo
//
//  环境与偏好设置示例
//

import SwiftUI

//  环境与偏好设置示例
struct EnvironmentAndPreferencesDemo: View {
    //  环境变量
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.locale) private var locale
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    //  状态管理
    @State private var isDarkMode = false
    @State private var fontSize = 16.0
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                //  标题
                Text("环境与偏好设置")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                
                //  环境变量
                VStack {
                    Text("1. 环境变量")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text("当前颜色模式: \(colorScheme == .dark ? "暗黑" : "浅色")")
                    Text("当前语言: \(Locale.current.languageCode ?? "未知")")
                    Text("水平尺寸类: \(horizontalSizeClass == .compact ? "紧凑" : "常规")")
                }
                .padding()
                .background(.gray.opacity(0.1))
                .cornerRadius(10)
                
                //  环境值传递
                VStack {
                    Text("2. 环境值传递")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    //  父视图设置环境值
                    EnvironmentParentView()
                }
                .padding()
                .background(.blue.opacity(0.1))
                .cornerRadius(10)
                
                //  偏好设置
                VStack {
                    Text("3. 偏好设置")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    VStack(spacing: 10) {
                        Text("字体大小: \(fontSize, specifier: "%.0f")")
                        Slider(value: $fontSize, in: 12...24)
                        
                        Toggle("暗黑模式", isOn: $isDarkMode)
                    }
                    .padding()
                    .background(.white)
                    .cornerRadius(10)
                    .shadow(radius: 2)
                }
                .padding()
                .background(.green.opacity(0.1))
                .cornerRadius(10)
                
                //  自定义环境值
                VStack {
                    Text("4. 自定义环境值")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    CustomEnvironmentParentView()
                }
                .padding()
                .background(.yellow.opacity(0.1))
                .cornerRadius(10)
                
                //  环境修饰符
                VStack {
                    Text("5. 环境修饰符")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    VStack {
                        Text("这个文本使用默认字体")
                        
                        //  局部覆盖环境值
                        Text("这个文本使用自定义字体")
                            .environment(\.font, .system(size: 20, weight: .bold))
                    }
                    .padding()
                    .background(.white)
                    .cornerRadius(10)
                    .shadow(radius: 2)
                }
                .padding()
                .background(.purple.opacity(0.1))
                .cornerRadius(10)
                
                //  场景值
                VStack {
                    Text("6. 场景值")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text("场景值用于访问系统级别的功能")
                        .font(.body)
                    
                    //  示例：使用场景值打开设置
                    Button("打开设置") {
                        //  在实际应用中，这里会使用UIApplication.shared.open来打开设置
                        print("打开设置")
                    }
                    .padding()
                    .background(.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding()
                .background(.red.opacity(0.1))
                .cornerRadius(10)
            }
            .padding()
        }
    }
}

//  环境父视图
struct EnvironmentParentView: View {
    //  设置环境值
    @State private var themeColor = Color.blue
    
    var body: some View {
        VStack {
            Text("父视图设置的主题色: \(themeColor.description)")
                .font(.headline)
            
            //  传递环境值给子视图
            EnvironmentChildView()
        }
        .environment(\.themeColor, themeColor)
    }
}

//  环境子视图
struct EnvironmentChildView: View {
    //  读取环境值
    @Environment(\.themeColor) private var themeColor
    
    var body: some View {
        Text("子视图读取的主题色: \(themeColor.description)")
            .foregroundColor(themeColor)
            .padding()
            .background(themeColor.opacity(0.1))
            .cornerRadius(10)
    }
}

//  自定义环境值
private struct ThemeColorKey: EnvironmentKey {
    static let defaultValue: Color = .blue
}

extension EnvironmentValues {
    var themeColor: Color {
        get { self[ThemeColorKey.self] }
        set { self[ThemeColorKey.self] = newValue }
    }
}

//  自定义环境父视图
struct CustomEnvironmentParentView: View {
    @State private var customColor = Color.green
    
    var body: some View {
        VStack {
            Text("自定义环境值示例")
                .font(.headline)
            
            CustomEnvironmentChildView()
        }
        .environment(\.themeColor, customColor)
    }
}

//  自定义环境子视图
struct CustomEnvironmentChildView: View {
    @Environment(\.themeColor) private var themeColor
    
    var body: some View {
        Text("使用自定义环境值")
            .padding()
            .background(themeColor)
            .foregroundColor(.white)
            .cornerRadius(10)
    }
}

#Preview {
    EnvironmentAndPreferencesDemo()
}