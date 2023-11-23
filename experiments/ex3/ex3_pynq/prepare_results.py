#!/usr/bin/python3
import argparse
import os

# driver-conv2d-B1_IHW9_IC512_FHW3_OC512_ST1-MANUAL-ACC-v3-Fs-app

def getDictFromFilename(filename):
  d = {}
  r = filename.split('-')
  r = r[3:]

  d['kernel_name']=r[0]
  d['kernel']='{}_i32'.format(r[0])

  d['tag']=r[1]

  s=r[1].replace('B','').replace('IHW','').replace('IC','').replace('FHW','').replace('OC','').replace('ST','').split('_')
  
  d['b'] = s[0]
  d['ihw'] = s[1]
  d['ic'] = s[2]
  d['fhw'] = s[3]
  d['oc'] = s[4]
  d['st'] = s[5]


  d['dims']='{}_{}_{}_{}_{}_{}'.format(d['b'],d['ihw'],d['ic'],d['fhw'],d['oc'],d['st'])


  d['strategy']=r[2]
  d['accel_version']=r[3]
  d['accel_strategy']=r[4]


  # if MAN or MANUAL, then cpp_manual
  if('MAN' in d['strategy'] or 'MANUAL' in d['strategy']):
    d['tool']='cpp_MAN'
  else:
    d['tool']=d['strategy']



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
            # problem_id,dims,kernel,tool,accel_size,accel_version,strategy,threads,board,REST OF PERF OUT
            print('{},{},{},{},{},{},{},{},{}'.format(d['tag'],d['dims'],d['kernel'],d['tool'], d['accel_version'],d['accel_strategy'],1,d['hostname'],l.strip('\n')))

if __name__ == "__main__":
    main()
