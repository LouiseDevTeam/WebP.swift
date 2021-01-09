//
//  Metadata.swift
//  WebP.swift
//
//  Created by Louis Shen on 2021/1/9.
//

import CWebP

struct MetadataPayload {
    public var bytes : UnsafeMutablePointer<__uint8_t>?
    public var size : size_t
    
    init() {
        bytes = nil
        size = 0
    }
}

struct Metadata {
    public var exif : MetadataPayload
    public var iccp : MetadataPayload
    public var xmp : MetadataPayload
    
    init() {
        exif = MetadataPayload()
        iccp = MetadataPayload()
        xmp = MetadataPayload()
    }
}

struct CMetadata {
    public static func metadataInit(metadata : UnsafeMutablePointer<Metadata>?) {
        if metadata == nil {
            return
        }
        memset(metadata, 0, MemoryLayout<UnsafeMutablePointer<Metadata>>.size)
    }
    
    private static func metadataPayloadDelete(payload : UnsafeMutablePointer<MetadataPayload>?) {
        if payload == nil {
            return
        }
        free(payload!.pointee.bytes)
        payload?.deallocate()
    }
    
    public static func metadataFree(_ metadata : UnsafeMutablePointer<Metadata>?) {
        if metadata == nil {
            return
        }
        metadataPayloadDelete(payload: &metadata!.pointee.exif)
        metadataPayloadDelete(payload: &metadata!.pointee.iccp)
        metadataPayloadDelete(payload: &metadata!.pointee.xmp)
    }
    
    public static func metadataCopy(metadata : UnsafeMutablePointer<CChar>?,
                                    metadataLen : size_t,
                                    payload : UnsafeMutablePointer<MetadataPayload>?) -> CInt {
        if (metadata == nil || metadataLen == 0 || payload == nil) {
            return 0
        }
        payload?.pointee.bytes = malloc(metadataLen).assumingMemoryBound(to: __uint8_t.self)
        if payload?.pointee.bytes == nil {
            return 0
        }
        payload?.pointee.size = metadataLen
        memcpy(payload?.pointee.bytes, metadata, metadataLen)
        return 1
    }
}
