import SwiftUI

/// 主线程与UI更新示例
struct MainThreadUIUpdate: View {
    @State private var isLoading = false
    @State private var result: String = "点击按钮开始"
    @State private var counter = 0
    @State private var imageData: Data? = nil
    
    var body: some View {
        VStack(spacing: 20) {
            Text("主线程与UI更新")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text(result)
                .font(.body)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
            
            Text("计数器: \(counter)")
                .font(.title)
                .fontWeight(.semibold)
            
            if let imageData = imageData, let image = UIImage(data: imageData) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .cornerRadius(8)
            }
            
            if isLoading {
                ProgressView()
                    .scaleEffect(1.5)
            }
            
            HStack(spacing: 10) {
                Button("错误：后台线程更新UI") {
                    updateUIOnBackgroundThread()
                }
                .buttonStyle(.bordered)
                
                Button("正确：主线程更新UI") {
                    updateUIOnMainThread()
                }
                .buttonStyle(.borderedProminent)
            }
            
            HStack(spacing: 10) {
                Button("@MainActor更新") {
                    updateUIWithMainActor()
                }
                .buttonStyle(.bordered)
                
                Button("加载网络图片") {
                    loadNetworkImage()
                }
                .buttonStyle(.bordered)
            }
            
            Button("避免主线程阻塞") {
                avoidMainThreadBlocking()
            }
            .buttonStyle(.bordered)
        }
        .padding()
    }
    
    func updateUIOnBackgroundThread() {
        isLoading = true
        result = "开始在后台线程更新UI..."
        
        DispatchQueue.global().async {
            print("当前线程: \(Thread.current), 主线程: \(Thread.current.isMainThread)")
            
            // 模拟耗时操作
            Thread.sleep(forTimeInterval: 2)
            
            // 错误：在后台线程更新UI
            self.counter += 1
            self.result = "错误：在后台线程更新UI (可能导致崩溃)"
            
            DispatchQueue.main.async {
                self.isLoading = false
            }
        }
    }
    
    func updateUIOnMainThread() {
        isLoading = true
        result = "开始在主线程更新UI..."
        
        DispatchQueue.global().async {
            print("后台线程: \(Thread.current), 主线程: \(Thread.current.isMainThread)")
            
            // 模拟耗时操作
            Thread.sleep(forTimeInterval: 2)
            
            // 正确：切换到主线程更新UI
            DispatchQueue.main.async {
                print("主线程: \(Thread.current), 主线程: \(Thread.current.isMainThread)")
                self.counter += 1
                self.result = "正确：在主线程更新UI"
                self.isLoading = false
            }
        }
    }
    
    func updateUIWithMainActor() {
        isLoading = true
        result = "开始使用@MainActor更新UI..."
        
        Task {
            await performBackgroundTask()
        }
    }
    
    @MainActor
    func performBackgroundTask() async {
        // 这个函数在主线程执行
        print("@MainActor函数 - 当前线程: \(Thread.current), 主线程: \(Thread.current.isMainThread)")
        
        // 但我们可以启动后台任务
        let backgroundTask = Task.detached {
            print("后台任务 - 当前线程: \(Thread.current), 主线程: \(Thread.current.isMainThread)")
            // 模拟耗时操作
            try? await Task.sleep(nanoseconds: 2 * 1_000_000_000)
            return 42
        }
        
        let resultValue = await backgroundTask.value
        
        // 这里仍然在主线程
        print("@MainActor函数 - 任务完成，当前线程: \(Thread.current), 主线程: \(Thread.current.isMainThread)")
        
        self.counter = resultValue
        self.result = "使用@MainActor更新UI完成"
        self.isLoading = false
    }
    
    func loadNetworkImage() {
        isLoading = true
        result = "开始加载网络图片..."
        
        DispatchQueue.global().async {
            // 模拟网络请求加载图片
            print("加载图片 - 当前线程: \(Thread.current)")
            
            // 模拟网络延迟
            Thread.sleep(forTimeInterval: 3)
            
            // 创建一个示例图片
            let size = CGSize(width: 200, height: 200)
            UIGraphicsBeginImageContext(size)
            let context = UIGraphicsGetCurrentContext()!
            
            // 绘制一个渐变背景
            let gradient = CGGradient(colorsSpace: nil, colors: [UIColor.blue.cgColor, UIColor.purple.cgColor] as CFArray, locations: nil)!
            context.drawLinearGradient(gradient, start: CGPoint(x: 0, y: 0), end: CGPoint(x: size.width, y: size.height), options: [])
            
            // 绘制文字
            let text = "网络图片"
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.boldSystemFont(ofSize: 20),
                .foregroundColor: UIColor.white
            ]
            let textSize = text.size(withAttributes: attributes)
            let textRect = CGRect(
                x: (size.width - textSize.width) / 2,
                y: (size.height - textSize.height) / 2,
                width: textSize.width,
                height: textSize.height
            )
            text.draw(in: textRect, withAttributes: attributes)
            
            let image = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            
            // 转换为Data
            let imageData = image.pngData()!
            
            // 切换到主线程更新UI
            DispatchQueue.main.async {
                self.imageData = imageData
                self.result = "网络图片加载完成"
                self.isLoading = false
            }
        }
    }
    
    func avoidMainThreadBlocking() {
        isLoading = true
        result = "开始避免主线程阻塞演示..."
        
        // 在主线程启动，但耗时操作在后台
        Task {
            // 这里在主线程
            print("Task开始 - 当前线程: \(Thread.current), 主线程: \(Thread.current.isMainThread)")
            
            // 启动后台任务
            let heavyResult = await Task.detached {
                print("后台任务 - 当前线程: \(Thread.current), 主线程: \(Thread.current.isMainThread)")
                
                // 模拟非常耗时的操作
                var sum = 0
                for i in 1...10_000_000 {
                    sum += i
                }
                return sum
            }.value
            
            // 回到主线程
            print("Task完成 - 当前线程: \(Thread.current), 主线程: \(Thread.current.isMainThread)")
            
            self.result = "避免主线程阻塞演示完成，计算结果: \(heavyResult)"
            self.isLoading = false
        }
        
        // 这里会立即执行，不会被阻塞
        print("函数返回 - 主线程没有被阻塞")
    }
}

struct MainThreadUIUpdate_Previews: PreviewProvider {
    static var previews: some View {
        MainThreadUIUpdate()
    }
}
