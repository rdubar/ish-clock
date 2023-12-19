/*
    ISH CLOCK version 1.2
    Copyright 1994-2023, Roger Dubar.
    
    This software is released under the MIT License.
    See the LICENSE.txt file in the project root for more information.
*/

function number(x) {
	var word = ['one','two','three','four','five','six','seven','eight','nine','ten','eleven','twelve'];
	if (x > 0 && x <= word.length)
		return word[x-1];
	// else
	return x;
}

function bittime(m) {
	if (m <= 7 || m > 53) return "five minutes";
	if (m <= 12 || m > 48) return "ten minutes";
	if (m <= 17 || m > 43) return "quarter";
	if (m <= 23 || m > 38) return "twenty minutes";
	if (m <= 28 || m > 33) return "twenty-five minutes";
	return m; //default
}

function ishtime(h, m) {
	var foo;
	h = number(h);
	if (m <= 3 || m > 57) return h + " o'clock";
	if (m <= 33 && m > 28) return "half past " + h;
	if (m < 30) {
		foo = "past"
	} else {
		foo = "to"
	};
	m = bittime(m);
	return m + " " + foo + " " + h;
}

function daytime(h) {
	if (!h || h > 21) return " at night";
	if (h < 12) return " in the morning";
	if (h <= 17) return " in the afternoon";
	return " in the evening"; // default
}

function ish(h, m, s) {
	if (!h || !m) { // if no time supplied, use the system time
		time = new Date();
		h = time.getHours();
		m = time.getMinutes();
		s = time.getSeconds();
	}
	if (!s) s = 0;
	z = daytime(h);
	h = h % 12; // fix to 12 hour clock
	if (m > 57 && s > 30) m++; // round seconds
	if (m > 60) m = 0; // round up minutes
	if (m > 33) h++; // round up hours
	if (h > 12) h = 1; // the clock turns round...
	if (h == 0) h = 12;
	return ("It is about " + ishtime(h, m) + z + ".");
}
document.writeln(ish());
