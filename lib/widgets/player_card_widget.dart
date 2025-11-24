import 'package:flutter/material.dart';
import 'package:erank_app/models/player_card.dart';
import 'package:google_fonts/google_fonts.dart';

class PlayerCardWidget extends StatelessWidget {
  final PlayerCard card;

  const PlayerCardWidget({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 450,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF2E2E3E),
            Color(0xFF4A148C),
            Color(0xFF1A1A2E),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF7F5AF0), width: 2),
        boxShadow: [
          BoxShadow(
            // CORREÇÃO AQUI:
            color: const Color(0xFF7F5AF0).withValues(alpha: 0.5),
            blurRadius: 20,
            spreadRadius: 2,
          )
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: -50,
            right: -50,
            child: Icon(Icons.shield,
                size: 300, color: Colors.white.withValues(alpha: 0.03)),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Text(
                          '${card.overall}',
                          style: GoogleFonts.bebasNeue(
                            fontSize: 64,
                            color: const Color(0xFF2CB67D),
                            height: 1,
                          ),
                        ),
                        Text(
                          card.role,
                          style: GoogleFonts.bebasNeue(
                            fontSize: 28,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Icon(Icons.flag, color: Colors.green, size: 30),
                      ],
                    ),
                    const Spacer(),
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: const Color(0xFF2CB67D), width: 2),
                        image: const DecorationImage(
                          image: AssetImage('assets/erank_logo.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Center(
                  child: Text(
                    card.nickname.toUpperCase(),
                    style: GoogleFonts.bebasNeue(
                      fontSize: 40,
                      color: const Color(0xFF2CB67D),
                      letterSpacing: 2,
                    ),
                  ),
                ),
                const Divider(color: Color(0xFF7F5AF0)),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStatColumn("VIT", card.vit.toString()),
                    _buildStatColumn("DER", card.der.toString()),
                    _buildStatColumn("KILL", card.kill.toString()),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStatColumn("ASS", card.ass.toString()),
                    _buildStatColumn("HS", card.hs.toString()),
                    _buildStatColumn("RCK", card.rck.toString()),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String label, String value) {
    return SizedBox(
      width: 60,
      child: Column(
        children: [
          Text(
            value,
            style: GoogleFonts.bebasNeue(
              fontSize: 24,
              color: Colors.white,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.bebasNeue(
              fontSize: 16,
              color: const Color(0xFF2CB67D),
            ),
          ),
        ],
      ),
    );
  }
}
