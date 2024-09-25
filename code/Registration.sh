#!/bin/bash

#---------------- Folder Arrangement ------------#
#                  |- train                      #
#         |- Data -|- test                       #
# ~/home -|- Packages                            #
#         |- Output -|- train                    #
#                    |- test                     #
#------------------------------------------------#


root_path='/home/elec5622'
data_root=$root_path'/Data/'
package_DIR=$root_path'/Packages/'

output_path=$root_path'/Output/'
train_output_path=$root_path'/Output/train/data/'
test_output_path=$root_path'/Output/test/data/'
floImg=$package_DIR'MNI152_T1_1mm_brain.nii'
aalImg=$package_DIR'aal.nii'

#====================  registration =======================#
echo "=============== begin registration... ========"

#---- process training images
cd $output_path'train/'
subIDs=`ls`

for subID in $subIDs 
do
   	echo "Processing training image "$subID
     	refImg=$subID

     fileext='.nii.gz'
     file=$subID
     basename $file $fileext
     filename="${file%%.*}"
	#affine registration
     	echo "Register MNI template using affine transform"
     	reg_aladin -ref $file -flo $floImg -res ${filename}_MNI152_T1_native_affine.nii.gz -aff ${filename}_MNI2Native_affine.txt
	#TODO
     #deformable registration
     	echo "Register MNI template using deformable transform"
	#TODO
	reg_f3d -ref $file -flo $floImg -aff ${filename}_MNI2Native_affine.txt -res ${filename}_MNI152_T1_native_warp.nii.gz -cpp ${filename}_warpcoeff.nii.gz
     #transform AAL atlas
    	#TODO
    	reg_resample -ref $file -flo aalImg -res ${filename}_transformed_aal.nii.gz -trans ${filename}_warpcoeff.nii.gz -inter 0 
     #remove files no longer needed
	#TODO
	echo "Removing intermediate files for $filename"
    	rm -f "${filename}_MNI2Native_affine.txt" "${filename}_warpcoeff.nii.gz"
done

#---- process test images
cd $output_path'test/'
subIDs=`ls`

for subID in $subIDs 
do
   	echo "Processing test image "$subID
     	refImg=$subID

     fileext='.nii.gz'
     file=$subID
     basename $file $fileext
     filename=$file
     filename="${file%%.*}"

	#affine registration
     	echo "Register MNI template using affine transform"
     	reg_aladin -ref $file -flo $floImg -res ${filename}_MNI152_T1_native_affine.nii.gz -aff ${filename}_MNI2Native_affine.txt
	#TODO
     #deformable registration
     	echo "Register MNI template using deformable transform"
     	reg_f3d -ref $file -flo $floImg -aff ${filename}_MNI2Native_affine.txt -res ${filename}_MNI152_T1_native_warp.nii.gz -cpp ${filename}_warpcoeff.nii.gz
	#TODO
     #transform AAL atlas
    	#TODO
    	reg_resample -ref $file -flo aalImg -res ${filename}_transformed_aal.nii.gz -trans ${filename}_warpcoeff.nii.gz -inter 0 
     #remove files no longer needed
     #TODO
     	echo "Removing intermediate files for $filename"
    	rm -f "${filename}_MNI2Native_affine.txt" "${filename}_warpcoeff.nii.gz"
done
#==================== End of registration ===============#
