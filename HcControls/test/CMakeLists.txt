cmake_minimum_required(VERSION 3.16)

project(test VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTOUIC ON)
set(CMAKE_CXX_STANDARD 17)

#导入Qt相关依赖包
find_package(QT NAMES Qt6 Qt5 REQUIRED COMPONENTS Quick Svg)
find_package(Qt${QT_VERSION_MAJOR} REQUIRED COMPONENTS Quick Svg)

qt_standard_project_setup(REQUIRES 6.5)

#设置可执行文件输出目录
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_SOURCE_DIR}/bin/${CMAKE_BUILD_TYPE})
if (APPLE)
    set(APPLICATION_DIR_PATH ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/${PROJECT_NAME}.app/Contents/MacOS)
else ()
    set(APPLICATION_DIR_PATH ${CMAKE_RUNTIME_OUTPUT_DIRECTORY})
endif ()

### 12
file(GLOB_RECURSE SRC_FILES "${CMAKE_CURRENT_SOURCE_DIR}/src/*.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/src/*.h"
)
qt_add_executable(test
    ${SRC_FILES}
)
file(GLOB_RECURSE QML_FILES RELATIVE "${CMAKE_CURRENT_SOURCE_DIR}" "${CMAKE_CURRENT_SOURCE_DIR}/*.qml")
qt_add_qml_module(test
    URI test
    VERSION 1.0
    QML_FILES ${QML_FILES}
)

add_dependencies(${PROJECT_NAME} Script-UpdateTranslations)

#添加国际化脚本

find_program(LUPDATE_EXECUTABLE lupdate)
find_program(LRELEASE_EXECUTABLE lrelease)
# find_program(QT_LUPDATE NAMES lupdate lupdate-qt6)
# find_program(QT_LRELEASE NAMES lrelease lrelease-qt6)
file(GLOB TS_FILE_PATHS ${CMAKE_CURRENT_LIST_DIR}/ *.ts)
add_custom_target(Script-UpdateTranslations
        COMMAND ${QT_LUPDATE} ${CMAKE_CURRENT_LIST_DIR} -ts ${PROJECT_NAME}_en_US.ts WORKING_DIRECTORY ${CMAKE_CURRENT_LIST_DIR}
        COMMAND ${QT_LUPDATE} ${CMAKE_CURRENT_LIST_DIR} -ts ${PROJECT_NAME}_zh_CN.ts WORKING_DIRECTORY ${CMAKE_CURRENT_LIST_DIR}
        COMMAND ${QT_LRELEASE} ${PROJECT_NAME}_en_US.ts WORKING_DIRECTORY ${CMAKE_CURRENT_LIST_DIR}
        COMMAND ${QT_LRELEASE} ${PROJECT_NAME}_zh_CN.ts WORKING_DIRECTORY ${CMAKE_CURRENT_LIST_DIR}
        COMMAND ${CMAKE_COMMAND} -E make_directory ${APPLICATION_DIR_PATH}/i18n
        COMMAND ${CMAKE_COMMAND} -E copy ${PROJECT_NAME}_en_US.qm ${PROJECT_NAME}_zh_CN.qm ${APPLICATION_DIR_PATH}/i18n
        SOURCES ${TS_FILE_PATHS}
)


# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(test PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.test
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

#复制程序运行所需要的动态库
if (WIN32)
    if (MSVC)
        if (CMAKE_SIZEOF_VOID_P EQUAL 4)
            file(GLOB_RECURSE 3RDPARTY_DLL_DIR ${CMAKE_SOURCE_DIR}/3rdparty/msvc/x86/*.dll)
        elseif (CMAKE_SIZEOF_VOID_P EQUAL 8)
            file(GLOB_RECURSE 3RDPARTY_DLL_DIR ${CMAKE_SOURCE_DIR}/3rdparty/msvc/x64/*.dll)
        endif ()
    elseif (MINGW)
        file(GLOB_RECURSE 3RDPARTY_DLL_DIR ${CMAKE_SOURCE_DIR}/3rdparty/mingw/*.dll)
    endif ()
    file(COPY ${3RDPARTY_DLL_DIR} DESTINATION ${CMAKE_RUNTIME_OUTPUT_DIRECTORY})
endif ()

#复制FluentUI源码到运行目录下，用于脚手架生成
file(MAKE_DIRECTORY ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/source/)
file(COPY ${CMAKE_SOURCE_DIR}/HcControls/ DESTINATION ${APPLICATION_DIR_PATH}/source/)

#导入component头文件,不然通过QML_NAMED_ELEMENT生成的c++类会找不到头文件报错
target_include_directories(${PROJECT_NAME} PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/src/component
)

#Release也支持日志打印代码位置
target_compile_definitions(${PROJECT_NAME}
        PRIVATE
        QT_MESSAGELOGCONTEXT
)

target_link_libraries(test PRIVATE
    Qt6::Quick
)

include(GNUInstallDirs)
install(TARGETS test
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
