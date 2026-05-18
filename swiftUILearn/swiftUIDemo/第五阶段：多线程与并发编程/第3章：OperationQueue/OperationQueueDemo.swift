import SwiftUI

/// OperationQueue示例
struct OperationQueueDemo: View {
    @State private var isLoading = false
    @State private var result: String = "点击按钮开始"
    @State private var operationsCompleted = 0
    
    var body: some View {
        VStack(spacing: 20) {
            Text("OperationQueue")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text(result)
                .font(.body)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
            
            HStack(spacing: 10) {
                Button("基本Operation") {
                    basicOperationDemo()
                }
                .buttonStyle(.bordered)
                
                Button("操作依赖") {
                    dependencyDemo()
                }
                .buttonStyle(.bordered)
            }
            
            HStack(spacing: 10) {
                Button("自定义Operation") {
                    customOperationDemo()
                }
                .buttonStyle(.bordered)
                
                Button("取消操作") {
                    cancellationDemo()
                }
                .buttonStyle(.bordered)
            }
            
            Button("最大并发数") {
                maxConcurrentDemo()
            }
            .buttonStyle(.bordered)
        }
        .padding()
    }
    
    func basicOperationDemo() {
        result = "开始基本Operation操作..."
        operationsCompleted = 0
        
        let queue = OperationQueue()
        
        for i in 1...3 {
            queue.addOperation {
                print("Operation \(i) 开始")
                Thread.sleep(forTimeInterval: 1)
                print("Operation \(i) 结束")
                
                DispatchQueue.main.async {
                    self.operationsCompleted += 1
                    if self.operationsCompleted == 3 {
                        self.result = "基本Operation操作完成"
                    }
                }
            }
        }
    }
    
    func dependencyDemo() {
        result = "开始操作依赖演示..."
        
        let queue = OperationQueue()
        
        let operation1 = BlockOperation {
            print("操作1 开始")
            Thread.sleep(forTimeInterval: 1)
            print("操作1 结束")
        }
        
        let operation2 = BlockOperation {
            print("操作2 开始")
            Thread.sleep(forTimeInterval: 1)
            print("操作2 结束")
        }
        
        let operation3 = BlockOperation {
            print("操作3 开始")
            Thread.sleep(forTimeInterval: 1)
            print("操作3 结束")
            
            DispatchQueue.main.async {
                self.result = "操作依赖演示完成"
            }
        }
        
        // 设置依赖关系: operation3 依赖于 operation2, operation2 依赖于 operation1
        operation2.addDependency(operation1)
        operation3.addDependency(operation2)
        
        // 添加到队列
        queue.addOperations([operation3, operation2, operation1], waitUntilFinished: false)
    }
    
    func customOperationDemo() {
        result = "开始自定义Operation演示..."
        
        let queue = OperationQueue()
        
        class CustomOperation: Operation, @unchecked Sendable {
            private let taskNumber: Int
            
            init(taskNumber: Int) {
                self.taskNumber = taskNumber
                super.init()
            }
            
            override func main() {
                if isCancelled {
                    return
                }
                
                print("自定义Operation \(taskNumber) 开始")
                Thread.sleep(forTimeInterval: 1)
                
                if isCancelled {
                    return
                }
                
                print("自定义Operation \(taskNumber) 结束")
            }
        }
        
        let operation1 = CustomOperation(taskNumber: 1)
        let operation2 = CustomOperation(taskNumber: 2)
        let operation3 = CustomOperation(taskNumber: 3)
        
        operation3.completionBlock = {
            DispatchQueue.main.async {
                self.result = "自定义Operation演示完成"
            }
        }
        
        queue.addOperations([operation1, operation2, operation3], waitUntilFinished: false)
    }
    
    func cancellationDemo() {
        result = "开始取消操作演示..."
        
        let queue = OperationQueue()
        
        let longOperation = BlockOperation()
        longOperation.addExecutionBlock { [weak longOperation] in
            print("长时间操作 开始")
            for i in 1...5 {
                if longOperation?.isCancelled ?? true {
                    print("操作被取消")
                    return
                }
                print("工作中... \(i)/5")
                Thread.sleep(forTimeInterval: 0.5)
            }
            print("长时间操作 结束")
        }
        
        queue.addOperation(longOperation)
        
        // 2秒后取消操作
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            if longOperation.isExecuting {
                longOperation.cancel()
                self.result = "操作已取消"
            }
        }
    }
    
    func maxConcurrentDemo() {
        result = "开始最大并发数演示..."
        operationsCompleted = 0
        
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 2 // 最多2个并发操作
        
        for i in 1...5 {
            queue.addOperation {
                print("并发操作 \(i) 开始")
                Thread.sleep(forTimeInterval: 1)
                print("并发操作 \(i) 结束")
                
                DispatchQueue.main.async {
                    self.operationsCompleted += 1
                    if self.operationsCompleted == 5 {
                        self.result = "最大并发数演示完成"
                    }
                }
            }
        }
    }
}

struct OperationQueueDemo_Previews: PreviewProvider {
    static var previews: some View {
        OperationQueueDemo()
    }
}
