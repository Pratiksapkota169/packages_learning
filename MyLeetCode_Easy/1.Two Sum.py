# coding:utf8
"""
1.Two Sum
Given an array of integers,return indices of the two
numbers such that they add up to a specific target.
You may assume that each input would have exactly one
solution.
找出数组中的两个数，这两个数和为target
扫到x时看前面Hash的数里有没有target-x，然后将x也放进Hash表
"""


# @return a tuple,(index1,index2)
# enumerate 函数用于遍历序列中的元素以及它们的下标
class Solution(object):
    # @return a tuple, (index1, index2)
    def twoSum(self, nums, target):
        for k1, v1 in enumerate(nums):
            for k2, v2 in enumerate(nums):
                if (v1 + v2) == target and k2 > k1:
                    return [k1, k2]


# 两个for循环，时间超时


# 使用Hash表，扫到x时看前面Hash的数里有没有target-x，然后将x也放进Hash表
class Solution(object):
    # @return a tuple, (index1, index2)
    def twoSum(self, num, target):
        dict = {}
        for i in range(len(num)):
            if dict.get(target - num[i], None) == None:
                dict[num[i]] = i
            else:
                return (dict[target - num[i]], i)
