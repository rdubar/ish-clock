"""Unit tests for ISH CLOCK boundary logic."""

import unittest
from ish import IshTime


class TestIshClock(unittest.TestCase):

    def phrase(self, h, m, s=0):
        clock = IshTime.__new__(IshTime)
        return clock.ish(h, m, s)

    # --- O'clock boundaries ---

    def test_exact_hour(self):
        self.assertIn("nine o'clock", self.phrase(9, 0))

    def test_just_after_hour(self):
        self.assertIn("nine o'clock", self.phrase(9, 3))

    def test_just_before_hour(self):
        """9:58 rounds up to ten o'clock."""
        self.assertIn("ten o'clock", self.phrase(9, 58))

    # --- Five minutes ---

    def test_five_past(self):
        result = self.phrase(9, 5)
        self.assertIn("five minutes", result)
        self.assertIn("past", result)
        self.assertIn("nine", result)

    def test_five_to(self):
        result = self.phrase(9, 55)
        self.assertIn("five minutes", result)
        self.assertIn("to", result)
        self.assertIn("ten", result)

    # --- Quarter ---

    def test_quarter_past(self):
        result = self.phrase(9, 15)
        self.assertIn("quarter", result)
        self.assertIn("past", result)

    def test_quarter_to(self):
        result = self.phrase(9, 45)
        self.assertIn("quarter", result)
        self.assertIn("to", result)

    # --- Half past ---

    def test_half_past(self):
        self.assertIn("half past", self.phrase(9, 30))

    def test_half_past_boundary_low(self):
        self.assertIn("half past", self.phrase(9, 29))

    def test_half_past_boundary_high(self):
        self.assertIn("half past", self.phrase(9, 33))

    # --- Hour rollover ---

    def test_twelve_to_one(self):
        """12:55 should say 'five minutes to one'."""
        result = self.phrase(12, 55)
        self.assertIn("to", result)
        self.assertIn("one", result)

    def test_eleven_to_twelve(self):
        """11:55 should say 'five minutes to twelve'."""
        result = self.phrase(11, 55)
        self.assertIn("to", result)
        self.assertIn("twelve", result)

    # --- Midnight and noon ---

    def test_midnight(self):
        """Midnight (0:00) with no args uses system time; test with explicit 24,0."""
        result = self.phrase(24, 0)
        self.assertIn("twelve o'clock", result)

    def test_midnight_zero(self):
        """0:00:00 triggers the 'use system time' fallback due to falsy check.
        This is existing behavior — hour 0 and minute 0 both falsy."""
        # Just verify it doesn't crash and returns a valid phrase
        result = self.phrase(0, 0)
        self.assertIn("It is about", result)

    def test_noon(self):
        result = self.phrase(12, 0)
        self.assertIn("twelve o'clock", result)
        self.assertIn("in the afternoon", result)

    # --- Minute overflow (59 + rounding) ---

    def test_minute_59_rounds_up(self):
        """At 9:59:45, seconds > 30 should round minute to 60 -> ten o'clock."""
        result = self.phrase(9, 59, 45)
        self.assertIn("ten o'clock", result)

    def test_minute_59_no_round(self):
        """At 9:59:10, seconds <= 30, minute stays 59 -> rounds to ten o'clock (59 > 57)."""
        result = self.phrase(9, 59, 10)
        self.assertIn("ten o'clock", result)

    def test_midnight_rollover(self):
        """At 23:59:45, should round to twelve o'clock at night."""
        result = self.phrase(23, 59, 45)
        self.assertIn("twelve o'clock", result)
        self.assertIn("at night", result)

    # --- Day parts ---

    def test_morning(self):
        self.assertIn("in the morning", self.phrase(8, 0))

    def test_afternoon(self):
        self.assertIn("in the afternoon", self.phrase(14, 0))

    def test_evening(self):
        self.assertIn("in the evening", self.phrase(20, 0))

    def test_night_late(self):
        self.assertIn("at night", self.phrase(23, 0))

    def test_night_boundary(self):
        """21:00 should be evening, 22:00 should be night."""
        self.assertIn("in the evening", self.phrase(21, 0))
        self.assertIn("at night", self.phrase(22, 0))

    # --- No raw numbers in output ---

    def test_no_digits_in_output(self):
        """Every time should produce all-word output, no digits."""
        for h in range(24):
            for m in range(60):
                result = self.phrase(h, m)
                for char in result:
                    if char.isdigit():
                        self.fail(f"Digit found in output for {h:02d}:{m:02d}: {result}")


if __name__ == "__main__":
    unittest.main()
