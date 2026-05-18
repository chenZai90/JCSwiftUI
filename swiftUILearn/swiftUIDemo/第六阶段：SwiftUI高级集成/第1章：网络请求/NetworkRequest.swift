//
//  NetworkRequest.swift
//  swiftUIDemo
//
//  网络请求示例
//

import SwiftUI

//  网络请求示例
struct NetworkRequestDemo: View {
    //  使用@StateObject创建视图模型
    @StateObject private var viewModel = NetworkViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                //  标题
                Text("网络请求")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                
                //  数据加载状态
                VStack {
                    Text("1. 数据加载状态")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    if viewModel.isLoading {
                        ProgressView("加载中...")
                    } else if let error = viewModel.error {
                        Text("错误: \(error)")
                            .foregroundColor(.red)
                    } else if let data = viewModel.data {
                        Text("加载成功: \(data)")
                            .foregroundColor(.green)
                    } else {
                        Text("点击按钮开始加载")
                    }
                    
                    Button("加载数据") {
                        viewModel.fetchData()
                    }
                    .padding()
                    .background(.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding()
                .background(.gray.opacity(0.1))
                .cornerRadius(10)
                
                //  网络图片加载
                VStack {
                    Text("2. 网络图片加载")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    if viewModel.isLoadingImage {
                        ProgressView("加载图片中...")
                    } else if let image = viewModel.image {
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .cornerRadius(10)
                    } else {
                        Text("点击按钮加载图片")
                    }
                    
                    Button("加载图片") {
                        viewModel.fetchImage()
                    }
                    .padding()
                    .background(.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding()
                .background(.blue.opacity(0.1))
                .cornerRadius(10)
                
                //  POST请求
                VStack {
                    Text("3. POST请求")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    TextField("输入名称", text: $viewModel.name)
                        .padding()
                        .border(.gray, width: 1)
                        .cornerRadius(5)
                    
                    if viewModel.isPosting {
                        ProgressView("提交中...")
                    } else if let postResult = viewModel.postResult {
                        Text("提交成功: \(postResult)")
                            .foregroundColor(.green)
                    }
                    
                    Button("提交数据") {
                        viewModel.postData()
                    }
                    .padding()
                    .background(.purple)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding()
                .background(.green.opacity(0.1))
                .cornerRadius(10)
            }
            .padding()
        }
    }
}

//  网络视图模型
class NetworkViewModel: ObservableObject {
    //  发布的属性
    @Published var isLoading = false
    @Published var error: String? = nil
    @Published var data: String? = nil
    @Published var isLoadingImage = false
    @Published var image: Image? = nil
    @Published var name = ""
    @Published var isPosting = false
    @Published var postResult: String? = nil
    
    //  模拟GET请求
    func fetchData() {
        isLoading = true
        error = nil
        data = nil
        
        //  模拟网络延迟
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            //  模拟成功响应
            self.data = "这是从服务器获取的数据"
            self.isLoading = false
        }
    }
    
    //  模拟图片加载
    func fetchImage() {
        isLoadingImage = true
        image = nil
        
        //  模拟网络延迟
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            //  使用系统图标作为模拟图片
            self.image = Image(systemName: "photo.fill")
            self.isLoadingImage = false
        }
    }
    
    //  模拟POST请求
    func postData() {
        isPosting = true
        postResult = nil
        
        //  模拟网络延迟
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            //  模拟成功响应
            self.postResult = "名称: \(self.name) 已提交"
            self.isPosting = false
        }
    }
}

#Preview {
    NetworkRequestDemo()
}
