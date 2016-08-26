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

#The map cannot be passed in as const,
#otherwise will fail to compile.
#Looking at the generated .cpp
#shows that Cython will declare
#iterator instead of const_iterator
#if foo is passed in as const:
#static unsigned int __pyx_f_10auto_like1_iterate_map(std::map<unsigned int,unsigned int>  const &__pyx_v_foo) {
#  unsigned int __pyx_v_sum1;
#  std::pair<unsigned int,unsigned int>  __pyx_v_i;
#  unsigned int __pyx_r;
#  std::map<unsigned int,unsigned int> ::iterator __pyx_t_1;
#  std::pair<unsigned int,unsigned int>  __pyx_t_2;
cdef unsigned iterate_map(map[unsigned,unsigned] & foo) nogil:

    cdef unsigned sum1=0
    for i in foo:
        sum1+=i.second

    return sum1

#When used with a vector, 
#and modeling after the iterate_map function,
#the function must NOT be nogil, else Cython will
#fail to generate a .cpp file...
cdef unsigned iterate_vector(vector[unsigned] & foo):

    cdef unsigned sum1=0
    #This code is generating PyObject temporaries,
    #but the iterate_map function above correctly 
    #generated the pair as the temporary:
    #static unsigned int __pyx_f_10auto_like1_iterate_vector(std::vector<unsigned int>  &__pyx_v_foo) {
    #unsigned int __pyx_v_sum1;
    #PyObject *__pyx_v_i = NULL;
    #unsigned int __pyx_r;
    #__Pyx_RefNannyDeclarations
    #std::vector<unsigned int> ::iterator __pyx_t_1;
    #unsigned int __pyx_t_2;
    #PyObject *__pyx_t_3 = NULL;
    #PyObject *__pyx_t_4 = NULL;
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


