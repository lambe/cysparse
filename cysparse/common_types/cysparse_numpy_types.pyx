cimport cysparse.common_types.cysparse_types as cp_types
cimport numpy as cnp
#from numpy.math cimport INFINITY
import numpy as np

#INFINITY = np.inf



CYSPARSE_TYPES_TO_NUMPY_DICT = dict()

CYSPARSE_TYPES_TO_NUMPY_DICT[cp_types.INT32_T] = np.int32
CYSPARSE_TYPES_TO_NUMPY_DICT[cp_types.UINT32_T] = np.uint32
CYSPARSE_TYPES_TO_NUMPY_DICT[cp_types.INT64_T] = np.int64
CYSPARSE_TYPES_TO_NUMPY_DICT[cp_types.UINT64_T] = np.uint64
CYSPARSE_TYPES_TO_NUMPY_DICT[cp_types.FLOAT32_T] = np.float32
CYSPARSE_TYPES_TO_NUMPY_DICT[cp_types.FLOAT64_T] = np.float64
CYSPARSE_TYPES_TO_NUMPY_DICT[cp_types.FLOAT128_T] = np.float128
CYSPARSE_TYPES_TO_NUMPY_DICT[cp_types.COMPLEX64_T] = np.complex64
CYSPARSE_TYPES_TO_NUMPY_DICT[cp_types.COMPLEX128_T] = np.complex128
CYSPARSE_TYPES_TO_NUMPY_DICT[cp_types.COMPLEX256_T] = np.complex256

def numpy_to_cysparse_type(numpy_type):
    """
    Return the corresponding :program:`CySparse` type when the :program:`NumPy` type is compatible.

    Args:
        numpy_type:


    """

    if not np.issctype(numpy_type):
        raise TypeError("Not a NumPy type")

    # we use the == operator defined by NumPy
    # this also allows the test of dtype for ndarrays
    if numpy_type == np.int32:
        return cp_types.INT32_T
    elif numpy_type == np.uint32:
        return cp_types.UINT32_T
    elif numpy_type == np.int64:
        return cp_types.INT64_T
    elif numpy_type == np.uint64:
        return cp_types.UINT64_T
    elif numpy_type == np.float32:
        return cp_types.FLOAT32_T
    elif numpy_type == np.float64:
        return cp_types.FLOAT64_T
    elif numpy_type == np.float128:
        return cp_types.FLOAT128_T
    elif numpy_type == np.complex64:
        return cp_types.COMPLEX64_T
    elif numpy_type == np.complex128:
        return cp_types.COMPLEX128_T
    elif numpy_type == np.complex256:
        return cp_types.COMPLEX256_T
    else:
        raise TypeError("Not a NumPy compatible type")

def is_numpy_type_compatible(numpy_type):
    """
    Test if a :program:`NumPy` type is compatible with :program:`CySparse`.

    Args:
        numpy_type:

    """
    try:
        numpy_to_cysparse_type(numpy_type)
        return True
    except TypeError:
        return False

def cysparse_to_numpy_type(cp_types.CySparseType cysparse_type):
    """
    Return the corresponding compatible :program:`NumPy` type.

    Args:
        cysparse_type:


    """
    # the test on the argument's type is done by Cython
    return CYSPARSE_TYPES_TO_NUMPY_DICT[cysparse_type]

# TODO: change name to are_mixed_types_strictly_compatible
def are_mixed_types_compatible(cp_types.CySparseType cysparse_type, numpy_type):
    """
    Test if two types are **strictly** compatible.

    Args:
        cysparse_type:
        numpy_type:

    """
    return cysparse_to_numpy_type(cysparse_type) == numpy_type

def are_mixed_types_cast_compatible(cp_types.CySparseType cysparse_type, numpy_type):
    """
    Test if two mixed types are compatible with a cast if needed, i.e. a cast of the :program:`NumPy` ``numpy_type``
    type to the :program:`CySparse` type.

    Args:
        cysparse_type:
        numpy_type:

    """
    if not is_numpy_type_compatible(numpy_type):
        return False

    cdef:
        cp_types.CySparseType numpy_type_to_cysparse_type = numpy_to_cysparse_type(numpy_type)
        cp_types.CySparseType resulting_type
    try:
        resulting_type = <cp_types.CySparseType> cp_types.result_type(cysparse_type, numpy_type_to_cysparse_type)
    except TypeError:
        return False

    return resulting_type == cysparse_type