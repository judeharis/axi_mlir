#!/usr/bin/python3
import argparse
import os

def getDictFromFilename(filename):
  # perf_output/perf-results-driver-matmul-m32_n32_k32-CPU-accNONE.csv
  # perf_output/perf-results-driver-matmul-m64_n64_k64-CPU-accNONE-app.csv
  # perf_output/perf-results-driver-matmul-m64_n64_k64-ACC-acc4_v1_Ns-app.csv
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

  # if MAN or MANUAL, then cpp_manual
  if('MAN' in d['strategy'] or 'MANUAL' in d['strategy']):
    d['tool']='cpp_manual'
  else:
    d['tool']='mlir_{}'.format(d['strategy'])

  # handle: "accNONE" or "acc4_v1_Ns" 
  acc_info=r[3].split('.')[0].replace('acc','')
  acc_info=acc_info.split('_')
  acc_size=0
  acc_version='NONE'
  acc_strategy='NONE'
  if(acc_info[0]=='NONE'):
    acc_size=0
    acc_version='NONE'
    acc_strategy='NONE'
  else:
    acc_size=acc_info[0]
    acc_version=acc_info[1]
    acc_strategy=acc_info[2]

  d['accel_size']=acc_size
  d['accel_version']=acc_version
  d['accel_strategy']=acc_strategy

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
            # problem_size,dims,kernel,tool,accel_size,accel_version,strategy,threads,board,REST OF PERF OUT,filename
            print('{},{},{},{},{},{},{},{},{},{},{}'.format(d['dims'],d['dims'],d['kernel'],d['tool'],d['accel_size'], d['accel_version'],d['accel_strategy'],1,d['hostname'],l.strip('\n'),filename))

if __name__ == "__main__":
    main()
