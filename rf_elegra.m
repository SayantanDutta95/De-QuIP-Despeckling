function y0 = rf_elegra(fnam,nv1,nv2,f,decim,intf)
%  		y0 = rf_elegra(fnam,nv1,nv2,f,decim,intf)
%
%  returns the re-constituted rf for data acquired with Elegra.
%
%  fnam is the data file name, nv1 is the first A-line to be returned, nv2 
%  is the last A-line to be returned in y0, f is the mixing frequency, 
%  decim is the decimation rate in Elegra data, intf is the interpolation 
%  factor to be used for generating the rf.  If nv1=nv2=0, entire echo 
%  field is processed.
%
%  Also see elegra1.

[I0,Q0,nv,np,fn]    = elegra(fnam);	 %starting point

if nv1 == 0 | nv2 ==0
   nv1 = 1;
   nv2 = nv;
end;

%  complex envelope

[nri,nci]=size(I0);
ce0 = I0(:,nv1:nv2) + i*Q0(:,nv1:nv2);
[nrc0,ncc0]=size(ce0);
ce0i = zeros(intf*size(ce0,1),size(ce0,2));

%  time and frequency axes for the interpolated data

dti= decim/(36*intf);
dui= 1/(size(ce0i,1)*dti);
ti = 0:dti:(size(ce0i,1)-1)*dti;
ui = -(size(ce0i,1)-1)*dui/2:dui:(size(ce0i,1)-1)*dui/2;
wt = 2*pi*f*(ti);

%  interpolated complex envelope

%ce0i = interpft(ce0,intf*size(ce0,1));

for j=1:ncc0
   ce0i(:,j) = interpft(ce0(:,j),nrc0*intf);
end;

%  sine and cosine functions for re-constituting rf

cwtp = cos(wt).';
swtp = sin(wt).';
cwt = repmat(cwtp,1,nv2-nv1+1);
swt = repmat(swtp,1,nv2-nv1+1);

%  rf data

y0 = real(ce0i).*cwt - imag(ce0i).*swt;


function [I,Q,nv,np,fn] = elegra(filename);
%
%	---------------------------------------------------------
% This contains proprietary information and is not for distribution. 
%	---------------------------------------------------------
%
% This file reads single frames of data acquired with the Siemens 
% Elegra in B-mode IQ Bypass mode. 
%
% USAGE: 
%	[I,Q,nv,np,fn] = elegra1(filename);
% It is assumed that the data have been acquired using imGetFrames() 
% and transferred to the Alpha (OpenVMS) using NFS. (The issue here 
% is byte ordering.) The data being read are 16-bit data words with 
% 12 valid bits per data point. The entire array is read. The frame 
% header is 9 words long and contains the frame number and the number 
% of vectors, which allows calculation of the number of points per 
% vector. The image data follows the frame header, and is written 
% vector by vector. Each vector has a 16-word header followed by an 
% I,Q,junk triplet of one word each.
%
%	I and Q are the complex baseband rf signal data
%	nv = the number of vectors per frame
%	np = the number of samples (I or Q) per vector
%	fn = the frame number
%	ce = the complex envelope = I + i*Q
%
%	angle(ce) = the phase
%	abs(ce)	  = the envelope of the bandpass signal

% Open the file with read-only access and big-endian byte ordering

fid = fopen(filename,'r','ieee-be');

% Read the data using unsigned 16-bit words. This doesn't allow 
% direct reading of the baseEchoAddress in DRAM or the 
% baseFlowAddress in DRAM which are both 32-bit words.
[a, count] = fread(fid,inf,'uint16');

disp(sprintf('frame size = %d', count));

a4 = a(4);		%a4 is size of valid (I, Q, junk) triplet data in each column or A-line
fn = a(1);		%fn is frame number
nv = a(2);		%nv is number of columns (lateral resolution)
np = a4/3;		%np is number of rows in each column (axial resolution)

% ((a(4)+16)*a(2)+9)*2 is the total byte size of echo frame file

vl = a4+16;		%vl is size of valid triplet data & useless header per column
b  = a(10:size(a));		%b is data without header
b2 = reshape(b(1:vl*nv),vl,nv);		%reshape 1D data into 2D
b3 = b2(17:vl,:);		%remove useless header info
I  = b3(1:3:a4,:);	%first of every three word of b3 is I
Q  = b3(2:3:a4,:);	%second of every three word of b3 is Q

It = I > 2047;			%adjusting signs
It = 4096*It;
I = I-It;

Qt = Q > 2047;
Qt = 4096*Qt;
Q = Q-Qt;

% phi = angle(ce);
% env = abs(ce) = sqrt(I.^2 + Q.^2);

fclose(fid);