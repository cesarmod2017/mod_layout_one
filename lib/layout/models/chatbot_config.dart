import 'package:flutter/material.dart';

/// Enum que define as posições disponíveis para o botão do chatbot
enum ChatbotPosition {
  /// Canto inferior direito (padrão)
  bottomRight,

  /// Canto inferior esquerdo
  bottomLeft,

  /// Canto superior direito
  topRight,

  /// Canto superior esquerdo
  topLeft,
}

/// Configuração do botão e janela do chatbot
///
/// Esta classe permite personalizar completamente a aparência e comportamento
/// do botão flutuante do chatbot e sua janela de exibição.
///
/// ## Exemplo de uso:
/// ```dart
/// ChatbotConfig(
///   chatWidget: MyChatbotWidget(),
///   position: ChatbotPosition.bottomRight,
///   icon: Icons.chat_bubble,
///   iconColor: Colors.white,
///   backgroundColor: Colors.blue,
///   windowWidth: 400,
///   windowHeight: 600,
/// )
/// ```
class ChatbotConfig {
  /// Widget do chatbot que será exibido na janela flutuante.
  /// Este é o único parâmetro obrigatório.
  final Widget chatWidget;

  /// Posição do botão flutuante na tela.
  /// Padrão: [ChatbotPosition.bottomRight]
  final ChatbotPosition position;

  /// Ícone do botão flutuante.
  /// Padrão: [Icons.chat_bubble_rounded]
  final IconData icon;

  /// Ícone exibido quando a janela do chatbot está aberta.
  /// Padrão: [Icons.close]
  final IconData closeIcon;

  /// Cor do ícone do botão flutuante.
  /// Se não informado, usa a cor do tema (colorScheme.onPrimary)
  final Color? iconColor;

  /// Cor de fundo do botão flutuante.
  /// Se não informado, usa a cor primária do tema (colorScheme.primary)
  final Color? backgroundColor;

  /// Tamanho do botão flutuante.
  /// Padrão: 56.0
  final double buttonSize;

  /// Tamanho do ícone dentro do botão.
  /// Padrão: 24.0
  final double iconSize;

  /// Largura da janela do chatbot.
  /// Padrão: 380.0
  final double windowWidth;

  /// Altura da janela do chatbot.
  /// Padrão: 500.0
  final double windowHeight;

  /// Margem do botão em relação às bordas da tela.
  /// Padrão: 16.0
  final double margin;

  /// Elevação (sombra) do botão flutuante.
  /// Padrão: 6.0
  final double elevation;

  /// Raio de borda da janela do chatbot.
  /// Padrão: 12.0
  final double windowBorderRadius;

  /// Tooltip exibido ao passar o mouse sobre o botão.
  /// Padrão: 'Chat'
  final String? tooltip;

  /// Cor de fundo da janela do chatbot.
  /// Se não informado, usa a cor de fundo do scaffold do tema
  final Color? windowBackgroundColor;

  /// Cor da borda da janela do chatbot.
  /// Se não informado, usa a cor de divisor do tema
  final Color? windowBorderColor;

  /// Espessura da borda da janela.
  /// Padrão: 1.0
  final double windowBorderWidth;

  /// Elevação (sombra) da janela do chatbot.
  /// Padrão: 8.0
  final double windowElevation;

  /// Se verdadeiro, mostra uma animação de badge/notificação no botão.
  /// Padrão: false
  final bool showBadge;

  /// Cor do badge de notificação.
  /// Padrão: Colors.red
  final Color? badgeColor;

  /// Callback executado quando a janela do chatbot é aberta.
  final VoidCallback? onOpen;

  /// Callback executado quando a janela do chatbot é fechada.
  final VoidCallback? onClose;

  const ChatbotConfig({
    required this.chatWidget,
    this.position = ChatbotPosition.bottomRight,
    this.icon = Icons.chat_bubble_rounded,
    this.closeIcon = Icons.close,
    this.iconColor,
    this.backgroundColor,
    this.buttonSize = 56.0,
    this.iconSize = 24.0,
    this.windowWidth = 380.0,
    this.windowHeight = 500.0,
    this.margin = 16.0,
    this.elevation = 6.0,
    this.windowBorderRadius = 12.0,
    this.tooltip,
    this.windowBackgroundColor,
    this.windowBorderColor,
    this.windowBorderWidth = 1.0,
    this.windowElevation = 8.0,
    this.showBadge = false,
    this.badgeColor,
    this.onOpen,
    this.onClose,
  });

  /// Cria uma cópia desta configuração com os valores especificados alterados.
  ChatbotConfig copyWith({
    Widget? chatWidget,
    ChatbotPosition? position,
    IconData? icon,
    IconData? closeIcon,
    Color? iconColor,
    Color? backgroundColor,
    double? buttonSize,
    double? iconSize,
    double? windowWidth,
    double? windowHeight,
    double? margin,
    double? elevation,
    double? windowBorderRadius,
    String? tooltip,
    Color? windowBackgroundColor,
    Color? windowBorderColor,
    double? windowBorderWidth,
    double? windowElevation,
    bool? showBadge,
    Color? badgeColor,
    VoidCallback? onOpen,
    VoidCallback? onClose,
  }) {
    return ChatbotConfig(
      chatWidget: chatWidget ?? this.chatWidget,
      position: position ?? this.position,
      icon: icon ?? this.icon,
      closeIcon: closeIcon ?? this.closeIcon,
      iconColor: iconColor ?? this.iconColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      buttonSize: buttonSize ?? this.buttonSize,
      iconSize: iconSize ?? this.iconSize,
      windowWidth: windowWidth ?? this.windowWidth,
      windowHeight: windowHeight ?? this.windowHeight,
      margin: margin ?? this.margin,
      elevation: elevation ?? this.elevation,
      windowBorderRadius: windowBorderRadius ?? this.windowBorderRadius,
      tooltip: tooltip ?? this.tooltip,
      windowBackgroundColor:
          windowBackgroundColor ?? this.windowBackgroundColor,
      windowBorderColor: windowBorderColor ?? this.windowBorderColor,
      windowBorderWidth: windowBorderWidth ?? this.windowBorderWidth,
      windowElevation: windowElevation ?? this.windowElevation,
      showBadge: showBadge ?? this.showBadge,
      badgeColor: badgeColor ?? this.badgeColor,
      onOpen: onOpen ?? this.onOpen,
      onClose: onClose ?? this.onClose,
    );
  }
}
