import Foundation
import Combine

// MARK: - NewsProCacheService
class NewsProCacheService {
    // MARK: - Singleton
    static let shared = NewsProCacheService()

    // MARK: - Cache Keys
    private enum CacheKeys {
        static let userPreferences = "news_pro_user_preferences"
        static let cachedArticles = "news_pro_cached_articles"
        static let favoriteArticleIds = "news_pro_favorite_article_ids"
        static let lastSyncTime = "news_pro_last_sync_time"
        static let selectedCategory = "news_pro_selected_category"
        static let searchHistory = "news_pro_search_history"
        static let readArticleIds = "news_pro_read_article_ids"
    }

    // MARK: - UserDefaults
    private let defaults = UserDefaults.standard

    // MARK: - Cache Expiration (in seconds)
    private let articlesCacheExpiration: TimeInterval = 3600 // 1 hour
    private let maxSearchHistoryCount = 20
    private let maxCachedArticlesCount = 100

    // MARK: - Initialization
    private init() {}

    // MARK: - User Preferences

    /// 保存用户偏好设置
    /// - Parameter preferences: 用户偏好字典
    func cacheUserPreferences(_ preferences: [String: Any]) {
        defaults.set(preferences, forKey: CacheKeys.userPreferences)
    }

    /// 获取用户偏好设置
    /// - Returns: 用户偏好字典
    func getUserPreferences() -> [String: Any]? {
        return defaults.dictionary(forKey: CacheKeys.userPreferences)
    }

    /// 保存特定偏好项
    /// - Parameters:
    ///   - value: 偏好值
    ///   - key: 偏好键
    func setPreference<T>(_ value: T, forKey key: String) {
        var preferences = getUserPreferences() ?? [:]
        preferences[key] = value
        cacheUserPreferences(preferences)
    }

    /// 获取特定偏好项
    /// - Parameter key: 偏好键
    /// - Returns: 偏好值
    func getPreference<T>(forKey key: String) -> T? {
        return getUserPreferences()?[key] as? T
    }

    /// 清除用户偏好设置
    func clearUserPreferences() {
        defaults.removeObject(forKey: CacheKeys.userPreferences)
    }

    // MARK: - Articles Cache

    /// 缓存新闻文章列表
    /// - Parameters:
    ///   - articles: 文章列表
    ///   - category: 分类（可选）
    func cacheArticles(_ articles: [NewsProNewsArticle], category: NewsProNewsCategory? = nil) {
        do {
            // 限制缓存数量
            let articlesToCache = Array(articles.prefix(maxCachedArticlesCount))
            let encoded = try JSONEncoder().encode(articlesToCache)

            let key = category != nil ?
                "\(CacheKeys.cachedArticles)_\(category!.rawValue)" :
                CacheKeys.cachedArticles

            defaults.set(encoded, forKey: key)
            defaults.set(Date(), forKey: "\(key)_timestamp")
        } catch {
            print("Failed to cache articles: \(error.localizedDescription)")
        }
    }

    /// 获取缓存的新闻文章列表
    /// - Parameter category: 分类（可选）
    /// - Returns: 文章列表
    func getCachedArticles(category: NewsProNewsCategory? = nil) -> [NewsProNewsArticle] {
        let key = category != nil ?
            "\(CacheKeys.cachedArticles)_\(category!.rawValue)" :
            CacheKeys.cachedArticles

        // 检查缓存是否过期
        guard !isCacheExpired(forKey: key, expiration: articlesCacheExpiration) else {
            clearCachedArticles(category: category)
            return []
        }

        guard let data = defaults.data(forKey: key) else {
            return []
        }

        do {
            let articles = try JSONDecoder().decode([NewsProNewsArticle].self, from: data)
            return articles
        } catch {
            print("Failed to decode cached articles: \(error.localizedDescription)")
            return []
        }
    }

    /// 清除缓存的文章
    /// - Parameter category: 分类（可选）
    func clearCachedArticles(category: NewsProNewsCategory? = nil) {
        let key = category != nil ?
            "\(CacheKeys.cachedArticles)_\(category!.rawValue)" :
            CacheKeys.cachedArticles

        defaults.removeObject(forKey: key)
        defaults.removeObject(forKey: "\(key)_timestamp")
    }

    /// 清除所有缓存的文章
    func clearAllCachedArticles() {
        NewsProNewsCategory.allCases.forEach { category in
            clearCachedArticles(category: category)
        }
        clearCachedArticles(category: nil)
    }

    /// 缓存单篇文章
    /// - Parameter article: 文章
    func cacheArticle(_ article: NewsProNewsArticle) {
        var cachedArticles = getCachedArticles()

        // 移除已存在的相同文章
        cachedArticles.removeAll { $0.id == article.id }

        // 添加新文章到开头
        cachedArticles.insert(article, at: 0)

        // 限制数量
        if cachedArticles.count > maxCachedArticlesCount {
            cachedArticles = Array(cachedArticles.prefix(maxCachedArticlesCount))
        }

        cacheArticles(cachedArticles)
    }

    /// 获取单篇缓存文章
    /// - Parameter articleId: 文章ID
    /// - Returns: 文章
    func getCachedArticle(articleId: String) -> NewsProNewsArticle? {
        let cachedArticles = getCachedArticles()
        return cachedArticles.first { $0.id == articleId }
    }

    // MARK: - Favorites Cache

    /// 缓存收藏文章ID列表
    /// - Parameter articleIds: 文章ID列表
    func cacheFavoriteArticleIds(_ articleIds: [String]) {
        defaults.set(articleIds, forKey: CacheKeys.favoriteArticleIds)
        defaults.set(Date(), forKey: "\(CacheKeys.favoriteArticleIds)_timestamp")
    }

    /// 获取缓存的收藏文章ID列表
    /// - Returns: 文章ID列表
    func getCachedFavoriteArticleIds() -> [String] {
        return defaults.stringArray(forKey: CacheKeys.favoriteArticleIds) ?? []
    }

    /// 添加收藏文章ID
    /// - Parameter articleId: 文章ID
    func addFavoriteArticleId(_ articleId: String) {
        var favoriteIds = getCachedFavoriteArticleIds()
        if !favoriteIds.contains(articleId) {
            favoriteIds.append(articleId)
            cacheFavoriteArticleIds(favoriteIds)
        }
    }

    /// 移除收藏文章ID
    /// - Parameter articleId: 文章ID
    func removeFavoriteArticleId(_ articleId: String) {
        var favoriteIds = getCachedFavoriteArticleIds()
        favoriteIds.removeAll { $0 == articleId }
        cacheFavoriteArticleIds(favoriteIds)
    }

    /// 检查文章是否已收藏
    /// - Parameter articleId: 文章ID
    /// - Returns: 是否已收藏
    func isArticleFavorited(_ articleId: String) -> Bool {
        return getCachedFavoriteArticleIds().contains(articleId)
    }

    /// 清除收藏缓存
    func clearFavoriteCache() {
        defaults.removeObject(forKey: CacheKeys.favoriteArticleIds)
        defaults.removeObject(forKey: "\(CacheKeys.favoriteArticleIds)_timestamp")
    }

    // MARK: - Search History

    /// 添加搜索历史
    /// - Parameter query: 搜索关键词
    func addSearchHistory(_ query: String) {
        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedQuery.isEmpty else { return }

        var history = getSearchHistory()

        // 移除已存在的相同搜索词
        history.removeAll { $0.lowercased() == trimmedQuery.lowercased() }

        // 添加到开头
        history.insert(trimmedQuery, at: 0)

        // 限制数量
        if history.count > maxSearchHistoryCount {
            history = Array(history.prefix(maxSearchHistoryCount))
        }

        defaults.set(history, forKey: CacheKeys.searchHistory)
    }

    /// 获取搜索历史
    /// - Returns: 搜索历史列表
    func getSearchHistory() -> [String] {
        return defaults.stringArray(forKey: CacheKeys.searchHistory) ?? []
    }

    /// 清除搜索历史
    func clearSearchHistory() {
        defaults.removeObject(forKey: CacheKeys.searchHistory)
    }

    /// 移除特定搜索历史
    /// - Parameter query: 搜索关键词
    func removeSearchHistory(_ query: String) {
        var history = getSearchHistory()
        history.removeAll { $0 == query }
        defaults.set(history, forKey: CacheKeys.searchHistory)
    }

    // MARK: - Read Articles

    /// 标记文章为已读
    /// - Parameter articleId: 文章ID
    func markArticleAsRead(_ articleId: String) {
        var readIds = getReadArticleIds()
        if !readIds.contains(articleId) {
            readIds.append(articleId)
            defaults.set(readIds, forKey: CacheKeys.readArticleIds)
        }
    }

    /// 获取已读文章ID列表
    /// - Returns: 文章ID列表
    func getReadArticleIds() -> [String] {
        return defaults.stringArray(forKey: CacheKeys.readArticleIds) ?? []
    }

    /// 检查文章是否已读
    /// - Parameter articleId: 文章ID
    /// - Returns: 是否已读
    func isArticleRead(_ articleId: String) -> Bool {
        return getReadArticleIds().contains(articleId)
    }

    /// 清除已读记录
    func clearReadHistory() {
        defaults.removeObject(forKey: CacheKeys.readArticleIds)
    }

    // MARK: - Selected Category

    /// 保存选中的分类
    /// - Parameter category: 分类（可选）
    func setSelectedCategory(_ category: NewsProNewsCategory?) {
        if let category = category {
            defaults.set(category.rawValue, forKey: CacheKeys.selectedCategory)
        } else {
            defaults.removeObject(forKey: CacheKeys.selectedCategory)
        }
    }

    /// 获取选中的分类
    /// - Returns: 分类
    func getSelectedCategory() -> NewsProNewsCategory? {
        guard let rawValue = defaults.string(forKey: CacheKeys.selectedCategory),
              let category = NewsProNewsCategory(rawValue: rawValue) else {
            return nil
        }
        return category
    }

    /// 清除选中的分类
    func clearSelectedCategory() {
        defaults.removeObject(forKey: CacheKeys.selectedCategory)
    }

    // MARK: - Last Sync Time

    /// 保存最后同步时间
    /// - Parameter date: 日期
    func setLastSyncTime(_ date: Date) {
        defaults.set(date, forKey: CacheKeys.lastSyncTime)
    }

    /// 获取最后同步时间
    /// - Returns: 日期
    func getLastSyncTime() -> Date? {
        return defaults.object(forKey: CacheKeys.lastSyncTime) as? Date
    }

    /// 检查是否需要同步
    /// - Parameter interval: 时间间隔
    /// - Returns: 是否需要同步
    func shouldSync(interval: TimeInterval = 300) -> Bool {
        guard let lastSync = getLastSyncTime() else {
            return true
        }
        return Date().timeIntervalSince(lastSync) > interval
    }

    // MARK: - Cache Management

    /// 检查缓存是否过期
    /// - Parameters:
    ///   - key: 缓存键
    ///   - expiration: 过期时间
    /// - Returns: 是否过期
    private func isCacheExpired(forKey key: String, expiration: TimeInterval) -> Bool {
        guard let timestamp = defaults.object(forKey: "\(key)_timestamp") as? Date else {
            return true
        }
        return Date().timeIntervalSince(timestamp) > expiration
    }

    /// 获取缓存大小（字节）
    /// - Returns: 缓存大小
    func getCacheSize() -> Int {
        var totalSize = 0

        // 计算各个缓存的大小
        let keys = [
            CacheKeys.userPreferences,
            CacheKeys.cachedArticles,
            CacheKeys.favoriteArticleIds,
            CacheKeys.searchHistory,
            CacheKeys.readArticleIds
        ]

        for key in keys {
            if let data = defaults.data(forKey: key) {
                totalSize += data.count
            }
        }

        // 分类缓存
        for category in NewsProNewsCategory.allCases {
            if let data = defaults.data(forKey: "\(CacheKeys.cachedArticles)_\(category.rawValue)") {
                totalSize += data.count
            }
        }

        return totalSize
    }

    /// 获取格式化的缓存大小
    /// - Returns: 格式化后的字符串
    func getFormattedCacheSize() -> String {
        let size = getCacheSize()
        let formatter = ByteCountFormatter()
        formatter.countStyle = .file
        return formatter.string(fromByteCount: Int64(size))
    }

    /// 清除所有缓存
    func clearAllCache() {
        let keys = [
            CacheKeys.userPreferences,
            CacheKeys.cachedArticles,
            CacheKeys.favoriteArticleIds,
            CacheKeys.lastSyncTime,
            CacheKeys.selectedCategory,
            CacheKeys.searchHistory,
            CacheKeys.readArticleIds
        ]

        for key in keys {
            defaults.removeObject(forKey: key)
            defaults.removeObject(forKey: "\(key)_timestamp")
        }

        // 清除分类缓存
        NewsProNewsCategory.allCases.forEach { category in
            let key = "\(CacheKeys.cachedArticles)_\(category.rawValue)"
            defaults.removeObject(forKey: key)
            defaults.removeObject(forKey: "\(key)_timestamp")
        }
    }

    /// 清除过期缓存
    func clearExpiredCache() {
        // 检查并清除过期的文章缓存
        clearExpiredArticlesCache()
    }

    /// 清除过期的文章缓存
    private func clearExpiredArticlesCache() {
        // 清除默认缓存
        if isCacheExpired(forKey: CacheKeys.cachedArticles, expiration: articlesCacheExpiration) {
            clearCachedArticles()
        }

        // 清除分类缓存
        for category in NewsProNewsCategory.allCases {
            let key = "\(CacheKeys.cachedArticles)_\(category.rawValue)"
            if isCacheExpired(forKey: key, expiration: articlesCacheExpiration) {
                clearCachedArticles(category: category)
            }
        }
    }
}

// MARK: - Cache Keys Constants
extension NewsProCacheService {
    /// 用户偏好键常量
    struct PreferenceKeys {
        static let darkMode = "dark_mode"
        static let notificationsEnabled = "notifications_enabled"
        static let fontSize = "font_size"
        static let autoPlayVideo = "auto_play_video"
        static let saveDataMode = "save_data_mode"
        static let language = "language"
    }
}

// MARK: - Publisher Extensions
extension NewsProCacheService {
    /// 异步缓存文章
    /// - Parameters:
    ///   - articles: 文章列表
    ///   - category: 分类
    /// - Returns: AnyPublisher<Void, Never>
    func cacheArticlesPublisher(
        _ articles: [NewsProNewsArticle],
        category: NewsProNewsCategory? = nil
    ) -> AnyPublisher<Void, Never> {
        Future<Void, Never> { promise in
            self.cacheArticles(articles, category: category)
            promise(.success(()))
        }
        .eraseToAnyPublisher()
    }

    /// 异步获取缓存文章
    /// - Parameter category: 分类
    /// - Returns: AnyPublisher<[NewsProNewsArticle], Never>
    func getCachedArticlesPublisher(
        category: NewsProNewsCategory? = nil
    ) -> AnyPublisher<[NewsProNewsArticle], Never> {
        Future<[NewsProNewsArticle], Never> { promise in
            let articles = self.getCachedArticles(category: category)
            promise(.success(articles))
        }
        .eraseToAnyPublisher()
    }

    /// 异步清除所有缓存
    /// - Returns: AnyPublisher<Void, Never>
    func clearAllCachePublisher() -> AnyPublisher<Void, Never> {
        Future<Void, Never> { promise in
            self.clearAllCache()
            promise(.success(()))
        }
        .eraseToAnyPublisher()
    }
}
