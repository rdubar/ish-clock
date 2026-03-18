# ISH CLOCK

> *The world's oldest fuzzy clock, now on your wrist.*

The ISH CLOCK tells the approximate time in a human-friendly format — "It is about quarter to ten in the morning" instead of "9:45 AM". First coded in 1994, it's been telling time the relaxed way for over 30 years.

### Version
1.3

### Author
Roger Dubar

## Implementations

ISH CLOCK is available in four languages:

| Language | File | Since |
|----------|------|-------|
| JavaScript | `ish.js` | 1994 |
| Python | `ish.py` | 2020 |
| C | `ish.c` | 2023 |
| Swift (Apple Watch) | `apple-watch/` | 2026 |

## Usage

### JavaScript
```js
ish();
```

### Python
```python
from ish import IshTime
clock = IshTime()
print(clock.now)
print(clock.then("14:25"))
print(clock.random())
```

### C
```bash
gcc -o ish ish.c
./ish
```

### Apple Watch
Open [`apple-watch/ISHWatch.xcodeproj`](apple-watch/ISHWatch.xcodeproj) in Xcode and run the `ISHWatch` scheme on a Watch simulator or device. The app displays the ish time with rotating pastel colours and refreshes automatically. No iPhone companion required.

## How It Works

The clock rounds the current time to the nearest five-minute interval and expresses it in natural language:

| Time | ISH CLOCK says |
|------|---------------|
| 9:02 | It is about nine o'clock in the morning. |
| 9:14 | It is about quarter past nine in the morning. |
| 9:31 | It is about half past nine in the morning. |
| 9:44 | It is about quarter to ten in the morning. |
| 21:55 | It is about ten o'clock in the evening. |

## License

This project is released under the MIT License. See the [LICENCE](LICENCE) file for details.

## Contributions

Contributions to the ISH CLOCK project are welcome.

## Acknowledgments

Special thanks to all users of the ISH CLOCK over the years.
