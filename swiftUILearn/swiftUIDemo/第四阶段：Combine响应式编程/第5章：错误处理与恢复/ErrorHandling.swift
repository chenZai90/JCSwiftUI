//
//  ErrorHandling.swift
//  swiftUIDemo
//
//  Created by AI Assistant
//  Combine错误处理与恢复示例
//

import SwiftUI
import Combine

enum CombineConversionError: LocalizedError {
    case invalidNumber(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidNumber(let string):
            return "无法转换为数字: \(string)"
        }
    }
}

enum CombineNetworkError: LocalizedError {
    case timeout
    case invalidURL
    case serverError(Int)
    
    var errorDescription: String? {
        switch self {
        case .timeout:
            return "请求超时"
        case .invalidURL:
            return "无效的URL"
        case .serverError(let code):
            return "服务器错误: \(code)"
        }
    }
}

class ErrorHandlingViewModel: ObservableObject {
    @Published var tryMapResult = ""
    @Published var catchResult = ""
    @Published var retryResult = ""
    @Published var isRetryLoading = false
    @Published var networkResult = ""
    @Published var isNetworkLoading = false
    
    private var cancellables = Set<AnyCancellable>()
    
    func testTryMap() {
        let strings = ["1", "2", "3", "invalid", "5"].publisher
        var results: [String] = []
        
        strings
            .tryMap { string -> Int in
                guard let number = Int(string) else {
                    throw CombineConversionError.invalidNumber(string)
                }
                return number
            }
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        self.tryMapResult = "tryMap结果: " + results.joined(separator: ", ")
                    case .failure(let error):
                        self.tryMapResult = "❌ 错误: \(error.localizedDescription)"
                    }
                },
                receiveValue: { number in
                    results.append("\(number)")
                }
            )
            .store(in: &cancellables)
    }
    
    func testCatch() {
        let subject = PassthroughSubject<String, CombineNetworkError>()
        
        subject
            .catch { error -> AnyPublisher<String, Never> in
                return Just("使用默认值 (错误: \(error.localizedDescription))")
                    .eraseToAnyPublisher()
            }
            .sink { value in
                self.catchResult = "收到: \(value)"
            }
            .store(in: &cancellables)
        
        subject.send("正常数据")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            subject.send(completion: .failure(.timeout))
        }
    }
    
    func testRetry() {
        isRetryLoading = true
        retryResult = "尝试中..."
        var attemptCount = 0
        
        let flakyPublisher = Future<String, CombineNetworkError> { promise in
            attemptCount += 1
            print("第\(attemptCount)次尝试")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                if attemptCount < 3 {
                    promise(.failure(.timeout))
                } else {
                    promise(.success("✅ 第\(attemptCount)次尝试成功!"))
                }
            }
        }
        
        flakyPublisher
            .retry(3)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isRetryLoading = false
                    if case .failure(let error) = completion {
                        self?.retryResult = "❌ 最终失败: \(error.localizedDescription)"
                    }
                },
                receiveValue: { [weak self] value in
                    self?.retryResult = value
                }
            )
            .store(in: &cancellables)
    }
    
    func testNetworkRequest() {
        isNetworkLoading = true
        networkResult = "请求中..."
        
        let simulatedNetworkRequest = Future<String, CombineNetworkError> { promise in
            DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
                if Bool.random() {
                    promise(.success("✅ 网络请求成功!"))
                } else {
                    promise(.failure(.serverError(500)))
                }
            }
        }
        
        simulatedNetworkRequest
            .retry(2)
            .catch { error -> AnyPublisher<String, Never> in
                return Just("❌ 使用缓存数据 (错误: \(error.localizedDescription))")
                    .eraseToAnyPublisher()
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                self?.isNetworkLoading = false
                self?.networkResult = result
            }
            .store(in: &cancellables)
    }
    
    func testReplaceError() {
        let publisher = Fail<String, CombineNetworkError>(error: .timeout)
        
        publisher
            .replaceError(with: "这是默认值")
            .sink { value in
                print("replaceError收到: \(value)")
            }
            .store(in: &cancellables)
    }
    
    func testMapError() {
        let originalError = NSError(domain: "NSURLErrorDomain", code: -1001, userInfo: nil)
        let publisher = Fail<String, NSError>(error: originalError)
        
        publisher
            .mapError { (error: NSError) -> CombineNetworkError in
                return .timeout
            }
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        print("mapError转换后: \(error)")
                    }
                },
                receiveValue: { _ in }
            )
            .store(in: &cancellables)
    }
}

struct ErrorHandlingDemo: View {
    @StateObject private var viewModel = ErrorHandlingViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("错误处理与恢复")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("1. tryMap - 抛出错误")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Button("测试tryMap") {
                        viewModel.testTryMap()
                    }
                    .padding()
                    .background(.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    
                    Text(viewModel.tryMapResult)
                        .font(.body)
                        .foregroundColor(.gray)
                }
                .padding()
                .background(.blue.opacity(0.1))
                .cornerRadius(10)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("2. catch - 捕获错误")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Button("测试catch") {
                        viewModel.testCatch()
                    }
                    .padding()
                    .background(.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    
                    Text(viewModel.catchResult)
                        .font(.body)
                        .foregroundColor(.gray)
                }
                .padding()
                .background(.green.opacity(0.1))
                .cornerRadius(10)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("3. retry - 重试机制")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Button("测试retry") {
                        viewModel.testRetry()
                    }
                    .padding()
                    .background(.orange)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .disabled(viewModel.isRetryLoading)
                    
                    if viewModel.isRetryLoading {
                        ProgressView()
                    }
                    
                    Text(viewModel.retryResult)
                        .font(.body)
                        .foregroundColor(.gray)
                }
                .padding()
                .background(.orange.opacity(0.1))
                .cornerRadius(10)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("4. 网络请求错误处理")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Button("测试网络请求") {
                        viewModel.testNetworkRequest()
                    }
                    .padding()
                    .background(.purple)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .disabled(viewModel.isNetworkLoading)
                    
                    if viewModel.isNetworkLoading {
                        ProgressView()
                    }
                    
                    Text(viewModel.networkResult)
                        .font(.body)
                        .foregroundColor(.gray)
                }
                .padding()
                .background(.purple.opacity(0.1))
                .cornerRadius(10)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("5. replaceError - 错误替换")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Button("测试replaceError") {
                        viewModel.testReplaceError()
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
                    Text("6. mapError - 错误类型转换")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Button("测试mapError") {
                        viewModel.testMapError()
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
    ErrorHandlingDemo()
}
