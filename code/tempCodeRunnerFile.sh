#!/bin/bash

#---------------- Folder Arrangement ------------#
#                  |- train                      #
#         |- Data -|- test                       #
# ~/home -|- Packages                            #
#         |- Output -|- train                    #
#                    |- test                     #
#------------------------------------------------#


# root_path='/home/elec5622'
root_path="$HOME/Desktop/Elec5622/Lab/w7/AD_prediction"
data_root=$root_path'/Data/'
package_DIR=$root_path'/Packages/'

output_path=$root_path'/Output/'
train_output_path=$root_path'/Output/train/'
test_output_path=$root_path'/Output/test/'
floImg=$package_DIR'MNI152_T1_1mm_brain.nii'
aalImg=$package_DIR'aal.nii'

#====================  measurement =======================#
echo "=============== begin measurement... ========"

#----- processing training images
cd $data_root'train/'
subIDs=$(ls)

for subID in $subIDs 
do
    echo "Processing training image "$subID
    fileext='.nii.gz'
    file=$subID
    filename="${file%%.*}"
 
    subGMMask=$train_output_path$filename'_GM.nii.gz'

    echo " >>>> Create measurements for "$filename"  <<<<<<"
    source ${root_path}/code/CreateSeedMask.sh $train_output_path 'AAL_to_'$filename$fileext 
    echo "i am done!"
    seedMask_path=$train_output_path'seedMasks/'
    cd $seedMask_path
    mask_IMGs=$(ls)

    echo -n $filename >> ${train_output_path}"AAL_statistics_volumn_train.csv"

    for mask in $mask_IMGs; 
    do
        # Calculate volume using fslstats
        volume=$(fslstats $mask -V | awk '{print $2}')  # Get the volume in cubic mm
        echo -n ",$volume" >> ${train_output_path}"AAL_statistics_volumn_train.csv"
    done