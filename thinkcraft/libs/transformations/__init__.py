
from transformations import *
import numpy 
major,minor,sub = numpy.__version__.split('.')
if minor > 6:
    print "Use this command to build the c library in the transfromations directory:"
    print "# python setup.py build_ext --inplace"
    from _transformations import *
