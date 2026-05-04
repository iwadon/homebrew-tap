class Attest < Formula
  desc "A lightweight C11 unit testing framework"
  homepage "https://github.com/iwadon/attest"
  license "MIT-0"
  head "https://github.com/iwadon/attest.git", branch: "main"

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <attest/attest.h>

      TEST(Math, Addition) {
        ASSERT_EQ(2 + 2, 4);
        EXPECT_NE(3 + 3, 7);
      }

      int main(int argc, char **argv) {
        return attest_main(argc, argv);
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lattest", "-o", "test"
    system "./test"
  end
end
