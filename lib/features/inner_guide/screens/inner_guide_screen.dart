import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/inner_guide_controller.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/inner_guide_response_widget.dart';
import '../widgets/ai_typing_indicator.dart';

class InnerGuideScreen extends StatefulWidget {
  const InnerGuideScreen({super.key});

  @override
  State<InnerGuideScreen> createState() => _InnerGuideScreenState();
}

class _InnerGuideScreenState extends State<InnerGuideScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  Map<String, String> _parseAI(String text) {
    try {
      return {
        "explanation": text.contains("Logical Explanation:") ? text.split("Logical Explanation:")[1].split("Reality Check:")[0].trim() : "",
        "reality": text.contains("Reality Check:") ? text.split("Reality Check:")[1].split("Calm Guidance:")[0].trim() : "",
        "guidance": text.contains("Calm Guidance:") ? text.split("Calm Guidance:")[1].trim() : text,
      };
    } catch (e) {
      return {"explanation": text, "reality": "", "guidance": ""};
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ai = context.watch<InnerGuideController>();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          "Inner Guide",
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(color: Colors.transparent),
          ),
        ),
      ),
      body: Stack(
        children: [
          // 1. AMBIENT BACKGROUND GLOWS
          Positioned.fill(
            child: Container(
              color: theme.colorScheme.surface,
              child: Stack(
                children: [
                  Positioned(
                    top: -100,
                    right: -50,
                    child: _buildAmbientGlow(theme.colorScheme.primary.withValues(alpha: 0.1), 300),
                  ),
                  Positioned(
                    bottom: 100,
                    left: -50,
                    child: _buildAmbientGlow(theme.colorScheme.secondary.withValues(alpha: 0.05), 250),
                  ),
                ],
              ),
            ),
          ),

          // 2. MAIN CONTENT
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                // ✅ Responsive: Tablet width capped at 700px for readability
                final double chatWidth = constraints.maxWidth > 800 ? 700 : constraints.maxWidth;

                return Center(
                  child: SizedBox(
                    width: chatWidth,
                    child: Column(
                      children: [
                        // Chat History Area
                        Expanded(
                          child: GestureDetector(
                            onTap: () => FocusScope.of(context).unfocus(),
                            child: ListView.builder(
                              controller: _scrollController,
                              physics: const BouncingScrollPhysics(),
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                              itemCount: ai.messages.length,
                              itemBuilder: (context, index) {
                                final msg = ai.messages[index];
                                final isUser = msg["role"] == "user";

                                if (isUser) {
                                  return _buildUserMessage(msg["content"]!, chatWidth);
                                }

                                final parsed = _parseAI(msg["content"]!);
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 28),
                                  child: InnerGuideResponseWidget(
                                    explanation: parsed["explanation"]!,
                                    realityCheck: parsed["reality"]!,
                                    guidance: parsed["guidance"]!,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),

                        if (ai.isLoading)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: AiTypingIndicator(),
                          ),

                        // Quick Action Suggestions (Only if chat is empty)
                        if (ai.messages.isEmpty) _buildQuickSuggestions(theme),

                        // PREMIUM INPUT BAR
                        _buildInputBar(theme, isDark),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // --- UI COMPONENTS ---

  Widget _buildAmbientGlow(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: color, blurRadius: 100, spreadRadius: 50),
        ],
      ),
    );
  }

  Widget _buildUserMessage(String text, double chatWidth) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: chatWidth * 0.75),
          child: ChatBubble(text: text, isUser: true),
        ),
      ),
    );
  }

  Widget _buildQuickSuggestions(ThemeData theme) {
    final suggestions = ["I'm feeling anxious", "Need a reality check", "How to stay calm?"];
    return Container(
      height: 45,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ActionChip(
              label: Text(suggestions[index]),
              labelStyle: TextStyle(color: theme.colorScheme.primary, fontSize: 13),
              backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.05),
              // ✅ FIXED: BorderSide.none used instead of non-existent Border.none
              side: BorderSide(color: theme.colorScheme.primary.withValues(alpha: 0.1)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              onPressed: () {
                _controller.text = suggestions[index];
                _handleSend();
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildInputBar(ThemeData theme, bool isDark) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(24),
                // ✅ Correct way to handle optional borders
                border: Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.1)),
              ),
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                minLines: 1,
                maxLines: 5,
                textCapitalization: TextCapitalization.sentences,
                style: theme.textTheme.bodyLarge,
                decoration: InputDecoration(
                  hintText: "Share your thoughts...",
                  hintStyle: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.4)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  // ✅ Correct way to remove TextField border
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: _handleSend,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 52,
              width: 52,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [theme.colorScheme.primary, theme.colorScheme.primary.withValues(alpha: 0.8)],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.primary.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: const Icon(Icons.arrow_upward_rounded, color: Colors.white, size: 26),
            ),
          ),
        ],
      ),
    );
  }

  void _handleSend() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    _controller.clear();
    context.read<InnerGuideController>().sendMessage(text);
    Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
  }
}