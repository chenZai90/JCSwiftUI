//
//  ThreadingAndSchedulers.swift
//  swiftUIDemo
//
//  Created by AI Assistant
//  Combine多线程与调度器示例
//

import SwiftUI
import Combine

class ThreadingViewModel: ObservableObject {
    @Published var resultText = ""
    @Published var threadInfo = ""
    @Published var isLoading = false
    @Published var calculationResult = 0
    
    private var cancellables = Set<AnyCancellable>()
    
    func testNoThreadSwitch() {
        let info = """
        当前线程: \(Thread.current)
        是否主线程: \(Thread.isMainThread)
        """
        threadInfo = info
        
        Just("测试数据")
            .sink { [weak self] value in
                let sinkInfo = """
                
                sink执行线程: \(Thread.current)
                sink是否主线程: \(Thread.isMainThread)
                """
                self?.threadInfo = info + sinkInfo
            }
            .store(in: &cancellables)
    }
    
    func testSubscribeOn() {
        resultText = "开始..."
        
        Just("后台数据")
            .subscribe(on: DispatchQueue.global(qos: .userInitiated))
            .map { value -> String in
                let threadInfo = """
                map执行线程: \(Thread.current)
                map是否主线程: \(Thread.isMainThread)
                值: \(value)
                """
                return threadInfo
            }
            .sink { [weak self] threadInfo in
                self?.resultText = threadInfo
            }
            .store(in: &cancellables)
    }
    
    func testReceiveOn() {
        Just("数据")
            .subscribe(on: DispatchQueue.global())
            .map { value in
                print("map在: \(Thread.current)")
                return value
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                print("sink在: \(Thread.current)")
                let isMain = Thread.isMainThread ? "是" : "否"
                self?.resultText = "sink在主线程: \(isMain)"
            }
            .store(in: &cancellables)
    }
    
    func performHeavyCalculation() {
        isLoading = true
        calculationResult = 0
        
        Just(())
            .subscribe(on: DispatchQueue.global(qos: .utility))
            .map { _ -> Int in
                var result = 0
                for i in 0...1_000_000 {
                    result += i
                }
                return result
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                self?.isLoading = false
                self?.calculationResult = result
            }
            .store(in: &cancellables)
    }
    
    func testDelay() {
        resultText = "等待延迟..."
        
        Just("延迟后的数据")
            .delay(for: .seconds(2), scheduler: DispatchQueue.main)
            .sink { [weak self] value in
                self?.resultText = "收到: \(value)"
            }
            .store(in: &cancellables)
    }
    
    func testTimeout() {
        resultText = "开始超时测试..."
        
        let delayedPublisher = Future<String, Error> { promise in
            DispatchQueue.global().asyncAfter(deadline: .now() + 3) {
                promise(.success("完成"))
            }
        }
        
        delayedPublisher
            .timeout(.seconds(2), scheduler: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    switch completion {
                    case .finished:
                        self?.resultText = "✅ 正常完成"
                    case .failure(let error):
                        self?.resultText = "❌ 超时: \(error)"
                    }
                },
                receiveValue: { _ in }
            )
            .store(in: &cancellables)
    }
}

struct ThreadingAndSchedulersDemo: View {
    @StateObject private var viewModel = ThreadingViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("多线程与调度器")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("1. 线程检查 - 不切换线程")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Button("测试无线程切换") {
                        viewModel.testNoThreadSwitch()
                    }
                    .padding()
                    .background(.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    
                    Text(viewModel.threadInfo)
                        .font(.body)
                        .foregroundColor(.gray)
                }
                .padding()
                .background(.blue.opacity(0.1))
                .cornerRadius(10)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("2. subscribe(on:) - 后台订阅")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Button("测试后台订阅") {
                        viewModel.testSubscribeOn()
                    }
                    .padding()
                    .background(.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    
                    Text(viewModel.resultText)
                        .font(.body)
                        .foregroundColor(.gray)
                }
                .padding()
                .background(.green.opacity(0.1))
                .cornerRadius(10)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("3. receive(on:) - 主线程接收")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Button("测试主线程接收") {
                        viewModel.testReceiveOn()
                    }
                    .padding()
                    .background(.orange)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding()
                .background(.orange.opacity(0.1))
                .cornerRadius(10)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("4. 后台耗时计算")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Button("开始计算") {
                        viewModel.performHeavyCalculation()
                    }
                    .padding()
                    .background(.purple)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .disabled(viewModel.isLoading)
                    
                    if viewModel.isLoading {
                        ProgressView("计算中...")
                    }
                    
                    Text("计算结果: \(viewModel.calculationResult)")
                        .font(.body)
                        .foregroundColor(.gray)
                }
                .padding()
                .background(.purple.opacity(0.1))
                .cornerRadius(10)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("5. delay - 延迟执行")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Button("测试延迟") {
                        viewModel.testDelay()
                    }
                    .padding()
                    .background(.pink)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding()
                .background(.pink.opacity(0.1))
                .cornerRadius(10)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("6. timeout - 超时控制")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Button("测试超时") {
                        viewModel.testTimeout()
                    }
                    .padding()
                    .background(.teal)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding()
                .background(.teal.opacity(0.1))
                .cornerRadius(10)
            }
            .padding()
        }
    }
}

#Preview {
    ThreadingAndSchedulersDemo()
}
