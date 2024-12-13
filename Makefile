 # to compile and run in one command type:
 # make run

 # define which compiler to use

 CXX := g++	# compiler type
 OUTPUT := sfmlgame	# name of binary out from compiler
 OS := $(shell uname)

 #linux compiler / linker flags
 ifeq ($(OS), Linux)
 	CXX_FLAGS := -03 -std=c++20 -Wno-unused-result -Wno-deprecated-declarations
 	#compiler step of the program
 	# -03 : one of max level of optimization
 	# -Wno-unused-result : turn off the warning the compiler generates if you have unused variables
 	# -Wno-deprecated-declarations : turn off the warning deprecated library
 	INCLUDES := -I./src -I ./src/imgui
 	# these Define the directories that you want to include
 	LDFLAGS := -03 -lsfml-graphics -lsfml-window -lsfml-system -lsfml-audio -lGL
 	# flags for the Linker
 	# -lsfml-graphics -lsfml-window -lsfml-system -lsfml-audio : linking all the libraries that are necessary for sfml
 	# -lGL : for enable working with imgui
 endif

 # macos compiler / linker flags
ifeq ($(OS), Darwin)
  	SFML_DIR := /usr/local/Cellar/sfml/2.6.2
  	CXX_FLAGS := -03 -std=c++20 -Wno-unused-result -Wno-deprecated-declarations
  	INCLUDES := -I./src -I ./src/imgui -I$(SFML_DIR)/include
	LDFLAGS := -lsfml-graphics -lsfml-window -lsfml-system -lsfml-audio -L$(SFML_DIR)/lib -framework OpenGL
endif

# the source files for the ecs game engine
SRC_FILES := $(wildcard src/*.cpp src/imgui/*.cpp)
OBJ_FILES := $(SRC_FILES:.cpp=.o)

# Include dependency files
DEP_FILES := $(SRC_FIELS:.cpp=.d)
-include $(DEP_FILES)

# all of these targets will be made if you just type make
all: $(OUTPUT)

# define the main executable requirements / command
$(OUTPUT): $(OBJ_FILES) Makefile
	$(CXX) $(OBJ_FILES) $(LDFLAGS) -o ./bin/$@

# specifies how the object files are compiled from cpp files
.cpp.o:
	$(CXX) -MMD -MP -c $(CXX_FLAGS) $(INCLUDES) $< -o $@

# typing 'make clean' will remove all intermediate build files
clean:
	rm -f $(OBJ_FILES) $(DEP_FILES) ./bin/$(OUTPUT)

# typing 'make run' will compile and run the program
run: $(OUTPUT)
	cd bin && ./$(OUTPUT) && cd ..


