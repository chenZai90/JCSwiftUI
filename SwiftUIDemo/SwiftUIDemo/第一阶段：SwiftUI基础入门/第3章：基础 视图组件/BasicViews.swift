//
//  BasicViews.swift
//  swiftUIDemo
//
//  基础视图组件示例
//

import SwiftUI

//  基础视图组件示例
struct BasicViewsDemo: View {
    //  状态变量
    @State private var text = ""
    @State private var password = ""
    @State private var message = ""
    @State private var isEnabled = false
    @State private var showPassword = false
    @State private var selectedOption = "选项1"
    @State private var selectedColor = Color.red
    @State private var sliderValue = 0.5
    @State private var intValue = 5
    @State private var count = 0
    @State private var progress = 0.0
    
    //  选择器选项
    let options = ["选项1", "选项2", "选项3"]
    let colors: [Color] = [.red, .green, .blue, .yellow]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                //  标题
                Text("基础视图组件")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                
                //  3.1 文本显示：Text
                VStack {
                    Text("3.1 文本显示：Text")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    //  基本文本
                    Text("Hello, SwiftUI!")
                        .padding()
                    
                    //  带样式的文本
                    Text("Hello, SwiftUI!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                        .italic()
                        .underline()
                        .strikethrough()
                        .padding()
                    
                    //  富文本
                    Text("Hello, \(Text("SwiftUI").foregroundColor(.blue).bold())!")
                        .padding()
                    
                    //  多行文本
                    Text("这是一段多行文本，\n可以通过反斜杠 n 来换行，\n或者直接在字符串中换行。")
                        .multilineTextAlignment(.center)
                        .lineLimit(3)
                        .truncationMode(.tail)
                        .padding()
                    
                    //  日期和数字格式化
                    let date = Date()
                    let number = 123456.789
                    
                    VStack(spacing: 8) {
                        Text("日期格式化：")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        Text(date, style: .date)
                        Text(date, style: .time)
                        Text(date, style: .relative)
                        
                        Text("\n数字格式化：")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        Text(number, format: .number)
                        Text(number, format: .currency(code: "CNY"))
                        Text(number, format: .percent)
                    }
                    .padding()
                }
                .padding()
                .background(.gray.opacity(0.1))
                .cornerRadius(10)
                
                //  3.2 图片显示：Image
                VStack {
                    Text("3.2 图片显示：Image")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    //  系统图标
                    HStack(spacing: 20) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                            .font(.system(size: 32))
                        
                        Image(systemName: "heart.fill")
                            .foregroundColor(.red)
                            .font(.system(size: 32))
                        
                        Image(systemName: "person.fill.badge.plus")
                            .symbolRenderingMode(.multicolor)
                            .font(.system(size: 32))
                    }
                    .padding()
                    
                    //  图片修饰符示例
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(Color.blue, lineWidth: 2)
                        )
                        .shadow(radius: 5)
                        .opacity(0.8)
                        .padding()
                }
                .padding()
                .background(.blue.opacity(0.1))
                .cornerRadius(10)
                
                //  3.3 按钮交互：Button
                VStack {
                    Text("3.3 按钮交互：Button")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    //  基本按钮
                    Button("点击我") {
                        print("按钮被点击了")
                    }
                    .padding()
                    
                    //  带图标的按钮
                    Button {
                        print("按钮被点击了")
                    } label: {
                        HStack {
                            Image(systemName: "star.fill")
                            Text("喜欢")
                        }
                    }
                    .padding()
                    
                    //  带角色的按钮
                    Button("删除", role: .destructive) {
                        print("删除操作")
                    }
                    .padding()
                    
                    //  按钮样式
                    HStack(spacing: 10) {
                        Button("边框按钮") {
                            // 操作
                        }
                        .buttonStyle(.bordered)
                        
                        Button("突出按钮") {
                            // 操作
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.blue)
                        
                        Button("文本按钮") {
                            // 操作
                        }
                        .buttonStyle(.plain)
                    }
                    .padding()
                    
                    //  禁用状态
                    Button("禁用按钮") {
                        // 操作
                    }
                    .disabled(!isEnabled)
                    .opacity(isEnabled ? 1.0 : 0.5)
                    .padding()
                    
                    Toggle("启用按钮", isOn: $isEnabled)
                        .padding()
                }
                .padding()
                .background(.green.opacity(0.1))
                .cornerRadius(10)
                
                //  3.4 输入控件
                VStack {
                    Text("3.4 输入控件")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    //  TextField 文本输入框
                    TextField("请输入文本", text: $text)
                        .textFieldStyle(.roundedBorder)
                        .padding()
                    
                    //  带提示的 TextField
                    TextField(
                        "请输入用户名",
                        text: $text,
                        prompt: Text("用户名不能为空")
                            .foregroundColor(.secondary)
                    )
                    .textFieldStyle(.roundedBorder)
                    .padding()
                    
                    //  SecureField 安全输入框
                    SecureField("请输入密码", text: $password)
                        .textFieldStyle(.roundedBorder)
                        .padding()
                    
                    //  带可见性切换的密码输入
                    ZStack(alignment: .trailing) {
                        if showPassword {
                            TextField("请输入密码", text: $password)
                        } else {
                            SecureField("请输入密码", text: $password)
                        }
                        Button(action: {
                            showPassword.toggle()
                        }) {
                            Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                                .foregroundColor(.secondary)
                                .padding(.trailing, 8)
                        }
                    }
                    .textFieldStyle(.roundedBorder)
                    .padding()
                    
                    //  TextEditor 多行文本编辑器
                    TextEditor(text: $message)
                        .frame(height: 150)
                        .border(Color.gray.opacity(0.3), width: 1)
                        .cornerRadius(8)
                        .padding()
                }
                .padding()
                .background(.yellow.opacity(0.1))
                .cornerRadius(10)
                
                //  3.5 开关与选择
                VStack {
                    Text("3.5 开关与选择")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    //  Toggle 开关
                    Toggle("启用功能", isOn: $isEnabled)
                        .toggleStyle(.switch)
                        .padding()
                    
                    //  带图标的 Toggle
                    Toggle(isOn: $isEnabled) {
                        HStack {
                            Image(systemName: "bell.fill")
                            Text("接收通知")
                        }
                    }
                    .toggleStyle(.switch)
                    .padding()
                    
                    //  Picker 选择器
                    Picker("选择", selection: $selectedOption) {
                        ForEach(options, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding()
                    
                    //  菜单样式 Picker
                    Picker("选择", selection: $selectedOption) {
                        ForEach(options, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.menu)
                    .padding()
                    
                    //  Slider 滑块
                    Slider(value: $sliderValue, in: 0...1)
                        .padding()
                        .tint(.blue)
                    
                    //  带标签的滑块
                    Slider(
                        value: $sliderValue,
                        in: 0...1,
                        label: { Text("亮度") },
                        minimumValueLabel: { Text("暗") },
                        maximumValueLabel: { Text("亮") }
                    )
                    .padding()
                    
                    //  整数滑块
                    Slider(value: Binding(
                        get: { Double(intValue) },
                        set: { intValue = Int($0) }
                    ), in: 0...10, step: 1)
                    .padding()
                    Text("值：\(intValue)")
                    
                    //  Stepper 步进器
                    Stepper("数量：\(count)", value: $count)
                        .padding()
                    
                    //  带范围的步进器
                    Stepper(
                        "数量：\(count)",
                        value: $count,
                        in: 0...10,
                        step: 2
                    )
                    .padding()
                }
                .padding()
                .background(.purple.opacity(0.1))
                .cornerRadius(10)
                
                //  3.6 进度指示：ProgressView
                VStack {
                    Text("3.6 进度指示：ProgressView")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    //  不确定进度
                    ProgressView()
                        .padding()
                    
                    //  带标签的进度指示器
                    ProgressView("加载中...")
                        .padding()
                    
                    //  确定进度
                    ProgressView("下载进度", value: progress, total: 1.0)
                        .padding()
                    
                    //  带百分比的进度条
                    ProgressView(
                        value: progress,
                        total: 1.0,
                        label: { Text("下载进度") },
                        currentValueLabel: { Text("\(Int(progress * 100))%") }
                    )
                    .padding()
                    
                    //  水平进度条样式
                    ProgressView(value: progress, total: 1.0)
                        .progressViewStyle(.linear)
                        .tint(.green)
                        .frame(height: 10)
                        .padding()
                    
                    //  进度控制按钮
                    Button("开始下载") {
                        //  模拟下载进度
                        withAnimation(.linear(duration: 2.0)) {
                            progress = 1.0
                        }
                    }
                    .padding()
                    
                    Button("重置进度") {
                        progress = 0.0
                    }
                    .padding()
                }
                .padding()
                .background(.orange.opacity(0.1))
                .cornerRadius(10)
                
                //  实战：创建一个用户设置页面
                VStack {
                    Text("实战：创建一个用户设置页面")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    NavigationLink(destination: SettingsView()) {
                        Text("查看设置页面")
                            .foregroundColor(.blue)
                            .underline()
                    }
                    .padding()
                }
                .padding()
                .background(.teal.opacity(0.1))
                .cornerRadius(10)
            }
            .padding()
        }
    }
}

/// 颜色选择器视图
struct ColorPickerView: View {
    let color: Color
    var body: some View {
        HStack {
            Rectangle()
                .fill(color)
                .frame(width: 20, height: 20)
                .cornerRadius(4)
            Text(String(describing: color))
        }
    }
}

/// 设置页面视图
struct SettingsView: View {
    // 状态变量
    @State private var notificationsEnabled = true
    @State private var selectedTheme = "浅色"
    @State private var fontSize = 16.0
    @State private var cacheSize = "128 MB"
    
    // 主题选项
    let themes = ["浅色", "深色", "跟随系统"]
    
    var body: some View {
        if #available(iOS 16.0, *) {
            NavigationStack {
                List {
                    // 个人信息区域
                    Section {
                        HStack {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 60, height: 60)
                                .foregroundColor(.blue)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("张三")
                                    .font(.headline)
                                Text("zhangsan@example.com")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 8)
                    }
                    
                    // 通知设置
                    Section("通知设置") {
                        Toggle("接收推送通知", isOn: $notificationsEnabled)
                        Toggle("声音提醒", isOn: $notificationsEnabled)
                        Toggle("振动提醒", isOn: $notificationsEnabled)
                    }
                    
                    // 外观设置
                    Section("外观设置") {
                        Picker("主题", selection: $selectedTheme) {
                            ForEach(themes, id: \.self) {
                                Text($0)
                            }
                        }
                        .pickerStyle(.menu)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("字体大小：\(Int(fontSize))")
                            Slider(value: $fontSize, in: 12...24, step: 1)
                                .tint(.blue)
                        }
                    }
                    
                    // 存储设置
                    Section("存储设置") {
                        HStack {
                            Text("缓存大小")
                            Spacer()
                            Text(cacheSize)
                                .foregroundColor(.secondary)
                        }
                        Button("清除缓存") {
                            // 清除缓存逻辑
                            print("清除缓存")
                        }
                        .foregroundColor(.blue)
                    }
                    
                    // 账户设置
                    Section {
                        Button("关于我们") {
                            // 关于我们逻辑
                        }
                        Button("隐私政策") {
                            // 隐私政策逻辑
                        }
                        Button("退出登录", role: .destructive) {
                            // 退出登录逻辑
                        }
                    }
                }
                .navigationTitle("设置")
                .navigationBarTitleDisplayMode(.inline)
            }
        } else {
            // Fallback on earlier versions
        }
    }
}

#Preview {
    BasicViewsDemo()
}
