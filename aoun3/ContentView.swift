import SwiftUI

struct ContentView: View {
    @State private var taskFiles: [TaskFile] = [] // مصفوفة لتخزين المهام

    var body: some View {
        TabView {
            // الصفحة الرئيسية: المهام
            NavigationView {
                ZStack {
                    Color(.systemGray6)
                        .edgesIgnoringSafeArea(.all)

                    if taskFiles.isEmpty {
                        VStack {
                            Spacer()
                            Text("لا يوجد أي مهام جديدة")
                                .foregroundColor(.gray)
                                .font(.title3)
                                .padding()

                            Image(systemName: "list.bullet.rectangle.portrait")
                                .font(.system(size: 80))
                                .foregroundColor(.purple.opacity(0.6))
                            Spacer()
                        }
                    } else {
                        List {
                            ForEach(taskFiles) { taskFile in
                                NavigationLink(destination: TaskDetailView(taskFile: taskFile)) {
                                    Text(taskFile.title)
                                        .font(.headline)
                                }
                            }
                        }
                    }
                }
                .navigationTitle("المهام")
                .navigationBarTitleDisplayMode(.large)
                .navigationBarItems(trailing:
                    NavigationLink(destination: AddTaskView(onSave: { newTask in
                        taskFiles.append(newTask) // إضافة مهمة جديدة
                        saveTasks() // حفظ المهام بعد الإضافة
                    })) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 30))
                            .foregroundColor(.purple)
                    }
                )
                .onAppear(perform: loadTasks) // تحميل المهام عند ظهور الصفحة
            }
            .tabItem {
                Image(systemName: "list.bullet")
                Text("المهام")
            }

            // الصفحة الثانية: التذكيرات
            NavigationView {
                ZStack {
                    Color(.systemGray6)
                        .edgesIgnoringSafeArea(.all)

                    VStack {
                        Spacer()
                        Text("لا يوجد أي تذكيرات جديدة")
                            .foregroundColor(.gray)
                            .font(.title3)

                        Image(systemName: "alarm")
                            .font(.system(size: 80))
                            .foregroundColor(.purple.opacity(0.6))
                        Spacer()
                    }
                }
                .navigationTitle("التذكيرات")
                .navigationBarTitleDisplayMode(.large)
            }
            .tabItem {
                Image(systemName: "alarm")
                Text("التذكيرات")
            }
        }
        .accentColor(.purple)
    }

    // دالة لحفظ المهام باستخدام UserDefaults
    private func saveTasks() {
        if let encoded = try? JSONEncoder().encode(taskFiles) {
            UserDefaults.standard.set(encoded, forKey: "SavedTasks")
        }
    }

    // دالة لتحميل المهام من UserDefaults
    private func loadTasks() {
        if let savedData = UserDefaults.standard.data(forKey: "SavedTasks"),
           let decoded = try? JSONDecoder().decode([TaskFile].self, from: savedData) {
            taskFiles = decoded
        }
    }
}

struct TaskDetailView: View {
    let taskFile: TaskFile

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(taskFile.title)
                .font(.largeTitle)
                .bold()
                .padding()

            ForEach(taskFile.tasks, id: \ .self) { task in
                Text("• \(task)")
                    .font(.title3)
                    .padding(.horizontal)
            }

            Spacer()
        }
        .navigationTitle("تفاصيل المهمة")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.white))
    }
}

#Preview {
    ContentView()
}
