#The docs state that the 
#Pythonic "for i in x"
#syntax works with STL 
#containers.
#
#Sometimes it works,
#sometimes it doesn't,
#and the behavior is 
#inconsistent

from libcpp.map cimport map
from libcpp.vector cimport vector

cdef unsigned iterate_map(map[unsigned,unsigned] & foo) nogil:

    cdef unsigned sum1=0
    for i in foo:
        sum1+=i.second

    return sum1

#When used with a vector, 
#and modeling after the iterate_map function,
#the function must NOT be nogil...:
cdef unsigned iterate_vector(vector[unsigned] & foo):

    cdef unsigned sum1=0
    for i in foo:
        sum1+=i

    return sum1

#...unless i gets declared as a cdef variable:
cdef unsigned iterate_vector2(vector[unsigned] & foo) nogil:

    cdef unsigned sum1=0
    cdef unsigned i
    for i in foo:
        sum1+=i

    return sum1


