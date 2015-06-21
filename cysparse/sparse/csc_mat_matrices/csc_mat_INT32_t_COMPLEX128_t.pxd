from cysparse.types.cysparse_types cimport *

from cysparse.sparse.s_mat_matrices.s_mat_INT32_t_COMPLEX128_t cimport ImmutableSparseMatrix_INT32_t_COMPLEX128_t
from cysparse.sparse.ll_mat_matrices.ll_mat_INT32_t_COMPLEX128_t cimport LLSparseMatrix_INT32_t_COMPLEX128_t


cdef class CSCSparseMatrix_INT32_t_COMPLEX128_t(ImmutableSparseMatrix_INT32_t_COMPLEX128_t):
    """
    Compressed Sparse Row Format matrix.

    Note:
        This matrix can **not** be modified.

    """
    ####################################################################################################################
    # Init/Free
    ####################################################################################################################
    cdef:
        COMPLEX128_t     *val		 # pointer to array of values
        INT32_t    *row		 # pointer to array of indices
        INT32_t    *ind		 # pointer to array of indices

        bint __col_indices_sorted_test_done  # we only test this once
        bint __col_indices_sorted  # are the column indices sorted in ascending order?
        INT32_t __first_row_not_ordered # first row that is not ordered

    cdef at(self, INT32_t i, INT32_t j)

    # this is needed as for the complex type, Cython's compiler crashes...
    cdef COMPLEX128_t safe_at(self, INT32_t i, INT32_t j) except *


cdef MakeCSCSparseMatrix_INT32_t_COMPLEX128_t(INT32_t nrow, INT32_t ncol, INT32_t nnz, INT32_t * ind, INT32_t * row, COMPLEX128_t * val, bint __is_symmetric)