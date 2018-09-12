m = 3;          % Number of bits per symbol
n = 2^m - 1;    % Codeword length
k = 5;          % Message length  - becaues of the nature of n, k must always be odd when m>0


msg = gf([0 1 0 1 0],m);      %creating a galouis field 

code = rsenc(msg,n,k);         %encoding the message created above

errors = linspace(0 ,0, length(code));

%errors(3) = 325;


noisy  = code + errors;

[rxcode, cnumerr] = rsdec(noisy,n,k);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Hand encoding process
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%creating a matrix
%
%   The encoding matrix is part identity for the first 4 rows and then
%   parity for the last 2, this way if any of the rows get corrupted we can
%   eliminate those rows and use the resulting inverse matrix to find the
%   original values
%


encodingMatrix = [01 00 00 00; 00 01 00 00; 00 00 01 00; 00 00 00 01; 27 28 12 14; 28 27 14 12]

%encodedMatrix = encodingMatrix * dataMatrix

    
generatorMatrix = [1 0 0 0 0 0; 0 1 0 0 0 0; 0 0 1 0 0 0; 0 0 0 1 0 0; 0 0 0 0 1 0; 0 0 0 0 0 1; 1 1 1 1 1 1; 32 16 8 4 2 1]

dataMatrix = [1 0 1 0 1 0; 0 0 0 1 1 1; 1 1 1 0 0 0; 0 1 0 1 0 1; 0 0 1 1 0 0; 1 1 0 0 1 1]

%   dataMatrix
%
%   1 0 1 0 1 0
%   0 0 0 1 1 1
%   1 1 1 0 0 0
%   0 1 0 1 0 1
%   0 0 1 1 0 0
%   1 1 0 0 1 1
%

encodedData = generatorMatrix * dataMatrix

% The data is encoded to have two extra rows of data that will help RS fix
% whatever is wrong with the data through rs_encoding

%with the encoded data we can currupt it and see if we can restore it with
%a simple matrix inversion technique


modifiedMatrix = encodedData([1:2,5:8],:)

modifiedGenerator = generatorMatrix([1:2, 5:8],:)

% Two of the rows of the matrix [3:4] are considered currupt, we can get
% teh original matrix for the inputted data by running a method to use the
% inverse generator matrix to get back the lost data like below.

fixedMatrix = inv(modifiedGenerator) * modifiedMatrix

dataMatrix

% if the data isn't normallized matlab will say a boolean comparison like
% dataMatrix == fixedMatrix isn't completely true.  This is because the end
% result is in floating point compared to integers for some of the values

%dataMatrix == fixedMatrix


