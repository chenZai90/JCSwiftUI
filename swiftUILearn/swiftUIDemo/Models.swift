import Foundation
import SwiftUI

// MARK: - NewsProUser Model
struct NewsProUser: Codable, Identifiable, Equatable, Hashable {
    let id: String
    let email: String
    let name: String
    let avatar: String?
    let bio: String?
    let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case email
        case name
        case avatar
        case bio
        case createdAt = "created_at"
    }
}

// MARK: - NewsProNewsCategory Enum
enum NewsProNewsCategory: String, Codable, CaseIterable, Identifiable, Hashable {
    case technology = "technology"
    case sports = "sports"
    case entertainment = "entertainment"
    case finance = "finance"
    case health = "health"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .technology:
            return "科技"
        case .sports:
            return "体育"
        case .entertainment:
            return "娱乐"
        case .finance:
            return "财经"
        case .health:
            return "健康"
        }
    }

    var icon: String {
        switch self {
        case .technology:
            return "cpu"
        case .sports:
            return "sportscourt"
        case .entertainment:
            return "film"
        case .finance:
            return "chart.line.uptrend.xyaxis"
        case .health:
            return "heart"
        }
    }

    var color: Color {
        switch self {
        case .technology:
            return .blue
        case .sports:
            return .green
        case .entertainment:
            return .purple
        case .finance:
            return .orange
        case .health:
            return .red
        }
    }
}

// MARK: - NewsProNewsArticle Model
struct NewsProNewsArticle: Codable, Identifiable, Equatable, Hashable {
    let id: String
    let title: String
    let summary: String
    let content: String
    let author: String
    let category: NewsProNewsCategory
    let imageURL: String?
    let publishedAt: Date
    var isFavorite: Bool
    var viewCount: Int

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case summary
        case content
        case author
        case category
        case imageURL = "image_url"
        case publishedAt = "published_at"
        case isFavorite = "is_favorite"
        case viewCount = "view_count"
    }
}

// MARK: - NewsProComment Model
struct NewsProComment: Codable, Identifiable, Equatable, Hashable {
    let id: String
    let articleId: String
    let userId: String
    let userName: String
    let content: String
    let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case articleId = "article_id"
        case userId = "user_id"
        case userName = "user_name"
        case content
        case createdAt = "created_at"
    }
}

// MARK: - NewsProAuthResponse
struct NewsProAuthResponse: Codable {
    let token: String
    let user: NewsProUser
    let expiresIn: Int

    enum CodingKeys: String, CodingKey {
        case token
        case user
        case expiresIn = "expires_in"
    }
}

// MARK: - NewsProAPIError
enum NewsProAPIError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case decodingError
    case networkError(Error)
    case serverError(Int)
    case unauthorized
    case notFound
    case badRequest(String)
    case unknown

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "无效的URL"
        case .invalidResponse:
            return "无效的响应"
        case .decodingError:
            return "数据解析失败"
        case .networkError(let error):
            return "网络错误: \(error.localizedDescription)"
        case .serverError(let code):
            return "服务器错误 (\(code))"
        case .unauthorized:
            return "未授权，请重新登录"
        case .notFound:
            return "资源未找到"
        case .badRequest(let message):
            return "请求错误: \(message)"
        case .unknown:
            return "未知错误"
        }
    }
}

// MARK: - NewsProPaginationResponse
struct NewsProPaginationResponse<T: Codable>: Codable {
    let items: [T]
    let total: Int
    let page: Int
    let limit: Int
    let hasMore: Bool

    enum CodingKeys: String, CodingKey {
        case items
        case total
        case page
        case limit
        case hasMore = "has_more"
    }
}

// MARK: - NewsProSearchResult
struct NewsProSearchResult: Codable {
    let articles: [NewsProNewsArticle]
    let total: Int
    let query: String
}

// MARK: - Mock Data Extensions
extension NewsProUser {
    static let mockUser = NewsProUser(
        id: "user_001",
        email: "user@example.com",
        name: "张三",
        avatar: "https://api.dicebear.com/7.x/avataaars/svg?seed=user001",
        bio: "热爱科技，关注时事",
        createdAt: Date().addingTimeInterval(-86400 * 365)
    )

    static let mockAdmin = NewsProUser(
        id: "admin_001",
        email: "admin@example.com",
        name: "管理员",
        avatar: "https://api.dicebear.com/7.x/avataaars/svg?seed=admin001",
        bio: "NewsPro 管理员",
        createdAt: Date().addingTimeInterval(-86400 * 730)
    )
}

extension NewsProNewsArticle {
    static let mockArticles: [NewsProNewsArticle] = [
        NewsProNewsArticle(
            id: "article_001",
            title: "苹果发布全新 iPhone 16 系列",
            summary: "苹果公司在秋季发布会上推出了全新的 iPhone 16 系列，带来了更强大的 A18 芯片和改进的相机系统。",
            content: "苹果公司在今天的秋季发布会上正式推出了 iPhone 16 系列。新系列包括 iPhone 16、iPhone 16 Plus、iPhone 16 Pro 和 iPhone 16 Pro Max 四款机型。\n\n全新的 A18 芯片采用 3nm 工艺制造，性能提升 20%，能效提升 30%。相机系统也得到了全面升级，主摄像头升级至 4800 万像素，支持 8K 视频录制。\n\niPhone 16 系列将于下周开始预售，起售价为 5999 元。",
            author: "科技日报",
            category: .technology,
            imageURL: "https://picsum.photos/seed/iphone16/400/300",
            publishedAt: Date().addingTimeInterval(-3600),
            isFavorite: false,
            viewCount: 12580
        ),
        NewsProNewsArticle(
            id: "article_002",
            title: "2024 年 NBA 总决赛精彩回顾",
            summary: "湖人队与凯尔特人队展开激烈对决，最终湖人队以 4-2 的总比分夺得总冠军。",
            content: "2024 年 NBA 总决赛在昨晚落下帷幕，洛杉矶湖人队以 4-2 的总比分击败波士顿凯尔特人队，夺得队史第 18 座总冠军奖杯。\n\n勒布朗·詹姆斯在第六场比赛中砍下 35 分、12 个篮板和 8 次助攻，荣膺总决赛 MVP。这是詹姆斯职业生涯第 5 座总冠军奖杯。\n\n湖人队的胜利也让他们在总冠军数量上追平了凯尔特人队，两队目前并列历史第一。",
            author: "体育周刊",
            category: .sports,
            imageURL: "https://picsum.photos/seed/nba2024/400/300",
            publishedAt: Date().addingTimeInterval(-7200),
            isFavorite: true,
            viewCount: 8920
        ),
        NewsProNewsArticle(
            id: "article_003",
            title: "最新科幻大片《星际穿越2》定档",
            summary: "克里斯托弗·诺兰执导的《星际穿越2》正式定档明年暑期，原班人马回归。",
            content: "华纳兄弟影业今日宣布，克里斯托弗·诺兰执导的科幻巨制《星际穿越2》正式定档明年 7 月 18 日全球上映。\n\n马修·麦康纳、安妮·海瑟薇等原班人马将悉数回归，同时还将有新面孔加入。影片将继续探索黑洞、时间膨胀等宇宙奥秘。\n\n诺兰表示，这部续集将带来更加震撼的视觉效果和更深刻的情感体验。",
            author: "娱乐前线",
            category: .entertainment,
            imageURL: "https://picsum.photos/seed/interstellar2/400/300",
            publishedAt: Date().addingTimeInterval(-10800),
            isFavorite: false,
            viewCount: 15670
        ),
        NewsProNewsArticle(
            id: "article_004",
            title: "A 股市场今日大涨，科技股领涨",
            summary: "受利好政策影响，A 股市场今日全线飘红，上证指数上涨 2.5%，科技股表现尤为亮眼。",
            content: "今日 A 股市场迎来强劲反弹，上证指数收盘上涨 2.5%，深证成指上涨 3.2%，创业板指上涨 3.8%。\n\n科技股成为今日市场最大亮点，半导体、人工智能板块多只个股涨停。市场成交量明显放大，两市合计成交超过 1.2 万亿元。\n\n分析人士认为，近期出台的一系列支持科技创新的政策是本轮上涨的主要驱动力。",
            author: "财经观察",
            category: .finance,
            imageURL: "https://picsum.photos/seed/stockmarket/400/300",
            publishedAt: Date().addingTimeInterval(-14400),
            isFavorite: false,
            viewCount: 23450
        ),
        NewsProNewsArticle(
            id: "article_005",
            title: "研究发现：每天步行 8000 步可显著降低死亡风险",
            summary: "一项最新研究表明，每天步行 8000 步可以显著降低心血管疾病和全因死亡风险。",
            content: "发表在《柳叶刀》杂志上的一项大规模研究表明，每天步行 8000 步可以带来最大的健康益处，进一步增加步数收益递减。\n\n研究跟踪了超过 10 万名参与者，发现每天步行 8000 步的人群相比每天步行 4000 步的人群，全因死亡风险降低 51%，心血管疾病风险降低 42%。\n\n专家建议，步行速度也很重要，中等强度的步行（每分钟 100-120 步）效果更佳。",
            author: "健康时报",
            category: .health,
            imageURL: "https://picsum.photos/seed/walking/400/300",
            publishedAt: Date().addingTimeInterval(-18000),
            isFavorite: true,
            viewCount: 18920
        ),
        NewsProNewsArticle(
            id: "article_006",
            title: "OpenAI 发布 GPT-5，性能大幅提升",
            summary: "OpenAI 正式发布 GPT-5，新模型在推理能力和多模态处理方面实现了重大突破。",
            content: "OpenAI 今日正式发布 GPT-5，这是迄今为止最强大的语言模型。GPT-5 在数学推理、代码生成和多语言处理方面都有显著提升。\n\n新模型支持更长的上下文窗口，最高可达 200 万 token。同时，GPT-5 还增强了多模态能力，可以更好地理解和生成图像、音频和视频内容。\n\nOpenAI 表示，GPT-5 将通过 API 和 ChatGPT Plus 向用户开放。",
            author: "AI 前沿",
            category: .technology,
            imageURL: "https://picsum.photos/seed/gpt5/400/300",
            publishedAt: Date().addingTimeInterval(-21600),
            isFavorite: false,
            viewCount: 32100
        )
    ]
}

extension NewsProComment {
    static let mockComments: [NewsProComment] = [
        NewsProComment(
            id: "comment_001",
            articleId: "article_001",
            userId: "user_002",
            userName: "李四",
            content: "期待已久！一定要入手一台。",
            createdAt: Date().addingTimeInterval(-1800)
        ),
        NewsProComment(
            id: "comment_002",
            articleId: "article_001",
            userId: "user_003",
            userName: "王五",
            content: "价格有点贵，等双十一看看有没有优惠。",
            createdAt: Date().addingTimeInterval(-3600)
        ),
        NewsProComment(
            id: "comment_003",
            articleId: "article_002",
            userId: "user_004",
            userName: "赵六",
            content: "詹姆斯太厉害了！恭喜湖人！",
            createdAt: Date().addingTimeInterval(-5400)
        )
    ]
}
