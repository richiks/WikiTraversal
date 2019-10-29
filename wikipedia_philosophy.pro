TEMPLATE = app

# make sure we do not accidentally #include files placed in 'resources'
CONFIG += no_include_pwd

###############################################################################
# BEGIN SECTION FOR SPECIFYING SOURCE/LIBRARY/RESOURCE FILES OF PROJECT       #
###############################################################################

# checks to ensure that the Stanford C++ library and its associated
# Java back-end are both present in this project
!exists($$PWD/lib/StanfordCPPLib/private/version.h) {
    message(*** Stanford C++ library not found!)
    message(*** This project cannot run without the folder lib/StanfordCPPLib/.)
    message(*** Place that folder into your project and try again.)
    error(Exiting.)
}
!exists($$PWD/lib/spl.jar) {
    message(*** Stanford Java back-end library 'spl.jar' not found!)
    message(*** This project cannot run without spl.jar present.)
    message(*** Place that file into your lib/ folder and try again.)
    error(Exiting.)
}

win32 {
    !exists($$PWD/lib/addr2line.exe) {
        message(*** Stanford C++ library support file 'addr2line.exe' not found!)
        message(*** Our library needs this file present to produce stack traces.)
        message(*** Place that file into your lib/ folder and try again.)
        error(Exiting.)
    }
}

exists($$PWD/lib/StanfordCPPLib/*.cpp) {
    SOURCES += $$PWD/lib/StanfordCPPLib/*.cpp
}
SOURCES += $$PWD/lib/StanfordCPPLib/collections/*.cpp
SOURCES += $$PWD/lib/StanfordCPPLib/graphics/*.cpp
SOURCES += $$PWD/lib/StanfordCPPLib/io/*.cpp
SOURCES += $$PWD/lib/StanfordCPPLib/private/*.cpp
SOURCES += $$PWD/lib/StanfordCPPLib/system/*.cpp
SOURCES += $$PWD/lib/StanfordCPPLib/util/*.cpp
exists($$PWD/src/*.cpp) {
    SOURCES += $$PWD/src/*.cpp
}
exists($$PWD/src/test/*.cpp) {
    SOURCES += $$PWD/src/test/*.cpp
}
exists($$PWD/*.cpp) {
    SOURCES += $$PWD/*.cpp
}

exists($$PWD/lib/StanfordCPPLib/*.h) {
    HEADERS += $$PWD/lib/StanfordCPPLib/*.h
}
HEADERS += $$PWD/lib/StanfordCPPLib/collections/*.h
HEADERS += $$PWD/lib/StanfordCPPLib/graphics/*.h
HEADERS += $$PWD/lib/StanfordCPPLib/io/*.h
HEADERS += $$PWD/lib/StanfordCPPLib/private/*.h
HEADERS += $$PWD/lib/StanfordCPPLib/system/*.h
HEADERS += $$PWD/lib/StanfordCPPLib/util/*.h
exists($$PWD/src/test/*.h) {
    INCLUDEPATH += $$PWD/src/test/
}
exists($$PWD/*.h) {
    HEADERS += $$PWD/*.h
}

INCLUDEPATH += $$PWD/lib/StanfordCPPLib/
INCLUDEPATH += $$PWD/lib/StanfordCPPLib/collections/
INCLUDEPATH += $$PWD/lib/StanfordCPPLib/graphics/
INCLUDEPATH += $$PWD/lib/StanfordCPPLib/io/
INCLUDEPATH += $$PWD/lib/StanfordCPPLib/system/
INCLUDEPATH += $$PWD/lib/StanfordCPPLib/util/
INCLUDEPATH += $$PWD/src/
INCLUDEPATH += $$PWD/
exists($$PWD/src/autograder/*.h) {
    INCLUDEPATH += $$PWD/src/autograder/
}
exists($$PWD/src/test/*.h) {
    INCLUDEPATH += $$PWD/src/test/
}

# directories listed as "Other files" in left Project pane of Qt Creator
#OTHER_FILES += $$files(res/*)
#exists($$PWD/*.txt) {
#    OTHER_FILES += $$files($$PWD/*.txt)
#}
#exists($$PWD/input/*) {
#    OTHER_FILES += $$files(input/*)
#}
#exists($$PWD/output/*) {
#    OTHER_FILES += $$files(output/*)
#}

###############################################################################
# END SECTION FOR SPECIFYING SOURCE/LIBRARY/RESOURCE FILES OF PROJECT         #
###############################################################################


###############################################################################
# BEGIN SECTION FOR SPECIFYING COMPILER/LINKER FLAGS AND LIBRARIES            #
###############################################################################

# set up flags for the C++ compiler
# (In general, many warnings/errors are enabled to tighten compile-time checking.
# A few overly pedantic/confusing errors are turned off for simplicity.)
QMAKE_CXXFLAGS += -std=c++11
QMAKE_CXXFLAGS += -Wall
QMAKE_CXXFLAGS += -Wextra
QMAKE_CXXFLAGS += -Wreturn-type
QMAKE_CXXFLAGS += -Werror=return-type
QMAKE_CXXFLAGS += -Wunreachable-code
QMAKE_CXXFLAGS += -Wno-missing-field-initializers
QMAKE_CXXFLAGS += -Wno-sign-compare
QMAKE_CXXFLAGS += -Wno-write-strings

# additional flags for Windows
win32 {
    # increase system stack size (helpful for recursive programs)
    QMAKE_LFLAGS += -Wl,--stack,268435456
    LIBS += -lDbghelp
    LIBS += -lbfd
    LIBS += -limagehlp
}

# additional flags for Mac OS X
macx {
    # increase system stack size (helpful for recursive programs)
    # (this has been disabled because it led to crashes on many systems)
    #QMAKE_LFLAGS += -Wl,-stack_size,0x2000000

    # calling cache() reduces warnings on Mac OS X systems
    cache()
    QMAKE_MAC_SDK = macosx
}

# additional flags for Linux
unix:!macx {
    unix-g++ {
        QMAKE_CXXFLAGS += -rdynamic
        QMAKE_CXXFLAGS += -Wl,--export-dynamic
    }

    QMAKE_LFLAGS += -rdynamic
    QMAKE_LFLAGS += -Wl,--export-dynamic
}

# additional flags for non-Windows systems (Mac and Linux)
!win32 {
    #QMAKE_CXXFLAGS += -Wno-dangling-field
    QMAKE_CXXFLAGS += -Wno-unused-const-variable
    LIBS += -ldl
}

# set up configuration flags used internally by the Stanford C++ libraries
# These flags are all optional but can simplify project configuration.
# (setting x/y to 999999 centers the window)
# (see platform.cpp/h for descriptions of some of these flags)

# what version of the Stanford .pro is this? (kludgy integer YYYYMMDD format)
DEFINES += SPL_PROJECT_VERSION=20161013

# x/y location and w/h of the graphical console window; set to -1 to center
DEFINES += SPL_CONSOLE_X=-1
DEFINES += SPL_CONSOLE_Y=-1
DEFINES += SPL_CONSOLE_WIDTH=800
DEFINES += SPL_CONSOLE_HEIGHT=500

# echo graphical console onto the plain text console as well?
DEFINES += SPL_CONSOLE_ECHO

# quit the C++ program when the graphical console is closed?
DEFINES += SPL_CONSOLE_EXIT_ON_CLOSE

# crash if the Java back-end version is older than that specified in version.h?
DEFINES += SPL_VERIFY_JAVA_BACKEND_VERSION

# crash if the .pro is older than the minimum specified in version.h? (SPL_PROJECT_VERSION)
DEFINES += SPL_VERIFY_PROJECT_VERSION

# allow clients to access the internal data inside the heap of PriorityQueue?
# (used for some practice exam exercises/demos)
DEFINES += PQUEUE_ALLOW_HEAP_ACCESS

# should toString / << of a PriorityQueue display the elements in sorted order,
# or in heap internal order? the former is more expected by client; the latter
# is faster and avoids a deep-copy
DEFINES += PQUEUE_PRINT_IN_HEAP_ORDER

# should we throw an error() when operator >> fails on a collection?
# for years this was true, but the C++ standard says you should just silently
# set the fail bit on the stream and exit, so that has been made the default.
# DEFINES += SPL_ERROR_ON_STREAM_EXTRACT

# build-specific options (debug vs release)

# make 'debug' target (default) use no optimization, generate debugger symbols,
# and catch/print to console any uncaught exceptions thrown by the program
CONFIG(debug, debug|release) {
    QMAKE_CXXFLAGS += -O0
    QMAKE_CXXFLAGS += -g3
    QMAKE_CXXFLAGS += -ggdb3
    QMAKE_CXXFLAGS += -fno-inline

    # print details about uncaught exceptions with red error text / stack trace
    DEFINES += SPL_CONSOLE_PRINT_EXCEPTIONS
}

# make 'release' target be statically linked so it is a stand-alone executable
CONFIG(release, debug|release) {
    QMAKE_CXXFLAGS += -O2
    macx {
        QMAKE_POST_LINK += 'macdeployqt $${OUT_PWD}/$${TARGET}.app'
        #QMAKE_POST_LINK += 'macdeployqt $${OUT_PWD}/$${TARGET}.app && rm $${OUT_PWD}/*.o && rm $${OUT_PWD}/Makefile'
    }
    unix:!macx {
        QMAKE_LFLAGS += -static
        QMAKE_LFLAGS += -static-libgcc
        QMAKE_LFLAGS += -static-libstdc++
        #QMAKE_POST_LINK += 'rm $${OUT_PWD}/*.o && rm $${OUT_PWD}/Makefile'
    }
    win32 {
        TARGET_PATH = $${OUT_PWD}/release/$${TARGET}.exe
        TARGET_PATH ~= s,/,\\,g

        OUT_PATH = $${OUT_PWD}/
        OUT_PATH ~= s,/,\\,g

        REMOVE_DIRS += '"'$${OUT_PWD}/release'"'
        REMOVE_DIRS += '"'$${OUT_PWD}/debug'"'
        REMOVE_FILES += '"'$${OUT_PWD}/Makefile'"'
        REMOVE_FILES += '"'$${OUT_PWD}/Makefile.Debug'"'
        REMOVE_FILES += '"'$${OUT_PWD}/Makefile.Release'"'
        #REMOVE_FILES += '"'$${OUT_PWD}/object_script.$${TARGET}.Release'"'
        REMOVE_FILES += '"'$${OUT_PWD}/object_script.$${TARGET}.Debug'"'
        REMOVE_DIRS ~= s,/,\\,g
        REMOVE_FILES ~= s,/,\\,g

        QMAKE_LFLAGS += -static
        QMAKE_LFLAGS += -static-libgcc
        QMAKE_LFLAGS += -static-libstdc++
        QMAKE_POST_LINK += copy '"'$${TARGET_PATH}'"' '"'$${OUT_PATH}'"'
        #QMAKE_POST_LINK += copy '"'$${TARGET_PATH}'"' '"'$${OUT_PATH}'"' \
        #    && rmdir /s /q $${REMOVE_DIRS} \
        #    && del $${REMOVE_FILES}
    }
}

###############################################################################
# END SECTION FOR SPECIFYING COMPILER/LINKER FLAGS AND LIBRARIES              #
###############################################################################


###############################################################################
# BEGIN SECTION FOR DEFINING HELPER FUNCTIONS FOR RESOURCE COPYING            #
###############################################################################

# This function copies the given files to the destination directory.
# Used to place important resources from res/ and spl.jar into build/ folder.
defineTest(copyToDestdir) {
    files = $$1

    for(FILE, files) {
        DDIR = $$OUT_PWD

        # Replace slashes in paths with backslashes for Windows
        win32:FILE ~= s,/,\\,g
        win32:DDIR ~= s,/,\\,g

        !win32 {
            copyResources.commands += cp -r '"'$$FILE'"' '"'$$DDIR'"' $$escape_expand(\\n\\t)
        }
        win32 {
            copyResources.commands += xcopy '"'$$FILE'"' '"'$$DDIR'"' /e /y $$escape_expand(\\n\\t)
        }
    }
    export(copyResources.commands)
}

# specify files to copy on non-Windows systems
!win32 {
    copyToDestdir($$files($$PWD/res/*))
    copyToDestdir($$files($$PWD/lib/*.jar))
    exists($$PWD/*.txt) {
        copyToDestdir($$files($$PWD/*.txt))
    }
}

# specify files to copy on Windows systems
win32 {
    copyToDestdir($$PWD/res)
    copyToDestdir($$PWD/lib/*.jar)
    copyToDestdir($$PWD/lib/addr2line.exe)
    exists($$PWD/*.txt) {
        copyToDestdir($$PWD/*.txt)
    }
}

# copy output/ dir to an output/ subdir of the build directory
exists($$PWD/output/*) {
    PROJECTOUTDIR = $$PWD/output
    BUILDOUTDIR = $$OUT_PWD
    win32 {
        # on windows, must change / to \ in paths,
        # and include \output at end of dest dir
        PROJECTOUTDIR ~= s,/,\\,g
        BUILDOUTDIR = $$OUT_PWD/output
        BUILDOUTDIR ~= s,/,\\,g
    }
    copydata.commands = $(COPY_DIR) '"'$$PROJECTOUTDIR'"' '"'$$BUILDOUTDIR'"'
    first.depends = $(first) copydata
    export(first.depends)
    export(copydata.commands)
}

# copy support files such as library JAR and addr2line
copyResources.input += $$files($$PWD/lib/*.jar)
win32 {
    copyResources.input += $$files($$PWD/lib/addr2line.exe)
}
copyResources.input += $$files($$PWD/res/*)
exists($$PWD/*.txt) {
    copyResources.input += $$files($$PWD/*.txt)
}
exists($$PWD/input/*) {
    copyResources.input += $$files(input/*)
}
exists($$PWD/output/*) {
    copyResources.input += $$files(output/*)
}

QMAKE_EXTRA_TARGETS += copyResources first copydata
#QMAKE_EXTRA_TARGETS += copyResources
POST_TARGETDEPS += copyResources

###############################################################################
# END SECTION FOR DEFINING HELPER FUNCTIONS FOR RESOURCE COPYING              #
###############################################################################
