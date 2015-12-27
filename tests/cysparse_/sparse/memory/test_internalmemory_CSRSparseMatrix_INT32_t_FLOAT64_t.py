#!/usr/bin/env python

"""
This file tests internal memory for all matrices objects.

"""

import unittest
from cysparse.sparse.ll_mat import *


########################################################################################################################
# Tests
########################################################################################################################

NROW = 10
NCOL = 14
SIZE = 10


#######################################################################
# Case: store_symmetry == False, Store_zero==False
#######################################################################
class CySparseInternalMemoryNoSymmetryNoZero_CSRSparseMatrix_INT32_t_FLOAT64_t_TestCase(unittest.TestCase):
    def setUp(self):

        self.nrow = NROW
        self.ncol = NCOL

        self.A = LinearFillLLSparseMatrix(nrow=self.nrow, ncol=self.ncol, dtype=FLOAT64_T, itype=INT32_T)


        self.C = self.A.to_csr()



    def test_memory_real_in_bytes(self):
        """
        Approximative test for internal memory.

        As the exact memory needed might change over time (i.e. differ with different implementations), we only
        test for a lower bound. This test also the existence of the method.
        """
        nrow, ncol = self.C.shape
        nnz = self.C.nnz

        real_memory_index = self.C.memory_index_in_bytes()
        real_memory_type = self.C.memory_element_in_bytes()
        real_memory_matrix = self.C.memory_real_in_bytes()


        # As of December 2015, this bound is tight!
        # col:  nnz * sizeof(index)
        # val:  nnz * sizeof(type)
        # ind:  (nrow + 1) * sizeof(index)

        self.assertTrue(real_memory_matrix >= ((nrow + 1 + nnz) * real_memory_index + nnz * real_memory_type))



#######################################################################
# Case: store_symmetry == True, Store_zero==False
#######################################################################
class CySparseInternalMemoryWithSymmetryNoZero_CSRSparseMatrix_INT32_t_FLOAT64_t_TestCase(unittest.TestCase):
    def setUp(self):

        self.size = SIZE

        self.A = LinearFillLLSparseMatrix(size=self.size, dtype=FLOAT64_T, itype=INT32_T, store_symmetry=True)


        self.C = self.A.to_csr()



    def test_memory_real_in_bytes(self):
        """
        Approximative test for internal memory.

        As the exact memory needed might change over time (i.e. differ with different implementations), we only
        test for a lower bound. This test also the existence of the method.
        """
        nrow, ncol = self.C.shape
        nnz = self.C.nnz

        real_memory_index = self.C.memory_index_in_bytes()
        real_memory_type = self.C.memory_element_in_bytes()
        real_memory_matrix = self.C.memory_real_in_bytes()


        # As of December 2015, this bound is tight!
        # col:  nnz * sizeof(index)
        # val:  nnz * sizeof(type)
        # ind:  (nrow + 1) * sizeof(index)

        self.assertTrue(real_memory_matrix >= ((nrow + 1 + nnz) * real_memory_index + nnz * real_memory_type))



#######################################################################
# Case: store_symmetry == False, Store_zero==True
#######################################################################
class CySparseInternalMemoryNoSymmetrySWithZero_CSRSparseMatrix_INT32_t_FLOAT64_t_TestCase(unittest.TestCase):
    def setUp(self):

        self.nrow = NROW
        self.ncol = NCOL

        self.A = LinearFillLLSparseMatrix(nrow=self.nrow, ncol=self.ncol, dtype=FLOAT64_T, itype=INT32_T, store_zero=True)


        self.C = self.A.to_csr()



    def test_memory_real_in_bytes(self):
        """
        Approximative test for internal memory.

        As the exact memory needed might change over time (i.e. differ with different implementations), we only
        test for a lower bound. This test also the existence of the method.
        """
        nrow, ncol = self.C.shape
        nnz = self.C.nnz

        real_memory_index = self.C.memory_index_in_bytes()
        real_memory_type = self.C.memory_element_in_bytes()
        real_memory_matrix = self.C.memory_real_in_bytes()


        # As of December 2015, this bound is tight!
        # col:  nnz * sizeof(index)
        # val:  nnz * sizeof(type)
        # ind:  (nrow + 1) * sizeof(index)

        self.assertTrue(real_memory_matrix >= ((nrow + 1 + nnz) * real_memory_index + nnz * real_memory_type))


#######################################################################
# Case: store_symmetry == True, Store_zero==True
#######################################################################
class CySparseInternalMemoryWithSymmetrySWithZero_CSRSparseMatrix_INT32_t_FLOAT64_t_TestCase(unittest.TestCase):
    def setUp(self):

        self.size = SIZE

        self.A = LinearFillLLSparseMatrix(size=self.size, dtype=FLOAT64_T, itype=INT32_T, store_symmetry=True, store_zero=True)


        self.C = self.A.to_csr()



    def test_memory_real_in_bytes(self):
        """
        Approximative test for internal memory.

        As the exact memory needed might change over time (i.e. differ with different implementations), we only
        test for a lower bound. This test also the existence of the method.
        """
        nrow, ncol = self.C.shape
        nnz = self.C.nnz

        real_memory_index = self.C.memory_index_in_bytes()
        real_memory_type = self.C.memory_element_in_bytes()
        real_memory_matrix = self.C.memory_real_in_bytes()


        # As of December 2015, this bound is tight!
        # col:  nnz * sizeof(index)
        # val:  nnz * sizeof(type)
        # ind:  (nrow + 1) * sizeof(index)

        self.assertTrue(real_memory_matrix >= ((nrow + 1 + nnz) * real_memory_index + nnz * real_memory_type))


if __name__ == '__main__':
    unittest.main()
