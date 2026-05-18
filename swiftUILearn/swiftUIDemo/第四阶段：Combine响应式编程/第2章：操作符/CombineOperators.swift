//
//  CombineOperators.swift
//  swiftUIDemo
//
//  Combine操作符示例
//

import SwiftUI
import Combine

//  Combine操作符示例
struct CombineOperatorsDemo: View {
    //  状态管理
    @State private var result = ""
    @State private var numbers: [Int] = []
    @State private var filteredNumbers: [Int] = []
    
    //  订阅存储
    @State private var cancellables = Set<AnyCancellable>()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                //  标题
                Text("Combine操作符")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                
                //  Map操作符
                VStack {
                    Text("1. Map操作符")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text("结果: \(result)")
                        .font(.body)
                    
                    Button("使用Map") {
                        useMapOperator()
                    }
                    .padding()
                    .background(.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding()
                .background(.gray.opacity(0.1))
                .cornerRadius(10)
                
                //  Filter操作符
                VStack {
                    Text("2. Filter操作符")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text("过滤后的数字: \(filteredNumbers.description)")
                        .font(.body)
                    
                    Button("使用Filter") {
                        useFilterOperator()
                    }
                    .padding()
                    .background(.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding()
                .background(.blue.opacity(0.1))
                .cornerRadius(10)
                
                //  Reduce操作符
                VStack {
                    Text("3. Reduce操作符")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text("结果: \(result)")
                        .font(.body)
                    
                    Button("使用Reduce") {
                        useReduceOperator()
                    }
                    .padding()
                    .background(.purple)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding()
                .background(.green.opacity(0.1))
                .cornerRadius(10)
                
                //  Debounce操作符
                VStack {
                    Text("4. Debounce操作符")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text("结果: \(result)")
                        .font(.body)
                    
                    Button("使用Debounce") {
                        useDebounceOperator()
                    }
                    .padding()
                    .background(.yellow)
                    .foregroundColor(.black)
                    .cornerRadius(10)
                }
                .padding()
                .background(.yellow.opacity(0.1))
                .cornerRadius(10)
                
                //  Throttle操作符
                VStack {
                    Text("5. Throttle操作符")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text("结果: \(result)")
                        .font(.body)
                    
                    Button("使用Throttle") {
                        useThrottleOperator()
                    }
                    .padding()
                    .background(.orange)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding()
                .background(.purple.opacity(0.1))
                .cornerRadius(10)
                
                //  FlatMap操作符
                VStack {
                    Text("6. FlatMap操作符")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text("结果: \(result)")
                        .font(.body)
                    
                    Button("使用FlatMap") {
                        useFlatMapOperator()
                    }
                    .padding()
                    .background(.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding()
                .background(.red.opacity(0.1))
                .cornerRadius(10)
            }
            .padding()
        }
    }
    
    //  使用Map操作符
    func useMapOperator() {
        let publisher = [1, 2, 3, 4, 5].publisher
        
        publisher
            .map { $0 * 2 }
            .sink { value in
                result = "\(value)"
            }
            .store(in: &cancellables)
    }
    
    //  使用Filter操作符
    func useFilterOperator() {
        let publisher = (1...10).publisher
        
        publisher
            .filter { $0 % 2 == 0 }
            .sink { value in
                filteredNumbers.append(value)
            }
            .store(in: &cancellables)
    }
    
    //  使用Reduce操作符
    func useReduceOperator() {
        let publisher = [1, 2, 3, 4, 5].publisher
        
        publisher
            .reduce(0, +)
            .sink { value in
                result = "\(value)"
            }
            .store(in: &cancellables)
    }
    
    //  使用Debounce操作符
    func useDebounceOperator() {
        let publisher = PassthroughSubject<String, Never>()
        
        publisher
            .debounce(for: .seconds(1), scheduler: DispatchQueue.main)
            .sink { value in
                result = value
            }
            .store(in: &cancellables)
        
        //  模拟快速输入
        publisher.send("H")
        publisher.send("He")
        publisher.send("Hel")
        publisher.send("Hell")
        publisher.send("Hello")
    }
    
    //  使用Throttle操作符
    func useThrottleOperator() {
        let publisher = Timer.publish(every: 0.1, on: .main, in: .common)
            .autoconnect()
        
        publisher
            .throttle(for: .seconds(1), scheduler: DispatchQueue.main, latest: true)
            .sink { value in
                result = "\(value)"
            }
            .store(in: &cancellables)
    }
    
    //  使用FlatMap操作符
    func useFlatMapOperator() {
        let publisher = [1, 2, 3].publisher
        
        publisher
            .flatMap { value in
                return Just("数字: \(value)")
            }
            .sink { value in
                result = value
            }
            .store(in: &cancellables)
    }
}

#Preview {
    CombineOperatorsDemo()
}