#!/bin/bash

#---------------- Folder Arrangement -----------------#
#                                                     #
#                                       |- train      #
#         		 	  |- Data|- test       #
# ~/home/elec5622/AD_prediction  |- Packages          #
#         		          |- Output|- train    #
#                                         |- test     #
#                                                     #
#-----------------------------------------------------#      

#define the paths for skull stripping
root_path='/home/elec5622/AD_prediction'
data_root=$root_path'/Data/'
package_DIR=$root_path'/Packages/'

output_path=$root_path'/Output/'
train_output_path=$root_path'/Output/train/'
test_output_path=$root_path'/Output/test/'


#=========  skull stripping ========#
# removing the non brain tissue of brain images
echo "=============== begin skull stripping... ========"
#----- processing training images
cd $data_root'train/'
subIDs=`ls`

for subID in $subIDs 
do
	echo "Processing training image "$subID
     fileext='.nii.gz'
     file=$subID
     basename $file $fileext #does not remove suffix, behave like print
     filename="${file%%.*}" #suffix removed
     #skull stripping
     bet $file $train_output_path/$filename'_brain' -c 117 174 79
     
done

#---- processing test images
cd $data_root'test/'
subIDs=`ls`

for subID in $subIDs 
do
echo "Processing test image "$subID

 	fileext='.nii.gz'
     	file=$subID
     	basename $file $fileext
     	filename="${file%%.*}"
     #skull stripping
     bet $file $test_output_path/$filename'_brain' -c 117 174 79

done

#Please carefully check each extracted brain image visually using fsleyes to ensure the result is correct. If not, please use the strategies taught in Tutorial 1 and Lab 1 to do the adjustment.#
#==================End of Skull Stripping=======================#

