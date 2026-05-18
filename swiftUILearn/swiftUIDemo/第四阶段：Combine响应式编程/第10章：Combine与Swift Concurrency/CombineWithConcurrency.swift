//
//  CombineWithConcurrency.swift
//  swiftUIDemo
//
//  Created by AI Assistant
//  Combine与Swift Concurrency结合示例
//

import SwiftUI
import Combine

// MARK: - 数据模型

struct NewsArticle: Identifiable, Codable {
    let id: UUID
    let title: String
    let content: String
    let author: String
}

// MARK: - ViewModel

class NewsViewModel: ObservableObject {
    @Published var articles: [NewsArticle] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let service = NewsService()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        // 使用Combine监听实时更新
        observeArticleUpdates()
    }
    
    // 1. 使用 async/await 加载数据
    func loadArticles() async {
        await MainActor.run {
            isLoading = true
            errorMessage = nil
        }
        
        do {
            let articles = try await service.fetchArticles()
            await MainActor.run {
                self.articles = articles
                self.isLoading = false
            }
        } catch {
            await MainActor.run {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        }
    }
    
    // 2. 使用Combine监听更新
    private func observeArticleUpdates() {
        service.articleUpdates
            .receive(on: DispatchQueue.main)
            .sink { [weak self] update in
                self?.applyUpdate(update)
            }
            .store(in: &cancellables)
    }
    
    private func applyUpdate(_ update: ArticleUpdate) {
        switch update {
        case .new(let article):
            articles.insert(article, at: 0)
        case .delete(let id):
            articles.removeAll { $0.id == id }
        }
    }
    
    // 3. 将Publisher转换为async函数
    func fetchFirstArticle() async throws -> [NewsArticle] {
        let publisher = service.fetchArticlesAsPublisher()
        return try await publisher.first()
    }
    
    func triggerUpdate() {
        let newArticle = NewsArticle(
            id: UUID(),
            title: "新文章: \(Date().formatted())",
            content: "这是一篇实时更新的文章",
            author: "System"
        )
        service.triggerNewArticle(newArticle)
    }
}

// MARK: - Service

enum ArticleUpdate {
    case new(NewsArticle)
    case delete(UUID)
}

class NewsService {
    private let updateSubject = PassthroughSubject<ArticleUpdate, Never>()
    var articleUpdates: AnyPublisher<ArticleUpdate, Never> {
        updateSubject.eraseToAnyPublisher()
    }
    
    // async/await 方式
    func fetchArticles() async throws -> [NewsArticle] {
        // 模拟网络延迟
        try await Task.sleep(nanoseconds: 1_500_000_000)
        
        return [
            NewsArticle(
                id: UUID(),
                title: "Swift 6.0 新特性介绍",
                content: "Swift 6.0 带来了很多激动人心的新特性...",
                author: "Tim Cook"
            ),
            NewsArticle(
                id: UUID(),
                title: "Combine 最佳实践",
                content: "在项目中正确使用Combine的建议...",
                author: "John Doe"
            ),
            NewsArticle(
                id: UUID(),
                title: "iOS 18 更新指南",
                content: "iOS 18 的新功能和API变更...",
                author: "Jane Smith"
            )
        ]
    }
    
    // Combine 方式
    func fetchArticlesAsPublisher() -> AnyPublisher<[NewsArticle], Error> {
        Future { promise in
            Task {
                do {
                    let articles = try await self.fetchArticles()
                    promise(.success(articles))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func triggerNewArticle(_ article: NewsArticle) {
        updateSubject.send(.new(article))
    }
}

// MARK: - Publisher扩展

extension Publisher {
    func first() async throws -> Output {
        try await withCheckedThrowingContinuation { continuation in
            var cancellable: AnyCancellable?
            var hasResumed = false
            
            cancellable = self
                .first()
                .sink(
                    receiveCompletion: { completion in
                        guard !hasResumed else { return }
                        hasResumed = true
                        
                        if case .failure(let error) = completion {
                            continuation.resume(throwing: error)
                        }
                    },
                    receiveValue: { value in
                        guard !hasResumed else { return }
                        hasResumed = true
                        continuation.resume(returning: value)
                    }
                )
        }
    }
}

// MARK: - View

struct CombineWithConcurrencyDemo: View {
    @StateObject private var viewModel = NewsViewModel()
    @State private var showTimerDemo = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Combine & Concurrency")
                    .font(.largeTitle)
                    .foregroundColor(.blue)
                    .fontWeight(.bold)
                
                // 操作按钮
                HStack(spacing: 15) {
                    Button {
                        Task {
                            await viewModel.loadArticles()
                        }
                    } label: {
                        HStack {
                            if viewModel.isLoading {
                                ProgressView()
                            } else {
                                Image(systemName: "arrow.clockwise")
                                Text("刷新 (async/await)")
                            }
                        }
                    }
                    .disabled(viewModel.isLoading)
                    .padding()
                    .background(.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    
                    Button {
                        viewModel.triggerUpdate()
                    } label: {
                        HStack {
                            Image(systemName: "plus")
                            Text("新文章 (Combine)")
                        }
                    }
                    .padding()
                    .background(.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                
                // 错误消息
                if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .padding()
                        .background(.red.opacity(0.1))
                        .cornerRadius(8)
                }
                
                // 文章列表
                List(viewModel.articles) { article in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(article.title)
                            .font(.headline)
                        Text(article.author)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Text(article.content)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .listStyle(.plain)
                
                Spacer()
                
                NavigationLink("定时器演示 (AsyncStream)") {
                    TimerDemoView()
                }
                .padding()
                .background(.orange)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .padding()
            .navigationTitle("混合编程")
        }
    }
}

// MARK: - Timer Demo

struct TimerDemoView: View {
    @State private var timerCount = 0
    @State private var timerTask: Task<Void, Never>?
    
    var body: some View {
        VStack(spacing: 30) {
            Text("AsyncStream 定时器")
                .font(.largeTitle)
                .foregroundColor(.orange)
                .fontWeight(.bold)
            
            Text("计数: \(timerCount)")
                .font(.system(size: 60, weight: .bold))
                .monospacedDigit()
            
            HStack(spacing: 20) {
                Button {
                    startTimer()
                } label: {
                    HStack {
                        Image(systemName: "play.fill")
                        Text("开始")
                    }
                    .padding()
                    .background(.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                
                Button {
                    stopTimer()
                } label: {
                    HStack {
                        Image(systemName: "stop.fill")
                        Text("停止")
                    }
                    .padding()
                    .background(.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                
                Button {
                    timerCount = 0
                } label: {
                    HStack {
                        Image(systemName: "arrow.clockwise")
                        Text("重置")
                    }
                    .padding()
                    .background(.orange)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
            }
            
            Text("使用 AsyncStream 和 Task 实现")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding()
    }
    
    func startTimer() {
        timerTask = Task {
            let stream = AsyncStream<Date> { continuation in
                let timer = Timer.publish(every: 1, on: .main, in: .common)
                    .autoconnect()
                    .sink { date in
                        continuation.yield(date)
                    }
                
                continuation.onTermination = { _ in
                    timer.cancel()
                }
            }
            
            for await _ in stream {
                timerCount += 1
            }
        }
    }
    
    func stopTimer() {
        timerTask?.cancel()
        timerTask = nil
    }
}

#Preview {
    CombineWithConcurrencyDemo()
}
