//
//  SearchView.swift
//  swiftUIDemo
//
//  Created by AI Assistant
//  NewsPro - 搜索视图
//

import SwiftUI
import Combine

struct NewsProSearchView: View {
    @StateObject private var viewModel = NewsProSearchViewModel()
    @State private var selectedArticle: NewsProNewsArticle?
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                searchBar
                
                if viewModel.searchText.isEmpty {
                    searchHistoryView
                } else if viewModel.isSearching {
                    loadingView
                } else if viewModel.searchResults.isEmpty {
                    emptyResultsView
                } else {
                    searchResultsList
                }
            }
            .navigationTitle("搜索")
            .navigationDestination(item: $selectedArticle) { article in
                NewsProNewsDetailView(article: article)
            }
        }
    }
    
    private var searchBar: some View {
        HStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("搜索新闻...", text: $viewModel.searchText)
                .textFieldStyle(.plain)
            
            if !viewModel.searchText.isEmpty {
                Button {
                    viewModel.clearSearch()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .padding()
    }
    
    private var searchHistoryView: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                if !viewModel.searchHistory.isEmpty {
                    HStack {
                        Text("搜索历史")
                            .font(.headline)
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        Button("清空") {
                            viewModel.clearHistory()
                        }
                        .font(.subheadline)
                        .foregroundColor(.blue)
                    }
                    
                    ForEach(viewModel.searchHistory, id: \.self) { query in
                        HStack {
                            Button {
                                viewModel.searchText = query
                            } label: {
                                HStack {
                                    Image(systemName: "clock")
                                        .foregroundColor(.gray)
                                    Text(query)
                                        .foregroundColor(.primary)
                                    Spacer()
                                }
                            }
                            
                            Button {
                                viewModel.removeHistory(query)
                            } label: {
                                Image(systemName: "xmark")
                                    .foregroundColor(.gray)
                                    .font(.caption)
                            }
                        }
                        .padding(.vertical, 8)
                    }
                }
                
                if !viewModel.hotSearchKeywords.isEmpty {
                    Text("热门搜索")
                        .font(.headline)
                        .fontWeight(.bold)
                    
                    FlowLayout(spacing: 8) {
                        ForEach(viewModel.hotSearchKeywords, id: \.self) { keyword in
                            Button {
                                viewModel.searchText = keyword
                            } label: {
                                Text(keyword)
                                    .font(.subheadline)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Color.blue.opacity(0.1))
                                    .foregroundColor(.blue)
                                    .cornerRadius(16)
                            }
                        }
                    }
                }
                
                Spacer()
            }
            .padding()
        }
    }
    
    private var loadingView: some View {
        VStack {
            Spacer()
            ProgressView()
            Text("搜索中...")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding(.top, 10)
            Spacer()
        }
    }
    
    private var emptyResultsView: some View {
        VStack(spacing: 20) {
            Spacer()
            Image(systemName: "magnifyingglass")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            Text("未找到相关结果")
                .font(.title2)
                .fontWeight(.semibold)
            Text("换个关键词试试吧")
                .font(.subheadline)
                .foregroundColor(.secondary)
            Spacer()
        }
    }
    
    private var searchResultsList: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.searchResults) { article in
                    NewsProSearchResultCard(article: article)
                        .onTapGesture {
                            selectedArticle = article
                        }
                }
            }
            .padding()
        }
    }
}

struct NewsProSearchResultCard: View {
    let article: NewsProNewsArticle
    
    var body: some View {
        HStack(spacing: 12) {
            if let imageURL = article.imageURL, let url = URL(string: imageURL) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                }
                .frame(width: 100, height: 80)
                .cornerRadius(8)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text(article.category.displayName)
                    .font(.caption)
                    .foregroundColor(.white)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(article.category.color)
                    .cornerRadius(4)
                
                Text(article.title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .lineLimit(2)
                
                HStack {
                    Text(article.author)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Text(article.publishedAt, style: .relative)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

struct FlowLayout: Layout {
    var spacing: CGFloat = 8
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = FlowResult(in: proposal.width ?? 0, spacing: spacing, subviews: subviews)
        return result.size
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = FlowResult(in: bounds.width, spacing: spacing, subviews: subviews)
        for (index, subview) in subviews.enumerated() {
            subview.place(at: CGPoint(x: bounds.minX + result.positions[index].x,
                                       y: bounds.minY + result.positions[index].y),
                          proposal: .unspecified)
        }
    }
    
    struct FlowResult {
        var size: CGSize = .zero
        var positions: [CGPoint] = []
        
        init(in maxWidth: CGFloat, spacing: CGFloat, subviews: Subviews) {
            var x: CGFloat = 0
            var y: CGFloat = 0
            var rowHeight: CGFloat = 0
            
            for subview in subviews {
                let size = subview.sizeThatFits(.unspecified)
                
                if x + size.width > maxWidth && x > 0 {
                    x = 0
                    y += rowHeight + spacing
                    rowHeight = 0
                }
                
                positions.append(CGPoint(x: x, y: y))
                rowHeight = max(rowHeight, size.height)
                x += size.width + spacing
            }
            
            self.size = CGSize(width: maxWidth, height: y + rowHeight)
        }
    }
}

class NewsProSearchViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var searchResults: [NewsProNewsArticle] = []
    @Published var isSearching = false
    @Published var searchHistory: [String] = []
    @Published var errorMessage: String?
    
    let hotSearchKeywords = ["iPhone", "AI", "NBA", "科技", "健康"]
    
    private var cancellables = Set<AnyCancellable>()
    private let newsService = NewsProNewsService.shared
    
    init() {
        loadSearchHistory()
        setupSearchBinding()
    }
    
    private func setupSearchBinding() {
        $searchText
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .filter { !$0.isEmpty }
            .sink { [weak self] query in
                self?.performSearch(query: query)
            }
            .store(in: &cancellables)
    }
    
    private func performSearch(query: String) {
        isSearching = true
        
        newsService.searchArticles(query: query)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isSearching = false
                    if case .failure(let error) = completion {
                        self?.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] result in
                    self?.searchResults = result.articles
                    self?.addToHistory(query)
                }
            )
            .store(in: &cancellables)
    }
    
    private func loadSearchHistory() {
        searchHistory = NewsProCacheService.shared.getSearchHistory()
    }
    
    private func addToHistory(_ query: String) {
        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedQuery.isEmpty else { return }
        
        var history = searchHistory
        history.removeAll { $0.lowercased() == trimmedQuery.lowercased() }
        history.insert(trimmedQuery, at: 0)
        history = Array(history.prefix(10))
        searchHistory = history
        
        NewsProCacheService.shared.addSearchHistory(trimmedQuery)
    }
    
    func clearSearch() {
        searchText = ""
        searchResults = []
    }
    
    func clearHistory() {
        searchHistory = []
        NewsProCacheService.shared.clearSearchHistory()
    }
    
    func removeHistory(_ query: String) {
        searchHistory.removeAll { $0 == query }
        NewsProCacheService.shared.removeSearchHistory(query)
    }
}

#Preview {
    NewsProSearchView()
}
