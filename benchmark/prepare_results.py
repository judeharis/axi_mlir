#!/usr/bin/python3
import argparse
import os

def getDictFromFilename(filename):
  # perf_output/perf-results-driver-matmul-m32_n32_k32-CPU-accNONE.csv
  d = {}

  r = filename.split('-')
  r = r[3:]
  
  d['kernel_name']=r[0]
  d['kernel']='{}_i32'.format(r[0])

  s=r[1].replace('m','').replace('n','').replace('k','').split('_')
  
  d['m'] = s[0]
  d['n'] = s[1]
  d['k'] = s[2]
  d['dims']='{}_{}_{}'.format(s[0],s[1],s[2])

  d['strategy']=r[2]

  if('MANUAL' in d['strategy']):
    d['tool']='cpp_manual'
  else:
    d['tool']='mlir_{}'.format(d['strategy'])
  
  acc_size=r[3].split('.')[0].replace('acc','')
  d['accel_size']=acc_size

  d['hostname']=os.uname()[1] + "_rel"

  return d

def main(raw_args=None):
  parser = argparse.ArgumentParser(description='Annotate and concatenate perf csv results from a folder')
  parser.add_argument(dest='results_folder', type=str,
                      default='perf_output', help='Folder containing perf CSV outputs')

  args = parser.parse_args(raw_args)

  directory = args.results_folder

  for filename in os.listdir(directory):
    if 'csv' in filename:
      f = os.path.join(directory, filename)
      # checking if it is a file
      d = {}
      if os.path.isfile(f):
        # print(f)
        d = getDictFromFilename(f)

      with open(f) as file:
        for l in file.readlines():
          if (',' in l):
            # Format : 
            # problem_size,dims,kernel,tool,accel_version,accel_size,accel_version,strategy,threads,board,REST OF PERF OUT,filename
            print('{},{},{},{},{},{},{},{},{},{},{}'.format(d['dims'],d['dims'],d['kernel'],d['tool'],d['accel_size'],1,1,1,d['hostname'],l.strip('\n'),filename))

if __name__ == "__main__":
    main()
