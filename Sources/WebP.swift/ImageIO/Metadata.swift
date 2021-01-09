//
//  Metadata.swift
//  WebP.swift
//
//  Created by Louis Shen on 2021/1/9.
//

import CWebP

struct MetadataPayload {
    public var bytes : UnsafeMutablePointer<__uint8_t>
    public var size : size_t
}

struct Metadata {
    public var exif : MetadataPayload
    public var iccp : MetadataPayload
    public var xmp : MetadataPayload
}

struct CMetadata {
    public static func MetadataInit(metadata : UnsafeMutablePointer<Metadata>) {
        memset(metadata, 0, MemoryLayout<UnsafeMutablePointer<Metadata>>.size)
    }
}
