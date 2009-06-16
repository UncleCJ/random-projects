rangeMinP = 5
rangeMaxP = 10
samplesPerBucketP = 5
numberOfBucketsP = 100000

resultMean = (rangeMinP + (rangeMaxP - rangeMinP)/2)*samplesPerBucketP
% resultVariance
resultRangeMin = rangeMinP*samplesPerBucketP
resultRangeMax = rangeMaxP*samplesPerBucketP

randomFloats=rand(samplesPerBucketP, numberOfBucketsP);
randoms=floor(rangeMinP+randomFloats*(rangeMaxP-rangeMinP+1));
sampleCollection = sum(randoms,1);

resultCounts = zeros(1, resultRangeMax - resultRangeMin + 1);

currValue = resultRangeMin;
for i = 1:length(resultCounts)
	resultCounts(i) = sum(sampleCollection == currValue);
	currValue += 1;
endfor

resultCounts;

bar(resultRangeMin:resultRangeMax,resultCounts);
xlabel('value');
ylabel('count');
title('distribution of 100000 buckets of 5 samples 5:10')
print -depsc results/normaldistribution1.eps
system ("convert -density 200 results/normaldistribution1.eps results/normaldistribution1.png")
