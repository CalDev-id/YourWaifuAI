//
//  ChatService2.swift
//  YourWaifuAI
//
//  Created by Heical Chandra on 06/08/24.
//

//import Foundation
//import Combine
//
//class ChatViewModel: ObservableObject {
//    @Published var chatHistory: [ChatMessage] = []
//    @Published var currentMessage: String = ""
//    @Published var errorMessage: String?
//
//    private var cancellables = Set<AnyCancellable>()
//    
//    init() {
//        loadChatHistory()
//    }
//    
//    func loadChatHistory() {
//        // Load chat history from UserDefaults (or another storage solution)
//        let defaults = UserDefaults.standard
//        if let data = defaults.data(forKey: "chat_history"),
//           let messages = try? JSONDecoder().decode([ChatMessage].self, from: data) {
//            self.chatHistory = messages
//        }
//    }
//    
//    func saveChatHistory() {
//        let defaults = UserDefaults.standard
//        if let data = try? JSONEncoder().encode(self.chatHistory) {
//            defaults.set(data, forKey: "chat_history")
//        }
//    }
//    
//    func sendMessageToModel(userID: String, userPrompt: String) {
//        let url = URL(string: "https://major-gisella-caldev-4864ed86.koyeb.app/chat-waifu")!
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        
//        // Prepare payload
//        let previousChat = self.chatHistory
//        let payload: [String: Any] = [
//            "user_id": userID,
//            "user_prompt": userPrompt,
//            "previous_chat": previousChat.map { ["role": $0.role, "content": $0.content] }
//        ]
//        
//        do {
//            request.httpBody = try JSONSerialization.data(withJSONObject: payload, options: [])
//        } catch {
//            DispatchQueue.main.async {
//                self.errorMessage = "Error encoding payload: \(error)"
//            }
//            return
//        }
//        
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                DispatchQueue.main.async {
//                    self.errorMessage = "Error sending request: \(error)"
//                }
//                return
//            }
//            
//            guard let data = data else {
//                DispatchQueue.main.async {
//                    self.errorMessage = "No data received"
//                }
//                return
//            }
//            
//            do {
//                let responseObject = try JSONDecoder().decode([String: String].self, from: data)
//                if let responseMessage = responseObject["response"] {
//                    DispatchQueue.main.async {
//                        self.chatHistory.append(ChatMessage(role: "user", content: userPrompt))
//                        self.chatHistory.append(ChatMessage(role: "system", content: responseMessage))
//                        self.saveChatHistory()
//                        self.currentMessage = ""
//                        self.errorMessage = nil
//                    }
//                } else {
//                    DispatchQueue.main.async {
//                        self.errorMessage = "Invalid response format"
//                    }
//                }
//            } catch {
//                DispatchQueue.main.async {
//                    self.errorMessage = "Error decoding response: \(error)"
//                }
//            }
//        }.resume()
//    }
//    
//    func sendMessage() {
//        let userID = "user_1" // Replace with actual user ID
//        sendMessageToModel(userID: userID, userPrompt: self.currentMessage)
//    }
//}


import Foundation
import Combine

class ChatViewModel: ObservableObject {
    @Published var chatHistory: [ChatMessage] = []
    @Published var currentMessage: String = ""
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false

    private var cancellables = Set<AnyCancellable>()
    
    init() {
        loadChatHistory()
    }
    
    func loadChatHistory() {
        // Load chat history from UserDefaults (or another storage solution)
        let defaults = UserDefaults.standard
        if let data = defaults.data(forKey: "chat_history"),
           let messages = try? JSONDecoder().decode([ChatMessage].self, from: data) {
            self.chatHistory = messages
        }
    }
    
    func saveChatHistory() {
        let defaults = UserDefaults.standard
        if let data = try? JSONEncoder().encode(self.chatHistory) {
            defaults.set(data, forKey: "chat_history")
        }
    }
    
    func addUserMessage(_ message: String) {
        self.chatHistory.append(ChatMessage(role: "user", content: message))
        self.saveChatHistory()
    }
    
    func sendMessageToModel(userID: String, userPrompt: String) {
        let url = URL(string: "https://parallel-arabelle-waifu-ical-cd5f2cfe.koyeb.app/chat-waifu")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Prepare payload
        let previousChat = self.chatHistory
        let payload: [String: Any] = [
            "user_id": userID,
            "user_prompt": userPrompt,
            "previous_chat": previousChat.map { ["role": $0.role, "content": $0.content] }
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: payload, options: [])
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "Error encoding payload: \(error)"
            }
            return
        }
        
        self.isLoading = true
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
            }
            
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = "Error sending request: \(error)"
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    self.errorMessage = "No data received"
                }
                return
            }
            
            do {
                let responseObject = try JSONDecoder().decode([String: String].self, from: data)
                if let responseMessage = responseObject["response"] {
                    DispatchQueue.main.async {
                        self.chatHistory.append(ChatMessage(role: "system", content: responseMessage))
                        self.saveChatHistory()
                        self.currentMessage = ""
                        self.errorMessage = nil
                    }
                } else {
                    DispatchQueue.main.async {
                        self.errorMessage = "Invalid response format"
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Error decoding response: \(error)"
                }
            }
        }.resume()
    }
    
    func sendMessage() {
        let userID = "user_1" // Replace with actual user ID
        sendMessageToModel(userID: userID, userPrompt: self.currentMessage)
    }
}
