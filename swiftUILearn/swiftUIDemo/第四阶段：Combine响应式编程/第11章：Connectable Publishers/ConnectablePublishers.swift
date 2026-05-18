//
//  ConnectablePublishers.swift
//  swiftUIDemo
//
//  Created by AI Assistant
//  Connectable Publishers 示例
//

import SwiftUI
import Combine

class ConnectableViewModel: ObservableObject {
    @Published var timerLog1 = ""
    @Published var timerLog2 = ""
    @Published var multicastLog = ""
    @Published var isConnected = false
    @Published var sharedValue = 0
    
    private var cancellables = Set<AnyCancellable>()
    private var timerCancellable: Cancellable?
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter
    }()
    
    // MARK: - connect() 示例
    func testConnect() {
        timerLog1 = ""
        timerLog2 = ""
        isConnected = false
        
        // 使用 makeConnectable 创建可连接的发布者
        let timerPublisher = Timer.publish(every: 0.5, on: .main, in: .common)
            .makeConnectable()
        
        // 订阅者1
        timerPublisher
            .sink { [weak self] date in
                guard let self = self else { return }
                self.timerLog1 += "S1: \(self.dateFormatter.string(from: date))\n"
            }
            .store(in: &cancellables)
        
        // 订阅者2
        timerPublisher
            .sink { [weak self] date in
                guard let self = self else { return }
                self.timerLog2 += "S2: \(self.dateFormatter.string(from: date))\n"
            }
            .store(in: &cancellables)
        
        // 2秒后手动连接
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            guard let self = self else { return }
            self.timerCancellable = timerPublisher.connect()
            self.isConnected = true
            self.timerLog1 += ">>> 开始连接! <<<\n"
            self.timerLog2 += ">>> 开始连接! <<<\n"
        }
        
        // 5秒后断开
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
            guard let self = self else { return }
            self.timerCancellable?.cancel()
            self.timerCancellable = nil
            self.isConnected = false
            self.timerLog1 += ">>> 连接断开 <<<\n"
            self.timerLog2 += ">>> 连接断开 <<<\n"
        }
    }
    
    // MARK: - autoconnect() 示例
    func testAutoConnect() {
        timerLog1 = "自动开始..."
        
        // 使用 autoconnect，订阅时自动开始
        Timer.publish(every: 0.5, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] date in
                guard let self = self else { return }
                self.timerLog1 += "\(self.dateFormatter.string(from: date)) "
            }
            .store(in: &cancellables)
    }
    
    // MARK: - multicast 示例
    func testMulticast() {
        multicastLog = ""
        
        // 创建 multicast 发布者
        let subject = PassthroughSubject<String, Never>()
        
        // 模拟昂贵操作
        let expensivePublisher = Just("昂贵的数据")
            .handleEvents(receiveOutput: { [weak self] _ in
                self?.multicastLog += "🔄 执行昂贵操作...\n"
            })
        
        // 使用 multicast
        expensivePublisher
            .multicast(subject: subject)
            .sink { [weak self] value in
                self?.multicastLog += "✅ 收到: \(value)\n"
            }
            .store(in: &cancellables)
        
        // 连接到源发布者
        expensivePublisher
            .multicast(subject: subject)
            .connect()
            .store(in: &cancellables)
    }
    
    // MARK: - CurrentValueSubject 示例
    func testCurrentValueSubject() {
        multicastLog = ""
        
        // 初始值为 0
        let subject = CurrentValueSubject<Int, Never>(0)
        
        // 第一个订阅者
        subject
            .sink { [weak self] value in
                self?.multicastLog += "订阅者1: \(value)\n"
            }
            .store(in: &cancellables)
        
        // 发送值
        subject.send(1)
        subject.send(2)
        subject.send(3)
        
        // 第二个订阅者（会立即收到当前值 3）
        subject
            .sink { [weak self] value in
                self?.multicastLog += "订阅者2: \(value)\n"
            }
            .store(in: &cancellables)
        
        // 再发送值，两个订阅者都会收到
        subject.send(4)
    }
    
    // MARK: - share() 示例
    func testShare() {
        multicastLog = ""
        sharedValue = 0
        
        // 模拟昂贵的操作
        let sharedPublisher = Timer.publish(every: 1.0, on: .main, in: .common)
            .prefix(3)
            .map { [weak self] _ in
                guard let self = self else { return 0 }
                self.sharedValue += 1
                return self.sharedValue
            }
            .share()
        
        // 两个订阅者共享同一个发布
        sharedPublisher
            .sink { [weak self] value in
                self?.multicastLog += "订阅者1: \(value)\n"
            }
            .store(in: &cancellables)
        
        sharedPublisher
            .sink { [weak self] value in
                self?.multicastLog += "订阅者2: \(value)\n"
            }
            .store(in: &cancellables)
    }
    
    func stopAll() {
        cancellables.removeAll()
        timerCancellable?.cancel()
        timerCancellable = nil
        isConnected = false
    }
}

struct ConnectablePublishersDemo: View {
    @StateObject private var viewModel = ConnectableViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Connectable Publishers")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                
                // 1. connect() 示例
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("1. connect() - 手动控制")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        Spacer()
                        
                        Text(viewModel.isConnected ? "🟢 连接中" : "⚪ 未连接")
                            .foregroundColor(viewModel.isConnected ? .green : .gray)
                    }
                    
                    Button("开始测试 (2秒后连接)") {
                        viewModel.testConnect()
                    }
                    .padding()
                    .background(.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    
                    HStack(spacing: 10) {
                        VStack(alignment: .leading) {
                            Text("订阅者1:")
                                .font(.caption)
                                .fontWeight(.semibold)
                            ScrollView {
                                Text(viewModel.timerLog1)
                                    .font(.system(.caption, design: .monospaced))
                            }
                            .frame(height: 80)
                            .border(Color.gray.opacity(0.3))
                        }
                        
                        VStack(alignment: .leading) {
                            Text("订阅者2:")
                                .font(.caption)
                                .fontWeight(.semibold)
                            ScrollView {
                                Text(viewModel.timerLog2)
                                    .font(.system(.caption, design: .monospaced))
                            }
                            .frame(height: 80)
                            .border(Color.gray.opacity(0.3))
                        }
                    }
                }
                .padding()
                .background(.blue.opacity(0.1))
                .cornerRadius(10)
                
                // 2. autoconnect() 示例
                VStack(alignment: .leading, spacing: 10) {
                    Text("2. autoconnect() - 自动开始")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Button("开始测试") {
                        viewModel.testAutoConnect()
                    }
                    .padding()
                    .background(.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    
                    Text(viewModel.timerLog1)
                        .font(.system(.body, design: .monospaced))
                        .frame(height: 50)
                        .border(Color.gray.opacity(0.3))
                }
                .padding()
                .background(.green.opacity(0.1))
                .cornerRadius(10)
                
                // 3. multicast 示例
                VStack(alignment: .leading, spacing: 10) {
                    Text("3. multicast() - 多播共享")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Button("测试 PassthroughSubject") {
                        viewModel.testMulticast()
                    }
                    .padding()
                    .background(.orange)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    
                    Button("测试 CurrentValueSubject") {
                        viewModel.testCurrentValueSubject()
                    }
                    .padding()
                    .background(.purple)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    
                    ScrollView {
                        Text(viewModel.multicastLog)
                            .font(.system(.caption, design: .monospaced))
                    }
                    .frame(height: 150)
                    .border(Color.gray.opacity(0.3))
                }
                .padding()
                .background(.orange.opacity(0.1))
                .cornerRadius(10)
                
                // 4. share() 示例
                VStack(alignment: .leading, spacing: 10) {
                    Text("4. share() - 共享发布者")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Button("测试共享") {
                        viewModel.testShare()
                    }
                    .padding()
                    .background(.pink)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    
                    ScrollView {
                        Text(viewModel.multicastLog)
                            .font(.system(.caption, design: .monospaced))
                    }
                    .frame(height: 150)
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
    ConnectablePublishersDemo()
}
