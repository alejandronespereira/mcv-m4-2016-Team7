% function to compute the multiple gaussian method
% based on work of David Martin Berregon.
%% Use :
%  MultG_fun(.02,4,33,5,2.5,5,'Highway');
%% Input :
% Threshold : Threshold to assign pixels to a Gaussian model 
% Rho : Adaptation constant
% K : Number of Gaussian in the mixture
% THFG : % of weights corresponding to foreground objects
% T1 : Frame in the beginning
% T2 : Endng Frame
% video : 'highway', 'fall' or 'traffic'. The folder corresponding to these
% video have to be in the same folder than this function.

%Output :
%Sequence : the mask you obtain.

% Copyright �  2013  Lesley-Ann DUFLOT
% 
%     This program is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
% 
%     This program is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public License
%     along with this program.  If not, see <http://www.gnu.org/licenses/>.


function [Sequence] = MultG_fun(Threshold,T1,T2,K,Rho,THFG,video)

VideoInFolder = ['input']; 
Fold = ['Dataset/' video];

% Initialization
switch (video)
    case 'Highway'
        a = 1050;
        o = '';
    case 'Fall'
        a = 1460;
        o = '';
    case 'Traffic'
        a = 0950;
        o = '0';
end
    a = a + T1;
    begin=['in00' o num2str(a)];
       
 
    Frame(:,:,1)=rgb2gray(imread(['./' Fold '/' VideoInFolder '/'  begin  '.jpg'])); 
    Frame(:,:,2)=rgb2gray(imread(['./' Fold '/' VideoInFolder '/'  begin  '.jpg'])); 
    Frame(:,:,3)=rgb2gray(imread(['./' Fold '/' VideoInFolder '/'  begin  '.jpg'])); 
    
[H,W,C]=size(Frame);
Frame=double(reshape(Frame,H*W,C));
[ws,sigmas,mus] = StGm( Frame,K,8);   % Initialization process

Sequence=zeros(H,W,T2-T1);

for t=T1:T2
    
  
            
            begin=['in00' o num2str(a)];
            a = a + 1;
    Frame=zeros(H,W,C);
    Frame(:,:,1)=rgb2gray(imread(['./' Fold '/' VideoInFolder '/'  begin  '.jpg'])); 
    Frame(:,:,2)=rgb2gray(imread(['./' Fold '/' VideoInFolder '/'  begin  '.jpg'])); 
    Frame(:,:,3)=rgb2gray(imread(['./' Fold '/' VideoInFolder '/'  begin  '.jpg'])); 
    
    Frame1D=double(reshape(Frame,H*W,3));    
    % Update of mixture model
    [ ws,sigmas,mus,menors ] = StGm(Frame1D,K,8,0.05,Rho,Threshold,sigmas, mus,ws);   
    % Foreground/Background detection
    [ FG ]      = ForeGround(ws,menors,sigmas,K,THFG );                                 
    Tmp         = [repmat(reshape(FG,H,W),[1 1 3])*255 reshape(Frame,H,W,3)];
    imshow(Tmp);
    pause(.5);
    Output(:,:) = Tmp(:,1:W,1);
    
    ind=t-T1+1;
    Sequence(:,:,ind) = Output(:,:);
    
end  