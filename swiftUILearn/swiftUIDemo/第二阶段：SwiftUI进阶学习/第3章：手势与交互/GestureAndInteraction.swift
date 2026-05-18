//
//  GestureAndInteraction.swift
//  swiftUIDemo
//
//  手势与交互示例
//

import SwiftUI

//  手势与交互示例
struct GestureAndInteractionDemo: View {
    //  状态管理
    @State private var isTapped = false
    @State private var isLongPressed = false
    @State private var offset = CGSize.zero
    @State private var scale = 1.0
    @State private var rotation = 0.0
    @State private var dragOffset = CGSize.zero
    @State private var isDragging = false
    @State private var tapCount = 0
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                //  标题
                Text("手势与交互")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                
                //  点击手势
                VStack {
                    Text("1. 点击手势")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text(isTapped ? "已点击" : "未点击")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(isTapped ? .green : .red)
                    
                    Rectangle()
                        .fill(.blue)
                        .frame(width: 200, height: 100)
                        .cornerRadius(10)
                        .overlay(
                            Text("点击我")
                                .foregroundColor(.white)
                                .font(.headline)
                        )
                        .onTapGesture {
                            isTapped.toggle()
                        }
                }
                .padding()
                .background(.gray.opacity(0.1))
                .cornerRadius(10)
                
                //  长按手势
                VStack {
                    Text("2. 长按手势")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text(isLongPressed ? "长按中..." : "未长按")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(isLongPressed ? .purple : .red)
                    
                    Rectangle()
                        .fill(.green)
                        .frame(width: 200, height: 100)
                        .cornerRadius(10)
                        .overlay(
                            Text("长按我")
                                .foregroundColor(.white)
                                .font(.headline)
                        )
                        .onLongPressGesture {
                            isLongPressed.toggle()
                        }
                }
                .padding()
                .background(.blue.opacity(0.1))
                .cornerRadius(10)
                
                //  拖拽手势
                VStack {
                    Text("3. 拖拽手势")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text("拖动下方的圆形")
                        .font(.subheadline)
                    
                    ZStack {
                        Rectangle()
                            .fill(.yellow.opacity(0.2))
                            .frame(width: 300, height: 200)
                            .cornerRadius(10)
                        
                        Circle()
                            .fill(.red)
                            .frame(width: 50, height: 50)
                            .offset(dragOffset)
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        dragOffset = value.translation
                                    }
                                    .onEnded { value in
                                        //  可以在这里添加结束拖动的逻辑
                                    }
                            )
                    }
                }
                .padding()
                .background(.green.opacity(0.1))
                .cornerRadius(10)
                
                //  缩放手势
                VStack {
                    Text("4. 缩放手势")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text("缩放比例: \(scale, specifier: "%.2f")")
                        .font(.subheadline)
                    
                    Rectangle()
                        .fill(.purple)
                        .frame(width: 200, height: 200)
                        .cornerRadius(10)
                        .scaleEffect(scale)
                        .gesture(
                            MagnificationGesture()
                                .onChanged { value in
                                    scale = value
                                }
                                .onEnded { value in
                                    //  可以在这里添加结束缩放的逻辑
                                }
                        )
                }
                .padding()
                .background(.yellow.opacity(0.1))
                .cornerRadius(10)
                
                //  旋转手势
                VStack {
                    Text("5. 旋转手势")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text("旋转角度: \(rotation, specifier: "%.0f")°")
                        .font(.subheadline)
                    
                    Rectangle()
                        .fill(.orange)
                        .frame(width: 200, height: 200)
                        .cornerRadius(10)
                        .rotationEffect(.degrees(rotation))
                        .gesture(
                            RotationGesture()
                                .onChanged { value in
                                    rotation = value.degrees
                                }
                                .onEnded { value in
                                    //  可以在这里添加结束旋转的逻辑
                                }
                        )
                }
                .padding()
                .background(.purple.opacity(0.1))
                .cornerRadius(10)
                
                //  组合手势
                VStack {
                    Text("6. 组合手势")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text("尝试拖动、缩放和旋转下方的正方形")
                        .font(.subheadline)
                    
                    Rectangle()
                        .fill(.blue)
                        .frame(width: 200, height: 200)
                        .cornerRadius(10)
                        .offset(offset)
                        .scaleEffect(scale)
                        .rotationEffect(.degrees(rotation))
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    offset = value.translation
                                }
                        )
                        .simultaneousGesture(
                            MagnificationGesture()
                                .onChanged { value in
                                    scale = value
                                }
                        )
                        .simultaneousGesture(
                            RotationGesture()
                                .onChanged { value in
                                    rotation = value.degrees
                                }
                        )
                }
                .padding()
                .background(.red.opacity(0.1))
                .cornerRadius(10)
                
                //  点击手势计数
                VStack {
                    Text("7. 点击手势计数")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text("点击次数: \(tapCount)")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Rectangle()
                        .fill(.green)
                        .frame(width: 200, height: 100)
                        .cornerRadius(10)
                        .overlay(
                            Text("点击我")
                                .foregroundColor(.white)
                                .font(.headline)
                        )
                        .onTapGesture(count: 2) {
                            tapCount += 1
                        }
                }
                .padding()
                .background(.orange.opacity(0.1))
                .cornerRadius(10)
                
                //  拖动手势状态
                VStack {
                    Text("8. 拖动手势状态")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text(isDragging ? "拖动中" : "静止")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(isDragging ? .blue : .gray)
                    
                    Rectangle()
                        .fill(.purple)
                        .frame(width: 100, height: 100)
                        .cornerRadius(10)
                        .offset(dragOffset)
                        .gesture(
                            DragGesture()
                                .onChanged { _ in
                                    isDragging = true
                                }
                                .onEnded { _ in
                                    isDragging = false
                                }
                        )
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
    GestureAndInteractionDemo()
}