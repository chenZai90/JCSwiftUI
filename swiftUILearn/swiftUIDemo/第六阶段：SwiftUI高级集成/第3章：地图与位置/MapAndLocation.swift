//
//  MapAndLocation.swift
//  swiftUIDemo
//
//  地图与位置示例
//

import SwiftUI
import MapKit

//  地图与位置示例
struct MapAndLocationDemo: View {
    //  状态管理
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 39.9042, longitude: 116.4074), //  北京
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    //  标记位置
    @State private var locations = [
        MapLocation(name: "北京", coordinate: CLLocationCoordinate2D(latitude: 39.9042, longitude: 116.4074)),
        MapLocation(name: "上海", coordinate: CLLocationCoordinate2D(latitude: 31.2304, longitude: 121.4737)),
        MapLocation(name: "广州", coordinate: CLLocationCoordinate2D(latitude: 23.1291, longitude: 113.2644))
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                //  标题
                Text("地图与位置")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                
                //  地图视图
                VStack {
                    Text("1. 地图视图")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    //  地图
                    Map(
                        coordinateRegion: $region,
                        annotationItems: locations
                    ) { location in
                        MapPin(
                            coordinate: location.coordinate,
                            tint: .red
                        )
                    }
                    .frame(height: 300)
                    .cornerRadius(10)
                }
                .padding()
                .background(.gray.opacity(0.1))
                .cornerRadius(10)
                
                //  地图控制
                VStack {
                    Text("2. 地图控制")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    HStack(spacing: 10) {
                        Button("北京") {
                            region = MKCoordinateRegion(
                                center: CLLocationCoordinate2D(latitude: 39.9042, longitude: 116.4074),
                                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                            )
                        }
                        .padding()
                        .background(.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        
                        Button("上海") {
                            region = MKCoordinateRegion(
                                center: CLLocationCoordinate2D(latitude: 31.2304, longitude: 121.4737),
                                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                            )
                        }
                        .padding()
                        .background(.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        
                        Button("广州") {
                            region = MKCoordinateRegion(
                                center: CLLocationCoordinate2D(latitude: 23.1291, longitude: 113.2644),
                                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                            )
                        }
                        .padding()
                        .background(.purple)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                }
                .padding()
                .background(.blue.opacity(0.1))
                .cornerRadius(10)
                
                //  位置信息
                VStack {
                    Text("3. 位置信息")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    ForEach(locations) {
                        location in
                        VStack(alignment: .leading) {
                            Text(location.name)
                                .font(.headline)
                            Text("纬度: \(location.coordinate.latitude, specifier: "%.4f")")
                            Text("经度: \(location.coordinate.longitude, specifier: "%.4f")")
                        }
                        .padding()
                        .background(.white)
                        .cornerRadius(10)
                        .shadow(radius: 2)
                        .padding(.vertical, 5)
                    }
                }
                .padding()
                .background(.green.opacity(0.1))
                .cornerRadius(10)
            }
            .padding()
        }
    }
}

//  地图位置模型
struct MapLocation: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}

#Preview {
    MapAndLocationDemo()
}