import SwiftUI

/// async-await并发编程示例
struct AsyncAwaitDemo: View {
    @State private var isLoading = false
    @State private var result: String = "点击按钮开始"
    @State private var fetchCount = 0
    
    var body: some View {
        VStack(spacing: 20) {
            Text("async-await并发编程")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text(result)
                .font(.body)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
            
            if isLoading {
                ProgressView()
                    .scaleEffect(1.5)
            }
            
            HStack(spacing: 10) {
                Button("基本async-await") {
                    Task {
                        await basicAsyncAwait()
                    }
                }
                .buttonStyle(.bordered)
                
                Button("TaskGroup") {
                    Task {
                        await taskGroupDemo()
                    }
                }
                .buttonStyle(.bordered)
            }
            
            HStack(spacing: 10) {
                Button("结构化并发") {
                    Task {
                        await structuredConcurrency()
                    }
                }
                .buttonStyle(.bordered)
                
                Button("任务取消") {
                    Task {
                        await cancellationDemo()
                    }
                }
                .buttonStyle(.bordered)
            }
            
            Button("Actor模型") {
                Task {
                    await actorDemo()
                }
            }
            .buttonStyle(.bordered)
        }
        .padding()
    }
    
    func basicAsyncAwait() async {
        isLoading = true
        result = "开始基本async-await操作..."
        
        do {
            let data = try await fetchData()
            result = "获取数据成功: \(data)"
        } catch {
            result = "获取数据失败: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    func fetchData() async throws -> String {
        print("开始获取数据")
        // 模拟网络请求延迟
        try await Task.sleep(nanoseconds: 2 * 1_000_000_000)
        print("数据获取完成")
        return "这是从服务器获取的数据"
    }
    
    func taskGroupDemo() async {
        isLoading = true
        result = "开始TaskGroup操作..."
        
        var results: [String] = []
        
        await withTaskGroup(of: String.self) { group in
            // 添加多个任务
            for i in 1...3 {
                group.addTask {
                    print("Task \(i) 开始")
                    try? await Task.sleep(nanoseconds: UInt64(i) * 1_000_000_000)
                    print("Task \(i) 结束")
                    return "任务 \(i) 结果"
                }
            }
            
            // 收集结果
            for await result in group {
                results.append(result)
            }
        }
        
        result = "TaskGroup操作完成:\n" + results.joined(separator: "\n")
        isLoading = false
    }
    
    func structuredConcurrency() async {
        isLoading = true
        result = "开始结构化并发操作..."
        
        async let task1 = fetchData()
        async let task2 = fetchData()
        async let task3 = fetchData()
        
        do {
            let (result1, result2, result3) = try await (task1, task2, task3)
            result = "结构化并发操作完成:\n" +
                    "任务1: \(result1)\n" +
                    "任务2: \(result2)\n" +
                    "任务3: \(result3)"
        } catch {
            result = "操作失败: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    func cancellationDemo() async {
        isLoading = true
        result = "开始任务取消演示..."
        
        let task = Task {
            for i in 1...10 {
                if Task.isCancelled {
                    print("任务被取消")
                    return "任务被取消"
                }
                print("工作中... \(i)/10")
                try? await Task.sleep(nanoseconds: 500_000_000)
            }
            return "任务完成"
        }
        
        // 2秒后取消任务
        try? await Task.sleep(nanoseconds: 2 * 1_000_000_000)
        task.cancel()
        
        let taskResult = await task.result
        
        switch taskResult {
        case .success(let value):
            result = "任务结果: \(value)"
        case .failure(let error):
            result = "任务失败: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    func actorDemo() async {
        isLoading = true
        result = "开始Actor模型演示..."
        
        let counter = Counter()
        
        // 多个任务同时访问Actor
        await withTaskGroup(of: Void.self) { group in
            for i in 1...10 {
                group.addTask {
                    await counter.increment()
                }
            }
        }
        
        let finalCount = await counter.value
        result = "Actor模型演示完成，最终计数: \(finalCount)"
        isLoading = false
    }
    
    // Actor示例
    actor Counter {
        private var _value = 0
        
        var value: Int {
            get async { _value }
        }
        
        func increment() {
            _value += 1
            print("计数: \(_value)")
        }
        
        func reset() {
            _value = 0
        }
    }
}

struct AsyncAwaitDemo_Previews: PreviewProvider {
    static var previews: some View {
        AsyncAwaitDemo()
    }
}
