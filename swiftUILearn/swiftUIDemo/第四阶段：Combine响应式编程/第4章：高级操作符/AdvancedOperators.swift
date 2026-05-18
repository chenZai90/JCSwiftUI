//
//  AdvancedOperators.swift
//  swiftUIDemo
//
//  Created by AI Assistant
//  Combine高级操作符示例
//

import SwiftUI
import Combine

class AdvancedOperatorsViewModel: ObservableObject {
    @Published var mapResult = ""
    @Published var flatMapResult = ""
    @Published var combineLatestResult = ""
    @Published var debounceResult = ""
    @Published var searchQuery = ""
    @Published var isSearching = false
    @Published var searchResults: [String] = []
    
    @Published var username = ""
    @Published var password = ""
    @Published var isFormValid = false
    
    private var cancellables = Set<AnyCancellable>()
    private var searchCancellable: AnyCancellable?
    
    init() {
        setupFormValidation()
        setupSearch()
    }
    
    func testMap() {
        let numbers = [1, 2, 3, 4].publisher
        var results: [String] = []
        
        numbers
            .map { $0 * 2 }
            .sink { value in
                results.append("\(value)")
            }
            .store(in: &cancellables)
        
        mapResult = "map结果: " + results.joined(separator: ", ")
    }
    
    func testFlatMap() {
        let subject = PassthroughSubject<String, Never>()
        flatMapResult = "等待结果..."
        
        subject
            .flatMap { query -> AnyPublisher<String, Never> in
                return Just("搜索: \(query)")
                    .delay(for: .seconds(0.3), scheduler: DispatchQueue.main)
                    .eraseToAnyPublisher()
            }
            .sink { [weak self] result in
                self?.flatMapResult = result
            }
            .store(in: &cancellables)
        
        subject.send("Swift")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            subject.send("Combine")
        }
    }
    
    private func setupFormValidation() {
        Publishers.CombineLatest($username, $password)
            .map { user, pass in
                !user.isEmpty && pass.count >= 6
            }
            .assign(to: &$isFormValid)
    }
    
    private func setupSearch() {
        $searchQuery
            .sink { [weak self] query in
                self?.performDebounceSearch(query: query)
            }
            .store(in: &cancellables)
    }
    
    func performDebounceSearch(query: String) {
        searchCancellable?.cancel()
        
        guard !query.isEmpty else {
            searchResults = []
            debounceResult = ""
            return
        }
        
        debounceResult = "等待搜索..."
        
        searchCancellable = Just(query)
            .delay(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .sink { [weak self] debouncedQuery in
                self?.performSearch(query: debouncedQuery)
            }
    }
    
    func performSearch(query: String) {
        isSearching = true
        debounceResult = "正在搜索: \(query)"
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.searchResults = [
                "\(query) - 结果1",
                "\(query) - 结果2",
                "\(query) - 结果3"
            ]
            self?.isSearching = false
            self?.debounceResult = "搜索完成"
        }
    }
    
    func testSwitchToLatest() {
        let subject = PassthroughSubject<String, Never>()
        
        subject
            .map { query -> AnyPublisher<String, Never> in
                return Just("\(query) - 结果")
                    .delay(for: .seconds(0.5), scheduler: DispatchQueue.main)
                    .eraseToAnyPublisher()
            }
            .switchToLatest()
            .sink { result in
                print("switchToLatest 结果: \(result)")
            }
            .store(in: &cancellables)
        
        subject.send("请求1")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            subject.send("请求2")
        }
    }
    
    func testCollectOperators() {
        let numbers = [1, 2, 3, 4, 5].publisher
        
        numbers
            .collect()
            .sink { array in
                print("collect: \(array)")
            }
            .store(in: &cancellables)
        
        numbers
            .reduce(0, +)
            .sink { sum in
                print("reduce sum: \(sum)")
            }
            .store(in: &cancellables)
        
        numbers
            .scan(0, +)
            .sink { runningTotal in
                print("scan: \(runningTotal)")
            }
            .store(in: &cancellables)
    }
}

struct AdvancedOperatorsDemo: View {
    @StateObject private var viewModel = AdvancedOperatorsViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("高级操作符")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("1. map/tryMap 转换")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Button("测试map") {
                        viewModel.testMap()
                    }
                    .padding()
                    .background(.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    
                    Text(viewModel.mapResult)
                        .font(.body)
                        .foregroundColor(.gray)
                }
                .padding()
                .background(.blue.opacity(0.1))
                .cornerRadius(10)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("2. flatMap")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Button("测试flatMap") {
                        viewModel.testFlatMap()
                    }
                    .padding()
                    .background(.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    
                    Text(viewModel.flatMapResult)
                        .font(.body)
                        .foregroundColor(.gray)
                }
                .padding()
                .background(.green.opacity(0.1))
                .cornerRadius(10)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("3. combineLatest 表单验证")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    TextField("用户名", text: $viewModel.username)
                        .textFieldStyle(.roundedBorder)
                    
                    SecureField("密码(≥6位)", text: $viewModel.password)
                        .textFieldStyle(.roundedBorder)
                    
                    Text(viewModel.isFormValid ? "✅ 表单有效" : "❌ 请填写完整")
                        .foregroundColor(viewModel.isFormValid ? .green : .red)
                }
                .padding()
                .background(.orange.opacity(0.1))
                .cornerRadius(10)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("4. debounce 搜索防抖")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    HStack {
                        TextField("输入搜索...", text: $viewModel.searchQuery)
                            .textFieldStyle(.roundedBorder)
                        
                        if viewModel.isSearching {
                            ProgressView()
                        }
                    }
                    
                    Text(viewModel.debounceResult)
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    if !viewModel.searchResults.isEmpty {
                        VStack(alignment: .leading) {
                            Text("搜索结果:")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            ForEach(viewModel.searchResults, id: \.self) { result in
                                Text(result)
                                    .font(.body)
                            }
                        }
                    }
                }
                .padding()
                .background(.purple.opacity(0.1))
                .cornerRadius(10)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("5. switchToLatest")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Button("测试switchToLatest") {
                        viewModel.testSwitchToLatest()
                    }
                    .padding()
                    .background(.pink)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding()
                .background(.pink.opacity(0.1))
                .cornerRadius(10)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("6. collect/reduce/scan")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Button("测试收集操作符") {
                        viewModel.testCollectOperators()
                    }
                    .padding()
                    .background(.teal)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding()
                .background(.teal.opacity(0.1))
                .cornerRadius(10)
            }
            .padding()
        }
    }
}

#Preview {
    AdvancedOperatorsDemo()
}
