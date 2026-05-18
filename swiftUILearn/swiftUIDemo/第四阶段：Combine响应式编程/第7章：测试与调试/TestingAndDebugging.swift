//
//  TestingAndDebugging.swift
//  swiftUIDemo
//
//  Created by AI Assistant
//  Combine测试与调试示例
//

import SwiftUI
import Combine

struct TestingAndDebuggingDemo: View {
    @State private var logOutput: String = ""
    @State private var debugLog: [String] = []
    
    @State private var cancellables = Set<AnyCancellable>()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("测试与调试")
                    .font(.largeTitle)
                    .foregroundColor(.blue)
                    .fontWeight(.bold)
                
                // 1. print操作符示例
                VStack(alignment: .leading, spacing: 10) {
                    Text("1. print() - 打印调试")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Button("测试print") {
                        testPrint()
                    }
                    .padding()
                    .background(.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding()
                .background(.blue.opacity(0.1))
                .cornerRadius(10)
                
                // 2. handleEvents示例
                VStack(alignment: .leading, spacing: 10) {
                    Text("2. handleEvents - 观察事件")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Button("测试handleEvents") {
                        testHandleEvents()
                    }
                    .padding()
                    .background(.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding()
                .background(.green.opacity(0.1))
                .cornerRadius(10)
                
                // 3. 调试日志展示
                VStack(alignment: .leading, spacing: 10) {
                    Text("调试日志:")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    ScrollView(.vertical) {
                        Text(logOutput)
                            .font(.system(.caption, design: .monospaced))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .frame(height: 200)
                    .border(Color.gray.opacity(0.3))
                    
                    Button("清空日志") {
                        logOutput = ""
                        debugLog.removeAll()
                    }
                    .padding(.horizontal)
                    .background(.gray)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                .padding()
                .background(.gray.opacity(0.1))
                .cornerRadius(10)
                
                // 4. 常见问题演示
                VStack(alignment: .leading, spacing: 10) {
                    Text("4. 常见问题: 订阅不触发")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    HStack(spacing: 10) {
                        Button("❌ 错误") {
                            testForgotToStore()
                        }
                        .padding()
                        .background(.red)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        
                        Button("✅ 正确") {
                            testCorrectSubscription()
                        }
                        .padding()
                        .background(.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                }
                .padding()
                .background(.orange.opacity(0.1))
                .cornerRadius(10)
            }
            .padding()
        }
    }
    
    // MARK: - 测试函数
    
    func appendLog(_ message: String) {
        let timestamp = DateFormatter.time.string(from: Date())
        let logEntry = "[\(timestamp)] \(message)\n"
        logOutput += logEntry
        debugLog.append(logEntry)
        print(logEntry)
    }
    
    func testPrint() {
        appendLog("开始测试print()...")
        
        let subject = PassthroughSubject<String, Never>()
        
        subject
            .print("📝 Print调试")
            .sink { value in
                self.appendLog("收到值: \(value)")
            }
            .store(in: &cancellables)
        
        subject.send("Hello")
        subject.send("Combine")
        subject.send(completion: .finished)
    }
    
    func testHandleEvents() {
        appendLog("开始测试handleEvents()...")
        
        let subject = PassthroughSubject<Int, Error>()
        
        subject
            .handleEvents(
                receiveSubscription: { subscription in
                    appendLog("📥 收到订阅: \(subscription)")
                },
                receiveOutput: { value in
                    appendLog("📤 收到值: \(value)")
                },
                receiveCompletion: { completion in
                    appendLog("🏁 完成: \(completion)")
                },
                receiveCancel: {
                    appendLog("❌ 订阅被取消")
                },
                receiveRequest: { demand in
                    appendLog("📋 请求: \(demand)")
                }
            )
            .sink(
                receiveCompletion: { completion in
                    self.appendLog("sink完成: \(completion)")
                },
                receiveValue: { value in
                    self.appendLog("sink收到: \(value)")
                }
            )
            .store(in: &cancellables)
        
        subject.send(1)
        subject.send(2)
        subject.send(completion: .finished)
    }
    
    func testForgotToStore() {
        appendLog("❌ 测试忘记.store(in:)...")
        
        let subject = PassthroughSubject<String, Never>()
        
        // ❌ 错误：没有持有AnyCancellable
        subject
            .sink { value in
                self.appendLog("永远不会被调用: \(value)")
            }
        
        subject.send("测试数据")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.appendLog("注意：上面的sink不会被调用！")
        }
    }
    
    func testCorrectSubscription() {
        appendLog("✅ 测试正确的订阅方式...")
        
        let subject = PassthroughSubject<String, Never>()
        
        // ✅ 正确：使用.store(in:)
        subject
            .sink { value in
                self.appendLog("✅ 正确收到: \(value)")
            }
            .store(in: &cancellables)
        
        subject.send("测试数据")
    }
}

// 辅助：时间格式化
extension DateFormatter {
    static let time: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss.SSS"
        return formatter
    }()
}

#Preview {
    TestingAndDebuggingDemo()
}
