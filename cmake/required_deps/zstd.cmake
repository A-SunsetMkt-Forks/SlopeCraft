

find_package(ZSTD QUIET)
if (NOT ZSTD_FOUND)
    message(STATUS "Failed to find zstd with \"find_package\", try importing manually...")
    find_library(zstd_lib_loc NAMES zstd REQUIRED)
    message(STATUS "Found zstd manually at ${zstd_lib_loc}")

    cmake_path(GET zstd_lib_loc EXTENSION zstd_lib_ext)
    message(STATUS "zstd_lib_ext: ${zstd_lib_ext}")
    set(zstd_is_shared OFF)
    set(shared_lib_extension ".dll;.so;.dylib")
    foreach (shared_lib_ext ${shared_lib_extension})
        if (${zstd_lib_ext} MATCHES ${shared_lib_ext})
            set(zstd_is_shared ON)
            break()
        endif ()
    endforeach ()
    if (${zstd_is_shared})
        add_library(zstd_manually_imported SHARED IMPORTED)
    else ()
        add_library(zstd_manually_imported STATIC IMPORTED)
    endif ()
    set_target_properties(zstd_manually_imported PROPERTIES
        IMPORTED_LOCATION ${zstd_lib_loc})
    find_file(zstd_header_loc NAMES zstd.h
        HINTS "/usr/lib/include/zstd.h")
    if (zstd_header_loc)
        cmake_path(GET zstd_header_loc PARENT_PATH zstd_include_dir)
        target_include_directories(zstd_manually_imported INTERFACE ${zstd_include_dir})
    endif ()
    #    cmake_path(GET zstd_lib_loc PARENT_PATH zstd_install_dir)
    #    cmake_path(GET zstd_install_dir PARENT_PATH zstd_install_dir)
    #    target_include_directories(zstd_manually_imported INTERFACE "${zstd_install_dir}/include")
endif ()

set(SC_zstd_target_name "")
if (TARGET zstd::libzstd_shared)
    set(SC_zstd_target_name "zstd::libzstd_shared")
elseif (TARGET zstd::zstd)
    set(SC_zstd_target_name "zstd::zstd")
elseif (TARGET zstd::libzstd_static)
    set(SC_zstd_target_name "zstd::libzstd_static")
elseif (TARGET zstd_manually_imported)
    set(SC_zstd_target_name "zstd_manually_imported")
elseif ()
    message(FATAL_ERROR "No zstd library target imported.")
endif ()
message(STATUS "Found zstd: ${SC_zstd_target_name}")