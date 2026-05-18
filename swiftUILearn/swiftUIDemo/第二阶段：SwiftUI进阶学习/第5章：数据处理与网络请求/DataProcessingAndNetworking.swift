//
//  DataProcessingAndNetworking.swift
//  swiftUIDemo
//
//  数据处理与网络请求示例
//

import SwiftUI

//  数据模型
struct Post: Identifiable, Decodable {
    let id: Int
    let title: String
    let body: String
    let userId: Int
}

//  数据处理与网络请求示例
struct DataProcessingAndNetworkingDemo: View {
    //  状态管理
    @State private var posts: [Post] = []
    @State private var isLoading = false
    @State private var errorMessage: String? = nil
    @State private var localData: [String] = ["本地数据1", "本地数据2", "本地数据3"]
    @State private var newData = ""
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                //  标题
                Text("数据处理与网络请求")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                
                //  本地数据处理
                VStack {
                    Text("1. 本地数据处理")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    HStack {
                        TextField("输入新数据", text: $newData)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                        
                        Button("添加") {
                            if !newData.isEmpty {
                                localData.append(newData)
                                newData = ""
                            }
                        }
                        .padding()
                        .background(.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    
                    List(localData, id: \.self) { item in
                        Text(item)
                    }
                    .frame(height: 200)
                }
                .padding()
                .background(.gray.opacity(0.1))
                .cornerRadius(10)
                
                //  网络请求
                VStack {
                    Text("2. 网络请求")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Button("获取数据") {
                        fetchPosts()
                    }
                    .padding()
                    .background(.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    
                    if isLoading {
                        ProgressView("加载中...")
                            .padding()
                    } else if let errorMessage = errorMessage {
                        Text("错误: \(errorMessage)")
                            .foregroundColor(.red)
                            .padding()
                    } else {
                        List(posts) { post in
                            VStack(alignment: .leading) {
                                Text(post.title)
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                Text(post.body)
                                    .font(.body)
                                    .foregroundColor(.gray)
                                    .lineLimit(2)
                            }
                        }
                        .frame(height: 300)
                    }
                }
                .padding()
                .background(.blue.opacity(0.1))
                .cornerRadius(10)
                
                //  数据过滤
                VStack {
                    Text("3. 数据过滤")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text("过滤后的本地数据:")
                        .font(.subheadline)
                    
                    List(localData.filter { $0.contains("1") }, id: \.self) {
                        Text($0)
                    }
                    .frame(height: 150)
                }
                .padding()
                .background(.green.opacity(0.1))
                .cornerRadius(10)
                
                //  数据排序
                VStack {
                    Text("4. 数据排序")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text("排序后的本地数据:")
                        .font(.subheadline)
                    
                    List(localData.sorted(), id: \.self) {
                        Text($0)
                    }
                    .frame(height: 150)
                }
                .padding()
                .background(.yellow.opacity(0.1))
                .cornerRadius(10)
            }
            .padding()
        }
    }
    
    //  网络请求方法
    func fetchPosts() {
        isLoading = true
        errorMessage = nil
        
        //  模拟网络请求
        DispatchQueue.global().async {
            //  模拟网络延迟
            sleep(2)
            
            //  模拟网络请求
            guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else {
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.errorMessage = "无效的URL"
                }
                return
            }
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                DispatchQueue.main.async {
                    self.isLoading = false
                    
                    if let error = error {
                        self.errorMessage = error.localizedDescription
                        return
                    }
                    
                    guard let data = data else {
                        self.errorMessage = "无数据返回"
                        return
                    }
                    
                    do {
                        let decodedPosts = try JSONDecoder().decode([Post].self, from: data)
                        self.posts = decodedPosts
                    } catch {
                        self.errorMessage = "解析数据失败"
                    }
                }
            }.resume()
        }
    }
}

#Preview {
    DataProcessingAndNetworkingDemo()
}