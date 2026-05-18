//
//  FormsAndSettings.swift
//  swiftUIDemo
//
//  表单与设置界面示例
//

import SwiftUI

//  表单与设置界面示例
struct FormsAndSettingsDemo: View {
    //  状态管理
    @State private var name = ""
    @State private var email = ""
    @State private var age = 18
    @State private var isSubscribed = false
    @State private var favoriteColor = "红色"
    @State private var notificationsEnabled = true
    @State private var darkModeEnabled = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                //  标题
                Text("表单与设置界面")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                
                //  基本表单
                VStack {
                    Text("1. 基本表单")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Form {
                        Section(header: Text("个人信息")) {
                            TextField("姓名", text: $name)
                            TextField("邮箱", text: $email)
                                .keyboardType(.emailAddress)
                            Stepper("年龄: \(age)", value: $age, in: 0...100)
                        }
                        
                        Section(header: Text("偏好设置")) {
                            Toggle("订阅通讯", isOn: $isSubscribed)
                            Picker("最喜欢的颜色", selection: $favoriteColor) {
                                Text("红色").tag("红色")
                                Text("蓝色").tag("蓝色")
                                Text("绿色").tag("绿色")
                                Text("黄色").tag("黄色")
                            }
                        }
                    }
                    .frame(height: 300)
                    .cornerRadius(10)
                }
                .padding()
                .background(.gray.opacity(0.1))
                .cornerRadius(10)
                
                //  设置界面
                VStack {
                    Text("2. 设置界面")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        SettingRow(title: "通知", isOn: $notificationsEnabled)
                        SettingRow(title: "深色模式", isOn: $darkModeEnabled)
                        
                        Divider()
                        
                        NavigationLink("账户设置") {
                            AccountSettingsView()
                        }
                        .foregroundColor(.blue)
                        
                        NavigationLink("隐私设置") {
                            PrivacySettingsView()
                        }
                        .foregroundColor(.blue)
                        
                        NavigationLink("关于") {
                            AboutView()
                        }
                        .foregroundColor(.blue)
                    }
                    .padding()
                    .background(.white)
                    .cornerRadius(10)
                    .shadow(radius: 2)
                }
                .padding()
                .background(.blue.opacity(0.1))
                .cornerRadius(10)
                
                //  复杂表单
                VStack {
                    Text("3. 复杂表单")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Form {
                        Section(header: Text("联系信息")) {
                            TextField("姓名", text: $name)
                            TextField("邮箱", text: $email)
                            TextField("电话", text: .constant(""))
                        }
                        
                        Section(header: Text("地址信息")) {
                            TextField("街道", text: .constant(""))
                            TextField("城市", text: .constant(""))
                            TextField("省份", text: .constant(""))
                            TextField("邮编", text: .constant(""))
                        }
                        
                        Section {
                            Button("保存") {
                                print("保存表单")
                            }
                            .foregroundColor(.blue)
                        }
                    }
                    .frame(height: 400)
                    .cornerRadius(10)
                }
                .padding()
                .background(.green.opacity(0.1))
                .cornerRadius(10)
                
                //  表单验证
                VStack {
                    Text("4. 表单验证")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    VStack(spacing: 10) {
                        TextField("输入邮箱", text: $email)
                            .padding()
                            .border(email.contains("@") ? .green : .red, width: 1)
                            .cornerRadius(5)
                        
                        if !email.isEmpty && !email.contains("@") {
                            Text("请输入有效的邮箱地址")
                                .foregroundColor(.red)
                                .font(.caption)
                        }
                        
                        Button("提交") {
                            print("提交表单")
                        }
                        .padding()
                        .background(email.contains("@") ? .blue : .gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .disabled(!email.contains("@"))
                    }
                    .padding()
                    .background(.white)
                    .cornerRadius(10)
                    .shadow(radius: 2)
                }
                .padding()
                .background(.yellow.opacity(0.1))
                .cornerRadius(10)
            }
            .padding()
        }
    }
}

//  设置行视图
struct SettingRow: View {
    let title: String
    @Binding var isOn: Bool
    
    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Toggle("", isOn: $isOn)
                .labelsHidden()
        }
    }
}

//  账户设置视图
struct AccountSettingsView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("账户设置")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("这里是账户设置页面")
                .font(.body)
        }
        .padding()
        .navigationTitle("账户设置")
    }
}

//  隐私设置视图
struct PrivacySettingsView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("隐私设置")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("这里是隐私设置页面")
                .font(.body)
        }
        .padding()
        .navigationTitle("隐私设置")
    }
}

//  关于视图
struct AboutView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("关于")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("SwiftUI Demo App")
                .font(.headline)
            Text("版本 1.0.0")
                .font(.body)
                .foregroundColor(.gray)
        }
        .padding()
        .navigationTitle("关于")
    }
}

#Preview {
    FormsAndSettingsDemo()
}