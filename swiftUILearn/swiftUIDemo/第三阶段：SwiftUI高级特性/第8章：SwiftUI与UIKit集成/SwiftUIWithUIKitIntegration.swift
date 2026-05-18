//
//  SwiftUIWithUIKitIntegration.swift
//  swiftUIDemo
//
//  SwiftUI与UIKit集成示例
//

import SwiftUI
import UIKit

//  SwiftUI与UIKit集成示例
struct SwiftUIWithUIKitIntegrationDemo: View {
    //  状态管理
    @State private var sliderValue = 50.0
    @State private var textFieldText = ""
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                //  标题
                Text("SwiftUI与UIKit集成")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                
                //  UIKit滑块集成
                VStack {
                    Text("1. UIKit滑块集成")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text("当前值: \(Int(sliderValue))")
                        .font(.subheadline)
                    
                    UIKitSlider(value: $sliderValue, range: 0...100)
                        .frame(height: 50)
                }
                .padding()
                .background(.gray.opacity(0.1))
                .cornerRadius(10)
                
                //  UIKit文本字段集成
                VStack {
                    Text("2. UIKit文本字段集成")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text("输入内容: \(textFieldText)")
                        .font(.subheadline)
                    
                    UIKitTextField(text: $textFieldText, placeholder: "请输入文本")
                        .frame(height: 50)
                        .padding(.horizontal, 20)
                }
                .padding()
                .background(.blue.opacity(0.1))
                .cornerRadius(10)
                
                //  UIKit按钮集成
                VStack {
                    Text("3. UIKit按钮集成")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    UIKitButton(title: "点击我") {
                        print("UIKit按钮被点击")
                    }
                    .frame(height: 50)
                    .padding(.horizontal, 40)
                }
                .padding()
                .background(.green.opacity(0.1))
                .cornerRadius(10)
                
                //  UIKit标签集成
                VStack {
                    Text("4. UIKit标签集成")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    UIKitLabel(text: "这是一个UIKit标签")
                        .frame(height: 50)
                }
                .padding()
                .background(.yellow.opacity(0.1))
                .cornerRadius(10)
                
                //  UIKit进度条集成
                VStack {
                    Text("5. UIKit进度条集成")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    UIKitProgressView(progress: sliderValue / 100)
                        .frame(height: 20)
                }
                .padding()
                .background(.purple.opacity(0.1))
                .cornerRadius(10)
                
                //  UIKit开关集成
                VStack {
                    Text("6. UIKit开关集成")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    UIKitSwitch(isOn: .constant(true))
                }
                .padding()
                .background(.red.opacity(0.1))
                .cornerRadius(10)
            }
            .padding()
        }
    }
}

//  UIKit滑块包装器
struct UIKitSlider: UIViewRepresentable {
    @Binding var value: Double
    var range: ClosedRange<Double>
    
    func makeUIView(context: Context) -> UISlider {
        let slider = UISlider()
        slider.minimumValue = Float(range.lowerBound)
        slider.maximumValue = Float(range.upperBound)
        slider.value = Float(value)
        slider.addTarget(context.coordinator, action: #selector(Coordinator.valueChanged), for: .valueChanged)
        return slider
    }
    
    func updateUIView(_ uiView: UISlider, context: Context) {
        uiView.value = Float(value)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject {
        let parent: UIKitSlider
        
        init(_ parent: UIKitSlider) {
            self.parent = parent
        }
        
        @objc func valueChanged(_ sender: UISlider) {
            parent.value = Double(sender.value)
        }
    }
}

//  UIKit文本字段包装器
struct UIKitTextField: UIViewRepresentable {
    @Binding var text: String
    var placeholder: String
    
    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.borderStyle = .roundedRect
        textField.delegate = context.coordinator
        return textField
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        let parent: UIKitTextField
        
        init(_ parent: UIKitTextField) {
            self.parent = parent
        }
        
        func textFieldDidChangeSelection(_ textField: UITextField) {
            parent.text = textField.text ?? ""
        }
    }
}

//  UIKit按钮包装器
struct UIKitButton: UIViewRepresentable {
    var title: String
    var action: () -> Void
    
    func makeUIView(context: Context) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.backgroundColor = .blue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.addTarget(context.coordinator, action: #selector(Coordinator.buttonTapped), for: .touchUpInside)
        return button
    }
    
    func updateUIView(_ uiView: UIButton, context: Context) {
        uiView.setTitle(title, for: .normal)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject {
        let parent: UIKitButton
        
        init(_ parent: UIKitButton) {
            self.parent = parent
        }
        
        @objc func buttonTapped() {
            parent.action()
        }
    }
}

//  UIKit标签包装器
struct UIKitLabel: UIViewRepresentable {
    var text: String
    
    func makeUIView(context: Context) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textAlignment = .center
        label.textColor = .blue
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }
    
    func updateUIView(_ uiView: UILabel, context: Context) {
        uiView.text = text
    }
}

//  UIKit进度条包装器
struct UIKitProgressView: UIViewRepresentable {
    var progress: Double
    
    func makeUIView(context: Context) -> UIProgressView {
        let progressView = UIProgressView()
        progressView.progress = Float(progress)
        return progressView
    }
    
    func updateUIView(_ uiView: UIProgressView, context: Context) {
        uiView.progress = Float(progress)
    }
}

//  UIKit开关包装器
struct UIKitSwitch: UIViewRepresentable {
    @Binding var isOn: Bool
    
    func makeUIView(context: Context) -> UISwitch {
        let uiSwitch = UISwitch()
        uiSwitch.isOn = isOn
        uiSwitch.addTarget(context.coordinator, action: #selector(Coordinator.switchChanged), for: .valueChanged)
        return uiSwitch
    }
    
    func updateUIView(_ uiView: UISwitch, context: Context) {
        uiView.isOn = isOn
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject {
        let parent: UIKitSwitch
        
        init(_ parent: UIKitSwitch) {
            self.parent = parent
        }
        
        @objc func switchChanged(_ sender: UISwitch) {
            parent.isOn = sender.isOn
        }
    }
}

#Preview {
    SwiftUIWithUIKitIntegrationDemo()
}
