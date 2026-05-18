//
//  ProfileView.swift
//  swiftUIDemo
//
//  Created by AI Assistant
//  NewsPro - 用户资料视图
//

import SwiftUI
import Combine

struct NewsProProfileView: View {
    @StateObject private var viewModel = NewsProProfileViewModel()
    @State private var showSettings = false
    @State private var showLogoutAlert = false
    @State private var selectedArticle: NewsProNewsArticle?
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    userInfoSection
                    
                    statisticsSection
                    
                    favoritesSection
                    
                    settingsSection
                    
                    logoutButton
                }
                .padding()
            }
            .navigationTitle("我的")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showSettings = true
                    } label: {
                        Image(systemName: "gearshape")
                    }
                }
            }
            .sheet(isPresented: $showSettings) {
                NewsProSettingsSheet(viewModel: viewModel)
            }
            .alert("退出登录", isPresented: $showLogoutAlert) {
                Button("取消", role: .cancel) {}
                Button("退出", role: .destructive) {
                    viewModel.logout()
                }
            } message: {
                Text("确定要退出登录吗？")
            }
            .navigationDestination(item: $selectedArticle) { article in
                NewsProNewsDetailView(article: article)
            }
        }
        .onAppear {
            viewModel.loadProfile()
        }
    }
    
    private var userInfoSection: some View {
        VStack(spacing: 16) {
            if let avatarURL = viewModel.user?.avatar, let url = URL(string: avatarURL) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .foregroundColor(.gray)
                }
                .frame(width: 100, height: 100)
                .clipShape(Circle())
            } else {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.blue)
            }
            
            VStack(spacing: 4) {
                Text(viewModel.user?.name ?? "未登录")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text(viewModel.user?.email ?? "")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            if let bio = viewModel.user?.bio {
                Text(bio)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
    
    private var statisticsSection: some View {
        HStack(spacing: 16) {
            StatisticCard(
                title: "收藏",
                value: "\(viewModel.favoriteCount)",
                icon: "heart.fill",
                color: .red
            )
            
            StatisticCard(
                title: "评论",
                value: "\(viewModel.commentCount)",
                icon: "text.bubble.fill",
                color: .blue
            )
            
            StatisticCard(
                title: "阅读",
                value: "\(viewModel.readCount)",
                icon: "eye.fill",
                color: .green
            )
        }
    }
    
    private var favoritesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("我的收藏")
                    .font(.headline)
                    .fontWeight(.bold)
                
                Spacer()
                
                NavigationLink {
                    NewsProFavoritesView()
                } label: {
                    Text("查看全部")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                }
            }
            
            if viewModel.favoriteArticles.isEmpty {
                Text("暂无收藏")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(viewModel.favoriteArticles.prefix(5)) { article in
                            NewsProFavoriteArticleCard(article: article)
                                .onTapGesture {
                                    selectedArticle = article
                                }
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
    
    private var settingsSection: some View {
        VStack(spacing: 0) {
            SettingsRow(icon: "bell.fill", title: "通知", color: .red) {
                Toggle("", isOn: $viewModel.notificationsEnabled)
                    .labelsHidden()
            }
            
            Divider().padding(.leading, 56)
            
            SettingsRow(icon: "moon.fill", title: "深色模式", color: .purple) {
                Toggle("", isOn: $viewModel.darkModeEnabled)
                    .labelsHidden()
            }
            
            Divider().padding(.leading, 56)
            
            SettingsRow(icon: "paintbrush.fill", title: "字体大小", color: .orange) {
                Text("中")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Divider().padding(.leading, 56)
            
            SettingsRow(icon: "trash.fill", title: "清除缓存", color: .gray) {
                Text(NewsProCacheService.shared.getFormattedCacheSize())
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
    
    private var logoutButton: some View {
        Button {
            showLogoutAlert = true
        } label: {
            Text("退出登录")
                .font(.headline)
                .foregroundColor(.red)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(16)
                .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
        }
    }
}

struct StatisticCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

struct NewsProFavoriteArticleCard: View {
    let article: NewsProNewsArticle
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let imageURL = article.imageURL, let url = URL(string: imageURL) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                }
                .frame(width: 150, height: 100)
                .cornerRadius(8)
            }
            
            Text(article.title)
                .font(.caption)
                .fontWeight(.medium)
                .lineLimit(2)
                .frame(width: 150, alignment: .leading)
        }
    }
}

struct SettingsRow<Content: View>: View {
    let icon: String
    let title: String
    let color: Color
    let trailing: () -> Content
    
    init(icon: String, title: String, color: Color, @ViewBuilder trailing: @escaping () -> Content) {
        self.icon = icon
        self.title = title
        self.color = color
        self.trailing = trailing
    }
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
                .frame(width: 32)
            
            Text(title)
                .font(.body)
            
            Spacer()
            
            trailing()
        }
        .padding()
    }
}

struct NewsProSettingsSheet: View {
    @ObservedObject var viewModel: NewsProProfileViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                Section("显示") {
                    Toggle("深色模式", isOn: $viewModel.darkModeEnabled)
                    Toggle("通知", isOn: $viewModel.notificationsEnabled)
                }
                
                Section("缓存") {
                    HStack {
                        Text("缓存大小")
                        Spacer()
                        Text(NewsProCacheService.shared.getFormattedCacheSize())
                            .foregroundColor(.secondary)
                    }
                    
                    Button("清除缓存", role: .destructive) {
                        NewsProCacheService.shared.clearAllCache()
                    }
                }
                
                Section("关于") {
                    HStack {
                        Text("版本")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("设置")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("完成") {
                        dismiss()
                    }
                }
            }
        }
    }
}

class NewsProProfileViewModel: ObservableObject {
    @Published var user: NewsProUser?
    @Published var favoriteArticles: [NewsProNewsArticle] = []
    @Published var favoriteCount = 0
    @Published var commentCount = 0
    @Published var readCount = 0
    @Published var darkModeEnabled = false
    @Published var notificationsEnabled = true
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    private let authService = NewsProAuthService.shared
    private let newsService = NewsProNewsService.shared
    
    init() {
        setupBindings()
        loadPreferences()
    }
    
    private func setupBindings() {
        authService.$currentUser
            .receive(on: DispatchQueue.main)
            .assign(to: &$user)
        
        newsService.$favoriteArticles
            .receive(on: DispatchQueue.main)
            .sink { [weak self] articles in
                self?.favoriteArticles = articles
                self?.favoriteCount = articles.count
            }
            .store(in: &cancellables)
    }
    
    private func loadPreferences() {
        let preferences = NewsProCacheService.shared.getUserPreferences() ?? [:]
        darkModeEnabled = preferences["dark_mode"] as? Bool ?? false
        notificationsEnabled = preferences["notifications"] as? Bool ?? true
        readCount = NewsProCacheService.shared.getReadArticleIds().count
    }
    
    func loadProfile() {
        user = authService.currentUser
        loadFavorites()
    }
    
    func loadFavorites() {
        newsService.fetchFavoriteArticles()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case .failure(let error) = completion {
                        self?.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] articles in
                    self?.favoriteArticles = articles
                    self?.favoriteCount = articles.count
                }
            )
            .store(in: &cancellables)
    }
    
    func logout() {
        authService.logout()
    }
}

#Preview {
    NewsProProfileView()
}
