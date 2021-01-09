import CWebP
import CPNG

var verbose = 0

var inFile = ""
var outFile = ""
var dumpFile = ""
var out : UnsafeMutablePointer<FILE>? = nil

var shortOutput = 0
var quiet = 0
var keepAlpha = 1
var blendAlpha = 0
var backgroundColor : __uint32_t = 0xffffff
var crop = 0, cropX = 0, cropY = 0, cropW = 0, cropH = 0
var resizeW = 0, resizeH = 0
var losslessPreset = 6
var useLosslessPreset = -1  // -1=unset, 0=don't use, 1=use it
var showProgress = 0
var keepMetadata = 0
var metadataWritten = 0

var picture = WebPPicture()

var printDistortion = -1

var originalPicture = WebPPicture()
var config = WebPConfig()
var stats = WebPAuxStats()
var memoryWriter = WebPMemoryWriter()
var useMemoryWriter : CInt

var metaData : Metadata = Metadata()
//var stopWatch : StopWatch

var argc = 6
var argv = ["cwebp","-lossless","-i","1.png","-o","1.webp"]

CMetadata.metadataInit(metadata: &metaData)

WebPMemoryWriterInit(&memoryWriter)
if (WebPPictureInit(&picture) == 0) ||
    (WebPPictureInit(&originalPicture) == 0) ||
    (WebPConfigInit(&config) == 0) {
    print("Error! Version mismatch!\n")
    exit(0)
}

if argc == 1 {
    Utils.helpShort()
    exit(0)
}

for i in argv.indices {
    if i == 0 {
        continue
    }
    
    //var parseError = 0
    if argv[i] == "-h" || argv[i] == "-help" {
        Utils.helpShort()
        exit(0)
    } else if argv[i] == "-H" || argv[i] == "-longhelp" {
        Utils.helpLong()
        exit(0)
    } else if argv[i] == "-o" && i + 1 < argc {
        outFile = argv[i + 1]
        continue
    } else if argv[i] == "-d" && i + 1 < argc {
        dumpFile = argv[i + 1]
        config.show_compressed = 1
        continue
    } else if argv[i] == "-print_psnr" {
        config.show_compressed = 1
        printDistortion = 0
    } else if argv[i] == "-print_ssim" {
        config.show_compressed = 1
        printDistortion = 1
    } else if argv[i] == "-print_lsim" {
        config.show_compressed = 1
        printDistortion = 2
    } else if argv[i] == "-short" {
        shortOutput += 1
    /*} else if argv[i] == "-s" && i + 2 < argc {
        picture.width = ExUtilGetInt(argv[++c], 0, &parse_error)
        picture.height = ExUtilGetInt(argv[++c], 0, &parse_error)
        if (picture.width > WEBP_MAX_DIMENSION || picture.width < 0 ||
            picture.height > WEBP_MAX_DIMENSION ||  picture.height < 0) {
          fprintf(stderr,
                  "Specified dimension (%d x %d) is out of range.\n",
                  picture.width, picture.height)
          goto Error
        }*/
    /*} else if argv[i] == "-m") && c + 1 < argc) {
        config.method = ExUtilGetInt(argv[++c], 0, &parse_error)
        use_lossless_preset = 0   // disable -z option
    *//*} else if argv[i] == "-q") && c + 1 < argc) {
        config.quality = ExUtilGetFloat(argv[++c], &parse_error)
        use_lossless_preset = 0   // disable -z option
    *//*} else if argv[i] == "-z") && c + 1 < argc) {
        lossless_preset = ExUtilGetInt(argv[++c], 0, &parse_error)
        if (use_lossless_preset != 0) use_lossless_preset = 1
 *//*} else if argv[i] == "-alpha_q") && c + 1 < argc) {
        config.alpha_quality = ExUtilGetInt(argv[++c], 0, &parse_error)
 *//*} else if argv[i] == "-alpha_method") && c + 1 < argc) {
        config.alpha_compression = ExUtilGetInt(argv[++c], 0, &parse_error)
 *//*} else if argv[i] == "-alpha_cleanup")) {
        // This flag is obsolete, does opposite of -exact.
        config.exact = 0
 *//*} else if argv[i] == "-exact")) {
        config.exact = 1
 *//*} else if argv[i] == "-blend_alpha") && c + 1 < argc) {
        blend_alpha = 1
        // background color is given in hex with an optional '0x' prefix
        background_color = ExUtilGetInt(argv[++c], 16, &parse_error)
        background_color = background_color & 0x00ffffffu
 *//*} else if argv[i] == "-alpha_filter") && c + 1 < argc) {
        ++c
        if argv[i] == "none")) {
          config.alpha_filtering = 0
        } else if argv[i] == "fast")) {
          config.alpha_filtering = 1
        } else if argv[i] == "best")) {
          config.alpha_filtering = 2
        } else {
          fprintf(stderr, "Error! Unrecognized alpha filter: %s\n", argv[c])
          goto Error
        }
 *//*} else if argv[i] == "-noalpha")) {
        keep_alpha = 0
      */
        
    } else if argv[i] == "-lossless" {
        config.lossless = 1
      /*} else if argv[i] == "-near_lossless") && c + 1 < argc) {
        config.near_lossless = ExUtilGetInt(argv[++c], 0, &parse_error)
        config.lossless = 1  // use near-lossless only with lossless
 *//*} else if argv[i] == "-hint") && c + 1 < argc) {
        ++c
        if argv[i] == "photo")) {
          config.image_hint = WEBP_HINT_PHOTO
        } else if argv[i] == "picture")) {
          config.image_hint = WEBP_HINT_PICTURE
        } else if argv[i] == "graph")) {
          config.image_hint = WEBP_HINT_GRAPH
        } else {
          fprintf(stderr, "Error! Unrecognized image hint: %s\n", argv[c])
          goto Error
        }
 *//*} else if argv[i] == "-size") && c + 1 < argc) {
        config.target_size = ExUtilGetInt(argv[++c], 0, &parse_error)
 *//*} else if argv[i] == "-psnr") && c + 1 < argc) {
        config.target_PSNR = ExUtilGetFloat(argv[++c], &parse_error)
 *//*} else if argv[i] == "-sns") && c + 1 < argc) {
        config.sns_strength = ExUtilGetInt(argv[++c], 0, &parse_error)
 *//*} else if argv[i] == "-f") && c + 1 < argc) {
        config.filter_strength = ExUtilGetInt(argv[++c], 0, &parse_error)
 *//*} else if argv[i] == "-af")) {
        config.autofilter = 1
 *//*} else if argv[i] == "-jpeg_like")) {
        config.emulate_jpeg_size = 1
 *//*} else if argv[i] == "-mt")) {
        ++config.thread_level  // increase thread level
 *//*} else if argv[i] == "-low_memory")) {
        config.low_memory = 1
 *//*} else if argv[i] == "-strong")) {
        config.filter_type = 1
 *//*} else if argv[i] == "-nostrong")) {
        config.filter_type = 0
 *//*} else if argv[i] == "-sharpness") && c + 1 < argc) {
        config.filter_sharpness = ExUtilGetInt(argv[++c], 0, &parse_error)
 *//*} else if argv[i] == "-sharp_yuv")) {
        config.use_sharp_yuv = 1
 *//*} else if argv[i] == "-pass") && c + 1 < argc) {
        config.pass = ExUtilGetInt(argv[++c], 0, &parse_error)
 *//*} else if argv[i] == "-qrange") && c + 2 < argc) {
        config.qmin = ExUtilGetInt(argv[++c], 0, &parse_error)
        config.qmax = ExUtilGetInt(argv[++c], 0, &parse_error)
        if (config.qmin < 0) config.qmin = 0
        if (config.qmax > 100) config.qmax = 100
 *//*} else if argv[i] == "-pre") && c + 1 < argc) {
        config.preprocessing = ExUtilGetInt(argv[++c], 0, &parse_error)
 *//*} else if argv[i] == "-segments") && c + 1 < argc) {
        config.segments = ExUtilGetInt(argv[++c], 0, &parse_error)
 *//*} else if argv[i] == "-partition_limit") && c + 1 < argc) {
        config.partition_limit = ExUtilGetInt(argv[++c], 0, &parse_error)
 *//*} else if argv[i] == "-map") && c + 1 < argc) {
        picture.extra_info_type = ExUtilGetInt(argv[++c], 0, &parse_error)
 *//*} else if argv[i] == "-crop") && c + 4 < argc) {
        crop = 1
        crop_x = ExUtilGetInt(argv[++c], 0, &parse_error)
        crop_y = ExUtilGetInt(argv[++c], 0, &parse_error)
        crop_w = ExUtilGetInt(argv[++c], 0, &parse_error)
        crop_h = ExUtilGetInt(argv[++c], 0, &parse_error)
 *//*} else if argv[i] == "-resize") && c + 2 < argc) {
        resize_w = ExUtilGetInt(argv[++c], 0, &parse_error)
        resize_h = ExUtilGetInt(argv[++c], 0, &parse_error)
 *//*#ifndef WEBP_DLL
      } else if argv[i] == "-noasm")) {
        VP8GetCPUInfo = NULL
  #endif
 */
    } else if argv[i] == "-version" {
        let version = WebPGetEncoderVersion()
        print("\((version >> 16) & 0xff).\((version >> 8) & 0xff).\(version & 0xff)")
        exit(0)
    } else if argv[i] == "-progress" {
        showProgress = 1
    } else if argv[i] == "-quiet" {
        quiet = 1
    /*} else if argv[i] == "-preset") && c + 1 < argc) {
        WebPPreset preset
        ++c
        if argv[i] == "default")) {
          preset = WEBP_PRESET_DEFAULT
        } else if argv[i] == "photo")) {
          preset = WEBP_PRESET_PHOTO
        } else if argv[i] == "picture")) {
          preset = WEBP_PRESET_PICTURE
        } else if argv[i] == "drawing")) {
          preset = WEBP_PRESET_DRAWING
        } else if argv[i] == "icon")) {
          preset = WEBP_PRESET_ICON
        } else if argv[i] == "text")) {
          preset = WEBP_PRESET_TEXT
        } else {
          fprintf(stderr, "Error! Unrecognized preset: %s\n", argv[c])
          goto Error
        }
        if (!WebPConfigPreset(&config, preset, config.quality)) {
          fprintf(stderr, "Error! Could initialize configuration with preset.\n")
          goto Error
        }
      } else if argv[i] == "-metadata") && c + 1 < argc) {
        static const struct {
          const char* option
          int flag
        } kTokens[] = {
          { "all",  METADATA_ALL },
          { "none", 0 },
          { "exif", METADATA_EXIF },
          { "icc",  METADATA_ICC },
          { "xmp",  METADATA_XMP },
        }
        const size_t kNumTokens = sizeof(kTokens) / sizeof(kTokens[0])
        const char* start = argv[++c]
        const char* const end = start + strlen(start)

        while (start < end) {
          size_t i
          const char* token = strchr(start, ',')
          if (token == NULL) token = end

          for (i = 0 i < kNumTokens ++i) {
            if ((size_t)(token - start) == strlen(kTokens[i].option) &&
                !strncmp(start, kTokens[i].option, strlen(kTokens[i].option))) {
              if (kTokens[i].flag != 0) {
                keep_metadata |= kTokens[i].flag
              } else {
                keep_metadata = 0
              }
              break
            }
          }
          if (i == kNumTokens) {
            fprintf(stderr, "Error! Unknown metadata type '%.*s'\n",
                    (int)(token - start), start)
            FREE_WARGV_AND_RETURN(-1)
          }
          start = token + 1
        }
  #ifdef HAVE_WINCODEC_H
        if (keep_metadata != 0 && keep_metadata != METADATA_ICC) {
          // TODO(jzern): remove when -metadata is supported on all platforms.
          fprintf(stderr, "Warning: only ICC profile extraction is currently"
                          " supported on this platform!\n")
        }
  #endif
 */
    } else if argv[i] == "-v" {
        verbose = 1
        /*} else if argv[i] == "--")) {
        if (c + 1 < argc) in_file = (const char*)GET_WARGV(argv, ++c)
        break
      */
    } else if argv[i] == "-i" && i + 1 < argc{
        inFile = argv[i + 1]
        continue
    } else if argv[i].first == "-" {
        print("Error! Unknown option '\(argv[i])'")
        Utils.helpLong()
        exit(-1)
    }
}
