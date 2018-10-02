//2nd introduction to programming in cuda 

_global_ void add2Vector(int N, float *d_A, float *d_B, float *d_C)
{
	int i = blockIdx.x * blockDim.x + threadIdx.x;
	
	if(i < N)
		d_C[i] = d_A[i] + d_B[i];
		//cout<<d_C[i];
}

int main(int argc, char **argv)
{
	int N = 5;
	float *A, *B, *C;
	A = (float*)malloc(N*sizeof(float));
	B = (float*)malloc(N*sizeof(float));
	C = (float*)malloc(N*sizeof(float));
	
	for (int i = 0; i < N; i++)
	{
		cout<<"Nhap a"<<i<<": ";
		cin>>A[i];
		cout<<"Nhap b"<<i<<": ";
		cin>>B[i];
	}
	
	for(int j = 0; j < N; j++)
	{
		cout<<a[i]<<"  "<<B[i]<<endl;
	}
	
	float *d_A, *d_B, *d_C;
	cudaMalloc(&d_A, N * sizeof(float));
	cudaMalloc(&d_B, N * sizeof(float));
	cudaMalloc(&d_C, N * sizeof(float));
	
	cudaMemcpy(d_A, A, N*sizeof(float), cudaMemcpyHostToDevice);
	cudaMemcpy(d_B, B, N*sizeof(float), cudaMemcpyHostToDevice);

	add2Vector<<ceil(N/256.0), 256>>(N, d_A, d_B, d_C);
	
	cudaMemcpy(C, d_C, N*sizeof(float), cudaMemcpyDeviceToHost);
	
	cout<<"Ket qua: "<<endl;
	for(int i = 0; i < N; i++)
		cout<<C[i]<< " ";
	cudaDeviceReset();
	return 0;
}