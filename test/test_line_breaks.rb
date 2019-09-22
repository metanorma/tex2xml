require "minitest/autorun"
require "helper"

class TestLineBreaks < Minitest::Test
  def test_hard_breaks
    assert_equal render_string(<<~'INPUT'), <<~OUTPUT
      \documentclass{metanorma}
      \begin{document}
        Previous paragraph.

        This paragraph is broken.\\
        Then, it continues.

        Following paragraph.
      \end{document}
    INPUT
      Previous paragraph.

      This paragraph is broken. +
      Then, it continues.

      Following paragraph.

    OUTPUT
  end
end
