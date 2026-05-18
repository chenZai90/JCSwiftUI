//
//  ContentView.swift
//  swiftUIDemo
//
//  SwiftUI学习示例主页面
//

import SwiftUI

//  主视图 - 提供示例导航
struct ContentView: View {
    var body: some View {
        //  导航堆栈 - 用于页面导航
        NavigationStack {
            //  列表 - 显示所有学习示例
            List {
                //  第一阶段 - SwiftUI基础入门
            Section(header: Text("第一阶段：SwiftUI基础入门")) {
                NavigationLink("第1章：SwiftUI简介与开发环境搭建", destination: SwiftUIIntroduction())
                NavigationLink("第2章：声明式UI基础", destination: DeclarativeUIDemo())
                NavigationLink("第3章：基础 视图组件", destination: BasicViewsDemo())
                NavigationLink("第4章：基础布局系统", destination: LayoutSystemDemo())
                NavigationLink("第5章：基础状态管理", destination: StateManagementDemo())
                NavigationLink("第6章：导航与表单", destination: NavigationAndForms())
            }
                
                //  第二阶段 - SwiftUI进阶学习
                Section(header: Text("第二阶段：SwiftUI进阶学习")) {
                    NavigationLink("第1章：高级视图组件", destination: AdvancedViewsDemo())
                    NavigationLink("第2章：动画与过渡", destination: AnimationAndTransitionDemo())
                    NavigationLink("第3章：手势与交互", destination: GestureAndInteractionDemo())
                    NavigationLink("第4章：响应式布局", destination: ResponsiveLayoutDemo())
                    NavigationLink("第5章：数据处理与网络请求", destination: DataProcessingAndNetworkingDemo())
                    NavigationLink("第6章：列表与滚动视图", destination: ListAndScrollViewDemo())
                    NavigationLink("第7章：导航系统", destination: NavigationSystemDemo())
                    NavigationLink("第8章：表单与设置界面", destination: FormsAndSettingsDemo())
                    NavigationLink("第9章：高级状态管理", destination: Stage2AdvancedStateManagement.AdvancedStateManagementDemo())
            NavigationLink("第10章：现代状态管理 (iOS 17+)", destination: Stage2ModernStateManagement.ModernStateManagementDemo())
                }
                
                //  第三阶段 - SwiftUI高级特性
                Section(header: Text("第三阶段：SwiftUI高级特性")) {
                    NavigationLink("第1章：自定义视图", destination: CustomViewsDemo())
                    NavigationLink("第2章：组合与容器", destination: CompositionAndContainerDemo())
                    NavigationLink("第3章：环境与偏好设置", destination: EnvironmentAndPreferencesDemo())
                    NavigationLink("第4章：高级动画与过渡", destination: AdvancedAnimationDemo())
                    NavigationLink("第5章：高级手势与交互", destination: AdvancedGestureDemo())
                    NavigationLink("第6章：高级布局技巧", destination: AdvancedLayoutDemo())
                    NavigationLink("第7章：高级状态管理技巧", destination: AdvancedStateManagementTechniquesDemo())
                    NavigationLink("第8章：SwiftUI与UIKit集成", destination: SwiftUIWithUIKitIntegrationDemo())
                    NavigationLink("第9章：高级状态管理", destination: S3_AdvancedStateManagementDemo())
                    NavigationLink("第10章：现代状态管理 (iOS 17+)", destination: S3_ModernStateManagementDemo())
                }
                
                //  第四阶段 - Combine响应式编程
                Section(header: Text("第四阶段：Combine响应式编程")) {
                    NavigationLink("第1章：Combine基础", destination: CombineBasicsDemo())
                    NavigationLink("第2章：操作符", destination: CombineOperatorsDemo())
                    NavigationLink("第3章：与SwiftUI集成", destination: CombineWithSwiftUIDemo())
                    NavigationLink("第9章：实战项目 - NewsPro新闻应用", destination: NewsProDemo())
                }
                
                //  第五阶段 - MVVM架构
                Section(header: Text("第五阶段：MVVM架构")) {
                    NavigationLink("第1章：MVVM基础", destination: MVVMBasicsDemo())
                    NavigationLink("第2章：数据绑定", destination: DataBindingDemo())
                    NavigationLink("第3章：依赖注入", destination: DependencyInjectionDemo())
                }
                
                //  第六阶段 - SwiftUI高级集成
                Section(header: Text("第六阶段：SwiftUI高级集成")) {
                    NavigationLink("第1章：网络请求", destination: NetworkRequestDemo())
                    NavigationLink("第2章：Core Data", destination: CoreDataIntegrationDemo())
                    NavigationLink("第3章：地图与位置", destination: MapAndLocationDemo())
                }
                
                //  第七阶段 - SwiftUI性能优化
                Section(header: Text("第七阶段：SwiftUI性能优化")) {
                    NavigationLink("第1章：性能分析", destination: PerformanceAnalysisDemo())
                    NavigationLink("第2章：渲染优化", destination: RenderingOptimizationDemo())
                }
                
                //  第八阶段 - SwiftUI应用发布
                Section(header: Text("第八阶段：SwiftUI应用发布")) {
                    NavigationLink("第1章：应用配置", destination: ApplicationConfigurationDemo())
                    NavigationLink("第2章：应用发布", destination: ApplicationPublishingDemo())
                }
                
                //  第九阶段 - SwiftUI与MV架构
                Section(header: Text("第九阶段：SwiftUI与MV架构")) {
                    NavigationLink("第1章：MVC架构", destination: MVCArchitectureDemo())
                    NavigationLink("第2章：MVVM架构", destination: MVVMArchitectureDemo())
                }
            }
            .navigationTitle("SwiftUI学习示例")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    ContentView()
}
