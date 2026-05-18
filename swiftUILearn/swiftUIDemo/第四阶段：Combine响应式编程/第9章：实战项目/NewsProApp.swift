//
//  NewsProApp.swift
//  swiftUIDemo
//
//  Created by AI Assistant
//  NewsPro - 专业新闻应用
//

import SwiftUI
import Combine

// 注意：@main 标签已移除，主入口在 swiftUIDemoApp.swift 中

// MARK: - NewsProApp 主入口（可选，用于独立预览）
struct NewsProAppEntry: App {
    @StateObject private var appState = NewsProAppState()
    
    var body: some Scene {
        WindowGroup {
            NewsProContentView()
                .environmentObject(appState)
        }
    }
}

// MARK: - 全局应用状态
class NewsProAppState: ObservableObject {
    @Published var isAuthenticated = false
    @Published var currentUser: NewsProUser?
    @Published var selectedTab = 0
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        // 检查登录状态
        NewsProAuthService.shared.$currentUser
            .receive(on: DispatchQueue.main)
            .sink { [weak self] user in
                self?.currentUser = user
                self?.isAuthenticated = user != nil
            }
            .store(in: &cancellables)
    }
}

// MARK: - 主内容视图
struct NewsProContentView: View {
    @EnvironmentObject var appState: NewsProAppState
    
    var body: some View {
        Group {
            if appState.isAuthenticated {
                NewsProMainTabView()
            } else {
                NewsProAuthView()
            }
        }
    }
}

// MARK: - 预览
struct NewsProApp_Previews: PreviewProvider {
    static var previews: some View {
        NewsProContentView()
            .environmentObject(NewsProAppState())
    }
}

// MARK: - 演示入口包装视图（用于从主界面导航）
struct NewsProDemo: View {
    @StateObject private var appState = NewsProAppState()
    
    var body: some View {
        NewsProContentView()
            .environmentObject(appState)
    }
}
