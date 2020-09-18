if(NOT DEFINED ENV{ENV_INSTALL})
    message(
        FATAL_ERROR
        "You have to specify an install path via `ENV_INSTALL' variable."
    )
endif()

file(
    TO_CMAKE_PATH
    "$ENV{ENV_INSTALL}"
    ROOT
)

set(
    ARCH
    x86
)

if(WIN32)
    set(
        MSBUILD_ARCH
        win32
    )
endif()

include(
    "${CMAKE_CURRENT_LIST_DIR}/build_common.cmake"
)