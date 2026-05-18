//
//  AnimationAndTransition.swift
//  swiftUIDemo
//
//  动画与过渡示例
//

import SwiftUI

//  动画与过渡示例
struct AnimationAndTransitionDemo: View {
    //  状态管理
    @State private var isVisible = false
    @State private var scale = 1.0
    @State private var rotation = 0.0
    @State private var opacity = 1.0
    @State private var offset = CGSize.zero
    @State private var color = Color.blue
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                //  标题
                Text("动画与过渡")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                
                //  淡入淡出动画
                VStack {
                    Text("1. 淡入淡出动画")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Button("显示/隐藏") {
                        withAnimation {
                            isVisible.toggle()
                        }
                    }
                    .padding()
                    .background(.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    
                    if isVisible {
                        Text("Hello, Animation!")
                            .font(.title)
                            .fontWeight(.bold)
                            .transition(.opacity)
                    }
                }
                .padding()
                .background(.gray.opacity(0.1))
                .cornerRadius(10)
                
                //  缩放动画
                VStack {
                    Text("2. 缩放动画")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Button("缩放") {
                        withAnimation(.spring()) {
                            scale = scale == 1.0 ? 1.5 : 1.0
                        }
                    }
                    .padding()
                    .background(.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    
                    Circle()
                        .fill(.red)
                        .frame(width: 100, height: 100)
                        .scaleEffect(scale)
                }
                .padding()
                .background(.blue.opacity(0.1))
                .cornerRadius(10)
                
                //  旋转动画
                VStack {
                    Text("3. 旋转动画")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Button("旋转") {
                        withAnimation(.easeInOut(duration: 1.0)) {
                            rotation += 360
                        }
                    }
                    .padding()
                    .background(.purple)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    
                    Rectangle()
                        .fill(.yellow)
                        .frame(width: 100, height: 100)
                        .rotationEffect(.degrees(rotation))
                }
                .padding()
                .background(.green.opacity(0.1))
                .cornerRadius(10)
                
                //  位移动画
                VStack {
                    Text("4. 位移动画")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Button("移动") {
                        withAnimation(.interactiveSpring()) {
                            offset = offset == .zero ? CGSize(width: 100, height: 50) : .zero
                        }
                    }
                    .padding()
                    .background(.orange)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    
                    Rectangle()
                        .fill(.blue)
                        .frame(width: 100, height: 100)
                        .offset(offset)
                }
                .padding()
                .background(.yellow.opacity(0.1))
                .cornerRadius(10)
                
                //  颜色动画
                VStack {
                    Text("5. 颜色动画")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Button("变色") {
                        withAnimation(.easeInOut(duration: 1.0)) {
                            color = color == .blue ? .red : .blue
                        }
                    }
                    .padding()
                    .background(.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    
                    Rectangle()
                        .fill(color)
                        .frame(width: 200, height: 100)
                        .cornerRadius(10)
                }
                .padding()
                .background(.purple.opacity(0.1))
                .cornerRadius(10)
                
                //  组合动画
                VStack {
                    Text("6. 组合动画")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Button("组合动画") {
                        withAnimation(.easeInOut(duration: 1.0)) {
                            scale = scale == 1.0 ? 1.2 : 1.0
                            rotation = rotation == 0 ? 45 : 0
                            opacity = opacity == 1.0 ? 0.5 : 1.0
                        }
                    }
                    .padding()
                    .background(.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    
                    Rectangle()
                        .fill(.green)
                        .frame(width: 100, height: 100)
                        .scaleEffect(scale)
                        .rotationEffect(.degrees(rotation))
                        .opacity(opacity)
                }
                .padding()
                .background(.red.opacity(0.1))
                .cornerRadius(10)
                
                //  过渡效果
                VStack {
                    Text("7. 过渡效果")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Button("切换视图") {
                        withAnimation {
                            isVisible.toggle()
                        }
                    }
                    .padding()
                    .background(.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    
                    if isVisible {
                        Text("滑入视图")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding()
                            .background(.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .transition(.slide)
                    }
                }
                .padding()
                .background(.orange.opacity(0.1))
                .cornerRadius(10)
                
                //  动画曲线
                VStack {
                    Text("8. 动画曲线")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    HStack(spacing: 10) {
                        Button("线性") {
                            withAnimation(.linear(duration: 1.0)) {
                                offset = CGSize(width: 150, height: 0)
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    withAnimation {
                                        offset = .zero
                                    }
                                }
                            }
                        }
                        .padding()
                        .background(.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        
                        Button("弹簧") {
                            withAnimation(.spring()) {
                                offset = CGSize(width: 150, height: 0)
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    withAnimation {
                                        offset = .zero
                                    }
                                }
                            }
                        }
                        .padding()
                        .background(.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    
                    Rectangle()
                        .fill(.purple)
                        .frame(width: 50, height: 50)
                        .offset(offset)
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
    AnimationAndTransitionDemo()
}