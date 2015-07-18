#!/usr/bin/env python

"""
This file tests basic umfpack operations.

We test **all** types and the symmetric and general cases.

     If this is a python script (.py), it has been automatically generated by the 'generate_code.py' script.

"""
from cysparse.sparse.ll_mat import *
from cysparse.types.cysparse_types import *
from cysparse.linalg.umfpack import NewUmfpackContext

import numpy as np

import unittest

import sys

def is_equal(A, B, eps=1e-12):
    if A.nrow != B.nrow or A.ncol != B.ncol:
        return False

    for i in xrange(A.nrow):
        for j in xrange(A.ncol):
            if abs(A[i, j] - B[i, j]) > eps:
                return False

    return True

########################################################################################################################
# Tests
########################################################################################################################
class CySparseUmfpackBaseTestCase(unittest.TestCase):
    def setUp(self):
        pass

class CySparseUmfpackLUTestCase(CySparseUmfpackBaseTestCase):
    """
    Verify equality ``L * U = P * R * A * Q``.
    """
    def setUp(self):
        self.nbr_of_elements = 36
        self.size = 6


  
  
        self.l_1_1 = NewArrowheadLLSparseMatrix(size=self.size, itype=INT32_T, dtype=FLOAT64_T, row_wise=False)

        self.context_1_1 = NewUmfpackContext(self.l_1_1)
        self.context_1_1.set_verbosity(0)

  
        self.l_1_2 = NewArrowheadLLSparseMatrix(size=self.size, itype=INT32_T, dtype=COMPLEX128_T, row_wise=False)

        self.context_1_2 = NewUmfpackContext(self.l_1_2)
        self.context_1_2.set_verbosity(0)

  

  
  
        self.l_2_1 = NewArrowheadLLSparseMatrix(size=self.size, itype=INT64_T, dtype=FLOAT64_T, row_wise=False)

        self.context_2_1 = NewUmfpackContext(self.l_2_1)
        self.context_2_1.set_verbosity(0)

  
        self.l_2_2 = NewArrowheadLLSparseMatrix(size=self.size, itype=INT64_T, dtype=COMPLEX128_T, row_wise=False)

        self.context_2_2 = NewUmfpackContext(self.l_2_2)
        self.context_2_2.set_verbosity(0)

  



  
  
    def test_simple_equality_one_by_one_1_1(self):
        (L, U, P, Q, D, do_recip, R) = self.context_1_1.get_LU()

        P_mat = NewPermutationLLSparseMatrix(P=P, size=self.size, dtype=FLOAT64_T, itype=INT32_T)
        Q_mat = NewPermutationLLSparseMatrix(P=Q, size=self.size, dtype=FLOAT64_T, itype=INT32_T)

        if do_recip:
            R_mat = NewLLSparseMatrix(size=self.size, dtype=FLOAT64_T, itype=INT32_T)
            for i in xrange(self.size):
                R_mat[i, i] = R[i]
        else:
            R_mat = NewLLSparseMatrix(size=self.size, dtype=FLOAT64_T, itype=INT32_T)
            for i in xrange(self.size):
                R_mat[i, i] = 1/R[i]

        self.failUnless(is_equal(L * U, P_mat * R_mat * self.l_1_1 * Q_mat))

  
    def test_simple_equality_one_by_one_1_2(self):
        (L, U, P, Q, D, do_recip, R) = self.context_1_2.get_LU()

        P_mat = NewPermutationLLSparseMatrix(P=P, size=self.size, dtype=COMPLEX128_T, itype=INT32_T)
        Q_mat = NewPermutationLLSparseMatrix(P=Q, size=self.size, dtype=COMPLEX128_T, itype=INT32_T)

        if do_recip:
            R_mat = NewLLSparseMatrix(size=self.size, dtype=COMPLEX128_T, itype=INT32_T)
            for i in xrange(self.size):
                R_mat[i, i] = R[i]
        else:
            R_mat = NewLLSparseMatrix(size=self.size, dtype=COMPLEX128_T, itype=INT32_T)
            for i in xrange(self.size):
                R_mat[i, i] = 1/R[i]

        self.failUnless(is_equal(L * U, P_mat * R_mat * self.l_1_2 * Q_mat))

  

  
  
    def test_simple_equality_one_by_one_2_1(self):
        (L, U, P, Q, D, do_recip, R) = self.context_2_1.get_LU()

        P_mat = NewPermutationLLSparseMatrix(P=P, size=self.size, dtype=FLOAT64_T, itype=INT64_T)
        Q_mat = NewPermutationLLSparseMatrix(P=Q, size=self.size, dtype=FLOAT64_T, itype=INT64_T)

        if do_recip:
            R_mat = NewLLSparseMatrix(size=self.size, dtype=FLOAT64_T, itype=INT64_T)
            for i in xrange(self.size):
                R_mat[i, i] = R[i]
        else:
            R_mat = NewLLSparseMatrix(size=self.size, dtype=FLOAT64_T, itype=INT64_T)
            for i in xrange(self.size):
                R_mat[i, i] = 1/R[i]

        self.failUnless(is_equal(L * U, P_mat * R_mat * self.l_2_1 * Q_mat))

  
    def test_simple_equality_one_by_one_2_2(self):
        (L, U, P, Q, D, do_recip, R) = self.context_2_2.get_LU()

        P_mat = NewPermutationLLSparseMatrix(P=P, size=self.size, dtype=COMPLEX128_T, itype=INT64_T)
        Q_mat = NewPermutationLLSparseMatrix(P=Q, size=self.size, dtype=COMPLEX128_T, itype=INT64_T)

        if do_recip:
            R_mat = NewLLSparseMatrix(size=self.size, dtype=COMPLEX128_T, itype=INT64_T)
            for i in xrange(self.size):
                R_mat[i, i] = R[i]
        else:
            R_mat = NewLLSparseMatrix(size=self.size, dtype=COMPLEX128_T, itype=INT64_T)
            for i in xrange(self.size):
                R_mat[i, i] = 1/R[i]

        self.failUnless(is_equal(L * U, P_mat * R_mat * self.l_2_2 * Q_mat))

  


if __name__ == '__main__':
    unittest.main()