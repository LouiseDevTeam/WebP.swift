//
//  ImageIOUtil.swift
//  WebP.swift
//
//  Created by Louis Shen on 2021/1/9.
//

import Foundation
/*
 void ImgIoUtilCopyPlane(const uint8_t* src, int src_stride,
                         uint8_t* dst, int dst_stride, int width, int height) {
   while (height-- > 0) {
     memcpy(dst, src, width * sizeof(*dst));
     src += src_stride;
     dst += dst_stride;
   }
 }
 */
struct ImageIOUtil {
    public static func imgIOUtilCopyPlane( src : inout UnsafeMutablePointer<__uint8_t>, srcStride : CInt, dst : inout UnsafeMutablePointer<__uint8_t>, dstStride : CInt, width : CInt, height : CInt) {
        var h = height - 1
        while h >= 0 {
            memcpy(dst, src, Int(width) * MemoryLayout<__uint8_t>.size)
            h -= 1
            src += UnsafeMutablePointer<__uint8_t>.Stride(srcStride)
            dst += UnsafeMutablePointer<__uint8_t>.Stride(dstStride)
        }
    }
}
