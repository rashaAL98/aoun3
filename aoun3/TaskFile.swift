import Foundation

struct TaskFile: Identifiable, Codable {
    let id: UUID
    var title: String
    var tasks: [String]
    
    init(id: UUID = UUID(), title: String, tasks: [String]) {
        self.id = id
        self.title = title
        self.tasks = tasks
    }
}
