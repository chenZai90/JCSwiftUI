import SwiftUI

/// 应用配置示例
/// 本文件演示了SwiftUI应用的配置和设置
struct ApplicationConfigurationDemo: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                //  标题
                Text("应用配置")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                
                //  应用信息
                VStack {
                    Text("1. 应用信息")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("• 应用名称: swiftUIDemo")
                        Text("• 版本号: 1.0.0")
                        Text("• 构建号: 1")
                        Text("• 包标识符: com.example.swiftUIDemo")
                    }
                    .padding()
                    .background(.gray.opacity(0.1))
                    .cornerRadius(10)
                }
                
                //  应用图标
                VStack {
                    Text("2. 应用图标")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Image(systemName: "appicon")
                        .font(.system(size: 100))
                        .foregroundColor(.blue)
                    
                    Text("应用图标应放置在Assets.xcassets中")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding()
                .background(.blue.opacity(0.1))
                .cornerRadius(10)
                
                //  启动屏幕
                VStack {
                    Text("3. 启动屏幕")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text("启动屏幕可以在Info.plist中配置")
                        .font(.body)
                    
                    Text("使用LaunchScreen.storyboard或SwiftUI启动屏幕")
                        .font(.body)
                }
                .padding()
                .background(.green.opacity(0.1))
                .cornerRadius(10)
                
                //  权限配置
                VStack {
                    Text("4. 权限配置")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("• 位置权限: NSLocationWhenInUseUsageDescription")
                        Text("• 相机权限: NSCameraUsageDescription")
                        Text("• 麦克风权限: NSMicrophoneUsageDescription")
                        Text("• 通知权限: NSUserNotificationUsageDescription")
                    }
                    .padding()
                    .background(.yellow.opacity(0.1))
                    .cornerRadius(10)
                }
                
                //  应用设置
                VStack {
                    Text("5. 应用设置")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text("使用Settings.bundle创建应用设置页面")
                        .font(.body)
                    
                    Text("支持用户自定义应用行为")
                        .font(.body)
                }
                .padding()
                .background(.purple.opacity(0.1))
                .cornerRadius(10)
            }
            .padding()
        }
    }
}

/// 预览
struct ApplicationConfigurationDemo_Previews: PreviewProvider {
    static var previews: some View {
        ApplicationConfigurationDemo()
    }
}