//
//  CoreDataIntegration.swift
//  swiftUIDemo
//
//  Core Data集成示例
//

import SwiftUI
import CoreData

//  项目模型（Core Data实体）
//  注意：这个模型通常在Core Data模型编辑器中定义
//  这里为了演示目的，我们使用代码定义
class CoreDataItem: NSManagedObject {
    @NSManaged var timestamp: Date?
}

//  扩展CoreDataItem以符合Identifiable
extension CoreDataItem: Identifiable {
}

//  Core Data集成示例
struct CoreDataIntegrationDemo: View {
    //  环境变量 - 用于获取Core Data上下文
    @Environment(\.managedObjectContext) private var viewContext
    
    //  从Core Data获取数据
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \CoreDataItem.timestamp, ascending: true)],
        animation: .default
    ) private var items: FetchedResults<CoreDataItem>
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                //  标题
                Text("Core Data集成")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                
                //  项目列表
                List {
                    ForEach(items) {
                        item in
                        NavigationLink {
                            Text("Item at \(item.timestamp!, formatter: itemFormatter)")
                        } label: {
                            Text(item.timestamp!, formatter: itemFormatter)
                        }
                    }
                    .onDelete(perform: deleteItems)
                }
                
                //  统计信息
                Text("项目数量: \(items.count)")
                    .font(.headline)
                    .padding()
                
                //  添加按钮
                Button("添加项目") {
                    addItem()
                }
                .padding()
                .background(.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .padding()
            .navigationTitle("Core Data示例")
        }
    }
    
    //  添加项目
    private func addItem() {
        withAnimation {
            let newItem = CoreDataItem(context: viewContext)
            newItem.timestamp = Date()
            
            do {
                try viewContext.save()
            } catch {
                //  处理错误
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    //  删除项目
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                //  处理错误
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

//  日期格式化
private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

//  预览
struct CoreDataIntegrationDemo_Previews: PreviewProvider {
    static var previews: some View {
        let persistenceController = PersistenceController.preview
        CoreDataIntegrationDemo()
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
    }
}

//  持久化控制器
struct PersistenceController {
    static let shared = PersistenceController()
    
    static var preview: PersistenceController {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        //  添加一些示例数据
        for _ in 0..<5 {
            let newItem = CoreDataItem(context: viewContext)
            newItem.timestamp = Date()
        }
        do {
            try viewContext.save()
        } catch {
            fatalError("Unresolved error \(error)")
        }
        return result
    }
    
    let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "swiftUIDemo")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
}