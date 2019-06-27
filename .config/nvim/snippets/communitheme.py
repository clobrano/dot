import os
import sys

folder = sys.argv[1]
builddir = os.path.join(folder, 'build')
os.system('sudo -i -H ninja install -C {}'.format(builddir))
