//
//  NewsListViewModel.swift
//  swiftUIDemo
//
//  Created by AI Assistant
//  NewsPro - 新闻列表视图模型
//

import Foundation
import Combine

class NewsProNewsListViewModel: ObservableObject {
    @Published var articles: [NewsProNewsArticle] = []
    @Published var isLoading = false
    @Published var isLoadingMore = false
    @Published var errorMessage: String?
    @Published var selectedCategory: NewsProNewsCategory?
    @Published var searchQuery = ""
    @Published var hasMorePages = true
    
    private var currentPage = 1
    private var cancellables = Set<AnyCancellable>()
    private let newsService = NewsProNewsService.shared
    
    var filteredArticles: [NewsProNewsArticle] {
        if searchQuery.isEmpty {
            return articles
        }
        return articles.filter { article in
            article.title.localizedCaseInsensitiveContains(searchQuery) ||
            article.summary.localizedCaseInsensitiveContains(searchQuery)
        }
    }
    
    init() {
        setupSearchBinding()
        loadInitialData()
    }
    
    private func setupSearchBinding() {
        $searchQuery
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] query in
                if query.isEmpty {
                    self?.loadInitialData()
                } else {
                    self?.searchArticles(query: query)
                }
            }
            .store(in: &cancellables)
    }
    
    func loadInitialData() {
        isLoading = true
        currentPage = 1
        
        newsService.fetchArticles(category: selectedCategory, page: 1)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case .failure(let error) = completion {
                        self?.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] response in
                    self?.articles = response.items
                    self?.hasMorePages = response.hasMore
                    self?.currentPage = response.page
                }
            )
            .store(in: &cancellables)
    }
    
    func loadMoreArticles() {
        guard hasMorePages, !isLoadingMore else { return }
        
        isLoadingMore = true
        
        newsService.loadMoreArticles(category: selectedCategory)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoadingMore = false
                    if case .failure(let error) = completion {
                        self?.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] response in
                    guard let self = self else { return }
                    self.articles.append(contentsOf: response.items)
                    self.hasMorePages = response.hasMore
                    self.currentPage = response.page
                }
            )
            .store(in: &cancellables)
    }
    
    func refresh() {
        loadInitialData()
    }
    
    func selectCategory(_ category: NewsProNewsCategory?) {
        selectedCategory = category
        NewsProCacheService.shared.setSelectedCategory(category)
        loadInitialData()
    }
    
    func toggleFavorite(_ article: NewsProNewsArticle) {
        newsService.toggleFavorite(articleId: article.id)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] updatedArticle in
                    guard let self = self,
                          let index = self.articles.firstIndex(where: { $0.id == updatedArticle.id }) else { return }
                    self.articles[index] = updatedArticle
                }
            )
            .store(in: &cancellables)
    }
    
    private func searchArticles(query: String) {
        isLoading = true
        
        newsService.searchArticles(query: query)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case .failure(let error) = completion {
                        self?.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] result in
                    self?.articles = result.articles
                    self?.hasMorePages = false
                }
            )
            .store(in: &cancellables)
    }
}
