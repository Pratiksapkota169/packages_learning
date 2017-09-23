# coding:utf8
"""
27.Remove Element
Given an array and a value,remove all instance of that value in
place and return the new length.
Do not allocate extra space for another array,you must do this
in place with constant memory.
The order of elements can be changed.It doesn't matter what you
leave beyond the new length.
Example:Given input array nums=[3,2,2,3],val=3
Your function should return length=2,with the first two elements
of nums being 2.

在数组中删除指定元素
不是指定元素就往前面放
"""


class Soultion:
    # @param    A       a list of integers
    # @param    elem    an integer, value need to be removed
    # @return an integer
    def removeElement(self, A, elem):
        sz = 0
        for i in range(0, len(A)):
            if A[i] != elem:
                A[sz] = A[i]
                sz += 1
        return sz
