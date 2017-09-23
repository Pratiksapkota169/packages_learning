# coding:utf8
"""
26.Remove Duplicate from Sorted Array
Given a sorted array,remove the duplicates in place such that each
that each element appear only once and return the new length.
Do not allocate extra space for another array,you must do this in
place with constant memory.
For example,Given input array nums=[1,1,2]
Your function should return length=2,with the first two elements
of nums being 1 and 2 respectively.It doesn't matter what you leave
beyond the new length.

有序数组删除重复元素到只留一个
往数组前部放，放之前保证和已放的最后一个不一样即可
"""


class Solution(object):
    def removeDuplicates(self, nums):
        if len(nums) == 0:
            return 0
        sz = 1
        for i in range(1, len(nums)):
            if nums[i] != nums[i - 1]:
                nums[sz] = nums[i]
                sz += 1
        return sz

# 最后返回去重后的长度
# range从1开始
