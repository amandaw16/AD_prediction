#!/bin/bash

#---------------- Folder Arrangement ------------#
#                  |- train                      #
#         |- Data -|- test                       #
# ~/home -|- Packages                            #
#         |- Output -|- train                    #
#                    |- test                     #
#------------------------------------------------#

root_path='/home/elec5622/AD_prediction'
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
cd $output_path'train/GM/'
subIDs=`ls`

for subID in $subIDs 
do
    echo "Processing training image "$subID
    fileext='.nii.gz'
    file=$subID
    filename="${file%%.*}"

    subGMMask=$train_output_path$filename'_GM.nii.gz'

    echo " >>>> Create measurements for "$filename"  <<<<<<"
    source ${root_path}/code/CreateSeedMask $train_output_path $filename$fileext 
    echo "Seed mask creation completed for "$filename

    seedMask_path=$train_output_path'seedMasks/'
    cd $seedMask_path
    mask_IMGs=`ls | wc -l`  # Counting the number of masks created
    
    echo -n $filename >> ${train_output_path}"AAL_statistics_volume_train.csv"

    for mask_img in $(ls *.nii.gz); 
    do
        echo "Processing mask image: $mask_img"
        # Calculate volume and append to csv file
        volume=$(fslstats $mask_img -V | awk '{print $2}')
        echo -n ",$volume" >> ${train_output_path}"AAL_statistics_volume_train.csv"
    done
    echo "" >> ${train_output_path}"AAL_statistics_volume_train.csv"

    # Remove seed mask directory after processing
    rm -rf $seedMask_path   
    cd $output_path'train/GM/'
done

#----- processing test images
cd $output_path'test/GM/'
subIDs=`ls`

for subID in $subIDs 
do
    echo "Processing test image "$subID
    fileext='.nii.gz'
    file=$subID
    filename="${file%%.*}"

    subGMMask=$test_output_path$filename'_GM.nii.gz'

    echo " >>>> Create measurements for "$filename"  <<<<<<"
    source ${root_path}/code/CreateSeedMask $test_output_path $filename$fileext 
    echo "Seed mask creation completed for "$filename

    seedMask_path=$test_output_path'seedMasks/'
    cd $seedMask_path
    mask_IMGs=`ls | wc -l`  # Counting the number of masks created
    
    echo -n $filename >> ${test_output_path}"AAL_statistics_volume_test.csv"

    for mask_img in $(ls *.nii.gz); 
    do
        echo "Processing mask image: $mask_img"
        # Calculate volume and append to csv file
        volume=$(fslstats $mask_img -V | awk '{print $2}')
        echo -n ",$volume" >> ${test_output_path}"AAL_statistics_volume_test.csv"
    done
    echo "" >> ${test_output_path}"AAL_statistics_volume_test.csv"

    # Remove seed mask directory after processing
    rm -rf $seedMask_path   
    cd $output_path'test/GM/'
done

#==================== End of measurement  =========#

