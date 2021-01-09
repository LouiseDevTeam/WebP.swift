import CWebP
import CPNG

/*func ReadYUV(data : inout UnsafeMutablePointer<__uint8_t>, dataSize : size_t, pic : UnsafeMutablePointer<WebPPicture>) -> CInt {
    let useArgb = pic.pointee.use_argb
    let uvWidth = (pic.pointee.width + 1) / 2
    let uvHeight = (pic.pointee.height + 1) / 2
    let yPlaneSize = pic.pointee.width * pic.pointee.height
    let uvPlaneSize = uvWidth * uvHeight
    let expectedDataSize = yPlaneSize + 2 * uvPlaneSize
    
    if dataSize != expectedDataSize {
        print("input data doesn't have the expected size (\(dataSize) instead of \(expectedDataSize)\n")
        return 0
    }
    
    pic.pointee.use_argb = 0
    if (WebPPictureAlloc(pic) == 0) {
        return 0
    }
}
*/
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

var picture : WebPPicture

var printDistortion = -1

var originalPicture : WebPPicture
var config : WebPConfig
var stats : WebPAuxStats
var memoryWriter : WebPMemoryWriter
var useMemoryWriter : CInt

var metaData : Metadata = Metadata()
//var stopWatch : StopWatch

var argc = 5
var argv = ["1","2","3","4","5"]

CMetadata.metadataInit(metadata: &metaData)
