import SwiftUI

struct ChatView: View {
    @StateObject private var viewModel = ChatViewModel()
    @State private var userInput: String = ""
    
    var body: some View {
        VStack {
            HStack {
                HStack {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .padding(.leading, 24)
                        .foregroundColor(.white)
                    Spacer()
                    Image("keqing")
                        .resizable()
                        .frame(width: 42, height: 42)
                        .cornerRadius(10)
                    Text("Keqing")
                        .font(.system(size: 15))
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                    Spacer()
                    Image(systemName: "waveform")
                        .font(.title2)
                        .padding(.trailing, 24)
                        .foregroundColor(.white)
                }
                .padding(.vertical, 10)
                .background(Color.secondaryBlack)
            }
            
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(viewModel.chatHistory) { message in
                            HStack {
                                if message.role == "user" {
                                    Spacer()
                                    Text(message.content)
                                        .padding()
                                        .background(Color.primaryBlue)
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                    VStack {
                                        Image(systemName: "person.circle.fill")
                                            .font(.system(size: 35))
                                            .foregroundColor(.white)
                                        Spacer(minLength: 0)
                                    }
                                } else {
                                    VStack {
                                        Image("keqing")
                                            .resizable()
                                            .frame(width: 38, height: 38)
                                            .cornerRadius(10)
                                        Spacer(minLength: 0)
                                    }
                                    Text(message.content)
                                        .padding()
                                        .background(Color.secondaryBlack)
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                    Spacer()
                                }
                            }
                            .id(message.id) // Set ID for each message
                        }
                        
                        if viewModel.isLoading {
                            HStack {
                                DotLoadingView()
                                    .padding()
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(10)
                                Spacer()
                            }
                            .id(UUID()) // Set an ID for the loading view
                        }
                    }
                    .onChange(of: viewModel.chatHistory.count) { _ in
                        withAnimation {
                            proxy.scrollTo(viewModel.chatHistory.last?.id, anchor: .bottom)
                        }
                    }
                    .onChange(of: viewModel.isLoading) { _ in
                        withAnimation {
                            proxy.scrollTo(viewModel.chatHistory.last?.id, anchor: .bottom)
                        }
                    }
                    .onAppear {
                        // Ensure scrolling to the bottom when the view first appears
                        if let lastMessageId = viewModel.chatHistory.last?.id {
                            withAnimation {
                                proxy.scrollTo(lastMessageId, anchor: .bottom)
                            }
                        }
                    }
                }
                .padding(.horizontal, 14)
            }
            
            HStack {
                Image(systemName: "phone.fill")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding(.trailing, 8)
                
                ZStack {
                    ZStack(alignment: .leading) {
                        if userInput.isEmpty {
                            Text("Message Keqing")
                                .foregroundColor(.white) // Warna placeholder
                                .padding(.leading, 16) // Sesuaikan padding agar placeholder tidak tersembunyi
                        }
                        
                        TextField("", text: $userInput)
                            .padding(10)
                            .padding(.trailing, 40)
                            .background(Color.greyChat)
                            .cornerRadius(8)
                            .foregroundColor(.white) // Warna teks input
                            .textFieldStyle(PlainTextFieldStyle())
                    }

                    HStack {
                        Spacer()
                        Button(action: {
                            viewModel.addUserMessage(userInput)
                            userInput = ""
                            viewModel.sendMessage()
                        }) {
                            Image(systemName: "paperplane.fill")
                                .font(.title)
                                .foregroundColor(.secondaryBlue)
                        }
                        .background(Color.greyChat)
                        .padding(.trailing, 10)
                    }
                }
            }
            .padding(14)
            
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
        }
        .background(Color.primaryBlack)
    }
}
