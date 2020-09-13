if(NOT DEFINED ROOT OR NOT DEFINED ARCH)
    message(
	FATAL_ERROR 
	    "Assert: ROOT = ${ROOT}; ARCH = ${ARCH}"
    )
endif()

include("${CMAKE_CURRENT_LIST_DIR}/Version.cmake")

set(
    BUILD
	0
)

if(DEFINED ENV{BUILD_NUMBER})
    set(
	BUILD
	    $ENV{BUILD_NUMBER}
    )
endif()

set(
    TAG
	""
)

if(DEFINED ENV{TAG})
    set(
	TAG
	    "$ENV{TAG}"
    )
endif()

set(
    BUILD_PATH
	"${CMAKE_CURRENT_LIST_DIR}/../build"
)

set(
    PACKAGE_NAME
	"cryptopp-${VERSION}-${ARCH}-${BUILD}${TAG}"
)

set(
    CMAKE_INSTALL_PREFIX
	${ROOT}/${PACKAGE_NAME}
)

set(
    GNU_RELEASE_LIBS_NAME
	"libcryptopp"
)

set(
    GNU_DEBUG_LIBS_NAME
	${GNU_RELEASE_LIBS_NAME}d
)

set(
    MSVS_RELEASE_LIBS_NAME
	"cryptlib"
)

set(
    MSVS_DEBUG_LIBS_NAME
	${MSVS_RELEASE_LIBS_NAME}d
)

if(WIN32)
    if(NOT ${ARCH} MATCHES x86)
	set(
	    MSBUILD_ARCH
		x64
	)
    else()
	set(
	    MSBUILD_ARCH
		win32
	)
    endif()

    execute_process(
	COMMAND
	    msbuild cryptlib.vcxproj /t:Build /p:Configuration=Release /p:Platform=${MSBUILD_ARCH}
	WORKING_DIRECTORY
	    "${BUILD_PATH}/.."
    )

    execute_process(
	COMMAND
	    msbuild cryptlib.vcxproj /t:Build /p:Configuration=Debug /p:Platform=${MSBUILD_ARCH}
	WORKING_DIRECTORY
	    "${BUILD_PATH}/.."
    )

    file(
        COPY
		${MSBUILD_ARCH}/Output/Release/cryptlib.lib 
	DESTINATION
		${ROOT}/${PACKAGE_NAME}/lib/cryptlib.lib
    )

    file(
        COPY
		${MSBUILD_ARCH}/Output/Debug/cryptlib.lib
	DESTINATION
		${ROOT}/${PACKAGE_NAME}/lib/cryptlibd.lib
    )

    file(
        COPY
		${MSBUILD_ARCH}/Output/Debug/cryptlib.pdb
	DESTINATION
		${ROOT}/${PACKAGE_NAME}/lib/cryptlib.pdb
    )

    file(
        COPY
		${MSBUILD_ARCH}/Output/Debug/cryptlib.pdb
	DESTINATION
		${ROOT}/${PACKAGE_NAME}/lib/cryptlibd.pdb
    )

    file(
	GLOB CRYPTOPP_PUBLIC_HEADERS
	    "${CMAKE_CURRENT_LIST_DIR}/../*.h"
    )

    file(
	COPY
	    ${CRYPTOPP_PUBLIC_HEADERS}
	DESTINATION
	    ${ROOT}/${PACKAGE_NAME}/include
    )

else()
    file(
	MAKE_DIRECTORY
	    ${BUILD_PATH}
    )

    set(
	ENV{LDFLAGS}
	    "-Wl,-rpath='\$$ORIGIN' -Wl,-rpath='\$$ORIGIN../'"
    )

    function(make isDebug)
	if(NOT ${isDebug} MATCHES "RELEASE")
    	    set(
		ENV{CXXFLAGS}
		    "-g2 -O2"
	    )
	endif()

	execute_process(
	    COMMAND
		make -j4
    	    WORKING_DIRECTORY
		"${BUILD_PATH}/.."
	)
    endfunction()

    function(clean)
	execute_process(
	    COMMAND
		make clean
	    WORKING_DIRECTORY
		"${BUILD_PATH}/.."
	)
    endfunction()

    function(install isDebug)
	if(NOT ${isDebug} MATCHES "RELEASE")
	    execute_process(
		COMMAND
		    ${CMAKE_COMMAND} -E copy 
			${BUILD_PATH}/../libcryptopp.a
			${CMAKE_INSTALL_PREFIX}/lib/libcryptoppd.a
		WORKING_DIRECTORY
		    "${BUILD_PATH}/.."
	    )
	else()
	    execute_process(
		COMMAND
		    make install 
			PREFIX=${CMAKE_INSTALL_PREFIX}
		WORKING_DIRECTORY
		    "${BUILD_PATH}/.."
	    )
	endif()
    endfunction()

    function(buildCrypto isDebug)
	message(
	    STATUS
		"STEP OF CLEANING IS STARTED WITH '${isDebug}' CONFIGURATION"
	)
	clean()

	message(
	    STATUS
		"STEP OF BUILDING IS STARTED WITH '${isDebug}' CONFIGURATION"
	)
	make(${isDebug})

	message(
	    STATUS
		"STEP INSTALLATION IS STARTED WITH ${isDebug} CONFIGURATION"
	)

	install(${isDebug})
    endfunction()

    buildCrypto("RELEASE")
    buildCrypto("DEBUG")
endif()

file(
    COPY
	"${CMAKE_CURRENT_LIST_DIR}/package.cmake" 
    DESTINATION
	"${ROOT}/${PACKAGE_NAME}"
)

message(
    STATUS
	"STEP PACKAGING IS STARTED"
)

execute_process(
    COMMAND
	"${CMAKE_COMMAND}" -E tar cf "${PACKAGE_NAME}.7z" --format=7zip -- "${PACKAGE_NAME}"
    WORKING_DIRECTORY
	"${ROOT}"
)