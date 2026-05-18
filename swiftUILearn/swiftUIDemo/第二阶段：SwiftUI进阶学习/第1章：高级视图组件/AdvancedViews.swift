//
//  AdvancedViews.swift
//  swiftUIDemo
//
//  高级视图组件示例
//

import SwiftUI

//  高级视图组件示例
struct AdvancedViewsDemo: View {
    //  状态管理
    @State private var selectedDate = Date()
    @State private var selectedTime = Date()
    @State private var isPlaying = false
    @State private var progress = 0.0
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                //  标题
                Text("高级视图组件")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                
                //  日期选择器
                VStack {
                    Text("1. 日期选择器")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    DatePicker(
                        "选择日期",
                        selection: $selectedDate,
                        displayedComponents: .date
                    )
                    .padding()
                    .background(.gray.opacity(0.1))
                    .cornerRadius(10)
                }
                
                //  时间选择器
                VStack {
                    Text("2. 时间选择器")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    DatePicker(
                        "选择时间",
                        selection: $selectedTime,
                        displayedComponents: .hourAndMinute
                    )
                    .padding()
                    .background(.blue.opacity(0.1))
                    .cornerRadius(10)
                }
                
                //  分段控件
                VStack {
                    Text("3. 分段控件")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Picker("选择选项", selection: .constant(0)) {
                        Text("选项1").tag(0)
                        Text("选项2").tag(1)
                        Text("选项3").tag(2)
                    }
                    .pickerStyle(.segmented)
                    .padding()
                    .background(.green.opacity(0.1))
                    .cornerRadius(10)
                }
                
                //  滑块
                VStack {
                    Text("4. 滑块")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    HStack {
                        Text("音量: \(Int(progress * 100))%")
                        Slider(value: $progress, in: 0...1)
                    }
                    .padding()
                    .background(.yellow.opacity(0.1))
                    .cornerRadius(10)
                }
                
                //  步进器
                VStack {
                    Text("5. 步进器")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Stepper(
                        "数量: \(Int(progress * 10))",
                        value: $progress,
                        in: 0...1,
                        step: 0.1
                    )
                    .padding()
                    .background(.purple.opacity(0.1))
                    .cornerRadius(10)
                }
                
                //  活动指示器
                VStack {
                    Text("6. 活动指示器")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Button("开始加载") {
                        isPlaying.toggle()
                    }
                    .padding()
                    .background(.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    
                    if isPlaying {
                        ProgressView("加载中...")
                            .padding()
                    }
                }
                .padding()
                .background(.red.opacity(0.1))
                .cornerRadius(10)
                
                //  进度视图
                VStack {
                    Text("7. 进度视图")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    ProgressView(value: progress)
                        .padding()
                    
                    Button("更新进度") {
                        withAnimation {
                            progress = progress < 1.0 ? progress + 0.1 : 0.0
                        }
                    }
                    .padding()
                    .background(.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding()
                .background(.orange.opacity(0.1))
                .cornerRadius(10)
                
                //  列表分组
                VStack {
                    Text("8. 列表分组")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    List {
                        Section(header: Text("水果")) {
                            Text("苹果")
                            Text("香蕉")
                            Text("橙子")
                        }
                        
                        Section(header: Text("蔬菜")) {
                            Text("西红柿")
                            Text("黄瓜")
                            Text("土豆")
                        }
                    }
                    .frame(height: 200)
                }
                .padding()
                .background(.gray.opacity(0.1))
                .cornerRadius(10)
            }
            .padding()
        }
    }
}

#Preview {
    AdvancedViewsDemo()
}