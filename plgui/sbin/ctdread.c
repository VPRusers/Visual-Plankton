#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "mex.h"
#define N_ELEMS  10
void readctd(char *fn, int ndata, double *d);

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
  char fn[128];
  const int ndata =110000; 
//  mxArray *Out; 
  double  *d;

/* check the inputs */
  if  (nrhs != 1)
    {
        mexErrMsgIdAndTxt("Images:cq:twoInputsRequired",
                          "%s","1 input arguments required.");
    }
  else if (nlhs >1) {
       mexErrMsgTxt("Two many output arguments.");
    }

 
    mxGetString(prhs[0], fn, mxGetM(prhs[0]) * mxGetN(prhs[0]) * sizeof(mxChar)+ 1);
//       Out = mxCreateNumericMatrix(N_ELEMS, ndata, mxINT32_CLASS, mxREAL);
//       Out = mxCreateDoubleMatrix(N_ELEMS, ndata, mxREAL);
         plhs[0]=mxCreateDoubleMatrix(N_ELEMS,ndata,mxREAL);

//       d = (long int *)mxGetPr(Out);
       d = (double *)mxGetPr(plhs[0]);

    readctd(fn, ndata, d);
//    plhs[0]=Out;
}

void readctd(char *fn, int ndata, double *d)
 {
  FILE *fp; 
//  char s[128], t[64], r[8];
  int n;
  long int ts; 
   fp =fopen(fn,"rt");
   if (fp ==NULL)
    {
       mexErrMsgTxt("Error: Cannot open input file");
     }
/*  
         mexPrintf("%s %d\n", fn,ndata);
*/
   n=0;
   while(n<ndata && feof(fp)==0)
     {
//     if (feof(fp)==0)
  //       {

//         fscanf(fp,"%3s %8d %1s %f %1s %f %1s %f %1s %f %1s %f %1s %f %1s %f %1s %f",&r,d+n*9,&r, d+n*9+1,&r, d+n*9+2,&r,d+n*9+3,&r,d+n*9+4,&r,d+n*9+5,&r,d+n*9+6,&r,d+n*9+7,&r,d+n*9+8);
         fscanf(fp,"%*3s %8d",&ts);
		 *(d+n*10)=ts;
		 fscanf(fp,"%*1s %lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf",d+n*10+1,d+n*10+2,d+n*10+3,d+n*10+4,d+n*10+5,d+n*10+6,d+n*10+7,d+n*10+8,d+n*10+9);

 //        }
      n++;
     }
    fclose(fp);
}
