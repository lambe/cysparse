# TODO: verify if we need to generate this file
# For the moment I (Nikolaj) 'm leaving it as it is just in case things change...

from cysparse.sparse.s_mat cimport SparseMatrix
#from cysparse.sparse.sparse_proxies cimport ProxySparseMatrix

from cysparse.types.cysparse_numpy_types import are_mixed_types_compatible, cysparse_to_numpy_type
from cysparse.sparse.ll_mat cimport PyLLSparseMatrix_Check

cimport numpy as cnp

cnp.import_array()

from python_ref cimport Py_INCREF, Py_DECREF, PyObject
cdef extern from "Python.h":
    # *** Types ***
    int PyInt_Check(PyObject *o)


cdef class TransposedSparseMatrix:
    """
    Proxy to the transposed matrix of a :class:`SparseMatrix`.

    """
    ####################################################################################################################
    # Init and properties
    ####################################################################################################################
    ####################################################################################################################
    # Common code from p_mat.pyx See #113: I could not solve the circular dependencies...
    ####################################################################################################################
    def __cinit__(self, SparseMatrix A):
        self.A = A
        Py_INCREF(self.A)  # increase ref to object to avoid the user deleting it explicitly or implicitly

    property nrow:
        def __get__(self):
            return self.A.ncol

        def __set__(self, value):
            raise AttributeError('Attribute nrow is read-only')

        def __del__(self):
            raise AttributeError('Attribute nrow is read-only')

    property ncol:
        def __get__(self):
            return self.A.nrow

        def __set__(self, value):
            raise AttributeError('Attribute ncol is read-only')

        def __del__(self):
            raise AttributeError('Attribute ncol is read-only')

    property dtype:
        def __get__(self):
            return self.A.cp_type.dtype

        def __set__(self, value):
            raise AttributeError('Attribute dtype is read-only')

        def __del__(self):
            raise AttributeError('Attribute dtype is read-only')

    property itype:
        def __get__(self):
            return self.A.cp_type.itype

        def __set__(self, value):
            raise AttributeError('Attribute itype is read-only')

        def __del__(self):
            raise AttributeError('Attribute itype is read-only')

    # for compatibility with numpy, PyKrylov, etc
    property shape:
        def __get__(self):
            return self.A.ncol, self.A.nrow

        def __set__(self, value):
            raise AttributeError('Attribute shape is read-only')

        def __del__(self):
            raise AttributeError('Attribute shape is read-only')

    def __dealloc__(self):
        Py_DECREF(self.A) # release ref

    def __repr__(self):
        return "Proxy to the transposed (.T) of %s" % self.A

    ####################################################################################################################
    # End of Common code
    ####################################################################################################################
    
    @property
    def T(self):
        return self.A

    
    @property
    def H(self):
        return self.A.conj

    
    @property
    def conj(self):
        return self.A.H

    ####################################################################################################################
    # Set/get
    ####################################################################################################################
    def __getitem__(self, tuple key):
        if len(key) != 2:
            raise IndexError('Index tuple must be of length 2 (not %d)' % len(key))

        if not PyInt_Check(<PyObject *>key[0]) or not PyInt_Check(<PyObject *>key[1]):
            raise IndexError("Only integers are accepted as indices for a transposed matrix")

        return self.A[key[1], key[0]]

    ####################################################################################################################
    # Basic operations
    ####################################################################################################################
    def __mul__(self, B):
        if cnp.PyArray_Check(B):
            # test type
            assert are_mixed_types_compatible(self.dtype, B.dtype), "Multiplication only allowed with a Numpy compatible type (%s)!" % cysparse_to_numpy_type(self.dtype)

            if B.ndim == 2:
                return self.A.matdot(B)
            elif B.ndim == 1:
                return self.A.matvec_transp(B)
            else:
                raise IndexError("Matrix dimensions must agree")
        elif PyLLSparseMatrix_Check(B):
            return self.A.matdot(B)
        else:
            raise NotImplementedError("Multiplication with this kind of object not implemented yet...")

    def matvec(self, B):
        return self.A.matvec_transp(B)

    def matvec_transp(self, B):
        return self.A.matvec(B)

    def matrix_copy(self):
        #return self.A.create_submatrix()
        pass

    def print_to(self, OUT):
        return self.A.print_to(OUT, transposed=True)