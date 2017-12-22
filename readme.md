1. 下载安装caffe，本文不再描述；
2. 下载vgg data modle for Caffe（http://www.robots.ox.ac.uk/%7Evgg/software/vgg_face/src/vgg_face_caffe.tar.gz）
3. 下载用于微调（Fine Tuning）的Dataset（https://www.cl.cam.ac.uk/research/dtg/attarchive/facedatabase.html），此Dataset需要将灰度图片转成rgb
4. 通过create_att_faces.sh创建数据库文件和均值文件
5. 创建solver.prototxt（以models/finetune_flickr_style/solver.prototxt）	和train_val.prototxt （以vgg_face_caffe/VGG_FACE_deploy.prototxt为模板），本见本仓库文件。
6. ./build/tools/caffe train -solver path/2/solver.prototxt -weights path/2/VGG_FACE.caffemodel #-gpu 0
7. 经过近10h的训练，得到如下结果：
	I1222 04:02:16.620232  4708 data_layer.cpp:73] Restarting data prefetching from start.
	I1222 04:02:47.203390  4703 solver.cpp:397]     Test net output #0: accuracy = 0.99
	I1222 04:02:47.203533  4703 solver.cpp:397]     Test net output #1: loss = 3.71212 (* 1 = 3.71212 loss)
	I1222 04:02:47.203552  4703 solver.cpp:315] Optimization Done.
	I1222 04:02:47.203562  4703 caffe.cpp:259] Optimization Done.

