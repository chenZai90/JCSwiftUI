import Foundation
import Combine

// MARK: - NewsProNewsService
class NewsProNewsService: ObservableObject {
    // MARK: - Singleton
    static let shared = NewsProNewsService()

    // MARK: - Published Properties
    @Published var articles: [NewsProNewsArticle] = []
    @Published var favoriteArticles: [NewsProNewsArticle] = []
    @Published var comments: [NewsProComment] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var currentPage: Int = 1
    @Published var hasMorePages: Bool = true

    // MARK: - Private Properties
    private var cancellables = Set<AnyCancellable>()
    private var allArticles: [NewsProNewsArticle] = []
    private var articleComments: [String: [NewsProComment]] = [:]

    // MARK: - Initialization
    private init() {
        loadMockData()
    }

    // MARK: - Public Methods

    /// 分页获取新闻文章
    /// - Parameters:
    ///   - category: 新闻分类（可选）
    ///   - page: 页码
    ///   - limit: 每页数量
    /// - Returns: AnyPublisher<NewsProPaginationResponse<NewsProNewsArticle>, NewsProAPIError>
    func fetchArticles(
        category: NewsProNewsCategory? = nil,
        page: Int = 1,
        limit: Int = 10
    ) -> AnyPublisher<NewsProPaginationResponse<NewsProNewsArticle>, NewsProAPIError> {
        isLoading = true
        errorMessage = nil

        return simulateNetworkRequest()
            .flatMap { [weak self] _ -> AnyPublisher<NewsProPaginationResponse<NewsProNewsArticle>, NewsProAPIError> in
                guard let self = self else {
                    return Fail(error: NewsProAPIError.unknown)
                        .eraseToAnyPublisher()
                }

                // 筛选文章
                var filteredArticles = self.allArticles
                if let category = category {
                    filteredArticles = filteredArticles.filter { $0.category == category }
                }

                // 按发布时间排序
                filteredArticles.sort { $0.publishedAt > $1.publishedAt }

                // 分页
                let startIndex = (page - 1) * limit
                let endIndex = min(startIndex + limit, filteredArticles.count)

                guard startIndex < filteredArticles.count else {
                    self.isLoading = false
                    return Just(NewsProPaginationResponse(
                        items: [],
                        total: filteredArticles.count,
                        page: page,
                        limit: limit,
                        hasMore: false
                    ))
                    .setFailureType(to: NewsProAPIError.self)
                    .eraseToAnyPublisher()
                }

                let paginatedArticles = Array(filteredArticles[startIndex..<endIndex])
                let hasMore = endIndex < filteredArticles.count

                // 更新状态
                if page == 1 {
                    self.articles = paginatedArticles
                } else {
                    self.articles.append(contentsOf: paginatedArticles)
                }
                self.currentPage = page
                self.hasMorePages = hasMore
                self.isLoading = false

                let response = NewsProPaginationResponse(
                    items: paginatedArticles,
                    total: filteredArticles.count,
                    page: page,
                    limit: limit,
                    hasMore: hasMore
                )

                return Just(response)
                    .setFailureType(to: NewsProAPIError.self)
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }

    /// 搜索新闻文章
    /// - Parameter query: 搜索关键词
    /// - Returns: AnyPublisher<NewsProSearchResult, NewsProAPIError>
    func searchArticles(query: String) -> AnyPublisher<NewsProSearchResult, NewsProAPIError> {
        isLoading = true
        errorMessage = nil

        return simulateNetworkRequest()
            .flatMap { [weak self] _ -> AnyPublisher<NewsProSearchResult, NewsProAPIError> in
                guard let self = self else {
                    return Fail(error: NewsProAPIError.unknown)
                        .eraseToAnyPublisher()
                }

                let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
                guard !trimmedQuery.isEmpty else {
                    self.isLoading = false
                    return Just(NewsProSearchResult(articles: [], total: 0, query: query))
                        .setFailureType(to: NewsProAPIError.self)
                        .eraseToAnyPublisher()
                }

                // 搜索匹配的文章
                let searchResults = self.allArticles.filter { article in
                    article.title.localizedCaseInsensitiveContains(trimmedQuery) ||
                    article.summary.localizedCaseInsensitiveContains(trimmedQuery) ||
                    article.content.localizedCaseInsensitiveContains(trimmedQuery) ||
                    article.author.localizedCaseInsensitiveContains(trimmedQuery)
                }

                self.isLoading = false

                let result = NewsProSearchResult(
                    articles: searchResults,
                    total: searchResults.count,
                    query: trimmedQuery
                )

                return Just(result)
                    .setFailureType(to: NewsProAPIError.self)
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }

    /// 切换文章收藏状态
    /// - Parameter articleId: 文章ID
    /// - Returns: AnyPublisher<NewsProNewsArticle, NewsProAPIError>
    func toggleFavorite(articleId: String) -> AnyPublisher<NewsProNewsArticle, NewsProAPIError> {
        return simulateNetworkRequest(delay: 0.5)
            .flatMap { [weak self] _ -> AnyPublisher<NewsProNewsArticle, NewsProAPIError> in
                guard let self = self else {
                    return Fail(error: NewsProAPIError.unknown)
                        .eraseToAnyPublisher()
                }

                // 查找文章
                guard let index = self.allArticles.firstIndex(where: { $0.id == articleId }) else {
                    return Fail(error: NewsProAPIError.notFound)
                        .eraseToAnyPublisher()
                }

                // 切换收藏状态
                var article = self.allArticles[index]
                article.isFavorite.toggle()
                self.allArticles[index] = article

                // 更新文章列表中的状态
                if let articleListIndex = self.articles.firstIndex(where: { $0.id == articleId }) {
                    self.articles[articleListIndex] = article
                }

                // 更新收藏列表
                if article.isFavorite {
                    if !self.favoriteArticles.contains(where: { $0.id == articleId }) {
                        self.favoriteArticles.append(article)
                    }
                } else {
                    self.favoriteArticles.removeAll { $0.id == articleId }
                }

                // 缓存收藏列表
                NewsProCacheService.shared.cacheFavoriteArticleIds(
                    self.favoriteArticles.map { $0.id }
                )

                return Just(article)
                    .setFailureType(to: NewsProAPIError.self)
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }

    /// 获取收藏的文章列表
    /// - Returns: AnyPublisher<[NewsProNewsArticle], NewsProAPIError>
    func fetchFavoriteArticles() -> AnyPublisher<[NewsProNewsArticle], NewsProAPIError> {
        return simulateNetworkRequest(delay: 0.5)
            .flatMap { [weak self] _ -> AnyPublisher<[NewsProNewsArticle], NewsProAPIError> in
                guard let self = self else {
                    return Fail(error: NewsProAPIError.unknown)
                        .eraseToAnyPublisher()
                }

                // 从缓存获取收藏ID列表
                let favoriteIds = NewsProCacheService.shared.getCachedFavoriteArticleIds()

                // 更新收藏文章列表
                self.favoriteArticles = self.allArticles.filter { favoriteIds.contains($0.id) }

                // 同步收藏状态
                for (index, var article) in self.allArticles.enumerated() {
                    let shouldBeFavorite = favoriteIds.contains(article.id)
                    if article.isFavorite != shouldBeFavorite {
                        article.isFavorite = shouldBeFavorite
                        self.allArticles[index] = article
                    }
                }

                return Just(self.favoriteArticles)
                    .setFailureType(to: NewsProAPIError.self)
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }

    /// 获取文章评论
    /// - Parameter articleId: 文章ID
    /// - Returns: AnyPublisher<[NewsProComment], NewsProAPIError>
    func fetchComments(articleId: String) -> AnyPublisher<[NewsProComment], NewsProAPIError> {
        isLoading = true

        return simulateNetworkRequest()
            .flatMap { [weak self] _ -> AnyPublisher<[NewsProComment], NewsProAPIError> in
                guard let self = self else {
                    return Fail(error: NewsProAPIError.unknown)
                        .eraseToAnyPublisher()
                }

                // 获取该文章的评论
                let articleComments = self.articleComments[articleId] ?? []

                // 按时间排序
                let sortedComments = articleComments.sorted { $0.createdAt > $1.createdAt }

                self.comments = sortedComments
                self.isLoading = false

                return Just(sortedComments)
                    .setFailureType(to: NewsProAPIError.self)
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }

    /// 添加评论
    /// - Parameters:
    ///   - articleId: 文章ID
    ///   - content: 评论内容
    /// - Returns: AnyPublisher<NewsProComment, NewsProAPIError>
    func addComment(articleId: String, content: String) -> AnyPublisher<NewsProComment, NewsProAPIError> {
        guard let currentUser = NewsProAuthService.shared.currentUser else {
            return Fail(error: NewsProAPIError.unauthorized)
                .eraseToAnyPublisher()
        }

        let trimmedContent = content.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedContent.isEmpty else {
            return Fail(error: NewsProAPIError.badRequest("评论内容不能为空"))
                .eraseToAnyPublisher()
        }

        return simulateNetworkRequest()
            .flatMap { [weak self] _ -> AnyPublisher<NewsProComment, NewsProAPIError> in
                guard let self = self else {
                    return Fail(error: NewsProAPIError.unknown)
                        .eraseToAnyPublisher()
                }

                let newComment = NewsProComment(
                    id: "comment_\(Int.random(in: 1000...9999))",
                    articleId: articleId,
                    userId: currentUser.id,
                    userName: currentUser.name,
                    content: trimmedContent,
                    createdAt: Date()
                )

                // 添加到评论列表
                var articleComments = self.articleComments[articleId] ?? []
                articleComments.append(newComment)
                self.articleComments[articleId] = articleComments

                // 更新当前显示的评论
                self.comments.insert(newComment, at: 0)

                return Just(newComment)
                    .setFailureType(to: NewsProAPIError.self)
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }

    /// 获取单篇文章详情
    /// - Parameter articleId: 文章ID
    /// - Returns: AnyPublisher<NewsProNewsArticle, NewsProAPIError>
    func fetchArticleDetail(articleId: String) -> AnyPublisher<NewsProNewsArticle, NewsProAPIError> {
        return simulateNetworkRequest(delay: 0.5)
            .flatMap { [weak self] _ -> AnyPublisher<NewsProNewsArticle, NewsProAPIError> in
                guard let self = self else {
                    return Fail(error: NewsProAPIError.unknown)
                        .eraseToAnyPublisher()
                }

                guard let index = self.allArticles.firstIndex(where: { $0.id == articleId }) else {
                    return Fail(error: NewsProAPIError.notFound)
                        .eraseToAnyPublisher()
                }

                // 增加浏览次数
                var article = self.allArticles[index]
                article.viewCount += 1
                self.allArticles[index] = article

                // 更新文章列表中的数据
                if let articleListIndex = self.articles.firstIndex(where: { $0.id == articleId }) {
                    self.articles[articleListIndex] = article
                }

                return Just(article)
                    .setFailureType(to: NewsProAPIError.self)
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }

    /// 获取相关文章
    /// - Parameters:
    ///   - articleId: 当前文章ID
    ///   - category: 文章分类
    ///   - limit: 数量限制
    /// - Returns: AnyPublisher<[NewsProNewsArticle], NewsProAPIError>
    func fetchRelatedArticles(
        articleId: String,
        category: NewsProNewsCategory,
        limit: Int = 5
    ) -> AnyPublisher<[NewsProNewsArticle], NewsProAPIError> {
        return simulateNetworkRequest(delay: 0.5)
            .flatMap { [weak self] _ -> AnyPublisher<[NewsProNewsArticle], NewsProAPIError> in
                guard let self = self else {
                    return Fail(error: NewsProAPIError.unknown)
                        .eraseToAnyPublisher()
                }

                // 获取同分类的其他文章
                let relatedArticles = self.allArticles
                    .filter { $0.category == category && $0.id != articleId }
                    .prefix(limit)
                    .map { $0 }

                return Just(Array(relatedArticles))
                    .setFailureType(to: NewsProAPIError.self)
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }

    /// 获取热门文章
    /// - Parameter limit: 数量限制
    /// - Returns: AnyPublisher<[NewsProNewsArticle], NewsProAPIError>
    func fetchPopularArticles(limit: Int = 10) -> AnyPublisher<[NewsProNewsArticle], NewsProAPIError> {
        return simulateNetworkRequest(delay: 0.5)
            .flatMap { [weak self] _ -> AnyPublisher<[NewsProNewsArticle], NewsProAPIError> in
                guard let self = self else {
                    return Fail(error: NewsProAPIError.unknown)
                        .eraseToAnyPublisher()
                }

                // 按浏览次数排序
                let popularArticles = self.allArticles
                    .sorted { $0.viewCount > $1.viewCount }
                    .prefix(limit)
                    .map { $0 }

                return Just(Array(popularArticles))
                    .setFailureType(to: NewsProAPIError.self)
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }

    /// 刷新文章列表
    /// - Parameter category: 新闻分类
    /// - Returns: AnyPublisher<NewsProPaginationResponse<NewsProNewsArticle>, NewsProAPIError>
    func refreshArticles(category: NewsProNewsCategory? = nil) -> AnyPublisher<NewsProPaginationResponse<NewsProNewsArticle>, NewsProAPIError> {
        currentPage = 1
        return fetchArticles(category: category, page: 1)
    }

    /// 加载更多文章
    /// - Parameter category: 新闻分类
    /// - Returns: AnyPublisher<NewsProPaginationResponse<NewsProNewsArticle>, NewsProAPIError>
    func loadMoreArticles(category: NewsProNewsCategory? = nil) -> AnyPublisher<NewsProPaginationResponse<NewsProNewsArticle>, NewsProAPIError> {
        guard hasMorePages else {
            return Just(NewsProPaginationResponse(
                items: [],
                total: articles.count,
                page: currentPage,
                limit: 10,
                hasMore: false
            ))
            .setFailureType(to: NewsProAPIError.self)
            .eraseToAnyPublisher()
        }

        return fetchArticles(category: category, page: currentPage + 1)
    }

    // MARK: - Private Methods

    /// 模拟网络请求延迟
    private func simulateNetworkRequest(delay: TimeInterval = 1.0) -> AnyPublisher<Void, NewsProAPIError> {
        Future<Void, NewsProAPIError> { promise in
            DispatchQueue.global().asyncAfter(deadline: .now() + delay) {
                promise(.success(()))
            }
        }
        .eraseToAnyPublisher()
    }

    /// 加载模拟数据
    private func loadMockData() {
        // 加载文章数据
        allArticles = NewsProNewsArticle.mockArticles

        // 加载评论数据
        for comment in NewsProComment.mockComments {
            var articleComments = self.articleComments[comment.articleId] ?? []
            articleComments.append(comment)
            self.articleComments[comment.articleId] = articleComments
        }

        // 从缓存加载收藏状态
        let favoriteIds = NewsProCacheService.shared.getCachedFavoriteArticleIds()
        for (index, var article) in allArticles.enumerated() {
            if favoriteIds.contains(article.id) {
                article.isFavorite = true
                allArticles[index] = article
                favoriteArticles.append(article)
            }
        }

        // 初始化文章列表
        articles = Array(allArticles.prefix(10))
    }
}
