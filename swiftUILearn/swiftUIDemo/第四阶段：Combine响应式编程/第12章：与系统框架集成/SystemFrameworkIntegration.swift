//
//  SystemFrameworkIntegration.swift
//  swiftUIDemo
//
//  Created by AI Assistant
//  与系统框架集成示例
//

import SwiftUI
import Combine
import Foundation

// MARK: - 通知名称
extension Notification.Name {
    static let dataDidUpdate = Notification.Name("dataDidUpdate")
    static let userDidLogin = Notification.Name("userDidLogin")
    static let timerTick = Notification.Name("timerTick")
}

class SystemFrameworkViewModel: ObservableObject {
    // MARK: - 发布属性
    @Published var notificationLog = ""
    @Published var timerLog = ""
    @Published var countdownValue = 10
    @Published var isCountdownRunning = false
    @Published var kvoValue = 0
    @Published var networkStatus = ""
    @Published var searchQuery = ""
    @Published var searchResults: [String] = []
    @Published var isSearching = false
    
    private var cancellables = Set<AnyCancellable>()
    private var countdownTimer: AnyCancellable?
    
    // MARK: - 1. NotificationCenter 示例
    func setupNotifications() {
        notificationLog = "监听通知中...\n"
        
        // 监听自定义通知
        NotificationCenter.default.publisher(for: .dataDidUpdate)
            .sink { [weak self] notification in
                if let message = notification.object as? String {
                    self?.notificationLog += "📬 收到通知: \(message)\n"
                }
            }
            .store(in: &cancellables)
        
        NotificationCenter.default.publisher(for: .userDidLogin)
            .sink { [weak self] notification in
                if let userInfo = notification.userInfo,
                   let userName = userInfo["userName"] as? String {
                    self?.notificationLog += "👤 用户登录: \(userName)\n"
                }
            }
            .store(in: &cancellables)
    }
    
    func sendNotification() {
        // 发送简单通知
        NotificationCenter.default.post(
            name: .dataDidUpdate,
            object: "数据已更新!"
        )
    }
    
    func sendLoginNotification() {
        // 发送带用户信息通知
        NotificationCenter.default.post(
            name: .userDidLogin,
            object: nil,
            userInfo: ["userName": "张三", "loginTime": Date()]
        )
    }
    
    // MARK: - 2. Timer Publisher 示例
    func startTimer() {
        timerLog = "定时器开始...\n"
        
        Timer.publish(every: 1.0, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] date in
                let timeFormatter = DateFormatter()
                timeFormatter.dateFormat = "HH:mm:ss"
                self?.timerLog += "⏰ \(timeFormatter.string(from: date))\n"
            }
            .store(in: &cancellables)
    }
    
    func startCountdown() {
        countdownValue = 10
        isCountdownRunning = true
        
        countdownTimer = Timer.publish(every: 1.0, on: .main, in: .common)
            .autoconnect()
            .prefix(11)
            .sink { [weak self] _ in
                guard let self = self else { return }
                if self.countdownValue > 0 {
                    self.countdownValue -= 1
                    self.timerLog += "⏳ 倒计时: \(self.countdownValue)\n"
                } else {
                    self.isCountdownRunning = false
                    self.timerLog += "🎉 倒计时结束!\n"
                }
            }
    }
    
    func stopCountdown() {
        countdownTimer?.cancel()
        countdownTimer = nil
        isCountdownRunning = false
    }
    
    // MARK: - 3. 模拟KVO示例
    class MyObservable: ObservableObject {
        @Published var count: Int = 0
        
        func increment() {
            count += 1
        }
    }
    
    func testKVO() {
        let observable = MyObservable()
        kvoValue = 0
        notificationLog += "KVO测试开始...\n"
        
        observable.$count
            .sink { [weak self] newValue in
                self?.kvoValue = newValue
                self?.notificationLog += "📊 计数变化: \(newValue)\n"
            }
            .store(in: &cancellables)
        
        // 模拟变化
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            observable.increment()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            observable.increment()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            observable.increment()
        }
    }
    
    // MARK: - 4. 搜索示例（综合应用）
    func setupSearch() {
        $searchQuery
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .filter { !$0.isEmpty }
            .handleEvents(receiveOutput: { [weak self] _ in
                self?.isSearching = true
                self?.networkStatus = "搜索中..."
            })
            .sink { [weak self] query in
                self?.performSearch(query: query)
            }
            .store(in: &cancellables)
    }
    
    private func performSearch(query: String) {
        // 模拟网络请求延迟
        Just(())
            .delay(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                // 模拟搜索结果
                self?.searchResults = [
                    "\(query) - 结果 1",
                    "\(query) - 结果 2",
                    "\(query) - 结果 3",
                    "\(query) - 结果 4",
                    "\(query) - 结果 5"
                ]
                self?.isSearching = false
                self?.networkStatus = "找到 \(self?.searchResults.count ?? 0) 个结果"
            }
            .store(in: &cancellables)
    }
    
    func stopAll() {
        cancellables.removeAll()
        countdownTimer?.cancel()
        countdownTimer = nil
    }
}

struct SystemFrameworkDemo: View {
    @StateObject private var viewModel = SystemFrameworkViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("系统框架集成")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                
                // 1. NotificationCenter
                VStack(alignment: .leading, spacing: 10) {
                    Text("1. NotificationCenter")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    HStack(spacing: 10) {
                        Button("发送通知") {
                            viewModel.sendNotification()
                        }
                        .padding()
                        .background(.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        
                        Button("用户登录") {
                            viewModel.sendLoginNotification()
                        }
                        .padding()
                        .background(.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                    
                    ScrollView {
                        Text(viewModel.notificationLog)
                            .font(.system(.caption, design: .monospaced))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .frame(height: 120)
                    .border(Color.gray.opacity(0.3))
                }
                .padding()
                .background(.blue.opacity(0.1))
                .cornerRadius(10)
                .onAppear {
                    viewModel.setupNotifications()
                }
                
                // 2. Timer Publisher
                VStack(alignment: .leading, spacing: 10) {
                    Text("2. Timer Publisher")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    HStack(spacing: 10) {
                        Button("开始计时") {
                            viewModel.startTimer()
                        }
                        .padding()
                        .background(.orange)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        
                        Button("开始倒计时") {
                            viewModel.startCountdown()
                        }
                        .padding()
                        .background(.red)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .disabled(viewModel.isCountdownRunning)
                        
                        Button("停止") {
                            viewModel.stopCountdown()
                        }
                        .padding()
                        .background(.gray)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                    
                    HStack {
                        Text("倒计时:")
                            .font(.headline)
                        Text("\(viewModel.countdownValue)")
                            .font(.system(size: 48, weight: .bold))
                            .foregroundColor(viewModel.isCountdownRunning ? .red : .gray)
                    }
                    
                    ScrollView {
                        Text(viewModel.timerLog)
                            .font(.system(.caption, design: .monospaced))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .frame(height: 100)
                    .border(Color.gray.opacity(0.3))
                }
                .padding()
                .background(.orange.opacity(0.1))
                .cornerRadius(10)
                
                // 3. 模拟KVO
                VStack(alignment: .leading, spacing: 10) {
                    Text("3. KVO 观察")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Button("测试KVO") {
                        viewModel.testKVO()
                    }
                    .padding()
                    .background(.purple)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    
                    HStack {
                        Text("当前值:")
                            .font(.headline)
                        Text("\(viewModel.kvoValue)")
                            .font(.system(size: 36, weight: .bold))
                            .foregroundColor(.purple)
                    }
                }
                .padding()
                .background(.purple.opacity(0.1))
                .cornerRadius(10)
                
                // 4. 搜索示例
                VStack(alignment: .leading, spacing: 10) {
                    Text("4. 搜索示例")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    HStack {
                        TextField("输入搜索...", text: $viewModel.searchQuery)
                            .textFieldStyle(.roundedBorder)
                        
                        if viewModel.isSearching {
                            ProgressView()
                        }
                    }
                    
                    Text(viewModel.networkStatus)
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    if !viewModel.searchResults.isEmpty {
                        List(viewModel.searchResults, id: \.self) { result in
                            Text(result)
                        }
                        .listStyle(.plain)
                        .frame(height: 150)
                    }
                }
                .padding()
                .background(.teal.opacity(0.1))
                .cornerRadius(10)
                .onAppear {
                    viewModel.setupSearch()
                }
                
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
    SystemFrameworkDemo()
}
