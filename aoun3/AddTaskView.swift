import SwiftUI
import Speech
import AVFoundation

struct AddTaskView: View {
    @State private var taskTitle: String = "" // حقل لعنوان المهمة
    @State private var selectedIcon: String = "list.bullet" // الأيقونة الافتراضية
    @State private var showMenu = false // حالة القائمة المنبثقة
    @State private var isRecording = false // حالة الميكروفون
    @State private var tasks: [String] = [] // قائمة القوائم النصية
    
    @Environment(\.dismiss) var dismiss // لإغلاق الصفحة
    
    private let speechRecognizer = SpeechRecognizer()
    var onSave: (TaskFile) -> Void // تمرير المهمة المحفوظة إلى الصفحة الرئيسية
    
    let icons = ["cart", "airplane", "sun.max", "moon", "pencil", "figure.walk", "pill"]

    var body: some View {
        NavigationView {
            ZStack {
                VStack(alignment: .leading, spacing: 16) {
                    // حقل النص مع زر اختيار الأيقونات
                    HStack {
                        Spacer()
                        TextField("عنوان المهمة", text: $taskTitle)
                            .font(.title2)
                            .multilineTextAlignment(.trailing)
                            .padding(.vertical, 8)
                            .overlay(Rectangle()
                                        .frame(height: 1)
                                        .foregroundColor(Color.gray.opacity(0.5)), alignment: .bottom)
                        
                        Button(action: {
                            withAnimation {
                                showMenu.toggle()
                            }
                        }) {
                            Image(systemName: selectedIcon)
                                .font(.title2)
                                .foregroundColor(.purple)
                                .padding(10)
                                .background(Color.purple.opacity(0.2))
                                .clipShape(Circle())
                        }
                        .padding(.leading, 8)
                    }
                    .padding(.horizontal)
                    .padding(.top, 20)

                    // زر الميكروفون تحت زر list.bullet
                    HStack {
                        Spacer()
                        Button(action: toggleRecording) {
                            Image(systemName: isRecording ? "stop.circle.fill" : "mic.fill.badge.plus")
                                .font(.largeTitle)
                                .foregroundColor(.purple)
                                .padding(20)
                                .background(Color.purple.opacity(0.2))
                                .clipShape(Circle())
                                .shadow(radius: 5)
                        }
                    }
                    .padding(.trailing, 16)
                    
                    // عرض القوائم النصية المحفوظة
                    VStack(alignment: .leading) {
                        ForEach(tasks, id: \.self) { task in
                            Text("• \(task)")
                                .font(.title3)
                                .foregroundColor(.black)
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                }
                
                // القائمة المنبثقة لاختيار الأيقونة
                if showMenu {
                    VStack {
                        // العنوان مع علامة X
                        HStack {
                            Button(action: {
                                withAnimation {
                                    showMenu = false
                                }
                            }) {
                                Image(systemName: "xmark")
                                    .font(.title2)
                                    .foregroundColor(.red)
                            }
                            Spacer()
                            Text("اختر أيقونة")
                                .font(.headline)
                                .foregroundColor(.purple)
                            Spacer()
                        }
                        .padding(.horizontal)
                        .padding(.top, 10)
                        
                        Divider()

                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 60))], spacing: 20) {
                            ForEach(icons, id: \.self) { icon in
                                Button(action: {
                                    selectedIcon = icon
                                    withAnimation {
                                        showMenu = false
                                    }
                                }) {
                                    Image(systemName: icon)
                                        .font(.title2)
                                        .foregroundColor(.purple)
                                        .padding()
                                        .background(Color.purple.opacity(0.1))
                                        .clipShape(Circle())
                                }
                            }
                        }
                        Divider()
                    }
                    .frame(width: 300)
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(radius: 10)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                trailing: Button("تم") {
                    saveTask()
                    dismiss()
                }
                .foregroundColor(.purple)
                .font(.headline)
            )
            .background(Color(UIColor.systemGray6))
        }
    }
    
    // حفظ المهمة
    private func saveTask() {
        let newTaskFile = TaskFile(title: taskTitle.isEmpty ? "مهمة جديدة" : taskTitle, tasks: tasks)
        onSave(newTaskFile)
    }

    // تشغيل/إيقاف التسجيل الصوتي
    private func toggleRecording() {
        if isRecording {
            speechRecognizer.stopRecording { result in
                if !result.isEmpty {
                    tasks.append(result)
                }
            }
        } else {
            speechRecognizer.startRecording()
        }
        isRecording.toggle()
    }
}

#Preview {
    AddTaskView { _ in }
}
