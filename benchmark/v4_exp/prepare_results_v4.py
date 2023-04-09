#!/usr/bin/python3
import argparse
import os

def getDictFromFilename(filename):
  # perf_output/perf-results-driver-matmul-m32_n32_k32-CPU-accNONE.csv
  # perf_output/perf-results-driver-matmul-m64_n64_k64-CPU-accNONE-app.csv
  # perf_output/perf-results-driver-matmul-m64_n64_k64-ACC-acc4_v1_Ns-app.csv
  # perf-results-driver-matmul-m512_n1024_k64-ACC_v4_As_64_64_64_0-MAN-app
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
  d['compile']=r[3]

  # if MAN or MANUAL, then cpp_manual
  if('MAN' in d['compile'] or 'MANUAL' in d['compile']):
    d['tool']='cpp_MAN'
  else:
    d['tool']='MLIR'

  # handle: "accNONE" or "acc4_v1_Ns" 
  # acc_info=r[2].split('.')[0].replace('acc','')
# ACC_v4_As_64_64_64_0
  acc_info=r[2].split('_')
  acc_size=0
  acc_version='NONE'
  acc_strategy='NONE'
  acc_id=0
  if(acc_info[0]=='NONE'):
    acc_size=0
    acc_version='NONE'
    acc_strategy='NONE'
  else:
    acc_size="16"
    acc_version=acc_info[1]
    acc_strategy=acc_info[2] + "_" + acc_info[3] + "_" + acc_info[4] + "_" + acc_info[5]
    acc_id=acc_info[6]

  d['accel_size']=acc_size
  d['accel_version']=acc_version
  d['accel_strategy']=acc_strategy
  d['prob_id']=acc_id

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
            # problem_id,dims,kernel,tool,accel_size,accel_version,strategy,threads,board,REST OF PERF OUT,filename
            print('{},{},{},{},{},{},{},{},{},{},{}'.format(d['prob_id'],d['dims'],d['kernel'],d['tool'],d['accel_size'], d['accel_version'],d['accel_strategy'],1,d['hostname'],l.strip('\n'),filename))

if __name__ == "__main__":
    main()
