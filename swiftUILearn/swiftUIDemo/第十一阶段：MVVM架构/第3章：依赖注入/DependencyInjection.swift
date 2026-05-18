//
//  DependencyInjection.swift
//  swiftUIDemo
//
//  依赖注入示例
//

import SwiftUI

//  依赖注入示例
struct DependencyInjectionDemo: View {
    //  使用@StateObject创建视图模型，并注入服务
    @StateObject private var viewModel = ProductViewModel(productService: ProductService())
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                //  标题
                Text("依赖注入")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                
                //  产品列表
                VStack {
                    Text("产品列表")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    if viewModel.isLoading {
                        ProgressView("加载中...")
                    } else if let error = viewModel.error {
                        Text("错误: \(error)")
                            .foregroundColor(.red)
                    } else {
                        List(viewModel.products) {
                            product in
                            ProductItemView(product: product)
                        }
                    }
                }
                .padding()
                .background(.gray.opacity(0.1))
                .cornerRadius(10)
                
                //  操作按钮
                HStack(spacing: 10) {
                    Button("加载产品") {
                        viewModel.loadProducts()
                    }
                    .padding()
                    .background(.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    
                    Button("添加产品") {
                        viewModel.addProduct()
                    }
                    .padding()
                    .background(.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
            }
            .padding()
        }
    }
}

//  产品模型
struct Product: Identifiable {
    let id: Int
    let name: String
    let price: Double
    let description: String
}

//  产品项视图
struct ProductItemView: View {
    let product: Product
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(product.name)
                .font(.headline)
                .fontWeight(.bold)
            Text("¥\(product.price, specifier: "%.2f")")
                .font(.subheadline)
                .foregroundColor(.green)
            Text(product.description)
                .font(.body)
                .foregroundColor(.gray)
        }
        .padding()
        .background(.white)
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}

//  产品服务协议
protocol ProductServiceProtocol {
    func getProducts() async throws -> [Product]
    func addProduct(name: String, price: Double, description: String) async throws -> Product
}

//  产品服务实现
class ProductService: ProductServiceProtocol {
    func getProducts() async throws -> [Product] {
        //  模拟网络请求
        try await Task.sleep(nanoseconds: 1 * 1_000_000_000)
        
        return [
            Product(id: 1, name: "iPhone 14", price: 6999, description: "苹果智能手机"),
            Product(id: 2, name: "iPad Pro", price: 8999, description: "苹果平板电脑"),
            Product(id: 3, name: "MacBook Air", price: 7999, description: "苹果笔记本电脑")
        ]
    }
    
    func addProduct(name: String, price: Double, description: String) async throws -> Product {
        //  模拟网络请求
        try await Task.sleep(nanoseconds: 500_000_000)
        
        return Product(id: Int.random(in: 100...999), name: name, price: price, description: description)
    }
}

//  产品视图模型
class ProductViewModel: ObservableObject {
    //  发布的属性
    @Published var products: [Product] = []
    @Published var isLoading = false
    @Published var error: String? = nil
    
    //  依赖的服务
    private let productService: ProductServiceProtocol
    
    //  初始化，通过依赖注入
    init(productService: ProductServiceProtocol) {
        self.productService = productService
    }
    
    //  加载产品
    func loadProducts() {
        isLoading = true
        error = nil
        
        Task {
            do {
                let products = try await productService.getProducts()
                DispatchQueue.main.async {
                    self.products = products
                    self.isLoading = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.error = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }
    
    //  添加产品
    func addProduct() {
        isLoading = true
        error = nil
        
        Task {
            do {
                let newProduct = try await productService.addProduct(
                    name: "新产品",
                    price: Double.random(in: 1000...9999),
                    description: "这是一个新添加的产品"
                )
                DispatchQueue.main.async {
                    self.products.append(newProduct)
                    self.isLoading = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.error = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }
}

#Preview {
    DependencyInjectionDemo()
}