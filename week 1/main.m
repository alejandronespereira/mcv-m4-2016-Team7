%This script execute the mandatory tasks regarding to segmentation metrics.
%To switch between A and B database make use of db parameter.

%Variables
FN = 0; TN = FN; FP = TN; TP = FP; Precision = TP ;Recall = Precision; F1 = Recall;

%Select the dataset to be analazyed (A or B)
db = 'A';
dbPath = strcat('Dataset/Dataset1/',db,'/');
%Extra 1 parameters
extra1 = true;
delayv = [4,10,25];
F1_delay = zeros(3,200);
%Calculate the number of files in the folder
imagefiles = dir(dbPath); 
resultList = deleteHiddenFiles(imagefiles);
gtfiles = deleteHiddenFiles(dir('Groundtruth/')); 
nfiles = length(resultList);

for ii=1:nfiles
   
    %Read image 
    currentfilename = resultList(ii).name;
    currentimage = imread(strcat(dbPath,currentfilename));
    
    %Read ground truth
    st = strsplit(currentfilename,'_');
    name = char(st{3});
    gtPath = strcat('Groundtruth/gt',name);
    ground = imread(gtPath);

    %Extra1
    if(extra1)
        for i = 1:3
            ground_delay = imread(strcat('Groundtruth/',gtfiles(ii+delayv(i)).name));
            [pixelTP, pixelFP, pixelFN, pixelTN] = PixelEvaluation(ground_delay,ground);
            recision = pixelTP / (pixelTP+pixelFP);
            Recall = pixelTP / (pixelTP+pixelFN);
            F1_delay(i,ii) = (2*Precision*Recall) / (Precision + Recall);
        end
    end

    %Select the object of the groundtruth
    ground = ground == 255;
    
    %Pixel evaluation of the current image
    [pixelTP, pixelFP, pixelFN, pixelTN] = PixelEvaluation(currentimage,ground);
    
    TP = TP + pixelTP;
    FP = FP + pixelFP;
    FN = FN + pixelFN;
    TN = TN + pixelTN;

    %Get plotting parameters 
    Precision = pixelTP / (pixelTP+pixelFP);
    Recall = pixelTP / (pixelTP+pixelFN);
    F1(ii) = (2*Precision*Recall) / (Precision + Recall);
    TPandFreground(ii) = pixelTP;
end
%Plot F1vsFrame
plotF1vsFrame(F1);

%Plot TPvsFrame
plotTpvsFrame(TPandFreground);

%Plot Delay
if(extra1)
    plotDelay(F1,F1_delay(1),F1_delay(2),F1_delay(3));
end

%Compute metrics
[Precision,Recall,F1] = computeMetrics(TP,FP,FN);

