# coding:utf8
"""
20.Valid Parentheses
Given a string containing just the characters '(',')','{','}','[' and ']',
determine if the input string is valid.
The brackets must close in the correct order."()" and "()[]{}" are all valid
but "([" and "([)]" are not.

判断括号序列是否合法，共有三种括号
用栈，遇到右括号时左括号必须和当前括号是一对，然后出栈
"""

class Solution(object):
    def isValid(self, s):
        dct = {"(": ")", "[": "]", "{": "}"}
        stk = []
        for c in s:
            if dct.get(c, None):
                stk.append(c)
            elif len(stk) == 0 or dct[stk[-1]] != c:
                return False
            else:
                stk.pop()
        return True if len(stk) == 0 else False
