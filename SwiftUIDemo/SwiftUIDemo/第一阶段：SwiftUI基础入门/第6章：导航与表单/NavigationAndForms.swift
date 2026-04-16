import SwiftUI

/// 导航与表单示例
/// 本文件演示了SwiftUI中的导航和表单功能
@available(iOS 16.0, *)
struct NavigationAndForms: View {
    /// 导航到详情页
    @State private var showDetail = false
    /// 导航路径
    @State private var navigationPath = NavigationPath()
    /// 表单数据
    @State private var name = ""
    @State private var age = 18
    @State private var email = ""
    @State private var isSubscribed = false
    @State private var favoriteColor = "红色"
    @State private var colors = ["红色", "蓝色", "绿色", "黄色"]
    
    var body: some View {
        if #available(iOS 16.0, *) {
            NavigationStack(path: $navigationPath) {
                List {
                    Section("导航示例") {
                        /// 基本导航
                        NavigationLink("前往详情页", destination: NavDetailView())
                        
                        /// 条件导航
                        NavigationLink("条件导航", isActive: $showDetail) {
                            NavDetailView()
                        }
                        
                        /// 编程式导航
                        Button("编程式导航到详情页") {
                            navigationPath.append("detail")
                        }
                        
                        /// 多级导航
                        NavigationLink("多级导航", destination: Level1View())
                    }
                    
                    Section("表单示例") {
                        /// 文本输入
                        TextField("姓名", text: $name)
                        
                        /// 数字输入
                        Stepper("年龄: \(age)", value: $age, in: 0...120)
                        
                        /// 邮箱输入
                        TextField("邮箱", text: $email)
                            .keyboardType(.emailAddress)
                        
                        /// 开关
                        Toggle("订阅通知", isOn: $isSubscribed)
                        
                        /// 选择器
                        Picker("最喜欢的颜色", selection: $favoriteColor) {
                            ForEach(colors, id: \.self) {
                                Text($0)
                            }
                        }
                        
                        /// 提交按钮
                        Button("提交表单") {
                            print("姓名: \(name)")
                            print("年龄: \(age)")
                            print("邮箱: \(email)")
                            print("订阅: \(isSubscribed)")
                            print("最喜欢的颜色: \(favoriteColor)")
                        }
                    }
                }
                .navigationTitle("导航与表单")
                .navigationDestination(for: String.self) {
                    if $0 == "detail" {
                        NavDetailView()
                    }
                }
            }
        } else {
            // Fallback on earlier versions
        }
    }
}

/// 详情视图
struct NavDetailView: View {
    var body: some View {
        VStack {
            Text("详情页")
                .font(.largeTitle)
            Text("这是一个导航到的详情页")
                .padding()
            Spacer()
        }
        .navigationTitle("详情页")
    }
}

/// 第一级视图
struct Level1View: View {
    var body: some View {
        List {
            NavigationLink("前往第二级", destination: Level2View())
        }
        .navigationTitle("第一级")
    }
}

/// 第二级视图
struct Level2View: View {
    var body: some View {
        List {
            NavigationLink("前往第三级", destination: Level3View())
        }
        .navigationTitle("第二级")
    }
}

/// 第三级视图
struct Level3View: View {
    var body: some View {
        VStack {
            Text("第三级")
                .font(.largeTitle)
            Spacer()
        }
        .navigationTitle("第三级")
    }
}

/// 预览
struct NavigationAndForms_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 16.0, *) {
            NavigationAndForms()
        } else {
            // Fallback on earlier versions
        }
    }
}
