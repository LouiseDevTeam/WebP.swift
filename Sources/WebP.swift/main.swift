import CWebP
import CPNG

var inFile : UnsafePointer<CChar>? = nil
var outFile : UnsafePointer<CChar>? = nil
var dumpFile : UnsafePointer<CChar>? = nil
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

var argc = 1
var argv = ["1","2","3","4","5"]

CMetadata.metadataInit(metadata: &metaData)

WebPMemoryWriterInit(&memoryWriter)
if (WebPPictureInit(&picture) == 0) ||
    (WebPPictureInit(&originalPicture) == 0) ||
    (WebPConfigInit(&config) == 0) {
    print("Error! Version mismatch!\n")
    exit(0)
}

if argc == 1 {
    Utils.HelpShort()
    exit(0)
}

