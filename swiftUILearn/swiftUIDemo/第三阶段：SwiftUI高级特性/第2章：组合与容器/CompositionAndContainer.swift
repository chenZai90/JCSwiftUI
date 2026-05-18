//
//  CompositionAndContainer.swift
//  swiftUIDemo
//
//  组合与容器示例
//

import SwiftUI

//  组合与容器示例
struct CompositionAndContainerDemo: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                //  标题
                Text("组合与容器")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                
                //  视图组合
                VStack {
                    Text("1. 视图组合")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    //  组合多个子视图
                    UserProfileView(
                        name: "张三",
                        avatar: "person.fill",
                        bio: "SwiftUI开发者",
                        followers: 1234,
                        following: 567
                    )
                }
                .padding()
                .background(.gray.opacity(0.1))
                .cornerRadius(10)
                
                //  容器视图
                VStack {
                    Text("2. 容器视图")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    //  自定义容器
                    FeatureContainer {
                        FeatureItem(title: "功能1", icon: "star.fill")
                        FeatureItem(title: "功能2", icon: "heart.fill")
                        FeatureItem(title: "功能3", icon: "bolt.fill")
                    }
                }
                .padding()
                .background(.blue.opacity(0.1))
                .cornerRadius(10)
                
                //  条件组合
                VStack {
                    Text("3. 条件组合")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    ConditionalView(isLoggedIn: true) { LoggedInView() }
                    ConditionalView(isLoggedIn: false) { LoggedOutView() }
                }
                .padding()
                .background(.green.opacity(0.1))
                .cornerRadius(10)
                
                //  列表组合
                VStack {
                    Text("4. 列表组合")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    ItemListView(items: [
                        "项目1", "项目2", "项目3", "项目4", "项目5"
                    ])
                }
                .padding()
                .background(.yellow.opacity(0.1))
                .cornerRadius(10)
                
                //  表单组合
                VStack {
                    Text("5. 表单组合")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    UserForm()
                }
                .padding()
                .background(.purple.opacity(0.1))
                .cornerRadius(10)
                
                //  导航组合
                VStack {
                    Text("6. 导航组合")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    NavigationLink("查看详情") {
                        CompDetailView()
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

//  用户资料视图
struct UserProfileView: View {
    let name: String
    let avatar: String
    let bio: String
    let followers: Int
    let following: Int
    
    var body: some View {
        VStack(spacing: 15) {
            //  头像
            Image(systemName: avatar)
                .font(.system(size: 60))
                .foregroundColor(.blue)
            
            //  姓名
            Text(name)
                .font(.title)
                .fontWeight(.bold)
            
            //  简介
            Text(bio)
                .font(.subheadline)
                .foregroundColor(.gray)
            
            //  统计信息
            HStack(spacing: 30) {
                VStack {
                    Text("\(followers)")
                        .font(.headline)
                        .fontWeight(.bold)
                    Text("粉丝")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                VStack {
                    Text("\(following)")
                        .font(.headline)
                        .fontWeight(.bold)
                    Text("关注")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
        }
        .padding()
        .background(.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

//  特性容器
struct FeatureContainer<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("特性列表")
                .font(.headline)
                .fontWeight(.bold)
            
            HStack(spacing: 20) {
                content
            }
        }
        .padding()
        .background(.white)
        .cornerRadius(10)
        .shadow(radius: 3)
    }
}

//  特性项
struct FeatureItem: View {
    let title: String
    let icon: String
    
    var body: some View {
        VStack {
            Image(systemName: icon)
                .font(.title)
                .foregroundColor(.blue)
            Text(title)
                .font(.subheadline)
        }
        .padding()
        .background(.gray.opacity(0.1))
        .cornerRadius(10)
    }
}

//  条件视图
struct ConditionalView<Content: View>: View {
    let isLoggedIn: Bool
    let content: Content
    
    init(isLoggedIn: Bool, @ViewBuilder content: () -> Content) {
        self.isLoggedIn = isLoggedIn
        self.content = content()
    }
    
    var body: some View {
        VStack {
            Text(isLoggedIn ? "已登录状态" : "未登录状态")
                .font(.headline)
                .fontWeight(.semibold)
            content
        }
        .padding()
        .background(isLoggedIn ? .green.opacity(0.1) : .red.opacity(0.1))
        .cornerRadius(10)
    }
}

//  已登录视图
struct LoggedInView: View {
    var body: some View {
        Text("欢迎回来！")
            .foregroundColor(.green)
    }
}

//  未登录视图
struct LoggedOutView: View {
    var body: some View {
        Text("请先登录")
            .foregroundColor(.red)
    }
}

//  项目列表视图
struct ItemListView: View {
    let items: [String]
    
    var body: some View {
        List {
            ForEach(items, id: \.self) {
                Text($0)
                    .font(.body)
            }
        }
        .frame(height: 200)
        .cornerRadius(10)
    }
}

//  用户表单
struct UserForm: View {
    @State private var name = ""
    @State private var email = ""
    
    var body: some View {
        Form {
            Section(header: Text("个人信息")) {
                TextField("姓名", text: $name)
                TextField("邮箱", text: $email)
                    .keyboardType(.emailAddress)
            }
            
            Section {
                Button("提交") {
                    print("提交表单")
                }
            }
        }
        .frame(height: 200)
        .cornerRadius(10)
    }
}

//  详情视图
struct CompDetailView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("详情页面")
                .font(.largeTitle)
                .fontWeight(.bold)
            Text("这是一个详情页面，通过导航链接打开")
                .font(.body)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}

#Preview {
    CompositionAndContainerDemo()
}