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


root_path='/home/elec5622/AD_prediction'
data_root=$root_path'/Data/'
package_DIR=$root_path'/Packages/'

output_path=$root_path'/Output/'
train_output_path=$root_path'/Output/train/'
test_output_path=$root_path'/Output/test/'



#================== Grey matter segmentation ==========#
echo "=============== begin grey matter segmentation...========"

#----- processing training images
cd $output_path'train/'
subIDs=`ls`

for subID in $subIDs 
do

	
	echo "Processing training image "$subID
     	fileext='.nii.gz'
     	file=$subID
    	basename $file $fileext
     	filename="${file%%.*}"

     	#tissue segmentation
     	base=$train_output_path$filename
	
    	
    	# -t type of image n=1 for T1 weighted
    	# -n number of tissue type classes
    	# -o basename for outputs
    	 
     	fast -t 1 -n 3 -o $base $subID
     	# mixel type output from FAST - mixed tissue type proababilities
     	# pve partial volume estimate for 0: CSF, 1:GM, 2:WM
     	# _pveseg segmentation image that combines PVE data into a single segmented image
     	# rename the segmented grey matter image file

     	done


#---- processing test images
cd $output_path'test/'
subIDs=`ls`

for subID in $subIDs 
do
echo "Processing test image "$subID

     	fileext='.nii.gz'
     	file=$subID
     	basename $file $fileext
     	filename=$file
     	filename="${file%%.*}"

     	#tissue segmentation
     	base=$test_output_path$filename
     	fast -t 1 -n 3 -o $base $subID
     	
     	
     	
     	
done


#Please carefully check the segmented grey matter mask visually using fsleyes to ensure the result is correct.#
#============= End of Grey matter segmentation=================#
