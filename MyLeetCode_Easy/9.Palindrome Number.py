# coding:utf8
"""
9.Palindrome Number
Determine whether an integer is a palindrome.
判断一个数字是否是回文串
判断翻转后的数字和原数字是否相同即可
"""


class Solution:
    # @return a boolean
    def isPalindrome(self, x):
        if x <= 0:
            return False if x < 0 else True
        a, b = x, 0
        while a:
            b, a = b * 10 + a % 10, a / 10
        return b == x
