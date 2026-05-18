//
//  CombineBasics.swift
//  swiftUIDemo
//
//  Combine基础示例
//

import SwiftUI
import Combine

//  Combine基础示例
struct CombineBasicsDemo: View {
    //  状态管理
    @State private var count = 0
    @State private var message = ""
    @State private var isLoading = false
    
    //  订阅存储
    @State private var cancellables = Set<AnyCancellable>()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                //  标题
                Text("Combine基础")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                
                //  发布者和订阅者
                VStack {
                    Text("1. 发布者和订阅者")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text("计数: \(count)")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Button("开始计数") {
                        startCounting()
                    }
                    .padding()
                    .background(.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding()
                .background(.gray.opacity(0.1))
                .cornerRadius(10)
                
                //  定时器
                VStack {
                    Text("2. 定时器")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text(message)
                        .font(.body)
                        .foregroundColor(.gray)
                    
                    Button("启动定时器") {
                        startTimer()
                    }
                    .padding()
                    .background(.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding()
                .background(.blue.opacity(0.1))
                .cornerRadius(10)
                
                //  异步操作
                VStack {
                    Text("3. 异步操作")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    if isLoading {
                        ProgressView("加载中...")
                    } else {
                        Text("点击按钮开始加载")
                    }
                    
                    Button("模拟网络请求") {
                        simulateNetworkRequest()
                    }
                    .padding()
                    .background(.purple)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding()
                .background(.green.opacity(0.1))
                .cornerRadius(10)
                
                //  错误处理
                VStack {
                    Text("4. 错误处理")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Button("模拟错误") {
                        simulateError()
                    }
                    .padding()
                    .background(.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding()
                .background(.yellow.opacity(0.1))
                .cornerRadius(10)
                
                //  多个发布者组合
                VStack {
                    Text("5. 多个发布者组合")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Button("组合发布者") {
                        combinePublishers()
                    }
                    .padding()
                    .background(.orange)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding()
                .background(.purple.opacity(0.1))
                .cornerRadius(10)
            }
            .padding()
        }
    }
    
    //  开始计数
    func startCounting() {
        //  创建一个发布者，发出1到10的数字
        let publisher = (1...10).publisher
        
        //  订阅发布者
        publisher
            .sink(receiveCompletion: { completion in
                print("完成: \(completion)")
            }, receiveValue: { value in
                print("收到值: \(value)")
                self.count = value
            })
            .store(in: &cancellables)
    }
    
    //  启动定时器
    func startTimer() {
        //  创建一个定时器发布者，每秒发出一个值
        let timerPublisher = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
        
        //  订阅定时器
        timerPublisher
            .sink {value in
                self.message = "当前时间: \(value)"
            }
            .store(in: &cancellables)
    }
    
    //  模拟网络请求
    func simulateNetworkRequest() {
        isLoading = true
        
        //  创建一个异步操作的发布者
        Future<String, Error> {
            promise in
            //  模拟网络延迟
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                promise(.success("请求成功完成"))
            }
        }
        .receive(on: DispatchQueue.main)
        .sink(receiveCompletion: { completion in
            self.isLoading = false
            switch completion {
            case .finished:
                print("请求完成")
            case .failure(let error):
                print("请求失败: \(error)")
            }
        }, receiveValue: { value in
            self.message = value
        })
        .store(in: &cancellables)
    }
    
    //  模拟错误
    func simulateError() {
        //  创建一个会产生错误的发布者
        let errorPublisher = Fail<String, Error>(error: NSError(domain: "com.example", code: 1, userInfo: nil))
        
        //  订阅并处理错误
        errorPublisher
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("完成")
                case .failure(let error):
                    self.message = "错误: \(error.localizedDescription)"
                }
            }, receiveValue: { value in
                print("收到值: \(value)")
            })
            .store(in: &cancellables)
    }
    
    //  组合多个发布者
    func combinePublishers() {
        //  创建两个发布者
        let publisher1 = Just("Hello")
        let publisher2 = Just("World")
        
        //  组合发布者
        publisher1
            .combineLatest(publisher2)
            .sink { value1, value2 in
                self.message = "组合结果: \(value1) \(value2)"
            }
            .store(in: &cancellables)
    }
}

#Preview {
    CombineBasicsDemo()
}