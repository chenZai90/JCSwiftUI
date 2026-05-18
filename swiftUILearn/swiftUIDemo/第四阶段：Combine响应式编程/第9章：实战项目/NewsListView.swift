//
//  NewsListView.swift
//  swiftUIDemo
//
//  Created by AI Assistant
//  NewsPro - 新闻列表视图
//

import SwiftUI

struct NewsProNewsListView: View {
    @StateObject private var viewModel = NewsProNewsListViewModel()
    @State private var selectedArticle: NewsProNewsArticle?
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                categorySelector
                
                if viewModel.isLoading && viewModel.articles.isEmpty {
                    loadingView
                } else if let error = viewModel.errorMessage, viewModel.articles.isEmpty {
                    errorView(message: error)
                } else {
                    articlesList
                }
            }
            .navigationTitle("NewsPro")
            .navigationDestination(item: $selectedArticle) { article in
                NewsProNewsDetailView(article: article)
            }
        }
    }
    
    private var categorySelector: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                NewsProCategoryButton(
                    title: "全部",
                    isSelected: viewModel.selectedCategory == nil
                ) {
                    viewModel.selectCategory(nil)
                }
                
                ForEach(NewsProNewsCategory.allCases) { category in
                    NewsProCategoryButton(
                        title: category.displayName,
                        isSelected: viewModel.selectedCategory == category
                    ) {
                        viewModel.selectCategory(category)
                    }
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 12)
        }
        .background(Color(.systemBackground))
    }
    
    private var loadingView: some View {
        VStack {
            Spacer()
            ProgressView()
                .scaleEffect(1.5)
            Text("加载中...")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding(.top, 10)
            Spacer()
        }
    }
    
    private func errorView(message: String) -> some View {
        VStack(spacing: 20) {
            Spacer()
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 60))
                .foregroundColor(.orange)
            Text("出错了")
                .font(.title2)
                .fontWeight(.semibold)
            Text(message)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            Button("重试") {
                viewModel.loadInitialData()
            }
            .padding(.horizontal, 30)
            .padding(.vertical, 12)
            .background(.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            Spacer()
        }
        .padding()
    }
    
    private var articlesList: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(viewModel.filteredArticles) { article in
                    NewsProNewsCard(article: article)
                        .onTapGesture {
                            selectedArticle = article
                        }
                        .onAppear {
                            if article.id == viewModel.filteredArticles.last?.id {
                                viewModel.loadMoreArticles()
                            }
                        }
                }
                
                if viewModel.isLoadingMore {
                    ProgressView()
                        .padding()
                }
            }
            .padding()
        }
        .refreshable {
            viewModel.refresh()
        }
    }
}

struct NewsProCategoryButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(isSelected ? .semibold : .regular)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? .blue : Color(.systemGray6))
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(20)
        }
    }
}

struct NewsProNewsCard: View {
    let article: NewsProNewsArticle
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if let imageURL = article.imageURL, let url = URL(string: imageURL) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 200)
                            .overlay(ProgressView())
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 200)
                            .clipped()
                            .cornerRadius(12)
                    case .failure:
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 200)
                            .overlay(
                                Image(systemName: "photo")
                                    .font(.largeTitle)
                                    .foregroundColor(.gray)
                            )
                    @unknown default:
                        EmptyView()
                    }
                }
                .cornerRadius(12)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(article.category.displayName)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(article.category.color)
                        .cornerRadius(6)
                    
                    Spacer()
                    
                    HStack(spacing: 4) {
                        Image(systemName: "eye.fill")
                            .font(.caption)
                        Text("\(article.viewCount)")
                            .font(.caption)
                    }
                    .foregroundColor(.secondary)
                }
                
                Text(article.title)
                    .font(.headline)
                    .fontWeight(.bold)
                    .lineLimit(2)
                
                Text(article.summary)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                
                HStack {
                    Image(systemName: "person.fill")
                        .font(.caption)
                    Text(article.author)
                        .font(.caption)
                    
                    Spacer()
                    
                    Text(article.publishedAt, style: .relative)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .foregroundColor(.secondary)
            }
            .padding(.horizontal, 4)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
}

#Preview {
    NewsProNewsListView()
}
