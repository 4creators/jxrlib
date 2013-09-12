//*@@@+++@@@@******************************************************************
//
// Copyright © Microsoft Corp.
// All rights reserved.
// 
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
// 
// • Redistributions of source code must retain the above copyright notice,
//   this list of conditions and the following disclaimer.
// • Redistributions in binary form must reproduce the above copyright notice,
//   this list of conditions and the following disclaimer in the documentation
//   and/or other materials provided with the distribution.
// 
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.
//
//*@@@---@@@@******************************************************************
#define _CRT_SECURE_NO_WARNINGS
#include <JXRTest.h>
#include <errno.h>

inline unsigned char clip_c(int v)
{
	if( v > 255 )    return 255;
	else if( v < 0 ) return 0;
	else             return (unsigned char)v;
}

void
unpack_yuv(unsigned char* dest_buffer, int* decode_buffer, int width, int height)
{
    unsigned char* yps0 = dest_buffer;
    unsigned char* yps1 = dest_buffer+width;
    unsigned char* ups  = dest_buffer+width*height;
    unsigned char* vps  = ups + (width>>1)*(height>>1);

    int* dp = decode_buffer;

    // JXR decoder generates Y00 Y10 Y01 Y11 U0 V0 packed and as signed integers
	int x, y;
    for( y = 0; y < height; y+=2 ) {
        for( x = 0; x < width; x+=2, dp+=6, yps0+=2, yps1+=2, ups++, vps++) {
            *(yps0+0) = clip_c((dp[0] >> 3) + 128);
            *(yps0+1) = clip_c((dp[1] >> 3) + 128);
            *(yps1+0) = clip_c((dp[2] >> 3) + 128);
            *(yps1+1) = clip_c((dp[3] >> 3) + 128);
            *ups      = clip_c((dp[4] >> 3) + 128);
            *vps      = clip_c((dp[5] >> 3) + 128);
        }
        yps0 += width;
        yps1 += width;
    }
}

//================================================================
// main function
//================================================================
int 
#ifndef __ANSI__
__cdecl 
#endif // __ANSI__
main(int argc, char* argv[])
{
    if (argc != 3) {
        fprintf(stderr, "Required arguments:\n");
        fprintf(stderr, "1. Path to JXR input file\n");
        fprintf(stderr, "2. Path to YUV output file\n");
        return 1;
    }

    errno = 0;

    /* Will check these for validity when opening via 'fopen'. */
    const char *jxr_path = argv[1];
    const char *yuv_path = argv[2];

    /* the planar YUV buffer */
    unsigned char *image_buffer = NULL;
    int yuv_size = 0;

    {
        ERR err = WMP_errSuccess;

        int width, height;
        PKCodecFactory* pCodecFactory = NULL;
        PKImageDecode*  pDecoder      = NULL;
        int* decode_buffer            = NULL;

        Call( PKCreateCodecFactory(&pCodecFactory, WMP_SDK_VERSION) );
        Call( pCodecFactory->CreateDecoderFromFile(jxr_path, &pDecoder) );
        
        // check that pixel format is YCC 4:2:0
        PKPixelFormatGUID pix_frmt;
        Call( pDecoder->GetPixelFormat(pDecoder, &pix_frmt) );
        if( memcmp(&pix_frmt, &GUID_PKPixelFormat12bppYCC420, 
                   sizeof(PKPixelFormatGUID)) != 0 ) {
            err = WMP_errFail;
            goto Cleanup;
        }
        
        // get the dimensions
        Call( pDecoder->GetSize(pDecoder, &width, &height) );
		yuv_size = width*height+2*(width>>1)*(height>>1);

        // decode
        PKRect rc;
        rc.X = 0;
        rc.Y = 0;
        rc.Width  = width;
        rc.Height = height;
    
        pDecoder->WMP.wmiSCP.bYUVData = TRUE;
        
        decode_buffer = (int*)malloc(4*yuv_size);
        Call( pDecoder->Copy(pDecoder, &rc, (U8*)decode_buffer, width*3*4) );
    
        // unpack the decoded result
        image_buffer = (unsigned char*)malloc(width*height+2*(width>>1)*(height>>1));
        unpack_yuv(image_buffer, decode_buffer, width, height);

    Cleanup:
        if( pDecoder )      pDecoder->Release(&pDecoder);
        if( pCodecFactory ) pCodecFactory->Release(&pCodecFactory);
        free(decode_buffer);
        if( err != WMP_errSuccess ) {
            fprintf(stderr, "Failed to decode\n");
            return 1;
        }
    }

    FILE *yuv_fd = fopen(yuv_path, "wb");
    if (!yuv_fd) {
        fprintf(stderr, "Invalid path to YUV file!");
        return 1;
    }

    fwrite(image_buffer, yuv_size, 1, yuv_fd);
    fclose(yuv_fd);
    free(image_buffer);

    return 0;
}
