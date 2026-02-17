cmake_minimum_required(VERSION 3.21)
project(rtlsdr)

if(CMAKE_SIZEOF_VOID_P EQUAL 8)
	set(ARCH_DIR "x64")
elseif(CMAKE_SIZEOF_VOID_P EQUAL 4)
	set(ARCH_DIR "x86")
else()
    message(FATAL_ERROR "sizeof(void*)=${CMAKE_SIZEOF_VOID_P} rtlsdr is unsupported")
endif()

message(STATUS "Using ${ARCH_DIR} build of rtlsdr")

set(SRC_DIR ${CMAKE_CURRENT_LIST_DIR})
add_library(rtlsdr::rtlsdr SHARED IMPORTED)
set_target_properties(rtlsdr::rtlsdr PROPERTIES 
	INTERFACE_INCLUDE_DIRECTORIES   ${SRC_DIR}/libusb
	IMPORTED_IMPLIB                 ${SRC_DIR}/libusb/${ARCH_DIR}/dll/libusb-1.0.lib
	IMPORTED_LOCATION               ${SRC_DIR}/libusb/${ARCH_DIR}/libusb.dll
)

# NOTE: rtlsdr_static doesn't include libusb or pthread symbols
add_library(libusb::libusb_static STATIC IMPORTED)
set_target_properties(rtlsdr::rtlsdr_static PROPERTIES
	INTERFACE_INCLUDE_DIRECTORIES   ${SRC_DIR}/libusb
	IMPORTED_LOCATION               ${SRC_DIR}/${ARCH_DIR}/static/libusb-1.0.lib
	INTERFACE_COMPILE_DEFINITIONS   librtlsdr_STATIC
)