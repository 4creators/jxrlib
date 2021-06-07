project(jxrlib C)
cmake_minimum_required(VERSION 3.9 FATAL_ERROR)
cmake_policy(VERSION 3.9)

set(CMAKE_POSITION_INDEPENDENT_CODE ON)

set(JXRLIB_HEADER_FILES
    common/include/guiddef.h
    common/include/wmsal.h
    common/include/wmspecstring.h
    common/include/wmspecstrings_adt.h
    common/include/wmspecstrings_strict.h

    image/sys/windowsmediaphoto.h

    jxrgluelib/JXRGlue.h
    jxrgluelib/JXRMeta.h

    jxrtestlib/JXRTest.h
)

add_library(jxrlib STATIC

    image/decode/JXRTranscode.c
    image/decode/decode.c
    image/decode/postprocess.c
    image/decode/segdec.c
    image/decode/strInvTransform.c
    image/decode/strPredQuantDec.c
    image/decode/strdec.c
    image/decode/strdec_x86.c

    image/encode/encode.c
    image/encode/segenc.c
    image/encode/strFwdTransform.c
    image/encode/strPredQuantEnc.c
    image/encode/strenc.c
    image/encode/strenc_x86.c

    image/sys/adapthuff.c
    image/sys/image.c
    image/sys/perfTimerANSI.c
    image/sys/strPredQuant.c
    image/sys/strTransform.c
    image/sys/strcodec.c

    jxrgluelib/JXRGlue.c
    jxrgluelib/JXRGlueJxr.c
    jxrgluelib/JXRGluePFC.c
    jxrgluelib/JXRMeta.c

    jxrtestlib/JXRTest.c
    jxrtestlib/JXRTestBmp.c
    jxrtestlib/JXRTestHdr.c
    jxrtestlib/JXRTestPnm.c
    jxrtestlib/JXRTestTif.c
    jxrtestlib/JXRTestYUV.c
)
add_library(jxrlib::jxrlib ALIAS jxrlib)

if(CMAKE_CXX_COMPILER_ID MATCHES "Clang") # Clang + AppleClang
    target_compile_options(jxrlib
        PUBLIC
            -Wno-extra-tokens
        PRIVATE
            -Wno-unused-value
            -Wno-dangling-else
            -Wno-constant-conversion
            -Wno-shift-negative-value
            -Wno-implicit-function-declaration
            -Wno-deprecated-declarations
            -Wno-incompatible-pointer-types
            -Wno-incompatible-pointer-types-discards-qualifiers
    )
endif()

target_compile_definitions(jxrlib
PUBLIC
    __ANSI__
    DISABLE_PERF_MEASUREMENT
)

include(GNUInstallDirs)

set(JXRLIB_INCLUDEDIR ${CMAKE_INSTALL_INCLUDEDIR}/jxrlib)
set(JXRLIB_CONFIGDIR ${CMAKE_INSTALL_LIBDIR}/cmake/jxrlib)
set(JXRLIB_LIBDIR ${CMAKE_INSTALL_LIBDIR})

target_include_directories(jxrlib
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/common/include>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/image/sys>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/image/x86>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/jxrgluelib>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/jxrtestlib>
        $<INSTALL_INTERFACE:${JXRLIB_INCLUDEDIR}>
)

install(TARGETS jxrlib
EXPORT
    jxrlib_targets
LIBRARY DESTINATION ${JXRLIB_LIBDIR}
ARCHIVE DESTINATION ${JXRLIB_LIBDIR}
)

install(FILES ${JXRLIB_HEADER_FILES}
DESTINATION ${JXRLIB_INCLUDEDIR}
COMPONENT Devel
)

install(EXPORT jxrlib_targets
  FILE jxrlib_targets.cmake
  NAMESPACE jxrlib::
  DESTINATION ${JXRLIB_CONFIGDIR}
)

include(CMakePackageConfigHelpers)

configure_package_config_file(${CMAKE_CURRENT_LIST_DIR}/jxrlibConfig.cmake.in
  ${CMAKE_CURRENT_BINARY_DIR}/jxrlibConfig.cmake
  INSTALL_DESTINATION ${JXRLIB_CONFIGDIR}
)

install(FILES
  ${CMAKE_CURRENT_BINARY_DIR}/jxrlibConfig.cmake
  DESTINATION ${JXRLIB_CONFIGDIR}
)
