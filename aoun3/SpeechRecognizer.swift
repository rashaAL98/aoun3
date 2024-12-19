import Speech
import AVFoundation

class SpeechRecognizer {
    private let audioEngine = AVAudioEngine()
    private var request: SFSpeechAudioBufferRecognitionRequest?
    private var task: SFSpeechRecognitionTask?
    private let recognizer = SFSpeechRecognizer(locale: Locale(identifier: "ar-SA"))
    private var recognizedText: String = ""

    func startRecording() {
        if audioEngine.isRunning {
            stopRecording { _ in }
        }

        let node = audioEngine.inputNode
        request = SFSpeechAudioBufferRecognitionRequest()

        guard let recognizer = recognizer, recognizer.isAvailable else {
            print("Speech recognizer is not available.")
            return
        }

        task = recognizer.recognitionTask(with: request!) { result, error in
            if let result = result {
                self.recognizedText = result.bestTranscription.formattedString
                print("Transcribed Text: \(self.recognizedText)")
            }
            if error != nil {
                print("Error during recognition: \(error?.localizedDescription ?? "Unknown error")")
                self.stopRecording { _ in }
            }
        }

        let recordingFormat = node.outputFormat(forBus: 0)
        node.removeTap(onBus: 0)
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            self.request?.append(buffer)
        }

        audioEngine.prepare()
        do {
            try audioEngine.start()
            print("Recording started...")
        } catch {
            print("Error starting the audio engine: \(error.localizedDescription)")
        }
    }

    func stopRecording(completion: @escaping (String) -> Void) {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        request?.endAudio()
        task?.cancel()

        if !recognizedText.isEmpty {
            completion(recognizedText)
        } else {
            completion("لم يتم التعرف على النص.")
        }

        request = nil
        task = nil
    }
}
