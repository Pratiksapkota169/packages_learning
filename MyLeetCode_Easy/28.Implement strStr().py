# coding:utf8
"""
28.Implement strStr()
Return the index of the first occurrence of needle in haystack,
or -1 if needle is not part of haystack.
实现字符串匹配函数，并返回一个指针，这个指针指向原字符串中第一次出现待匹配字符串的位置
如haystack='aabbaa';needle='bb'，返回'bbaa'

KMP算法：
在匹配过程称，若发生不匹配的情况，如果next[j]>=0，则目标串的指针i不变，
将模式串的指针j移动到next[j]的位置继续进行匹配；
若next[j]=-1，则将i右移1位，并将j置0，继续进行比较。

其实KMP算法与BF算法的区别就在于KMP算法巧妙的消除了指针i的回溯问题，
只需确定下次匹配j的位置即可，使得问题的复杂度由O(mn)下降到O(m+n)。

在KMP算法中，为了确定在匹配不成功时，下次匹配时j的位置，引入了next[]数组，
next[j]的值表示P[0...j-1]中最长后缀的长度等于相同字符序列的前缀。
"""
from numpy.core.tests.test_mem_overlap import xrange


# 思路一：库函数string.find()
class Solution(object):
    def strStr(self, haystack, needle):
        return haystack.find(needle)


# 思路二：扫描haystack，当遇到与needle首字符相同的位置时，检查haystack从该位置开始
# 的与needle长度相同的块，与needle是否相同
class Solution(object):
    def strStr(self, haystack, needle):
        if not needle:
            return 0
        for i in xrange(len(haystack) - len(needle) + 1):
            if haystack[i] == needle[0]:
                j = 1
                while j < len(needle) and haystack[i + j] == needle[j]:
                    j += 1
                if j == len(needle):
                    return i
        return -1


# 思路三：利用类似substring的方法简化代码
class Solution(object):
    def strStr(self, haystack, needle):
        for i in xrange(len(haystack) - len(needle) + 1):
            if haystack[i:len(needle) + i] == needle:
                return i
        return -1


# 思路四：鉴于这是一个模式匹配问题，可以考虑KMP算法。该算法对于任何模式和目标序列，
# 都可以在线性时间内完成匹配查找(O(n+m))，而不会发生退化
class Solution(object):
    def strStr(self, haystack, needle):
        if not needle:
            return 0
        # generate next array, need O(n) time
        i, j, m, n = -1, 0, len(haystack), len(needle)
        next = [-1] * n
        while j < n - 1:
            # needle[k] stands for prefix, neelde[j] stands for postfix
            if i == -1 or needle[i] == needle[j]:
                i, j = i + 1, j + 1
                next[j] = i
            else:
                i = next[i]
        # check through the haystack using next, need O(m) time
        i = j = 0
        while i < m and j < n:
            if j == -1 or haystack[i] == needle[j]:
                i, j = i + 1, j + 1
            else:
                j = next[j]
        if j == n:
            return i - j
        return -1
