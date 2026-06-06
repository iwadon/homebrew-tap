class TersePrompt < Formula
  desc "Lightweight, modern C library for multi-line text input in CLI applications"
  homepage "https://github.com/iwadon/terse-prompt"
  license "MIT-0"
  head "https://github.com/iwadon/terse-prompt.git", branch: "master"

  depends_on "cmake" => :build
  depends_on "terse"

  def install
    configure_args = std_cmake_args + %w[
      -DTPROMPT_BUILD_TESTING=OFF
      -DTPROMPT_BUILD_EXAMPLES=OFF
      -DTPROMPT_USE_TERSE_TEST_MODE=OFF
    ]
    system "cmake", "-S", ".", "-B", "build", *configure_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <tprompt.h>
      int main(void) {
        terse_handle_t terse_handle = terse_open(TERSE_PROFILE_AUTO, NULL);
        if (!terse_handle) return 1;
        tprompt_options_t options = TPROMPT_OPTIONS_DEFAULT;
        options.terse_handle = terse_handle;
        tprompt_handle_t handle = tprompt_open(&options);
        if (!handle) {
          terse_close(terse_handle);
          return 1;
        }
        tprompt_close(handle);
        terse_close(terse_handle);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-ltprompt", "-L#{Formula["terse"].opt_lib}", "-lterse", "-liconv", "-o", "test"
    system "./test"
  end
end
