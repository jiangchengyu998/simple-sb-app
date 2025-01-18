package com.example.simplesbapp;

import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import java.io.IOException;
import java.util.Set;
import java.util.concurrent.CopyOnWriteArraySet;

public class ChatController extends TextWebSocketHandler {
    private static final Set<WebSocketSession> sessions = new CopyOnWriteArraySet<>();

    @Override
    public void afterConnectionEstablished(WebSocketSession session) {
        sessions.add(session);
        System.out.println("新用户加入: " + session.getId());
    }

    @Override
    protected void handleTextMessage(WebSocketSession session, TextMessage message) throws IOException {
        String payload = message.getPayload();
        System.out.println("收到消息: " + payload);

        // 广播消息到所有连接的客户端
        for (WebSocketSession wsSession : sessions) {
            if (wsSession.isOpen()) {
                wsSession.sendMessage(new TextMessage("用户" + session.getId() + "说: " + payload));
            }
        }
    }

    @Override
    public void afterConnectionClosed(WebSocketSession session, org.springframework.web.socket.CloseStatus status) {
        sessions.remove(session);
        System.out.println("用户离开: " + session.getId());
    }
}
