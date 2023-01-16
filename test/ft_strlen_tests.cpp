#include "gtest/gtest.h"
#include "template.hpp"

TEST(StrlenTest, Trivial)
{
	EXPECT_EQ(strlen("Hello, world"), ft_strlen("Hello, world"));
}

TEST(StrlenTest, BoundaryChecks)
{
	EXPECT_EQ(strlen(""), ft_strlen(""));
}
