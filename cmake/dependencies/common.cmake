# load common dependencies
# this file will also load platform specific dependencies

# submodules
# moonlight common library
set(ENET_NO_INSTALL ON CACHE BOOL "Don't install any libraries build for enet")
add_subdirectory(third-party/moonlight-common-c/enet)

# web server
add_subdirectory(third-party/Simple-Web-Server)

# common dependencies
find_package(OpenSSL REQUIRED)
find_package(PkgConfig REQUIRED)
find_package(Threads REQUIRED)
pkg_check_modules(CURL REQUIRED libcurl)

# miniupnp
pkg_check_modules(MINIUPNP miniupnpc REQUIRED)
include_directories(SYSTEM ${MINIUPNP_INCLUDE_DIRS})

# ffmpeg pre-compiled binaries
pkg_check_modules(FFMPEG ffmpeg-sunshine)

if(NOT FFMPEG_FOUND)
    set(FFMPEG_PREFIX ${CMAKE_SOURCE_DIR}/third-party/build-deps/ffmpeg/${CMAKE_SYSTEM_NAME}-${CMAKE_SYSTEM_PROCESSOR})

    if(NOT EXISTS ${FFMPEG_PREFIX}/ffmpeg-sunshine.pc.inx)
        message(FATAL_ERROR "Unsupported operating system (${CMAKE_SYSTEM_NAME}) and processor (${CMAKE_SYSTEM_PROCESSOR}) combination")
    endif()

    configure_file(${FFMPEG_PREFIX}/ffmpeg-sunshine.pc.in ffmpeg-sunshine.pc @ONLY)
    set(ENV{PKG_CONFIG_PATH} ${CMAKE_CURRENT_BINARY_DIR}:$ENV{PKG_CONFIG_PATH})
    pkg_check_modules(FFMPEG ffmpeg-sunshine REQUIRED NO_CMAKE_PATH NO_CMAKE_ENVIRONMENT_PATH)
endif()

# platform specific dependencies
if(WIN32)
    include(${CMAKE_MODULE_PATH}/dependencies/windows.cmake)
elseif(UNIX)
    include(${CMAKE_MODULE_PATH}/dependencies/unix.cmake)

    if(APPLE)
        include(${CMAKE_MODULE_PATH}/dependencies/macos.cmake)
    else()
        include(${CMAKE_MODULE_PATH}/dependencies/linux.cmake)
    endif()
endif()
