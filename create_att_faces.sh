#!/usr/bin/env sh
# Create the imagenet lmdb inputs
# N.B. set the path to the imagenet train + val data dirs

EXAMPLE=examples/att_faces
DATA=data/att_faces
TOOLS=build/tools
DBTYPE=lmdb
TRAIN_DATA_ROOT=$DATA/train/
TEST_DATA_ROOT=$DATA/tst/
ROOT=./
# Set RESIZE=true to resize the images to 256x256. Leave as false if images have
# already been resized using another tool.
RESIZE=true
if $RESIZE; then
  RESIZE_HEIGHT=224
  RESIZE_WIDTH=224
else
  RESIZE_HEIGHT=0
  RESIZE_WIDTH=0
fi

if [ ! -d "$TRAIN_DATA_ROOT" ]; then
  echo "Error: TRAIN_DATA_ROOT is not a path to a directory: $TRAIN_DATA_ROOT"
  echo "Set the TRAIN_DATA_ROOT variable in create_att_faces.sh to the path" \
       "where the ImageNet training data is stored."
  exit 1
fi

if [ ! -d "$TEST_DATA_ROOT" ]; then
  echo "Error: TEST_DATA_ROOT is not a path to a directory: $TEST_DATA_ROOT"
  echo "Set the TEST_DATA_ROOT variable in create_att_faces.sh to the path" \
       "where the ImageNet test data is stored."
  exit 1
fi

echo "Creating train lmdb..."
rm -rf $EXAMPLE/att_faces_train_$DBTYPE $EXAMPLE/att_faces_tst_$DBTYPE

GLOG_logtostderr=1 $TOOLS/convert_imageset \
    --resize_height=$RESIZE_HEIGHT \
    --resize_width=$RESIZE_WIDTH \
    --shuffle \
    $TRAIN_DATA_ROOT \
    $DATA/train.txt \
    $EXAMPLE/att_faces_train_$DBTYPE

echo "Creating tst lmdb..."
rm -f $EXAMPLE/mean.binaryproto
GLOG_logtostderr=1 $TOOLS/convert_imageset \
    --resize_height=$RESIZE_HEIGHT \
    --resize_width=$RESIZE_WIDTH \
    --shuffle \
    $TEST_DATA_ROOT \
    $DATA/tst.txt \
    $EXAMPLE/att_faces_tst_$DBTYPE
echo "Computing image mean..."
./build/tools/compute_image_mean -backend=$DBTYPE $EXAMPLE/att_faces_train_$DBTYPE $EXAMPLE/mean.binaryproto
echo "Done."
