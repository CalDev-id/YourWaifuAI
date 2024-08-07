////
////  ChatService.swift
////  YourWaifuAI
////
////  Created by Heical Chandra on 06/08/24.
////
//
//import Foundation
//import Combine
//
//class ChatService: ObservableObject {
//    @Published var messages: [ChatMessage] = []
//    
//    func sendMessage(userInput: String) {
//        let userMessage = ChatMessage(sender: "user", content: userInput)
//        messages.append(userMessage)
//        
//        let userPrompt = UserPrompt(user_id: "user123", user_prompt: userInput)
//        
//        guard let url = URL(string: "https://major-gisella-caldev-4864ed86.koyeb.app/chat") else { return }
//        
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        
//        do {
//            request.httpBody = try JSONEncoder().encode(userPrompt)
//        } catch {
//            print("Failed to encode user prompt: \(error)")
//            return
//        }
//        
//        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
//            if let error = error {
//                print("Error making request: \(error)")
//                return
//            }
//            
//            guard let data = data else {
//                print("No data received")
//                return
//            }
//            
//            do {
//                let chatResponse = try JSONDecoder().decode(ChatResponse.self, from: data)
//                let modelMessage = ChatMessage(sender: "model", content: chatResponse.response)
//                
//                DispatchQueue.main.async {
//                    self?.messages.append(modelMessage)
//                }
//            } catch {
//                print("Failed to decode response: \(error)")
//            }
//        }.resume()
//    }
//}
