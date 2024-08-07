////
////  ContentView.swift
////  YourWaifuAI
////
////  Created by Heical Chandra on 05/08/24.
////
//
//import SwiftUI
//
//struct ContentView: View {
//    @StateObject private var chatService = ChatService()
//    @State private var userInput: String = ""
//    
//    var body: some View {
//        VStack {
//            ScrollView {
//                VStack(alignment: .leading) {
//                    ForEach(chatService.messages) { message in
//                        HStack {
//                            if message.sender == "user" {
//                                Spacer()
//                                Text(message.content)
//                                    .padding()
//                                    .background(Color.blue)
//                                    .cornerRadius(10)
//                                    .foregroundColor(.white)
//                                    .padding(.horizontal, 10)
//                            } else {
//                                Text(message.content)
//                                    .padding()
//                                    .background(Color.gray.opacity(0.2))
//                                    .cornerRadius(10)
//                                    .padding(.horizontal, 10)
//                                Spacer()
//                            }
//                        }
//                    }
//                }
//            }
//            .padding(.top)
//            
//            HStack {
//                TextField("Type your message...", text: $userInput)
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//                    .padding(.leading, 10)
//                
//                Button(action: {
//                    chatService.sendMessage(userInput: userInput)
//                    userInput = ""
//                }) {
//                    Text("Send")
//                        .padding(.vertical, 10)
//                        .padding(.horizontal, 20)
//                        .background(Color.blue)
//                        .cornerRadius(10)
//                        .foregroundColor(.white)
//                        .padding(.trailing, 10)
//                }
//            }
//            .padding(.bottom)
//        }
//        .environmentObject(chatService)
//    }
//}
