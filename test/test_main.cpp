#include "gtest/gtest.h"
#include "template.hpp"

int	main(int ac, char **av)
{
	::testing::InitGoogleTest(&ac, av);
	return RUN_ALL_TESTS();
}