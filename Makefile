###############################
#         BINARY NAME         #
###############################
NAME := template

###############################
#        LIBRARY FLAGS        #
###############################
LDFLAGS :=
LDLIBS :=

###############################
#      INCLUDE FOLDERS        #
###############################
INCS := include

###############################
#     DIRECTORY VARIABLES     #
###############################
SRC_DIR := src
BUILD_DIR := .build

###############################
#        SOURCE FILES         #
###############################
SRCS := ft_strlen.cpp
ENTRY_SRC := main.cpp

###############################
#        OBJECT FILES         #
###############################
OBJS := $(SRCS:%.cpp=$(BUILD_DIR)/%.o)
ENTRY_OBJS := $(ENTRY_SRC:%.cpp=$(BUILD_DIR)/%.o)
DEPS := $(OBJS:.o=.d)

###############################
#          CPP FLAGS          #
###############################
CXX := c++
CXXFLAGS := -Wall -Werror -Wextra
CPPFLAGS := $(addprefix -I, $(INCS)) -MMD -MP

###############################
#         TEST CONFIGS        #
###############################
GTEST_DIR := libs/googletest
GTEST_TARGET := $(GTEST_DIR)/build/lib/libgtest.a

TEST_LDFLAGS := -L$(GTEST_DIR)/build/lib -lgtest -lgtest_main -lpthread
TEST_INC := -I$(GTEST_DIR)/googletest/include

TEST_DIR := test

TEST_SRCS := ft_strlen_tests.cpp test_main.cpp
TEST_OBJS := $(TEST_SRCS:%.cpp=$(BUILD_DIR)/%.o)

TEST_TARGET := run_tests

###############################
#          MISC VARS          #
###############################
RM := rm -rf

###############################
#         DEFAULT RULE        #
###############################
all: $(NAME)

###############################
#         DEBUG RULES        #
###############################
debug: CXXFLAGS += -g -DDEBUG
debug: all

memory: CXXFLAGS += -fsanitize=memory -fsanitize-memory-track-origins=2 -fPIE -pie -fno-omit-frame-pointer -g
memory: re

address: CXXFLAGS += -fsanitize=address -fsanitize=undefined -fno-sanitize-recover=all -fsanitize=float-divide-by-zero -fsanitize=float-cast-overflow -fno-sanitize=null -fno-sanitize=alignment -g
address: re

print-%: ; @echo $* = $($*)

###############################
#          GIT RULES          #
###############################
submodules:
	git submodule sync
	git submodule update --init

###############################
#        COMPILE RULES        #
###############################
$(NAME): $(BUILD_DIR) $(OBJS) $(ENTRY_OBJS)
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) $(OBJS) $(ENTRY_OBJS) -o $(NAME) $(LDFLAGS) $(LDLIBS)

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.cpp
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) -c $< -o $@

###############################
#     FOLDER CREATION RULE    #
###############################
$(BUILD_DIR):
	@test -d $@ || mkdir -p $@

###############################
#          TEST RULES         #
###############################
test: $(GTEST_TARGET) $(BUILD_DIR) $(OBJS) $(TEST_OBJS)
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) $(TEST_INC) $(OBJS) $(TEST_OBJS) -o $(TEST_TARGET) $(TEST_LDFLAGS) $(LDFLAGS) $(LDLIBS)
	./$(TEST_TARGET)

$(BUILD_DIR)/%.o: $(TEST_DIR)/%.cpp
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) $(TEST_INC) -c $< -o $@

$(GTEST_TARGET):
	cmake -S $(GTEST_DIR) -B $(GTEST_DIR)/build
	make -sC $(GTEST_DIR)/build

###############################
#         CLEAN RULES         #
###############################
clean:
	$(RM) $(BUILD_DIR)

fclean: clean
	$(RM) $(NAME)
	$(RM) $(TEST_TARGET)

re: fclean all

###############################
#          DEPS RULE          #
###############################
-include $(DEPS)

.PHONY: all clean fclean re debug memory address thread test
