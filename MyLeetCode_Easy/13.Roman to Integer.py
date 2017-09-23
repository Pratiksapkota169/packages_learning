# coding:utf8
"""
13.Roman to Integer
Given a roman numeral,convert it to an integer.
Input is guaranteed to be within the range from 1 to 3999
罗马数字转阿拉伯数字
右边比左边大就减对应值，否则就加对应值
IV:5-1=4    VI:5+1=6
"""


class Solution:
    # @return an integer
    def romanToInt(self, s):
        roval = {"I": 1, "V": 5, "X": 10, "L": 50, "C": 100, "D": 500, "M": 1000}
        ans = 0
        for i in range(len(s)):
            if i + 1 < len(s) and roval[s[i]] < roval[s[i + 1]]:
                ans -= roval[s[i]]
            else:
                ans += roval[s[i]]
        return ans
