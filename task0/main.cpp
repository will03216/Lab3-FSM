#include "gtest/gtest.h"

int add(int a, int b) { return a + b; }

class TestAdd : public ::testing::Test
{
    void SetUp() override
    {
        // Runs before each test
    }

    void TearDown() override
    {
        // Runs after each test
    }
};

// Don't worry about the syntax here, the TEST_F macro is very complicated.
// Just know that this is how you create a test case.
TEST_F(TestAdd, AddTest)
{
    // This should pass, 2 + 4 = 6
    EXPECT_EQ(add(2, 4), 6);
}

TEST_F(TestAdd, AddTest2)
{
    // 测试不同的加法情况
    EXPECT_EQ(add(3, 5), 8);  // 这是正确的测试，应该通过
    
    // 故意设置错误的预期结果，以便观察测试失败时的输出
    EXPECT_EQ(add(10, 5), 20); // 这将失败，因为 10 + 5 不等于 20
}

int main(int argc, char **argv)
{
    // Standard Google Test main function
    testing::InitGoogleTest(&argc, argv);
    auto res = RUN_ALL_TESTS();
    return res;
}
