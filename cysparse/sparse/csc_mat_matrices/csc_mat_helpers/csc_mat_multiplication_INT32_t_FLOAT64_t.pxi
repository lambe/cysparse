

###################################################
# CSCSparseMatrix by Numpy vector
###################################################
######################
# A * b
######################
cdef cnp.ndarray[cnp.npy_float64, ndim=1, mode='c'] multiply_csc_mat_with_numpy_vector_INT32_t_FLOAT64_t(CSCSparseMatrix_INT32_t_FLOAT64_t A, cnp.ndarray[cnp.npy_float64, ndim=1] b):
    """
    Multiply a :class:`CSCSparseMatrix` ``A`` with a numpy vector ``b``.

    Args
        A: A :class:`CSCSparseMatrix`.
        b: A numpy.ndarray of dimension 1 (a vector).

    Returns:
        ``c = A * b``: a **new** numpy.ndarray of dimension 1.

    Raises:
        IndexError if dimensions don't match.

    Note:
        This version is general as it takes into account strides in the numpy arrays and if the :class:`CSCSparseMatrix`
        is symmetric or not.


    """
    # TODO: test, test, test!!!
    cdef INT32_t A_nrow = A.nrow
    cdef INT32_t A_ncol = A.ncol

    cdef size_t sd = sizeof(FLOAT64_t)

    # test dimensions
    if A_ncol != b.size:
        raise IndexError("Dimensions must agree ([%d,%d] * [%d, %d])" % (A_nrow, A_ncol, b.size, 1))

    # direct access to vector b
    cdef FLOAT64_t * b_data = <FLOAT64_t *> cnp.PyArray_DATA(b)

    # array c = A * b

    # for the moment, I (Nikolaj) choose to keep np.empty and to use memset in the kernel...

    # if you choose to use np.zeros instead of np.empty...
    # TODO: the non continguous version is a bit overkill...
    #        - the kernel version is too broad for this call (c_data, c.strides[0] / sd doesn't make sense here)
    #        - for the moment the y vector is init to 0 twice... once here and once in the kernel...

    cdef cnp.ndarray[cnp.npy_float64, ndim=1] c = np.empty(A_nrow, dtype=np.float64)
    #cdef cnp.ndarray[cnp.npy_float64, ndim=1] c = np.zeros(A_nrow, dtype=np.float64)

    cdef FLOAT64_t * c_data = <FLOAT64_t *> cnp.PyArray_DATA(c)

    # test if b vector is C-contiguous or not
    if cnp.PyArray_ISCONTIGUOUS(b):
        if A.__store_symmetric:
            pass
            multiply_sym_csc_mat_with_numpy_vector_kernel_INT32_t_FLOAT64_t(A_nrow, A_ncol, b_data, c_data, A.val, A.row, A.ind, 1)
        else:
            multiply_csc_mat_with_numpy_vector_kernel_INT32_t_FLOAT64_t(A_nrow, A_ncol, b_data, c_data, A.val, A.row, A.ind, 1)
    else:
        if A.__store_symmetric:
            multiply_sym_csc_mat_with_strided_numpy_vector_kernel_INT32_t_FLOAT64_t(A.nrow, A.ncol,
                                                                 b_data, b.strides[0] / sd,
                                                                 c_data, c.strides[0] / sd,
                                                                 A.val, A.row, A.ind)
        else:
            multiply_csc_mat_with_strided_numpy_vector_kernel_INT32_t_FLOAT64_t(A.nrow, A.ncol,
                                                             b_data, b.strides[0] / sd,
                                                             c_data, c.strides[0] / sd,
                                                             A.val, A.row, A.ind)

    return c


######################
# A^t * b
######################
cdef cnp.ndarray[cnp.npy_float64, ndim=1, mode='c'] multiply_transposed_csc_mat_with_numpy_vector_INT32_t_FLOAT64_t(CSCSparseMatrix_INT32_t_FLOAT64_t A, cnp.ndarray[cnp.npy_float64, ndim=1] b):
    """
    Multiply a transposed :class:`CSCSparseMatrix` ``A`` with a numpy vector ``b``.

    Args
        A: A :class:`CSCSparseMatrix`.
        b: A numpy.ndarray of dimension 1 (a vector).

    Returns:
        :math:`c = A^t * b`: a **new** numpy.ndarray of dimension 1.

    Raises:
        IndexError if dimensions don't match.

    Note:
        This version is general as it takes into account strides in the numpy arrays and if the :class:`CSCSparseMatrix`
        is symmetric or not.

    """
    # TODO: test, test, test!!!
    cdef INT32_t A_nrow = A.nrow
    cdef INT32_t A_ncol = A.ncol

    cdef size_t sd = sizeof(FLOAT64_t)

    # test dimensions
    if A_nrow != b.size:
        raise IndexError("Dimensions must agree ([%d,%d] * [%d, %d])" % (A_ncol, A_nrow, b.size, 1))

    # direct access to vector b
    cdef FLOAT64_t * b_data = <FLOAT64_t *> cnp.PyArray_DATA(b)

    # array c = A^t * b
    # TODO: check if we can not use static version of empty (cnp.empty instead of np.empty)
    cdef cnp.ndarray[cnp.npy_float64, ndim=1] c = np.empty(A_ncol, dtype=np.float64)
    cdef FLOAT64_t * c_data = <FLOAT64_t *> cnp.PyArray_DATA(c)

    # test if b vector is C-contiguous or not
    if cnp.PyArray_ISCONTIGUOUS(b):
        if A.__store_symmetric:
            multiply_sym_csc_mat_with_numpy_vector_kernel_INT32_t_FLOAT64_t(A_nrow, A_ncol, b_data, c_data, A.val, A.row, A.ind)
        else:
            multiply_tranposed_csc_mat_with_numpy_vector_kernel_INT32_t_FLOAT64_t(A_nrow, A_ncol, b_data, c_data,
         A.val, A.row, A.ind)
    else:
        if A.__store_symmetric:
            multiply_sym_csc_mat_with_strided_numpy_vector_kernel_INT32_t_FLOAT64_t(A.nrow, A_ncol,
                                                                 b_data, b.strides[0] / sd,
                                                                 c_data, c.strides[0] / sd,
                                                                 A.val, A.row, A.ind)
        else:
            multiply_tranposed_csc_mat_with_strided_numpy_vector_kernel_INT32_t_FLOAT64_t(A_nrow, A_ncol,
                                                                                      b_data, b.strides[0] / sd,
                                                                                      c_data, c.strides[0] / sd,
                                                                                      A.val, A.row, A.ind)

    return c

