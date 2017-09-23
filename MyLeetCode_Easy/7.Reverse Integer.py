# coding:utf8
"""
7.Reverse Integer
Reverse digits of an integer
Example1:x=123,return 321
Example2:x=-123,return -321

Note:
The input is assumed to be a 32-bit signed integer.
"""


class Solution:
    # @return an integer
    def reverse(selfself, x):
        a, result = 0, 0
        b = abs(x)
        while b:
            a, b = a * 10 + b % 10, b / 10
            result = a if x > 0 else -a
        return result if result < 2147483648 and result >= -2147483648 else 0


# x=321,a=0,b=321
# a=1,b=32
# a=12,b=3
# a=123

# 原整数反转后溢出怎么办？——比如x=1000000003，反转溢出，那么规定溢出的结果都返回0

class Solution(object):
    def reverse(self, x):
        """
        :type x: int
        :rtype: int
        """
        x = int(str(x)[::-1]) if x >= 0 else - int(str(-x)[::-1])
        return x if x < 2147483648 and x >= -2147483648 else 0
# 利用Python的字符串反转操作来实现对整数的反转，反转后的字符串要重新转换为整数。同上面一样，要注意正负和溢出情况。
