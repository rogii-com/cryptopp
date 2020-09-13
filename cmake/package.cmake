if(TARGET Cryptopp)
    return()
endif()

set(
    CRYPTOPP_INCLUDE_PATH
    "${CMAKE_CURRENT_LIST_DIR}/include"
)

set(
    CRYPTOPP_STATIC_LIBRARY_PATH
    "${CMAKE_CURRENT_LIST_DIR}/lib"
)

add_library(
    Cryptopp
    STATIC
    IMPORTED
)

if(MSVC)
    set_target_properties(
        Cryptopp
        PROPERTIES
        IMPORTED_LOCATION
            "${CRYPTOPP_STATIC_LIBRARY_PATH}/cryptlib.lib"
        IMPORTED_LOCATION_DEBUG
            "${CRYPTOPP_STATIC_LIBRARY_PATH}/cryptlibd.lib"
        INTERFACE_INCLUDE_DIRECTORIES
            "${CRYPTOPP_INCLUDE_PATH}"
    )
elseif(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
    set_target_properties(
        Cryptopp
        PROPERTIES
        IMPORTED_LOCATION
            "${CRYPTOPP_STATIC_LIBRARY_PATH}/libcryptopp.a"
        IMPORTED_LOCATION_DEBUG
            "${CRYPTOPP_STATIC_LIBRARY_PATH}/libcryptoppd.a"
        INTERFACE_INCLUDE_DIRECTORIES
            "${CRYPTOPP_INCLUDE_PATH}"
    )
endif()
