
#define MKTAG(a,b,c,d)   ((a) | ((b) << 8) | ((c) << 16) | ((unsigned)(d) << 24))
#define FFERRTAG(a, b, c, d) (-(int)MKTAG(a, b, c, d))

#define AVERROR_BSF_NOT_FOUND      FFERRTAG(0xF8,'B','S','F') ///< Bitstream filter not found (exit 8)
#define AVERROR_BUG                FFERRTAG( 'B','U','G','!') ///< Internal bug, also see AVERROR_BUG2 (exit 190) 
#define AVERROR_BUFFER_TOO_SMALL   FFERRTAG( 'B','U','F','S') ///< Buffer too small (exit 190)
#define AVERROR_DECODER_NOT_FOUND  FFERRTAG(0xF8,'D','E','C') ///< Decoder not found (exit 190)
#define AVERROR_DEMUXER_NOT_FOUND  FFERRTAG(0xF8,'D','E','M') ///< Demuxer not found (exit 8)
#define AVERROR_ENCODER_NOT_FOUND  FFERRTAG(0xF8,'E','N','C') ///< Encoder not found (exit 8)
#define AVERROR_EOF                FFERRTAG( 'E','O','F',' ') ///< End of file (exit 187)
#define AVERROR_EXIT               FFERRTAG( 'E','X','I','T') ///< Immediate exit was requested; the called function should not be restarted (exit 187)
#define AVERROR_EXTERNAL           FFERRTAG( 'E','X','T',' ') ///< Generic error in an external library (exit 187)
#define AVERROR_FILTER_NOT_FOUND   FFERRTAG(0xF8,'F','I','L') ///< Filter not found (exit 8)
#define AVERROR_INVALIDDATA        FFERRTAG( 'I','N','D','A') ///< Invalid data found when processing input (exit 183)
#define AVERROR_MUXER_NOT_FOUND    FFERRTAG(0xF8,'M','U','X') ///< Muxer not found (exit 8)
#define AVERROR_OPTION_NOT_FOUND   FFERRTAG(0xF8,'O','P','T') ///< Option not found (exit 8)
#define AVERROR_PATCHWELCOME       FFERRTAG( 'P','A','W','E') ///< Not yet implemented in FFmpeg, patches welcome (exit 176)
#define AVERROR_PROTOCOL_NOT_FOUND FFERRTAG(0xF8,'P','R','O') ///< Protocol not found (exit 8)
#define AVERROR_STREAM_NOT_FOUND   FFERRTAG(0xF8,'S','T','R') ///< Stream not found (exit 8)
#define AVERROR_BUG2               FFERRTAG( 'B','U','G',' ') // (exit 190)
#define AVERROR_UNKNOWN            FFERRTAG( 'U','N','K','N') ///< Unknown error, typically from an external library (exit 171)
#define AVERROR_EXPERIMENTAL       (-0x2bb2afa8) ///< Requested feature is flagged experimental. Set strict_std_compliance if you really want to use it. (exit 88)
#define AVERROR_INPUT_CHANGED      (-0x636e6701) ///< Input changed between calls. Reconfiguration is required. (can be OR-ed with AVERROR_OUTPUT_CHANGED) (exit 88)
#define AVERROR_OUTPUT_CHANGED     (-0x636e6702) ///< Output changed between calls. Reconfiguration is required. (can be OR-ed with AVERROR_INPUT_CHANGED) (exit 254)
int main() {
// https://ffmpeg.org/doxygen/trunk/error_8h_source.html
return AVERROR_EXTERNAL;
}
