import SwiftUI

/// 多线程基础概念示例
struct ThreadBasics: View {
    @State private var isLoading = false
    @State private var result: String = "点击按钮开始"
    @State private var threadInfo: String = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Text("多线程基础概念")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text(threadInfo)
                .font(.subheadline)
                .foregroundColor(.gray)
            
            Text(result)
                .font(.body)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
            
            HStack(spacing: 10) {
                Button("主线程操作") {
                    performOnMainThread()
                }
                .buttonStyle(.borderedProminent)
                
                Button("后台线程操作") {
                    performOnBackgroundThread()
                }
                .buttonStyle(.bordered)
            }
            
            Button("并行操作") {
                performParallelOperations()
            }
            .buttonStyle(.bordered)
        }
        .padding()
        .onAppear {
            updateThreadInfo()
        }
    }
    
    func updateThreadInfo() {
        let thread = Thread.current
        threadInfo = "当前线程: \(thread.name ?? "Unknown"), 主线程: \(thread.isMainThread)"
    }
    
    func performOnMainThread() {
        updateThreadInfo()
        result = "在主线程执行..."
        
        // 模拟耗时操作
        Thread.sleep(forTimeInterval: 2)
        
        result = "主线程操作完成"
        updateThreadInfo()
    }
    
    func performOnBackgroundThread() {
        result = "在后台线程执行..."
        
        DispatchQueue.global(qos: .userInitiated).async {
            // 模拟耗时操作
            Thread.sleep(forTimeInterval: 2)
            
            let thread = Thread.current
            let threadName = thread.name ?? "Unknown"
            
            DispatchQueue.main.async {
                result = "后台线程操作完成 (线程: \(threadName))"
                updateThreadInfo()
            }
        }
    }
    
    func performParallelOperations() {
        result = "开始并行操作..."
        
        let group = DispatchGroup()
        var results: [String] = []
        
        // 并行执行3个任务
        for i in 1...3 {
            group.enter()
            
            DispatchQueue.global().async {
                // 模拟不同时长的任务
                Thread.sleep(forTimeInterval: TimeInterval(i))
                
                DispatchQueue.main.async {
                    results.append("任务 \(i) 完成")
                }
                
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            result = "所有并行任务完成:\n" + results.joined(separator: "\n")
            updateThreadInfo()
        }
    }
}

struct ThreadBasics_Previews: PreviewProvider {
    static var previews: some View {
        ThreadBasics()
    }
}
