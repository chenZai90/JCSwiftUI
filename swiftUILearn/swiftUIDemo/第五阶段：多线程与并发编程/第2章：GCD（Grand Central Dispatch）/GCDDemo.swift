import SwiftUI

/// GCD（Grand Central Dispatch）示例
struct GCDDemo: View {
    @State private var isLoading = false
    @State private var result: String = "点击按钮开始"
    @State private var operationCount = 0
    
    var body: some View {
        VStack(spacing: 20) {
            Text("GCD（Grand Central Dispatch）")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text(result)
                .font(.body)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
            
            HStack(spacing: 10) {
                Button("串行队列") {
                    serialQueueDemo()
                }
                .buttonStyle(.bordered)
                
                Button("并发队列") {
                    concurrentQueueDemo()
                }
                .buttonStyle(.bordered)
            }
            
            HStack(spacing: 10) {
                Button("Dispatch Group") {
                    dispatchGroupDemo()
                }
                .buttonStyle(.bordered)
                
                Button("Semaphore") {
                    semaphoreDemo()
                }
                .buttonStyle(.bordered)
            }
            
            HStack(spacing: 10) {
                Button("Barrier") {
                    barrierDemo()
                }
                .buttonStyle(.bordered)
                
                Button("延迟执行") {
                    delayExecution()
                }
                .buttonStyle(.bordered)
            }
        }
        .padding()
    }
    
    func serialQueueDemo() {
        result = "开始串行队列操作..."
        operationCount = 0
        
        let serialQueue = DispatchQueue(label: "com.example.serial")
        
        for i in 1...3 {
            serialQueue.async {
                print("串行任务 \(i) 开始")
                Thread.sleep(forTimeInterval: 1)
                print("串行任务 \(i) 结束")
                
                DispatchQueue.main.async {
                    self.operationCount += 1
                    if self.operationCount == 3 {
                        self.result = "串行队列操作完成"
                    }
                }
            }
        }
    }
    
    func concurrentQueueDemo() {
        result = "开始并发队列操作..."
        operationCount = 0
        
        let concurrentQueue = DispatchQueue(label: "com.example.concurrent", attributes: .concurrent)
        
        for i in 1...3 {
            concurrentQueue.async {
                print("并发任务 \(i) 开始")
                Thread.sleep(forTimeInterval: 1)
                print("并发任务 \(i) 结束")
                
                DispatchQueue.main.async {
                    self.operationCount += 1
                    if self.operationCount == 3 {
                        self.result = "并发队列操作完成"
                    }
                }
            }
        }
    }
    
    func dispatchGroupDemo() {
        result = "开始Dispatch Group操作..."
        
        let group = DispatchGroup()
        let queue = DispatchQueue.global()
        var results: [String] = []
        
        for i in 1...3 {
            group.enter()
            queue.async {
                print("Group任务 \(i) 开始")
                Thread.sleep(forTimeInterval: TimeInterval(i))
                print("Group任务 \(i) 结束")
                
                results.append("任务 \(i) 完成")
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            self.result = "Dispatch Group操作完成:\n" + results.joined(separator: "\n")
        }
    }
    
    func semaphoreDemo() {
        result = "开始Semaphore操作..."
        
        let semaphore = DispatchSemaphore(value: 2) // 最多2个并发
        let queue = DispatchQueue.global()
        var results: [String] = []
        
        for i in 1...5 {
            queue.async {
                semaphore.wait()
                print("Semaphore任务 \(i) 开始")
                Thread.sleep(forTimeInterval: 1)
                print("Semaphore任务 \(i) 结束")
                
                DispatchQueue.main.async {
                    results.append("任务 \(i) 完成")
                }
                semaphore.signal()
            }
        }
        
        // 等待所有任务完成
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.result = "Semaphore操作完成:\n" + results.joined(separator: "\n")
        }
    }
    
    func barrierDemo() {
        result = "开始Barrier操作..."
        
        let concurrentQueue = DispatchQueue(label: "com.example.barrier", attributes: .concurrent)
        var data: [Int] = []
        
        // 并行读取
        for i in 1...3 {
            concurrentQueue.async {
                print("读取操作 \(i)")
            }
        }
        
        // 屏障写入
        concurrentQueue.async(flags: .barrier) {
            print("开始写入操作")
            Thread.sleep(forTimeInterval: 1)
            data.append(42)
            print("写入操作完成")
            
            DispatchQueue.main.async {
                self.result = "Barrier操作完成，数据: \(data)"
            }
        }
        
        // 并行读取
        for i in 4...6 {
            concurrentQueue.async {
                print("读取操作 \(i)")
            }
        }
    }
    
    func delayExecution() {
        result = "开始延迟执行..."
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.result = "延迟2秒执行完成"
        }
    }
}

struct GCDDemo_Previews: PreviewProvider {
    static var previews: some View {
        GCDDemo()
    }
}
