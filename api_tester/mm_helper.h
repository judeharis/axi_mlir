#ifndef MMHELPER
#define MMHELPER

using namespace std;
void print_matrix(int rows, int cols, int* matrix){
  cout << "==================================" << endl;
  for(int r=0;r<rows;r++){
    cout << "|";
    for(int c=0;c<cols;c++){
      // cout << matrix[r * cols  + c];
      printf("%-3d",matrix[r * cols  + c]);
      if(c+1<cols) cout << ",";
    }
    cout << "|" << endl;
  }
  cout << "==================================" << endl;
}

void save_matrix(string file,int rows, int cols, int* matrix){
  std::ofstream outfile;
  outfile.open(file, std::ios_base::app);
  outfile << "==================================" << endl;
  for(int r=0;r<rows;r++){
    outfile << "|";
    for(int c=0;c<cols;c++){
        // cout << matrix[r * cols  + c];
        //   printf("%-4d",matrix[r * cols  + c]);
      outfile << (int) matrix[r * cols  + c];
      if(c+1<cols) outfile << ",";
    }
    outfile << "|" << endl;
  }
  outfile << "==================================" << endl;
}

void simpleGEMM(int rows, int cols, int depth, int* inputs, int* weights, int* outputs){
  for(int i=0;i<rows;i++){
    for(int w=0;w<cols;w++){
      int acc = 0;
      for(int d=0;d<depth;d++){
        int x = inputs[i*depth+d];
        int y =  weights[d*cols + w];
        acc+=  x*y;
      }
      outputs[i*cols+w] = acc;
    }
  }

}
#endif // MMHELPER