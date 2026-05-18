//
//  MainTabView.swift
//  swiftUIDemo
//
//  Created by AI Assistant
//  NewsPro - 主标签导航视图
//

import SwiftUI
import Combine

// MARK: - 主标签视图
struct NewsProMainTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            NewsProNewsListView()
                .tabItem {
                    Label("首页", systemImage: "newspaper.fill")
                }
                .tag(0)
            
            NewsProFavoritesView()
                .tabItem {
                    Label("收藏", systemImage: "heart.fill")
                }
                .tag(1)
            
            NewsProSearchView()
                .tabItem {
                    Label("搜索", systemImage: "magnifyingglass")
                }
                .tag(2)
            
            NewsProProfileView()
                .tabItem {
                    Label("我的", systemImage: "person.fill")
                }
                .tag(3)
        }
        .tint(.blue)
    }
}

// MARK: - 收藏视图
struct NewsProFavoritesView: View {
    @StateObject private var viewModel = NewsProFavoritesViewModel()
    @State private var selectedArticle: NewsProNewsArticle?
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.favoriteArticles.isEmpty && !viewModel.isLoading {
                    emptyStateView
                } else {
                    articlesList
                }
            }
            .navigationTitle("我的收藏")
            .navigationDestination(item: $selectedArticle) { article in
                NewsProNewsDetailView(article: article)
            }
        }
        .onAppear {
            viewModel.loadFavorites()
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "heart.slash")
                .font(.system(size: 80))
                .foregroundColor(.gray)
            
            Text("暂无收藏")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("浏览新闻时，点击收藏按钮\n即可将喜欢的文章收藏起来")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
    
    private var articlesList: some View {
        List {
            ForEach(viewModel.favoriteArticles) { article in
                NewsProNewsCard(article: article)
                    .onTapGesture {
                        selectedArticle = article
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button(role: .destructive) {
                            viewModel.removeFavorite(article)
                        } label: {
                            Label("取消收藏", systemImage: "heart.slash")
                        }
                    }
            }
        }
        .listStyle(.plain)
        .refreshable {
            viewModel.loadFavorites()
        }
    }
}

// MARK: - 收藏视图模型
class NewsProFavoritesViewModel: ObservableObject {
    @Published var favoriteArticles: [NewsProNewsArticle] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    
    func loadFavorites() {
        isLoading = true
        
        NewsProNewsService.shared.fetchFavoriteArticles()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case .failure(let error) = completion {
                        self?.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] articles in
                    self?.favoriteArticles = articles
                }
            )
            .store(in: &cancellables)
    }
    
    func removeFavorite(_ article: NewsProNewsArticle) {
        NewsProNewsService.shared.toggleFavorite(articleId: article.id)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] _ in
                    self?.favoriteArticles.removeAll { $0.id == article.id }
                }
            )
            .store(in: &cancellables)
    }
}

// MARK: - 预览
#Preview {
    NewsProMainTabView()
}
