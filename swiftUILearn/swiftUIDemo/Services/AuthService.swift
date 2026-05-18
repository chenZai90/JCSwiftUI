import Foundation
import Combine

// MARK: - NewsProAuthService
class NewsProAuthService: ObservableObject {
    // MARK: - Singleton
    static let shared = NewsProAuthService()

    // MARK: - Published Properties
    @Published var currentUser: NewsProUser?
    @Published var isAuthenticated: Bool = false
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    // MARK: - Private Properties
    private var cancellables = Set<AnyCancellable>()
    private let tokenKey = "news_pro_auth_token"
    private let userKey = "news_pro_current_user"

    // MARK: - Mock Credentials
    private let mockCredentials: [(email: String, password: String, user: NewsProUser)] = [
        (
            email: "user@example.com",
            password: "password123",
            user: NewsProUser.mockUser
        ),
        (
            email: "admin@example.com",
            password: "admin123",
            user: NewsProUser.mockAdmin
        )
    ]

    // MARK: - Initialization
    private init() {
        loadCachedUser()
    }

    // MARK: - Public Methods

    /// 用户登录
    /// - Parameters:
    ///   - email: 邮箱
    ///   - password: 密码
    /// - Returns: AnyPublisher<NewsProUser, NewsProAPIError>
    func login(email: String, password: String) -> AnyPublisher<NewsProUser, NewsProAPIError> {
        isLoading = true
        errorMessage = nil

        return simulateNetworkRequest()
            .flatMap { [weak self] _ -> AnyPublisher<NewsProUser, NewsProAPIError> in
                guard let self = self else {
                    return Fail(error: NewsProAPIError.unknown)
                        .eraseToAnyPublisher()
                }

                // 验证邮箱和密码
                if let credential = self.mockCredentials.first(where: {
                    $0.email.lowercased() == email.lowercased() &&
                    $0.password == password
                }) {
                    // 登录成功
                    let user = credential.user
                    self.currentUser = user
                    self.isAuthenticated = true
                    self.cacheUser(user)
                    self.isLoading = false
                    return Just(user)
                        .setFailureType(to: NewsProAPIError.self)
                        .eraseToAnyPublisher()
                } else {
                    // 登录失败
                    self.isLoading = false
                    self.errorMessage = "邮箱或密码错误"
                    return Fail(error: NewsProAPIError.unauthorized)
                        .eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }

    /// 用户注册
    /// - Parameters:
    ///   - email: 邮箱
    ///   - password: 密码
    ///   - name: 用户名
    /// - Returns: AnyPublisher<NewsProUser, NewsProAPIError>
    func register(email: String, password: String, name: String) -> AnyPublisher<NewsProUser, NewsProAPIError> {
        isLoading = true
        errorMessage = nil

        return simulateNetworkRequest()
            .flatMap { [weak self] _ -> AnyPublisher<NewsProUser, NewsProAPIError> in
                guard let self = self else {
                    return Fail(error: NewsProAPIError.unknown)
                        .eraseToAnyPublisher()
                }

                // 检查邮箱是否已被注册
                if self.mockCredentials.contains(where: { $0.email.lowercased() == email.lowercased() }) {
                    self.isLoading = false
                    self.errorMessage = "该邮箱已被注册"
                    return Fail(error: NewsProAPIError.badRequest("该邮箱已被注册"))
                        .eraseToAnyPublisher()
                }

                // 验证邮箱格式
                guard self.isValidEmail(email) else {
                    self.isLoading = false
                    self.errorMessage = "邮箱格式不正确"
                    return Fail(error: NewsProAPIError.badRequest("邮箱格式不正确"))
                        .eraseToAnyPublisher()
                }

                // 验证密码长度
                guard password.count >= 6 else {
                    self.isLoading = false
                    self.errorMessage = "密码长度至少为6位"
                    return Fail(error: NewsProAPIError.badRequest("密码长度至少为6位"))
                        .eraseToAnyPublisher()
                }

                // 创建新用户
                let newUser = NewsProUser(
                    id: "user_\(Int.random(in: 1000...9999))",
                    email: email,
                    name: name,
                    avatar: "https://api.dicebear.com/7.x/avataaars/svg?seed=\(email)",
                    bio: nil,
                    createdAt: Date()
                )

                self.currentUser = newUser
                self.isAuthenticated = true
                self.cacheUser(newUser)
                self.isLoading = false

                return Just(newUser)
                    .setFailureType(to: NewsProAPIError.self)
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }

    /// 用户登出
    func logout() {
        currentUser = nil
        isAuthenticated = false
        errorMessage = nil
        clearCachedUser()
    }

    /// 更新用户信息
    /// - Parameters:
    ///   - name: 新用户名
    ///   - bio: 新简介
    ///   - avatar: 新头像URL
    /// - Returns: AnyPublisher<NewsProUser, NewsProAPIError>
    func updateProfile(name: String?, bio: String?, avatar: String?) -> AnyPublisher<NewsProUser, NewsProAPIError> {
        guard let currentUser = currentUser else {
            return Fail(error: NewsProAPIError.unauthorized)
                .eraseToAnyPublisher()
        }

        isLoading = true

        return simulateNetworkRequest()
            .flatMap { [weak self] _ -> AnyPublisher<NewsProUser, NewsProAPIError> in
                guard let self = self else {
                    return Fail(error: NewsProAPIError.unknown)
                        .eraseToAnyPublisher()
                }

                let updatedUser = NewsProUser(
                    id: currentUser.id,
                    email: currentUser.email,
                    name: name ?? currentUser.name,
                    avatar: avatar ?? currentUser.avatar,
                    bio: bio ?? currentUser.bio,
                    createdAt: currentUser.createdAt
                )

                self.currentUser = updatedUser
                self.cacheUser(updatedUser)
                self.isLoading = false

                return Just(updatedUser)
                    .setFailureType(to: NewsProAPIError.self)
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }

    /// 修改密码
    /// - Parameters:
    ///   - oldPassword: 旧密码
    ///   - newPassword: 新密码
    /// - Returns: AnyPublisher<Bool, NewsProAPIError>
    func changePassword(oldPassword: String, newPassword: String) -> AnyPublisher<Bool, NewsProAPIError> {
        guard currentUser != nil else {
            return Fail(error: NewsProAPIError.unauthorized)
                .eraseToAnyPublisher()
        }

        isLoading = true

        return simulateNetworkRequest()
            .flatMap { [weak self] _ -> AnyPublisher<Bool, NewsProAPIError> in
                guard let self = self else {
                    return Fail(error: NewsProAPIError.unknown)
                        .eraseToAnyPublisher()
                }

                // 验证新密码长度
                guard newPassword.count >= 6 else {
                    self.isLoading = false
                    self.errorMessage = "新密码长度至少为6位"
                    return Fail(error: NewsProAPIError.badRequest("新密码长度至少为6位"))
                        .eraseToAnyPublisher()
                }

                self.isLoading = false
                return Just(true)
                    .setFailureType(to: NewsProAPIError.self)
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }

    /// 发送重置密码邮件
    /// - Parameter email: 邮箱
    /// - Returns: AnyPublisher<Bool, NewsProAPIError>
    func sendPasswordResetEmail(email: String) -> AnyPublisher<Bool, NewsProAPIError> {
        isLoading = true

        return simulateNetworkRequest()
            .flatMap { [weak self] _ -> AnyPublisher<Bool, NewsProAPIError> in
                guard let self = self else {
                    return Fail(error: NewsProAPIError.unknown)
                        .eraseToAnyPublisher()
                }

                guard self.isValidEmail(email) else {
                    self.isLoading = false
                    return Fail(error: NewsProAPIError.badRequest("邮箱格式不正确"))
                        .eraseToAnyPublisher()
                }

                self.isLoading = false
                return Just(true)
                    .setFailureType(to: NewsProAPIError.self)
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }

    // MARK: - Private Methods

    /// 模拟网络请求延迟
    private func simulateNetworkRequest() -> AnyPublisher<Void, NewsProAPIError> {
        Future<Void, NewsProAPIError> { promise in
            DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
                promise(.success(()))
            }
        }
        .eraseToAnyPublisher()
    }

    /// 验证邮箱格式
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }

    /// 缓存用户信息
    private func cacheUser(_ user: NewsProUser) {
        if let encoded = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(encoded, forKey: userKey)
        }
        // 模拟存储 token
        UserDefaults.standard.set("mock_token_\(user.id)", forKey: tokenKey)
    }

    /// 加载缓存的用户信息
    private func loadCachedUser() {
        guard let token = UserDefaults.standard.string(forKey: tokenKey),
              let data = UserDefaults.standard.data(forKey: userKey),
              let user = try? JSONDecoder().decode(NewsProUser.self, from: data) else {
            return
        }

        currentUser = user
        isAuthenticated = true
    }

    /// 清除缓存的用户信息
    private func clearCachedUser() {
        UserDefaults.standard.removeObject(forKey: userKey)
        UserDefaults.standard.removeObject(forKey: tokenKey)
    }
}

// MARK: - NewsProAuthService Errors
extension NewsProAuthService {
    enum NewsProAuthError: Error, LocalizedError {
        case invalidCredentials
        case emailAlreadyExists
        case invalidEmail
        case weakPassword
        case userNotFound
        case networkError
        case unknown

        var errorDescription: String? {
            switch self {
            case .invalidCredentials:
                return "邮箱或密码错误"
            case .emailAlreadyExists:
                return "该邮箱已被注册"
            case .invalidEmail:
                return "邮箱格式不正确"
            case .weakPassword:
                return "密码强度不够"
            case .userNotFound:
                return "用户不存在"
            case .networkError:
                return "网络连接失败"
            case .unknown:
                return "未知错误"
            }
        }
    }
}
