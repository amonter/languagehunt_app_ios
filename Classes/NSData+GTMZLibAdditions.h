//
//  NSData+GTMZLibAdditions.h
//  CrowdScannerMindField
//
//  Created by Adrian Avendano on 26/01/2013.
//  Copyright (c) 2013 crowdscanner. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (GTMZLibAdditions)


// NOTE: For 64bit, none of these apis handle input sizes >32bits, they will
// return nil when given such data.  To handle data of that size you really
// should be streaming it rather then doing it all in memory.

#pragma mark Gzip Compression

/// Return an autoreleased NSData w/ the result of gzipping the bytes.
//
//  Uses the default compression level.
+ (NSData *)gtm_dataByGzippingBytes:(const void *)bytes
                             length:(NSUInteger)length;

/// Return an autoreleased NSData w/ the result of gzipping the payload of |data|.
//
//  Uses the default compression level.
+ (NSData *)gtm_dataByGzippingData:(NSData *)data;

/// Return an autoreleased NSData w/ the result of gzipping the bytes using |level| compression level.
//
// |level| can be 1-9, any other values will be clipped to that range.
+ (NSData *)gtm_dataByGzippingBytes:(const void *)bytes
                             length:(NSUInteger)length
                   compressionLevel:(int)level;

/// Return an autoreleased NSData w/ the result of gzipping the payload of |data| using |level| compression level.
+ (NSData *)gtm_dataByGzippingData:(NSData *)data
                  compressionLevel:(int)level;

#pragma mark Zlib "Stream" Compression

// NOTE: deflate is *NOT* gzip.  deflate is a "zlib" stream.  pick which one
// you really want to create.  (the inflate api will handle either)

/// Return an autoreleased NSData w/ the result of deflating the bytes.
//
//  Uses the default compression level.
+ (NSData *)gtm_dataByDeflatingBytes:(const void *)bytes
                              length:(NSUInteger)length;

/// Return an autoreleased NSData w/ the result of deflating the payload of |data|.
//
//  Uses the default compression level.
+ (NSData *)gtm_dataByDeflatingData:(NSData *)data;

/// Return an autoreleased NSData w/ the result of deflating the bytes using |level| compression level.
//
// |level| can be 1-9, any other values will be clipped to that range.
+ (NSData *)gtm_dataByDeflatingBytes:(const void *)bytes
                              length:(NSUInteger)length
                    compressionLevel:(int)level;

/// Return an autoreleased NSData w/ the result of deflating the payload of |data| using |level| compression level.
+ (NSData *)gtm_dataByDeflatingData:(NSData *)data
                   compressionLevel:(int)level;

#pragma mark Uncompress of Gzip or Zlib

/// Return an autoreleased NSData w/ the result of decompressing the bytes.
//
// The bytes to decompress can be zlib or gzip payloads.
+ (NSData *)gtm_dataByInflatingBytes:(const void *)bytes
                              length:(NSUInteger)length;

/// Return an autoreleased NSData w/ the result of decompressing the payload of |data|.
//
// The data to decompress can be zlib or gzip payloads.
+ (NSData *)gtm_dataByInflatingData:(NSData *)data;


#pragma mark "Raw" Compression Support

// NOTE: raw deflate is *NOT* gzip or deflate.  it does not include a header
// of any form and should only be used within streams here an external crc/etc.
// is done to validate the data.  The RawInflate apis can be used on data
// processed like this.

/// Return an autoreleased NSData w/ the result of *raw* deflating the bytes.
//
//  Uses the default compression level.
//  *No* header is added to the resulting data.
+ (NSData *)gtm_dataByRawDeflatingBytes:(const void *)bytes
                                 length:(NSUInteger)length;

/// Return an autoreleased NSData w/ the result of *raw* deflating the payload of |data|.
//
//  Uses the default compression level.
//  *No* header is added to the resulting data.
+ (NSData *)gtm_dataByRawDeflatingData:(NSData *)data;

/// Return an autoreleased NSData w/ the result of *raw* deflating the bytes using |level| compression level.
//
// |level| can be 1-9, any other values will be clipped to that range.
//  *No* header is added to the resulting data.
+ (NSData *)gtm_dataByRawDeflatingBytes:(const void *)bytes
                                 length:(NSUInteger)length
                       compressionLevel:(int)level;

/// Return an autoreleased NSData w/ the result of *raw* deflating the payload of |data| using |level| compression level.
//  *No* header is added to the resulting data.
+ (NSData *)gtm_dataByRawDeflatingData:(NSData *)data
                      compressionLevel:(int)level;

/// Return an autoreleased NSData w/ the result of *raw* decompressing the bytes.
//
// The data to decompress, it should *not* have any header (zlib nor gzip).
+ (NSData *)gtm_dataByRawInflatingBytes:(const void *)bytes
                                 length:(NSUInteger)length;

/// Return an autoreleased NSData w/ the result of *raw* decompressing the payload of |data|.
//
// The data to decompress, it should *not* have any header (zlib nor gzip).
+ (NSData *)gtm_dataByRawInflatingData:(NSData *)data;

@end
