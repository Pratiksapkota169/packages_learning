# coding:utf8
"""
21.Merge Two Sorted Lists
Merge two sorted linked lists and return it as a new list.
The new list should be made by splicing together the nodes of the first two lists.

合并两个有序列表
归并排序了，加个临时头节点好写一些
"""
from Cython.Compiler.ExprNodes import ListNode


# Definition for singly-linked list.
# class ListNode(object):
#     def __init__(self, x):
#         self.val = x
#         self.next = None

class Solution(object):
    def mergeTwoLists(self, l1, l2):
        nHead = ListNode(0)
        lt, rt, backHead = l1, l2, nHead
        while lt or rt:
            if lt is None:
                nHead.next, rt = rt, rt.next
            elif rt is None:
                nHead.next, lt = lt, lt.next
            elif lt.val < rt.val:
                nHead.next, lt = lt, lt.next
            else:
                nHead.next, rt = rt, rt.next
            nHead = nHead.next
        return backHead.next
