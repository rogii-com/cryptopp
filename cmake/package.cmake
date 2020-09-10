if(TARGET Cryptopp::static_library)
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
    Cryptopp::static_library
    STATIC
    IMPORTED
)

if(MSVC)
    set_target_properties(
        Cryptopp::static_library
        PROPERTIES
        IMPORTED_LOCATION
            "${CRYPTOPP_STATIC_LIBRARY_PATH}/libcryptopp.lib"
        IMPORTED_LOCATION_DEBUG
            "${CRYPTOPP_STATIC_LIBRARY_PATH}/libcryptoppd.lib"
        INTERFACE_INCLUDE_DIRECTORIES
            "${CRYPTOPP_INCLUDE_PATH}"
    )
elseif(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
    set_target_properties(
        Cryptopp::static_library
        PROPERTIES
        IMPORTED_LOCATION
            "${CRYPTOPP_STATIC_LIBRARY_PATH}/libcryptopp.a"
        IMPORTED_LOCATION_DEBUG
            "${CRYPTOPP_STATIC_LIBRARY_PATH}/libcryptoppd.a"
        INTERFACE_INCLUDE_DIRECTORIES
            "${CRYPTOPP_INCLUDE_PATH}/cryptopp"
    )
endif()
