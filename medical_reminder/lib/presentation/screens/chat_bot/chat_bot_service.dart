import 'dart:io';
import 'package:google_generative_ai/google_generative_ai.dart';

class MedicalAiService {
  final GenerativeModel _model;

  MedicalAiService(String apiKey)
      : _model = GenerativeModel(
          model: 'gemini-2.5-flash-lite',
          apiKey: apiKey,
          systemInstruction: Content.system(
            "You are a professional medical assistant. "
            "You may explain symptoms, images, reports, or conditions. "
            "Do NOT give a final diagnosis. "
            "If the query is unrelated to health, politely refuse.",
          ),
        );

  /// TEXT ONLY
  Future<String> sendText(String text) async {
    final response = await _model.generateContent([
      Content.text(text),
    ]);
    return response.text ?? "No response.";
  }

  /// TEXT + IMAGE
  Future<String> sendImageWithText({
    required String text,
    required File image,
  }) async {
    final bytes = await image.readAsBytes();

    final response = await _model.generateContent([
      Content.multi([
        TextPart(text),
        DataPart('image/jpeg', bytes),
      ])
    ]);

    return response.text ?? "No response.";
  }
}
