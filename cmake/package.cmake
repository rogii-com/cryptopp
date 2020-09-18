if(TARGET Cryptopp)
    return()
endif()

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
            "${CMAKE_CURRENT_LIST_DIR}/lib/cryptlib.lib"
        IMPORTED_LOCATION_DEBUG
            "${CMAKE_CURRENT_LIST_DIR}/lib/cryptlibd.lib"
        INTERFACE_INCLUDE_DIRECTORIES
            "${CMAKE_CURRENT_LIST_DIR}/include"
    )
elseif(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
    set_target_properties(
        Cryptopp
        PROPERTIES
        IMPORTED_LOCATION
            "${CMAKE_CURRENT_LIST_DIR}/lib/libcryptopp.a"
        IMPORTED_LOCATION_DEBUG
            "${CMAKE_CURRENT_LIST_DIR}/lib/libcryptoppd.a"
        INTERFACE_INCLUDE_DIRECTORIES
            "${CMAKE_CURRENT_LIST_DIR}/include"
    )
endif()
