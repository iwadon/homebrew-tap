class Terse < Formula
  desc "C library that unifies rendering, input, and terminal capability detection for text UI environments"
  homepage "https://github.com/iwadon/terse"
  license "MIT-0"
  head "https://github.com/iwadon/terse.git", branch: "master"

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DTERSE_BUILD_TESTING=OFF", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <terse.h>

      int main(void) {
        terse_handle_t handle = terse_open(TERSE_PROFILE_AUTO, NULL);
        if (!handle) return 1;
        terse_close(handle);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lterse", "-liconv", "-o", "test"
    system "./test"
  end
end
