file(GLOB_RECURSE rc_msstyles_bitmaps ${CMAKE_CURRENT_BINARY_DIR}/bitmaps/*)
add_rc_deps(rapps.rc ${rc_msstyles_bitmaps})

file(GLOB_RECURSE rc_msstyles_lang ${CMAKE_CURRENT_BINARY_DIR}/lang/*)
add_rc_deps(rapps.rc ${rc_msstyles_lang})

file(GLOB_RECURSE rc_msstyles_textfiles ${CMAKE_CURRENT_BINARY_DIR}/textfiles/*)
add_rc_deps(rapps.rc ${rc_msstyles_textfiles})

list(APPEND TEXTFILES
    textfiles/Light/ExtraLargeLight.INI
    textfiles/Light/LargeFontsLight.INI
    textfiles/Light/NormalLight.INI
    textfiles/Dark/ExtraLargeDark.INI
    textfiles/Dark/LargeFontsDark.INI
    textfiles/Dark/NormalDark.INI)

file(MAKE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/textfiles)
foreach(_file ${TEXTFILES})
    get_filename_component(_file_name ${_file} NAME_WE)
    string(REPLACE ${CMAKE_SOURCE_DIR} ${CMAKE_BINARY_DIR} _converted_file "${_file}")
    string(REPLACE ${_file_name} "${_file_name}_utf16" _converted_file ${_converted_file})
    set(_file ${CMAKE_CURRENT_SOURCE_DIR}/${_file})
    set(_converted_file ${CMAKE_CURRENT_BINARY_DIR}/${_converted_file})
    add_custom_command(OUTPUT ${_converted_file}
                       COMMAND native-utf16le ${_file} ${_converted_file}
                       DEPENDS native-utf16le ${_file})
    list(APPEND _converted_files ${_converted_file})
endforeach()

set_source_files_properties(noble.rc PROPERTIES OBJECT_DEPENDS "${_converted_files}")
add_library(noble.msstyles SHARED noble.rc)
set_module_type(noble.msstyles module)
set_target_properties(noble.msstyles PROPERTIES SUFFIX "")
add_cd_file(TARGET noble.msstyles DESTINATION reactos/Resources/Themes/Noble FOR all)
