//
//  ChatView.swift
//  Muscle-Training-Diary
//
//  Created by 東　秀斗 on 2023/05/01.
//

import SwiftUI
import ComposableArchitecture

extension UIApplication {
    func closeKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct ChatView: View {
    let store: StoreOf<ChatStore>

    var body: some View {
        WithViewStore(store) { viewStore in
            ZStack {
                Color("backColor")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .onTapGesture {
                        UIApplication.shared.closeKeyboard()
                    }
                VStack {
                    header
                    messageBody
                        .padding()
                    MessageInputView(messageText: viewStore.binding(\.$newMessage)) {
                        viewStore.send(.push)
                    }
                }
            }
        }
    }

    var header: some View {
        WithViewStore(store) { viewStore in
            HStack {
                Text("チャットBot")
                    .font(.title2)
                Spacer()
                Button(
                    action: {
                        viewStore.send(.delete)
                    }
                ) {
                    HStack {
                        Image(systemName: "trash")
                        Text("削除")
                    }
                    .foregroundColor(.red)
                }
            }
            .padding([.top, .leading, .trailing])
        }
    }

    var messageBody: some View {
        WithViewStore(store) { viewStore in
            ScrollViewReader { reader in
                VStack {
                    ScrollView {
                        ForEach(viewStore.messages) { message in
                            if message.messageText.isEmpty {
                                DotAnimation()
                            } else {
                                MessageRow(message: message)
                            }
                        }
                        Text("")
                            .id("bottom")
                    }
                }
                .onReceive(NotificationCenter.default.publisher(for: NSNotification.scrollToBottom)) { _ in
                    reader.scrollTo("bottom")
                }
                .onAppear {
                    reader.scrollTo("bottom")
                }
            }
            .frame(maxHeight: .infinity)
            .onTapGesture {
                UIApplication.shared.closeKeyboard()
            }
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardDidShowNotification)) { _ in
                withAnimation {
                    NotificationCenter.default.post(name: NSNotification.scrollToBottom, object: nil, userInfo: nil)
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardDidHideNotification)) { _ in
                NotificationCenter.default.post(name: NSNotification.scrollToBottom, object: nil, userInfo: nil)
            }
        }
    }
}

struct MessageInputView: View {
    @Binding var messageText: String

    var sendMessage: () -> Void
    let width = UIScreen.main.bounds.width
    let innerPadding: CGFloat = 8
    let maxHeight: CGFloat = 150

    private var height: CGFloat {
        let height = messageText.boundingRect(
            with: .init(width: width - innerPadding * 2 - 12, height: UIScreen.main.bounds.height),
            options: .usesLineFragmentOrigin,
            attributes: [.font: UIFont.preferredFont(forTextStyle: .body)],
            context: nil)
            .height
        let paddingHeight = height + innerPadding * 2
        return paddingHeight < maxHeight ? paddingHeight : maxHeight
    }

    var body: some View {
        HStack {
            ZStack(alignment: .leading) {
                TextEditor(text: $messageText)
                    .frame(height: height)
                    .foregroundColor(.primary)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .cornerRadius(25)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                    )
                if messageText.isEmpty {
                    Text("質問")
                        .foregroundColor(Color.gray.opacity(0.4))
                        .padding(.horizontal, 20)
                }
            }

            Button(action: sendMessage) {
                Image(systemName: "arrow.up.circle.fill")
                    .resizable()
                    .frame(width: 25, height: 25)
                    .foregroundColor(.blue)
            }
            .padding(.horizontal, 10)
            .clipShape(Circle())
            .disabled(
                messageText.isEmpty)
        }
        .padding()
    }
}

struct MessageRow: View {
    var message: Message

    var body: some View {
        HStack {
            if message.isSelf {
                Spacer()
            }
            Text(message.messageText)
                .padding(10)
                .background(message.isSelf ? Color.blue : Color.gray)
                .foregroundColor(.white)
                .clipShape(BubbleShape(isSelf: message.isSelf))
            if !message.isSelf {
                Spacer()
            }
        }
    }
}

struct DotAnimation: View {
    @State private var shouldAnimate = false

    var body: some View {
        HStack {
            HStack {
                Circle()
                    .fill(Color.white)
                    .frame(width: 10, height: 10)
                    .scaleEffect(shouldAnimate ? 1.0 : 0.5)
                    .animation(Animation.easeInOut(duration: 0.3).repeatForever(), value: shouldAnimate)
                Circle()
                    .fill(Color.white)
                    .frame(width: 10, height: 10)
                    .scaleEffect(shouldAnimate ? 1.0 : 0.5)
                    .animation(Animation.easeInOut(duration: 0.3).repeatForever().delay(0.3), value: shouldAnimate)
                Circle()
                    .fill(Color.white)
                    .frame(width: 10, height: 10)
                    .scaleEffect(shouldAnimate ? 1.0 : 0.5)
                    .animation(Animation.easeInOut(duration: 0.3).repeatForever().delay(0.6), value: shouldAnimate)
            }
            .padding(10)
            .background(Color.gray)
            .foregroundColor(.white)
            .clipShape(BubbleShape(isSelf: false))
            Spacer()
        }
        .onAppear {
            self.shouldAnimate = true
            NotificationCenter.default.post(name: NSNotification.scrollToBottom, object: nil, userInfo: nil)
        }
    }
}

struct BubbleShape: Shape {
    var isSelf: Bool
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect,
                                byRoundingCorners: [.topLeft, .topRight, isSelf ? .bottomLeft : .bottomRight],
                                cornerRadii: CGSize(width: 12, height: 12)
        )
        return Path(path.cgPath)
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView(store: Store(initialState: ChatStore.State(), reducer: ChatStore()))
    }
}
