//
//  NewsDetailView.swift
//  swiftUIDemo
//
//  Created by AI Assistant
//  NewsPro - 新闻详情视图
//

import SwiftUI
import Combine

struct NewsProNewsDetailView: View {
    let article: NewsProNewsArticle
    @StateObject private var viewModel: NewsProNewsDetailViewModel
    @Environment(\.dismiss) private var dismiss
    
    init(article: NewsProNewsArticle) {
        self.article = article
        _viewModel = StateObject(wrappedValue: NewsProNewsDetailViewModel(article: article))
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                articleHeader
                
                Divider()
                
                articleContent
                
                Divider()
                
                commentsSection
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack(spacing: 16) {
                    Button {
                        viewModel.toggleFavorite()
                    } label: {
                        Image(systemName: viewModel.isFavorite ? "heart.fill" : "heart")
                            .foregroundColor(viewModel.isFavorite ? .red : .gray)
                    }
                    
                    ShareLink(item: viewModel.shareText) {
                        Image(systemName: "square.and.arrow.up")
                    }
                }
            }
        }
        .onAppear {
            viewModel.loadComments()
            viewModel.loadRelatedArticles()
        }
    }
    
    private var articleHeader: some View {
        VStack(alignment: .leading, spacing: 12) {
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
                    Text("\(viewModel.article.viewCount)")
                        .font(.caption)
                }
                .foregroundColor(.secondary)
            }
            
            Text(article.title)
                .font(.title)
                .fontWeight(.bold)
            
            HStack {
                Image(systemName: "person.fill")
                    .font(.caption)
                Text(article.author)
                    .font(.subheadline)
                
                Spacer()
                
                Text(article.publishedAt, style: .date)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .foregroundColor(.secondary)
        }
    }
    
    @ViewBuilder
    private var articleContent: some View {
        if let imageURL = article.imageURL, let url = URL(string: imageURL) {
            AsyncImage(url: url) { phase in
                switch phase {
                case .empty:
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 250)
                        .overlay(ProgressView())
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(maxHeight: 250)
                        .clipped()
                        .cornerRadius(12)
                case .failure:
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 250)
                        .overlay(
                            Image(systemName: "photo")
                                .font(.largeTitle)
                                .foregroundColor(.gray)
                        )
                @unknown default:
                    EmptyView()
                }
            }
        }
        
        Text(article.content)
            .font(.body)
            .lineSpacing(6)
    }
    
    private var commentsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("评论")
                    .font(.headline)
                    .fontWeight(.bold)
                
                Text("(\(viewModel.comments.count))")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Spacer()
            }
            
            commentInput
            
            if viewModel.isLoadingComments {
                HStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
                .padding()
            } else if viewModel.comments.isEmpty {
                Text("暂无评论，快来抢沙发！")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity)
                    .padding()
            } else {
                ForEach(viewModel.comments) { comment in
                    CommentRow(comment: comment)
                }
            }
            
            if !viewModel.relatedArticles.isEmpty {
                Divider()
                
                Text("相关阅读")
                    .font(.headline)
                    .fontWeight(.bold)
                
                ForEach(viewModel.relatedArticles) { relatedArticle in
                    RelatedArticleRow(article: relatedArticle)
                }
            }
        }
    }
    
    private var commentInput: some View {
        HStack(spacing: 12) {
            TextField("写评论...", text: $viewModel.newCommentText)
                .textFieldStyle(.roundedBorder)
            
            Button {
                viewModel.submitComment()
            } label: {
                Image(systemName: "paperplane.fill")
                    .foregroundColor(.blue)
            }
            .disabled(viewModel.newCommentText.isEmpty || viewModel.isSubmittingComment)
        }
    }
}

struct CommentRow: View {
    let comment: NewsProComment
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "person.circle.fill")
                    .font(.title2)
                    .foregroundColor(.blue)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(comment.userName)
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    Text(comment.createdAt, style: .relative)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            
            Text(comment.content)
                .font(.body)
                .padding(.leading, 36)
        }
        .padding(.vertical, 8)
    }
}

struct RelatedArticleRow: View {
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
                .frame(width: 80, height: 60)
                .cornerRadius(8)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(article.title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .lineLimit(2)
                
                Text(article.publishedAt, style: .relative)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(.vertical, 8)
    }
}

class NewsProNewsDetailViewModel: ObservableObject {
    @Published var article: NewsProNewsArticle
    @Published var isFavorite: Bool
    @Published var comments: [NewsProComment] = []
    @Published var relatedArticles: [NewsProNewsArticle] = []
    @Published var newCommentText = ""
    @Published var isLoadingComments = false
    @Published var isSubmittingComment = false
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    private let newsService = NewsProNewsService.shared
    
    var shareText: String {
        "\(article.title)\n\n来源：NewsPro"
    }
    
    init(article: NewsProNewsArticle) {
        self.article = article
        self.isFavorite = article.isFavorite
        
        setupBindings()
    }
    
    private func setupBindings() {
        newsService.$favoriteArticles
            .receive(on: DispatchQueue.main)
            .sink { [weak self] favorites in
                guard let self = self else { return }
                self.isFavorite = favorites.contains { $0.id == self.article.id }
            }
            .store(in: &cancellables)
    }
    
    func toggleFavorite() {
        newsService.toggleFavorite(articleId: article.id)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case .failure(let error) = completion {
                        self?.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] updatedArticle in
                    self?.article = updatedArticle
                    self?.isFavorite = updatedArticle.isFavorite
                }
            )
            .store(in: &cancellables)
    }
    
    func loadComments() {
        isLoadingComments = true
        
        newsService.fetchComments(articleId: article.id)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoadingComments = false
                    if case .failure(let error) = completion {
                        self?.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] comments in
                    self?.comments = comments
                }
            )
            .store(in: &cancellables)
    }
    
    func submitComment() {
        guard !newCommentText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        isSubmittingComment = true
        
        newsService.addComment(articleId: article.id, content: newCommentText)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isSubmittingComment = false
                    if case .failure(let error) = completion {
                        self?.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] newComment in
                    self?.comments.insert(newComment, at: 0)
                    self?.newCommentText = ""
                }
            )
            .store(in: &cancellables)
    }
    
    func loadRelatedArticles() {
        newsService.fetchRelatedArticles(articleId: article.id, category: article.category)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] articles in
                    self?.relatedArticles = articles
                }
            )
            .store(in: &cancellables)
    }
}

#Preview {
    NavigationStack {
        NewsProNewsDetailView(article: NewsProNewsArticle.mockArticles[0])
    }
}
