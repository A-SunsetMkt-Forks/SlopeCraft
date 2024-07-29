cmake_minimum_required(VERSION 3.29)

find_package(ZLIB REQUIRED)

set(NBT_BUILD_SHARED OFF CACHE BOOL "")
set(NBT_BUILD_TESTS OFF CACHE BOOL "")
FetchContent_Declare(libnbt++
    GIT_REPOSITORY https://github.com/PrismLauncher/libnbtplusplus
    GIT_TAG 23b955121b8217c1c348a9ed2483167a6f3ff4ad #Merge pull request #3 from TheKodeToad/max-depth-attempt2
    OVERRIDE_FIND_PACKAGE
    EXCLUDE_FROM_ALL)
message(STATUS "Cloning libnbt++...")
FetchContent_MakeAvailable(libnbt++)
find_package(libnbt++ REQUIRED)

target_link_libraries(nbt++ ZLIB::ZLIB)