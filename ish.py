# ISH CLOCK version 1.3
# Copyright 1994-2026, Roger Dubar.
#
# This software is released under the MIT License.
# See the LICENSE file in the project root for more information.

from datetime import datetime
from random import randint


def ish(*args):
    ish = IshTime()
    return ish.now
    

class IshTime():
    def __init__(self, time=None, width=40):
        """
        A class to represent a text-based telling of the time, for example:
        
            It is about twenty-five minutes to eleven in the morning.
        
        Attributes:
        
        now : 
            The ish time at the time of creation
        
        time: str
            The ish time at the time specified        
        
        Methods:
        
        then(time)
            The ish time at a specified time, datetime object,
            a string such as "11:20", or "13:20:12", or "0744"
            or an int such as 1, 222, etc.
        
        random()
            Returns a reandom ish time
        
        """
        self.now = self.time = self.ish(0,0,0)
        self.long = "It is about twenty-five minutes to eleven in the morning."
        if time:
            self.time = self.then(time)
            
    def random(self):
        return self.ish(randint(0,24), randint(0,60), randint(0,60))
    
    def then(self, time):
        if isinstance(time, datetime):
            return self.ish(time.hour, time.minute, time.second)

        if isinstance(time, int):
            time = f'{time:04}'
        if isinstance(time, str):
            if ':' in time:
                parts = time.split(':')
            elif len(time) >= 4:
                parts = [time[0:2], time[2:4]]
                if len(time) > 4:
                    parts.append(time[4:])
            else:
                return "IshTime not known."
        elif isinstance(time, (list, tuple)):
            parts = list(time)
        else:
            return "IshTime not known."

        h = int(parts[0]) if len(parts) > 0 else 0
        m = int(parts[1]) if len(parts) > 1 else 0
        s = int(parts[2]) if len(parts) > 2 else 0
        return self.ish(h, m, s)
        

    def number(self, x):
        try:
            return ('one','two','three','four','five','six',
            'seven','eight','nine','ten','eleven','twelve')[x-1]
        except:
            return x

    def bittime(self, m):
        m = int(m)
        if m <= 7 or m > 53:
            m ="five minutes"
        elif m <= 12 or m > 48:
            m ="ten minutes"
        elif m <= 17 or m > 43:
            m ="quarter"
        elif m <= 23 or m > 38:
            m ="twenty minutes"
        elif m <= 28 or m > 33:
            m ="twenty-five minutes"
        else:
            m = "twenty-five minutes"
        return m # default

    def ishtime(self, h, m):
        foo = ''
        h = self.number(h)
        m = int(m)
        if m <= 3 or m > 57:
            return h + " o'clock"
        elif m <= 33 and m > 28:
            return "half past " + h
        elif m < 30:
            foo = "past"
        else:
            foo = "to"
        m = self.bittime(m)
        return m + " " + foo + " " + h

    def daytime(self, h):
        h = int(h)
        if not h or h >= 22: return "at night"
        elif h < 12: return "in the morning"
        elif (h <= 17) : return "in the afternoon"
        return "in the evening" #  default

    def ish(self, h=0,m=0,s=0):
        if not h and not m:
            ct = datetime.now()
            h = ct.hour
            m = ct.minute
            s = ct.second 
 
        #if (not s) s = 0
        z = self.daytime(h)
        h = int(h)
        m = int(m)
        h = h % 12 # fix to 12 hour clock
        if (m > 57 and s > 30): m += 1 # round seconds
        if (m >= 60): m = 0; h += 1 # round up minutes and hour
        if (m > 33): h += 1 # round up hours
        h = ((h + 11) % 12) + 1 # normalize to 1-12
        return (f"It is about {self.ishtime(h, m)} {z}.")

def main():
    ish = IshTime()
    print(ish.now)
    #print("Then:",ish.then(3434))
    #print("Random:",ish.random())

if __name__ == "__main__":
    main()
    