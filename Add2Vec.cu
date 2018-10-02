//2nd introduction to programming in cuda 
#include <stdio.h>

// check err
#define CUDA_CHECK(call)\
{\
	cudaError_t err = call;\
	if (err != cudaSuccess)\
	{\
		printf("%s in %s at line %d!\n", cudaGetErrorString(err), __FILE__, __LINE__);\
		exit(EXIT_FAILURE);\
	}\
}

// kernel
__global__ void add2Vector(int N, float *d_A, float *d_B, float *d_C)
{
	int i = blockIdx.x * blockDim.x + threadIdx.x;
	
	if(i < N)
		d_C[i] = d_A[i] + d_B[i];
		//printf("%f  ", d_C[i]);
		//cout<<d_C[i];
}

int main(int argc, char **argv)
{
	int N = 200000000;
	float *A, *B, *C;
	A = (float*)malloc(N*sizeof(float));
	B = (float*)malloc(N*sizeof(float));
	C = (float*)malloc(N*sizeof(float));
	
	for (int i = 0; i < N; i++)
	{
		//printf("Nhap A%d : ", i);
		//scanf("%f", &A[i]);
		//printf("Nhap B%d : ", i);
		//scanf("%f", &B[i]);
		A[i] = i;
		B[i] = i;
	}
	
	
	//for(int j = 0; j < N; j++)
	//{
		//printf("%f   %f\n", A[j], B[j]); 
	//}
	
	
	float *d_A, *d_B, *d_C;
	
	CUDA_CHECK(cudaMalloc(&d_A, N * sizeof(float)));
	CUDA_CHECK(cudaMalloc(&d_B, N * sizeof(float)));
	CUDA_CHECK(cudaMalloc(&d_C, N * sizeof(float)));
	
	CUDA_CHECK(cudaMemcpy(d_A, A, N*sizeof(float), cudaMemcpyHostToDevice));
	CUDA_CHECK(cudaMemcpy(d_B, B, N*sizeof(float), cudaMemcpyHostToDevice));
	
	dim3 blockSize(256);
	dim3 gridSize((N-1)/256 + 1);
	
	clock_t begin = clock();
	add2Vector<<<gridSize, blockSize>>>(N, d_A, d_B, d_C);
	
	cudaDeviceSynchronize();
	clock_t end = clock();
	CUDA_CHECK(cudaGetLastError());
	
	CUDA_CHECK(cudaMemcpy(C, d_C, N*sizeof(float), cudaMemcpyDeviceToHost));
	
	//printf("Ket qua: \n");
	//for(int i = 0; i < N; i++)
		//printf("%f  ", C[i]);
	float time = (float)(end - begin)/CLOCKS_PER_SEC;
	printf("\nThoi gian tinh toan: %f\n",  time);
	cudaFree(d_A);
	cudaFree(d_B);
	cudaFree(d_C);
	cudaDeviceReset();
	return 0;
}