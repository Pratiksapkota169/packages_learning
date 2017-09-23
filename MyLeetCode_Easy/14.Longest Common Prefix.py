# coding:utf8
"""
14.Longest Common Prefix
Write a function to find the longest common prefix string amongst an array of strings
求所有的字符串的最长公共前缀
暴力直接一位位扫，直到遇到某位有不同的字符或者某个字符串结尾
"""


class Solution(object):
    def longestCommonPrefix(self, strs):
        if len(strs) <= 1:
            return strs[0] if len(strs) == 1 else ""
        end, min1 = 0, min([len(s) for s in strs])
        while end < min1:
            for i in range(1, len(strs)):
                if strs[i][end] != strs[i - 1][end]:
                    return strs[0][:end]
            end += 1
        return strs[0][:end]
