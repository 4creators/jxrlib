##//*@@@+++@@@@******************************************************************
##//
##// Copyright © Microsoft Corp.
##// All rights reserved.
##// 
##// Redistribution and use in source and binary forms, with or without
##// modification, are permitted provided that the following conditions are met:
##// 
##// • Redistributions of source code must retain the above copyright notice,
##//   this list of conditions and the following disclaimer.
##// • Redistributions in binary form must reproduce the above copyright notice,
##//   this list of conditions and the following disclaimer in the documentation
##//   and/or other materials provided with the distribution.
##// 
##// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
##// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
##// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
##// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
##// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
##// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
##// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
##// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
##// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
##// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
##// POSSIBILITY OF SUCH DAMAGE.
##//
##//*@@@---@@@@******************************************************************
## Makefile for building JPEG XR Porting Kit
##
build: all

CC=cc

DIR_SYS=image/sys
DIR_DEC=image/decode
DIR_ENC=image/encode

DIR_GLUE=jxrgluelib
DIR_TEST=jxrtestlib
DIR_EXEC=jxrencoderdecoder

## Are we building shared?
ifneq ($(SHARED),)
PICFLAG=-fPIC
else
PICFLAG=
endif

ifneq ($(BIG_ENDIAN),)
ENDIANFLAG=-D_BIG__ENDIAN_
else
ENDIANFLAG=
endif

CFLAGS=-I. -Icommon/include -I$(DIR_SYS) $(ENDIANFLAG) -D__ANSI__ -DDISABLE_PERF_MEASUREMENT -w $(PICFLAG) -O

##--------------------------------
##
## Common files
##

OBJ_SYS=adapthuff.o image.o strcodec.o strPredQuant.o strTransform.o perfTimerANSI.o

$(OBJ_SYS):
	$(CC) $(CFLAGS) -c $(DIR_SYS)/$*.c


##--------------------------------
##
## Decode files
##

OBJ_DEC=decode.o postprocess.o segdec.o strdec.o strInvTransform.o strPredQuantDec.o JXRTranscode.o

$(OBJ_DEC):
	$(CC) $(CFLAGS) -c $(DIR_DEC)/$*.c


##--------------------------------
##
## Encode files
##

OBJ_ENC=encode.o segenc.o strenc.o strFwdTransform.o strPredQuantEnc.o

$(OBJ_ENC):
	$(CC) $(CFLAGS) -c $(DIR_ENC)/$*.c

##--------------------------------
##
## JPEG XR library
##

libjpegxr.a: $(OBJ_ENC) $(OBJ_DEC) $(OBJ_SYS)
	ar rvu $@ $(OBJ_ENC) $(OBJ_DEC) $(OBJ_SYS)
	ranlib $@

libjpegxr.so: $(OBJ_ENC) $(OBJ_DEC) $(OBJ_SYS)
	$(CC) -shared -o $@ $(OBJ_ENC) $(OBJ_DEC) $(OBJ_SYS)

##--------------------------------
##
## Glue files
##

OBJ_GLUE=JXRGlue.o JXRMeta.o JXRGluePFC.o JXRGlueJxr.o

$(OBJ_GLUE):
	$(CC) $(CFLAGS) -I$(DIR_GLUE) -c $(DIR_GLUE)/$*.c

##--------------------------------
##
## Test files
##

OBJ_TEST=JXRTest.o JXRTestBmp.o JXRTestHdr.o JXRTestPnm.o JXRTestTif.o JXRTestYUV.o

$(OBJ_TEST):
	$(CC) $(CFLAGS) -I$(DIR_GLUE) -I$(DIR_TEST) -c $(DIR_TEST)/$*.c

##--------------------------------
##
## JPEG XR Glue library
##
libjxrglue.a: $(OBJ_GLUE) $(OBJ_TEST)
	ar rvu $@ $(OBJ_GLUE) $(OBJ_TEST)
	ranlib $@

libjxrglue.so: $(OBJ_GLUE) $(OBJ_TEST)
	$(CC) -shared -o $@ -L. -ljpegxr $(OBJ_GLUE) $(OBJ_TEST)

##--------------------------------
##
## Enc app files
##

ifneq ($(SHARED),)
LIBRARIES=libjpegxr.so libjxrglue.so
else
LIBRARIES=libjpegxr.a libjxrglue.so
endif

LIBS=-L. $(shell echo $(LIBRARIES) | sed -e 's/lib\([^ ]*\)\.\(a\|so\)/-l\1/g') -lm
ENCAPP=JxrEncApp

$(ENCAPP): $(LIBRARIES) 
	$(CC) $(DIR_EXEC)/$(ENCAPP).c -o $(ENCAPP) $(CFLAGS) -I$(DIR_GLUE) -I$(DIR_TEST) $(LIBS)

##--------------------------------
##
## Dec app files
##

DECAPP=JxrDecApp

$(DECAPP): $(LIBRARIES) 
	$(CC) $(DIR_EXEC)/$(DECAPP).c -o $(DECAPP) $(CFLAGS) -I$(DIR_GLUE) -I$(DIR_TEST) $(LIBS)

##--------------------------------
##
## JPEG XR library
##
all: $(ENCAPP) $(DECAPP)

clean:
	rm -rf *App *.o libj*.a libj*.so

##
