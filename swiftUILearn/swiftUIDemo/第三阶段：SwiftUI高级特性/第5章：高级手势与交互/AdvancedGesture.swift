//
//  AdvancedGesture.swift
//  swiftUIDemo
//
//  高级手势与交互示例
//

import SwiftUI

//  高级手势与交互示例
struct AdvancedGestureDemo: View {
    //  状态管理
    @State private var offset = CGSize.zero
    @State private var scale = 1.0
    @State private var rotation = 0.0
    @State private var isDragging = false
    @State private var dragOffset = CGSize.zero
    @State private var longPressActive = false
    @State private var tapCount = 0
    @State private var isPinching = false
    @State private var pinchScale = 1.0
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                //  标题
                Text("高级手势与交互")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                
                //  拖动手势
                VStack {
                    Text("1. 拖动手势")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Rectangle()
                        .fill(.blue)
                        .frame(width: 100, height: 100)
                        .offset(offset)
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    offset = value.translation
                                }
                                .onEnded { value in
                                    withAnimation {
                                        offset = .zero
                                    }
                                }
                        )
                }
                .padding()
                .background(.gray.opacity(0.1))
                .cornerRadius(10)
                
                //  缩放手势
                VStack {
                    Text("2. 缩放手势")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Circle()
                        .fill(.red)
                        .frame(width: 100, height: 100)
                        .scaleEffect(scale)
                        .gesture(
                            MagnificationGesture()
                                .onChanged { value in
                                    scale = value
                                }
                                .onEnded { value in
                                    withAnimation {
                                        scale = 1.0
                                    }
                                }
                        )
                }
                .padding()
                .background(.blue.opacity(0.1))
                .cornerRadius(10)
                
                //  旋转手势
                VStack {
                    Text("3. 旋转手势")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Rectangle()
                        .fill(.green)
                        .frame(width: 100, height: 100)
                        .rotationEffect(.degrees(rotation))
                        .gesture(
                            RotationGesture()
                                .onChanged { angle in
                                    rotation = angle.degrees
                                }
                                .onEnded { angle in
                                    withAnimation {
                                        rotation = 0
                                    }
                                }
                        )
                }
                .padding()
                .background(.green.opacity(0.1))
                .cornerRadius(10)
                
                //  长按手势
                VStack {
                    Text("4. 长按手势")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Rectangle()
                        .fill(longPressActive ? .purple : .orange)
                        .frame(width: 100, height: 100)
                        .gesture(
                            LongPressGesture(minimumDuration: 1.0)
                                .onChanged { _ in
                                    longPressActive = true
                                }
                                .onEnded { _ in
                                    withAnimation {
                                        longPressActive = false
                                    }
                                }
                        )
                }
                .padding()
                .background(.yellow.opacity(0.1))
                .cornerRadius(10)
                
                //  点击手势
                VStack {
                    Text("5. 点击手势")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text("点击次数: \(tapCount)")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Button("点击我") {
                        tapCount += 1
                    }
                    .padding()
                    .background(.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding()
                .background(.purple.opacity(0.1))
                .cornerRadius(10)
                
                //  组合手势
                VStack {
                    Text("6. 组合手势")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Rectangle()
                        .fill(.red)
                        .frame(width: 100, height: 100)
                        .offset(dragOffset)
                        .scaleEffect(pinchScale)
                        .gesture(
                            SimultaneousGesture(
                                DragGesture()
                                    .onChanged { value in
                                        dragOffset = value.translation
                                    }
                                    .onEnded { _ in
                                        withAnimation {
                                            dragOffset = .zero
                                        }
                                    },
                                MagnificationGesture()
                                    .onChanged { value in
                                        pinchScale = value
                                    }
                                    .onEnded { _ in
                                        withAnimation {
                                            pinchScale = 1.0
                                        }
                                    }
                            )
                        )
                }
                .padding()
                .background(.red.opacity(0.1))
                .cornerRadius(10)
                
                //  连续点击手势
                VStack {
                    Text("7. 连续点击手势")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text("双击或三击我")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding()
                        .background(.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .gesture(
                            TapGesture(count: 2)
                                .onEnded { _ in
                                    print("双击")
                                }
                        )
                }
                .padding()
                .background(.orange.opacity(0.1))
                .cornerRadius(10)
                
                //  高级拖动手势
                VStack {
                    Text("8. 高级拖动手势")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    ZStack {
                        Color.gray.opacity(0.1)
                            .frame(height: 200)
                            .cornerRadius(10)
                        
                        Circle()
                            .fill(.blue)
                            .frame(width: 50, height: 50)
                            .position(x: 100 + dragOffset.width, y: 100 + dragOffset.height)
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        dragOffset = value.translation
                                    }
                                    .onEnded { _ in
                                        withAnimation {
                                            dragOffset = .zero
                                        }
                                    }
                            )
                    }
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
    AdvancedGestureDemo()
}
