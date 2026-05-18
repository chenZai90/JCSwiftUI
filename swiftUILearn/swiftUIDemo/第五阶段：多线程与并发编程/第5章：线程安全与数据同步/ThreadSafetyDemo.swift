import SwiftUI

/// 线程安全与数据同步示例
struct ThreadSafetyDemo: View {
    @State private var isLoading = false
    @State private var result: String = "点击按钮开始"
    @State private var counter = 0
    
    // 线程安全的计数器
    private let safeCounter = SafeCounter()
    
    var body: some View {
        VStack(spacing: 20) {
            Text("线程安全与数据同步")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text(result)
                .font(.body)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
            
            Text("当前计数: \(counter)")
                .font(.title)
                .fontWeight(.semibold)
            
            if isLoading {
                ProgressView()
                    .scaleEffect(1.5)
            }
            
            HStack(spacing: 10) {
                Button("非线程安全") {
                    nonThreadSafeDemo()
                }
                .buttonStyle(.bordered)
                
                Button("线程安全 (锁)") {
                    threadSafeWithLock()
                }
                .buttonStyle(.bordered)
            }
            
            HStack(spacing: 10) {
                Button("线程安全 (串行队列)") {
                    threadSafeWithSerialQueue()
                }
                .buttonStyle(.bordered)
                
                Button("线程安全 (Actor)") {
                    threadSafeWithActor()
                }
                .buttonStyle(.bordered)
            }
            
            Button("原子操作") {
                atomicOperationDemo()
            }
            .buttonStyle(.bordered)
        }
        .padding()
    }
    
    func nonThreadSafeDemo() {
        isLoading = true
        result = "开始非线程安全操作..."
        counter = 0
        
        let queue = DispatchQueue.global()
        
        for i in 1...1000 {
            queue.async {
                // 非线程安全的操作
                self.counter += 1
                
                if i == 1000 {
                    DispatchQueue.main.async {
                        self.result = "非线程安全操作完成，最终计数: \(self.counter)"
                        self.isLoading = false
                    }
                }
            }
        }
    }
    
    func threadSafeWithLock() {
        isLoading = true
        result = "开始线程安全操作 (锁)..."
        counter = 0
        
        let queue = DispatchQueue.global()
        let lock = NSLock()
        
        for i in 1...1000 {
            queue.async {
                lock.lock()
                self.counter += 1
                lock.unlock()
                
                if i == 1000 {
                    DispatchQueue.main.async {
                        self.result = "线程安全操作 (锁) 完成，最终计数: \(self.counter)"
                        self.isLoading = false
                    }
                }
            }
        }
    }
    
    func threadSafeWithSerialQueue() {
        isLoading = true
        result = "开始线程安全操作 (串行队列)..."
        counter = 0
        
        let concurrentQueue = DispatchQueue.global()
        let serialQueue = DispatchQueue(label: "com.example.serial")
        
        for i in 1...1000 {
            concurrentQueue.async {
                serialQueue.sync {
                    self.counter += 1
                }
                
                if i == 1000 {
                    DispatchQueue.main.async {
                        self.result = "线程安全操作 (串行队列) 完成，最终计数: \(self.counter)"
                        self.isLoading = false
                    }
                }
            }
        }
    }
    
    func threadSafeWithActor() {
        isLoading = true
        result = "开始线程安全操作 (Actor)..."
        
        Task {
            await safeCounter.reset()
            
            await withTaskGroup(of: Void.self) { group in
                for _ in 1...1000 {
                    group.addTask {
                        await self.safeCounter.increment()
                    }
                }
            }
            
            let finalCount = await safeCounter.value
            
            DispatchQueue.main.async {
                self.result = "线程安全操作 (Actor) 完成，最终计数: \(finalCount)"
                self.counter = finalCount
                self.isLoading = false
            }
        }
    }
    
    func atomicOperationDemo() {
        isLoading = true
        result = "开始原子操作演示..."
        counter = 0
        
        let queue = DispatchQueue.global()
        let atomicCounter = AtomicInt(value: 0)
        
        for i in 1...1000 {
            queue.async {
                atomicCounter.increment()
                
                if i == 1000 {
                    DispatchQueue.main.async {
                        let finalValue = atomicCounter.value
                        self.counter = finalValue
                        self.result = "原子操作演示完成，最终计数: \(finalValue)"
                        self.isLoading = false
                    }
                }
            }
        }
    }
    
    // 线程安全的Actor计数器
    actor SafeCounter {
        private var _value = 0
        
        var value: Int {
            get async { _value }
        }
        
        func increment() {
            _value += 1
        }
        
        func reset() {
            _value = 0
        }
    }
    
    // 原子整型
    class AtomicInt {
        private var _value: Int
        private let lock = NSLock()
        
        init(value: Int) {
            _value = value
        }
        
        var value: Int {
            get {
                lock.lock()
                defer { lock.unlock() }
                return _value
            }
        }
        
        func increment() {
            lock.lock()
            defer { lock.unlock() }
            _value += 1
        }
        
        func reset() {
            lock.lock()
            defer { lock.unlock() }
            _value = 0
        }
    }
}

struct ThreadSafetyDemo_Previews: PreviewProvider {
    static var previews: some View {
        ThreadSafetyDemo()
    }
}
