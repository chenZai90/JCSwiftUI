//
//  AdvancedThemeSystem.swift
//  swiftUIDemo
//
//  高级主题系统示例 - 包含完整的主题系统实现
//

import SwiftUI

// MARK: - 1. 主题数据模型定义

// 主题数据模型
struct AppTheme: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let primaryColor: Color
    let secondaryColor: Color
    let backgroundColor: Color
    let textColor: Color
    let accentColor: Color
    let isDarkMode: Bool
    
    // 预设主题集合
    static let light = AppTheme(
        name: "浅色",
        primaryColor: .blue,
        secondaryColor: .gray,
        backgroundColor: .white,
        textColor: .black,
        accentColor: .orange,
        isDarkMode: false
    )
    
    static let dark = AppTheme(
        name: "深色",
        primaryColor: .blue,
        secondaryColor: .gray,
        backgroundColor: .black,
        textColor: .white,
        accentColor: .orange,
        isDarkMode: true
    )
    
    static let blue = AppTheme(
        name: "蓝色",
        primaryColor: .blue,
        secondaryColor: .indigo,
        backgroundColor: Color(red: 0.95, green: 0.95, blue: 1.0),
        textColor: .blue,
        accentColor: .purple,
        isDarkMode: false
    )
    
    static let green = AppTheme(
        name: "绿色",
        primaryColor: .green,
        secondaryColor: .teal,
        backgroundColor: Color(red: 0.9, green: 0.98, blue: 0.92),
        textColor: .green,
        accentColor: .mint,
        isDarkMode: false
    )
    
    static let purple = AppTheme(
        name: "紫色",
        primaryColor: .purple,
        secondaryColor: .pink,
        backgroundColor: Color(red: 0.98, green: 0.95, blue: 1.0),
        textColor: .purple,
        accentColor: .pink,
        isDarkMode: false
    )
    
    // 所有预设主题
    static let allThemes = [light, dark, blue, green, purple]
}

// 主题管理器
class ThemeManager: ObservableObject {
    static let shared = ThemeManager()
    
    @Published var currentTheme: AppTheme
    
    private init() {
        // 从UserDefaults加载保存的主题
        if let savedTheme = UserDefaults.standard.string(forKey: "app_theme"),
           let theme = AppTheme.allThemes.first(where: { $0.name == savedTheme }) {
            self.currentTheme = theme
        } else {
            self.currentTheme = .light
        }
    }
    
    // 切换主题
    func switchTheme(to theme: AppTheme) {
        withAnimation(.easeInOut) {
            currentTheme = theme
            // 保存主题选择
            UserDefaults.standard.set(theme.name, forKey: "app_theme")
        }
    }
    
    // 快速切换到暗色/浅色
    func toggleDarkMode() {
        if currentTheme.isDarkMode {
            switchTheme(to: .light)
        } else {
            switchTheme(to: .dark)
        }
    }
}

// MARK: - 2. 主题环境键
struct AppThemeKey: EnvironmentKey {
    static let defaultValue = AppTheme.light
}

extension EnvironmentValues {
    var appTheme: AppTheme {
        get { self[AppThemeKey.self] }
        set { self[AppThemeKey.self] = newValue }
    }
}

// MARK: - 3. 自定义主题修饰符

// 主题背景修饰符
struct ThemedBackground: ViewModifier {
    let theme: AppTheme
    
    func body(content: Content) -> some View {
        content
            .background(theme.backgroundColor)
    }
}

// 主题文本修饰符
struct ThemedText: ViewModifier {
    let theme: AppTheme
    
    func body(content: Content) -> some View {
        content
            .foregroundColor(theme.textColor)
    }
}

// 主题按钮修饰符
struct ThemedButton: ViewModifier {
    let theme: AppTheme
    
    func body(content: Content) -> some View {
        content
            .foregroundColor(.white)
            .padding()
            .background(theme.primaryColor)
            .cornerRadius(10)
    }
}

// 主题卡片修饰符
struct ThemedCard: ViewModifier {
    let theme: AppTheme
    
    func body(content: Content) -> some View {
        content
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.white)
                    .shadow(color: .gray.opacity(0.2),
                    radius: 5,
                    x: 0,
                    y: 2)
            )
            .cornerRadius(15)
    }
}

// 便捷View扩展
extension View {
    func themedBackground(_ theme: AppTheme) -> some View {
        self.modifier(ThemedBackground(theme: theme))
    }
    
    func themedText(_ theme: AppTheme) -> some View {
        self.modifier(ThemedText(theme: theme))
    }
    
    func themedButton(_ theme: AppTheme) -> some View {
        self.modifier(ThemedButton(theme: theme))
    }
    
    func themedCard(_ theme: AppTheme) -> some View {
        self.modifier(ThemedCard(theme: theme))
    }
}

// MARK: - 4. 主题选择视图
struct ThemeSelectorView: View {
    @Environment(\.appTheme) private var currentTheme
    @StateObject private var themeManager = ThemeManager.shared
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // 标题
                Text("主题选择")
                    .font(.title)
                    .fontWeight(.bold)
                    .themedText(currentTheme)
                
                // 主题选择器
                VStack(alignment: .leading, spacing: 12) {
                    Text("选择您偏好的主题")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                        ForEach(AppTheme.allThemes) { theme in
                            ThemeCard(theme: theme, isSelected: currentTheme.id == theme.id) {
                                themeManager.switchTheme(to: theme)
                            }
                        }
                    }
                }
                .padding()
                .themedCard(currentTheme)
                
                // 快速切换
                Divider()
                    .padding(.horizontal)
                
                // 主题预览
                ATThemePreviewView()
                    .padding()
                    .themedCard(currentTheme)
                
                // 自定义主题
                ThemeCustomizationView()
                    .padding()
                    .themedCard(currentTheme)
                
                Spacer()
            }
            .padding()
            .themedBackground(currentTheme)
        }
        .navigationTitle("主题系统")
    }
}

// 主题卡片
struct ThemeCard: View {
    let theme: AppTheme
    let isSelected: Bool
    let onSelect: () -> Void
    
    var body: some View {
        VStack(spacing: 8) {
            // 主题颜色预览
            HStack(spacing: 4) {
                Circle()
                    .fill(theme.primaryColor)
                    .frame(width: 24, height: 24)
                Circle()
                    .fill(theme.accentColor)
                    .frame(width: 24, height: 24)
                Circle()
                    .fill(theme.backgroundColor)
                    .frame(width: 24, height: 24)
                    .overlay(
                        Circle().stroke(Color.gray, lineWidth: 1)
                    )
            }
            
            Text(theme.name)
                .font(.caption)
                .fontWeight(.medium)
            
            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(isSelected ? Color.blue.opacity(0.1) : Color.clear)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(isSelected ? Color.blue : Color.gray.opacity(0.3))
        )
        .onTapGesture {
            onSelect()
        }
    }
}

// 主题预览视图
struct ATThemePreviewView: View {
    @Environment(\.appTheme) private var currentTheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("主题预览")
                .font(.headline)
                .fontWeight(.bold)
            
            // 按钮预览
            HStack(spacing: 12) {
                Button("按钮1") {}
                    .font(.headline)
                    .themedButton(currentTheme)
                
                Button("按钮2") {}
                    .font(.headline)
                    .themedButton(currentTheme)
                
                Spacer()
            }
            
            // 卡片预览
            VStack(alignment: .leading, spacing: 8) {
                Text("卡片标题")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Text("这是卡片的内容文本，展示在当前主题下的显示效果。")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Divider()
                
                HStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(.secondary)
                    Text("已收藏")
                        .foregroundColor(.secondary)
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(8)
        }
    }
}

// 自定义主题视图
struct ThemeCustomizationView: View {
    @Environment(\.appTheme) private var currentTheme
    @StateObject private var themeManager = ThemeManager.shared
    @State private var customTheme = AppTheme(
        name: "自定义",
        primaryColor: .blue,
        secondaryColor: .gray,
        backgroundColor: .white,
        textColor: .black,
        accentColor: .orange,
        isDarkMode: false
    )
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("自定义主题")
                .font(.headline)
                .fontWeight(.bold)
            
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("主色调")
                    Spacer()
                    ColorPicker("", selection: Binding(get: { customTheme.primaryColor }, set: { customTheme = AppTheme(name: "自定义", primaryColor: $0, secondaryColor: customTheme.secondaryColor, backgroundColor: customTheme.backgroundColor, textColor: customTheme.textColor, accentColor: customTheme.accentColor, isDarkMode: customTheme.isDarkMode) }))
                }
                
                HStack {
                    Text("次色调")
                    Spacer()
                    ColorPicker("", selection: Binding(get: { customTheme.secondaryColor }, set: { customTheme = AppTheme(name: "自定义", primaryColor: customTheme.primaryColor, secondaryColor: $0, backgroundColor: customTheme.backgroundColor, textColor: customTheme.textColor, accentColor: customTheme.accentColor, isDarkMode: customTheme.isDarkMode) }))
                }
                
                HStack {
                    Text("背景色")
                    Spacer()
                    ColorPicker("", selection: Binding(get: { customTheme.backgroundColor }, set: { customTheme = AppTheme(name: "自定义", primaryColor: customTheme.primaryColor, secondaryColor: customTheme.secondaryColor, backgroundColor: $0, textColor: customTheme.textColor, accentColor: customTheme.accentColor, isDarkMode: customTheme.isDarkMode) }))
                }
                
                HStack {
                    Text("文字色")
                    Spacer()
                    ColorPicker("", selection: Binding(get: { customTheme.textColor }, set: { customTheme = AppTheme(name: "自定义", primaryColor: customTheme.primaryColor, secondaryColor: customTheme.secondaryColor, backgroundColor: customTheme.backgroundColor, textColor: $0, accentColor: customTheme.accentColor, isDarkMode: customTheme.isDarkMode) }))
                }
                
                HStack {
                    Text("强调色")
                    Spacer()
                    ColorPicker("", selection: Binding(get: { customTheme.accentColor }, set: { customTheme = AppTheme(name: "自定义", primaryColor: customTheme.primaryColor, secondaryColor: customTheme.secondaryColor, backgroundColor: customTheme.backgroundColor, textColor: customTheme.textColor, accentColor: $0, isDarkMode: customTheme.isDarkMode) }))
                }
            }
            
            Button(action: {
                themeManager.switchTheme(to: customTheme)
            }) {
                Text("应用自定义主题")
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(customTheme.primaryColor)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
    }
}

// MARK: - 5. 完整主题系统演示
struct ThemeSystemDemo: View {
    @StateObject private var themeManager = ThemeManager.shared
    
    var body: some View {
        TabView {
            ThemeSelectorView()
                .tabItem {
                    Label("主题选择", systemImage: "paintpalette")
                }
            
            ThemeDemoContentView()
                .tabItem {
                    Label("演示", systemImage: "eye")
                }
        }
        .environment(\.appTheme, themeManager.currentTheme)
        .preferredColorScheme(themeManager.currentTheme.isDarkMode ? .dark : .light)
    }
}

// 主题演示内容
struct ThemeDemoContentView: View {
    @Environment(\.appTheme) private var currentTheme
    @StateObject private var themeManager = ThemeManager.shared
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // 标题
                Text("主题系统演示")
                    .font(.title)
                    .fontWeight(.bold)
                    .themedText(currentTheme)
                
                // 当前主题信息
                VStack(alignment: .leading, spacing: 12) {
                    Text("当前主题信息")
                        .font(.headline)
                        .fontWeight(.bold)
                    
                    HStack {
                        Text("主题名称")
                        Spacer()
                        Text(currentTheme.name)
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("主色调")
                        Spacer()
                        Circle()
                            .fill(currentTheme.primaryColor)
                            .frame(width: 24, height: 24)
                    }
                    
                    HStack {
                        Text("背景色")
                        Spacer()
                        Circle()
                            .fill(currentTheme.backgroundColor)
                            .frame(width: 24, height: 24)
                            .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                    }
                }
                .padding()
                .themedCard(currentTheme)
                
                // 主题切换
                VStack(spacing: 16) {
                    Text("快速切换")
                        .font(.headline)
                        .fontWeight(.bold)
                    
                    Button("切换到深色模式") {
                        themeManager.switchTheme(to: .dark)
                    }
                    .themedButton(currentTheme)
                    
                    Button("切换到蓝色主题") {
                        themeManager.switchTheme(to: .blue)
                    }
                    .themedButton(currentTheme)
                    
                    Button("切换到绿色主题") {
                        themeManager.switchTheme(to: .green)
                    }
                    .themedButton(currentTheme)
                }
                .padding()
                .themedCard(currentTheme)
                
                // 组件展示
                VStack(spacing: 16) {
                    Text("组件展示")
                        .font(.headline)
                        .fontWeight(.bold)
                    
                    TextField("输入框", text: .constant(""))
                        .textFieldStyle(.roundedBorder)
                    
                    Toggle("开关", isOn: .constant(true))
                    
                    Toggle("开关", isOn: .constant(false))
                    
                    Picker("选择", selection: .constant("")) {
                        Text("选项1").tag("1")
                        Text("选项2").tag("2")
                        Text("选项3").tag("3")
                    }
                    .pickerStyle(.segmented)
                }
                .padding()
                .themedCard(currentTheme)
                
                Spacer()
            }
            .padding()
            .themedBackground(currentTheme)
        }
        .navigationTitle("主题演示")
    }
}

#Preview {
    ThemeSystemDemo()
}
