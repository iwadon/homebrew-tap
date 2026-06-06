class TersePrompt < Formula
  desc "A lightweight, modern C library for multi-line text input in CLI applications."
  homepage "https://github.com/iwadon/terse-prompt"
  license "MIT-0"
  head "https://github.com/iwadon/terse-prompt.git", branch: "master"

  depends_on "cmake" => :build
  depends_on "terse"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DTPROMPT_BUILD_TESTING=OFF", "-DTPROMPT_BUILD_EXAMPLES=OFF", "-DTPROMPT_USE_TERSE_TEST_MODE=OFF", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end
end
