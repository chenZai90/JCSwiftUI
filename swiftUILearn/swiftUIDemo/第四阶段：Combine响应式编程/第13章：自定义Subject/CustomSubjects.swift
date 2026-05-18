//
//  CustomSubjects.swift
//  swiftUIDemo
//
//  Created: AI Assistant
//  自定义Subject示例
//

import SwiftUI
import Combine

// MARK: - 1. 验证Subject
class ValidatedSubject<Output, Failure: Error>: Subject {
    typealias Output = Output
    typealias Failure = Failure
    
    private let subject = PassthroughSubject<Output, Failure>()
    private let validation: (Output) -> Bool
    
    init(validation: @escaping (Output) -> Bool) {
        self.validation = validation
    }
    
    func send(_ value: Output) {
        if validation(value) {
            subject.send(value)
        }
    }
    
    func send(subscription: Subscription) {
        subject.send(subscription: subscription)
    }
    
    func send(completion: Subscribers.Completion<Failure>) {
        subject.send(completion: completion)
    }
    
    func receive<S>(subscriber: S) where S: Subscriber, Failure == S.Failure, Output == S.Input {
        subject.receive(subscriber: subscriber)
    }
}

// MARK: - 2. 限流Subject
class ThrottledSubject<Output, Failure: Error>: Subject {
    typealias Output = Output
    typealias Failure = Failure
    
    private let subject = PassthroughSubject<Output, Failure>()
    private var lastSendTime: Date?
    private let minimumInterval: TimeInterval
    
    init(minimumInterval: TimeInterval) {
        self.minimumInterval = minimumInterval
    }
    
    func send(_ value: Output) {
        let now = Date()
        if let lastTime = lastSendTime,
           now.timeIntervalSince(lastTime) < minimumInterval {
            return
        }
        lastSendTime = now
        subject.send(value)
    }
    
    func send(subscription: Subscription) {
        subject.send(subscription: subscription)
    }
    
    func send(completion: Subscribers.Completion<Failure>) {
        subject.send(completion: completion)
    }
    
    func receive<S>(subscriber: S) where S: Subscriber, Failure == S.Failure, Output == S.Input {
        subject.receive(subscriber: subscriber)
    }
}

// MARK: - 3. 防抖Subject
class DebouncedSubject<Output, Failure: Error>: Subject {
    typealias Output = Output
    typealias Failure = Failure
    
    private let subject = PassthroughSubject<Output, Failure>()
    private var debounceWorkItem: DispatchWorkItem?
    private let dueTime: TimeInterval
    
    init(dueTime: TimeInterval = 0.3) {
        self.dueTime = dueTime
    }
    
    func send(_ value: Output) {
        debounceWorkItem?.cancel()
        
        let workItem = DispatchWorkItem { [weak self] in
            self?.subject.send(value)
        }
        
        debounceWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + dueTime, execute: workItem)
    }
    
    func send(subscription: Subscription) {
        subject.send(subscription: subscription)
    }
    
    func send(completion: Subscribers.Completion<Failure>) {
        debounceWorkItem?.cancel()
        subject.send(completion: completion)
    }
    
    func receive<S>(subscriber: S) where S: Subscriber, Failure == S.Failure, Output == S.Input {
        subject.receive(subscriber: subscriber)
    }
}

// MARK: - 4. 去重Subject
class DistinctSubject<Output: Equatable, Failure: Error>: Subject {
    typealias Output = Output
    typealias Failure = Failure
    
    private let subject = PassthroughSubject<Output, Failure>()
    private var lastValue: Output?
    
    func send(_ value: Output) {
        guard value != lastValue else { return }
        lastValue = value
        subject.send(value)
    }
    
    func send(subscription: Subscription) {
        subject.send(subscription: subscription)
    }
    
    func send(completion: Subscribers.Completion<Failure>) {
        subject.send(completion: completion)
    }
    
    func receive<S>(subscriber: S) where S: Subscriber, Failure == S.Failure, Output == S.Input {
        subject.receive(subscriber: subscriber)
    }
}

// MARK: - ViewModel
class CustomSubjectViewModel: ObservableObject {
    @Published var validatedLog = ""
    @Published var throttledLog = ""
    @Published var debouncedLog = ""
    @Published var distinctLog = ""
    @Published var aggregatedLog = ""
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - 验证Subject示例
    func testValidatedSubject() {
        validatedLog = "测试验证Subject (长度3-10):\n"
        
        let subject = ValidatedSubject<String, Never> { value in
            value.count >= 3 && value.count <= 10
        }
        
        subject
            .sink { [weak self] value in
                self?.validatedLog += "✅ 接受: \(value)\n"
            }
            .store(in: &cancellables)
        
        subject.send("AB")              // ❌ 太短
        subject.send("ABCDEF")          // ✅ 有效
        subject.send("ABCDEFGHIJKL")    // ❌ 太长
        subject.send("Hello")            // ✅ 有效
    }
    
    // MARK: - 限流Subject示例
    func testThrottledSubject() {
        throttledLog = "测试限流Subject (1秒间隔):\n"
        
        let subject = ThrottledSubject<String, Never>(minimumInterval: 1.0)
        
        subject
            .sink { [weak self] value in
                self?.throttledLog += "✅ 收到: \(value)\n"
            }
            .store(in: &cancellables)
        
        // 快速发送多个事件
        subject.send("事件A")
        subject.send("事件B")
        subject.send("事件C") // 只有第一个会被接收
        
        // 1秒后再发送
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.1) {
            subject.send("事件D")
        }
    }
    
    // MARK: - 防抖Subject示例
    func testDebouncedSubject() {
        debouncedLog = "测试防抖Subject (0.5秒延迟):\n"
        
        let subject = DebouncedSubject<String, Never>(dueTime: 0.5)
        
        subject
            .sink { [weak self] value in
                self?.debouncedLog += "✅ 收到: \(value)\n"
            }
            .store(in: &cancellables)
        
        // 快速输入
        subject.send("H")
        subject.send("He")
        subject.send("Hel")
        subject.send("Hell")
        subject.send("Hello") // 只有最后一个会被接收
    }
    
    // MARK: - 去重Subject示例
    func testDistinctSubject() {
        distinctLog = "测试去重Subject:\n"
        
        let subject = DistinctSubject<String, Never>()
        
        subject
            .sink { [weak self] value in
                self?.distinctLog += "✅ 收到: \(value)\n"
            }
            .store(in: &cancellables)
        
        subject.send("Hello")
        subject.send("Hello")  // ❌ 重复
        subject.send("World")
        subject.send("World")  // ❌ 重复
        subject.send("Swift")
    }
    
    // MARK: - 聚合示例
    func testAggregation() {
        aggregatedLog = "测试聚合 (每3个值聚合一次):\n"
        
        var buffer: [Int] = []
        let subject = PassthroughSubject<Int, Never>()
        
        subject
            .sink { [weak self] value in
                buffer.append(value)
                if buffer.count == 3 {
                    let sum = buffer.reduce(0, +)
                    self?.aggregatedLog += "✅ 聚合: \(buffer) = \(sum)\n"
                    buffer.removeAll()
                }
            }
            .store(in: &cancellables)
        
        subject.send(1)
        subject.send(2)
        subject.send(3)  // 触发聚合: 1+2+3=6
        
        subject.send(4)
        subject.send(5)
        subject.send(6)  // 触发聚合: 4+5+6=15
    }
    
    func stopAll() {
        cancellables.removeAll()
    }
}

// MARK: - View
struct CustomSubjectsDemo: View {
    @StateObject private var viewModel = CustomSubjectViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("自定义Subject")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                
                // 1. 验证Subject
                VStack(alignment: .leading, spacing: 10) {
                    Text("1. 验证Subject")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text("自动验证输入，只接受长度3-10的值")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Button("测试验证") {
                        viewModel.testValidatedSubject()
                    }
                    .padding()
                    .background(.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    
                    ScrollView {
                        Text(viewModel.validatedLog)
                            .font(.system(.caption, design: .monospaced))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .frame(height: 120)
                    .border(Color.gray.opacity(0.3))
                }
                .padding()
                .background(.blue.opacity(0.1))
                .cornerRadius(10)
                
                // 2. 限流Subject
                VStack(alignment: .leading, spacing: 10) {
                    Text("2. 限流Subject")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text("限制发送频率，每1秒只允许一个值通过")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Button("测试限流") {
                        viewModel.testThrottledSubject()
                    }
                    .padding()
                    .background(.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    
                    ScrollView {
                        Text(viewModel.throttledLog)
                            .font(.system(.caption, design: .monospaced))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .frame(height: 120)
                    .border(Color.gray.opacity(0.3))
                }
                .padding()
                .background(.green.opacity(0.1))
                .cornerRadius(10)
                
                // 3. 防抖Subject
                VStack(alignment: .leading, spacing: 10) {
                    Text("3. 防抖Subject")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text("延迟发送，只接收最后一次输入")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Button("测试防抖") {
                        viewModel.testDebouncedSubject()
                    }
                    .padding()
                    .background(.orange)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    
                    ScrollView {
                        Text(viewModel.debouncedLog)
                            .font(.system(.caption, design: .monospaced))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .frame(height: 120)
                    .border(Color.gray.opacity(0.3))
                }
                .padding()
                .background(.orange.opacity(0.1))
                .cornerRadius(10)
                
                // 4. 去重Subject
                VStack(alignment: .leading, spacing: 10) {
                    Text("4. 去重Subject")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text("自动过滤重复的连续值")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Button("测试去重") {
                        viewModel.testDistinctSubject()
                    }
                    .padding()
                    .background(.purple)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    
                    ScrollView {
                        Text(viewModel.distinctLog)
                            .font(.system(.caption, design: .monospaced))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .frame(height: 120)
                    .border(Color.gray.opacity(0.3))
                }
                .padding()
                .background(.purple.opacity(0.1))
                .cornerRadius(10)
                
                // 5. 聚合示例
                VStack(alignment: .leading, spacing: 10) {
                    Text("5. 值聚合示例")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text("收集3个值后进行聚合计算")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Button("测试聚合") {
                        viewModel.testAggregation()
                    }
                    .padding()
                    .background(.pink)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    
                    ScrollView {
                        Text(viewModel.aggregatedLog)
                            .font(.system(.caption, design: .monospaced))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .frame(height: 120)
                    .border(Color.gray.opacity(0.3))
                }
                .padding()
                .background(.pink.opacity(0.1))
                .cornerRadius(10)
                
                // 停止按钮
                Button("停止所有") {
                    viewModel.stopAll()
                }
                .padding()
                .background(.gray)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .padding()
        }
        .onDisappear {
            viewModel.stopAll()
        }
    }
}

#Preview {
    CustomSubjectsDemo()
}
