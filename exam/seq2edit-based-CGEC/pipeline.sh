# Step1. Data Preprocessing

## Download Structbert
if [ ! -f ./plm/chinese-struct-bert-large/pytorch_model.bin ]; then
    wget https://alice-open.oss-cn-zhangjiakou.aliyuncs.com/StructBERT/ch_model
    mv ch_model ./plm/chinese-struct-bert-large/pytorch_model.bin
fi

## Tokenize
SRC_FILE=../../data/train_data/hsk_small_fewshot_qwen_train.src  # 每行一个病句
TGT_FILE=../../data/train_data/hsk_small_fewshot_qwen_train.tgt  # 每行一个正确句子，和病句一一对应
EXP_FILE=../../data/exp_data/hsk_small_fewshot_qwen_train_2.exp
NOG_FILE=../../data/exp_data/hsk_small_fewshot_qwen_train.nog
TYP_FILE=../../data/exp_data/hsk_small_fewshot_qwen_train.typ
#SRC_FILE=../../data/train_data/hsk_small_train.src  # 每行一个病句
#TGT_FILE=../../data/train_data/hsk_small_train.tgt  # 每行一个正确句子，和病句一一对应
#EXP_FILE=../../data/exp_data/hsk_small_train.exp
#NOG_FILE=../../data/exp_data/hsk_small_train.nog
#TYP_FILE=../../data/exp_data/hsk_small_train.typ

if [ ! -f $SRC_FILE".char" ]; then
    python ../../tools/segment/segment_bert.py < $SRC_FILE > $SRC_FILE".char"  # 分字
fi
if [ ! -f $TGT_FILE".char" ]; then
    python ../../tools/segment/segment_bert.py < $TGT_FILE > $TGT_FILE".char"  # 分字
fi
if [ ! -f $EXP_FILE".char" ]; then
    python ../../tools/segment/segment_bert.py < $EXP_FILE > $EXP_FILE".char"  # 分字
fi
if [ ! -f $NOG_FILE".char" ]; then
    python ../../tools/segment/segment_bert.py < $NOG_FILE > $NOG_FILE".char"  # 分字
fi
if [ ! -f $TYP_FILE".char" ]; then
    python ../../tools/segment/segment_bert.py < $TYP_FILE > $TYP_FILE".char"  # 分字
fi

## Generate label file
LABEL_FILE=../../data/train_data/hsk_small_qwen_train.label  # 训练数据
if [ ! -f $LABEL_FILE ]; then
    python ./utils/preprocess_data.py -s $SRC_FILE".char" -t $TGT_FILE".char" -o $LABEL_FILE --worker_num 1
    cp $LABEL_FILE $LABEL_FILE".shuf"
fi

# Step2. Training
CUDA_DEVICE=0
SEED=1

#echo "preprocess------"
#DEV_SET=../../data/valid_data/MuCGEC_CGED_Dev.label
#DEV_SRC=../../data/valid_data/src.txt
#DEV_TGT=../../data/valid_data/tgt.txt
#if [ ! -f $DEV_SRC".char" ]; then
#    python ../../tools/segment/segment_bert.py < $DEV_SRC > $DEV_SRC".char"  # 分字
#fi
#
#if [ ! -f $DEV_SET ]; then
#    python ./utils/preprocess_data.py -s $DEV_SRC".char" -t $DEV_TGT".char" -o $DEV_SET --worker_num 32
#    shuf $DEV_SET > $DEV_SET".shuf"
#fi
#echo "------"

MODEL_DIR=./exps/seq2edit_hsk_small
if [ ! -d $MODEL_DIR ]; then
  mkdir -p $MODEL_DIR
fi

PRETRAIN_WEIGHTS_DIR=./plm/chinese-struct-bert-large

if [ ! -d ${MODEL_DIR}/src_bak ]; then
  mkdir -p ${MODEL_DIR}/src_bak
fi
cp ./pipeline.sh $MODEL_DIR/src_bak
cp -r ./gector $MODEL_DIR/src_bak
cp ./train.py $MODEL_DIR/src_bak
cp ./predict.py $MODEL_DIR/src_bak

VOCAB_PATH=./data/output_vocabulary_chinese_char_hsk+lang8_5
#
## Freeze encoder (Cold Step)
COLD_LR=1e-3
COLD_BATCH_SIZE=128
COLD_MODEL_NAME=Best_Model_Stage_1
COLD_EPOCH=2
echo "freeze train------"
#CUDA_VISIBLE_DEVICES=$CUDA_DEVICE python train.py --tune_bert 0\
#                --train_set $LABEL_FILE".shuf"\
#                --exp_set $EXP_FILE".char"\
#                --nogold_set $NOG_FILE".char"\
#                --error_type_set $TYP_FILE".char"\
#                --model_dir $MODEL_DIR\
#                --model_name $COLD_MODEL_NAME\
#                --vocab_path $VOCAB_PATH\
#                --batch_size $COLD_BATCH_SIZE\
#                --n_epoch $COLD_EPOCH\
#                --lr $COLD_LR\
#                --weights_name $PRETRAIN_WEIGHTS_DIR\
#                --seed $SEED

# Unfreeze encoder
LR=1e-5
BATCH_SIZE=16
ACCUMULATION_SIZE=4
MODEL_NAME=Best_Model_Stage_2
EPOCH=20
PATIENCE=3
echo "unfreeze train------"
#CUDA_VISIBLE_DEVICES=$CUDA_DEVICE python train.py --tune_bert 1\
#                --train_set $LABEL_FILE".shuf"\
#                --exp_set $EXP_FILE".char"\
#                --nogold_set $NOG_FILE".char"\
#                --error_type_set $TYP_FILE".char"\
#                --model_dir $MODEL_DIR\
#                --model_name $MODEL_NAME\
#                --vocab_path $VOCAB_PATH\
#                --batch_size $BATCH_SIZE\
#                --n_epoch $EPOCH\
#                --lr $LR\
#                --accumulation_size $ACCUMULATION_SIZE\
#                --weights_name $PRETRAIN_WEIGHTS_DIR\
#                --pretrain_folder $MODEL_DIR\
#                --pretrain "Temp_Model"\
#                --seed $SEED
#

## Step3. Inference
MODEL_PATH=$MODEL_DIR"/Best_Model_Stage_2.th"
RESULT_DIR=$MODEL_DIR"/results"
#
INPUT_FILE=/data/qins/workspace/rethinking_paper_result/gold/nlpcc_source.txt # 输入文件
EXP_FILE=../../data/test_data/nlpcc_test.exp
NOG_FILE=../../data/test_data/nlpcc_test.nog
TYP_FILE=../../data/test_data/nlpcc_test.typ
if [ ! -f $INPUT_FILE".char" ]; then
    python ../../tools/segment/segment_bert.py < $INPUT_FILE > $INPUT_FILE".char"  # 分字
fi
if [ ! -f $EXP_FILE".char" ]; then
    python ../../tools/segment/segment_bert.py < $EXP_FILE> $EXP_FILE".char"  # 分字
fi
if [ ! -f $NOG_FILE".char" ]; then
    python ../../tools/segment/segment_bert.py < $NOG_FILE> $NOG_FILE".char"  # 分字
fi
if [ ! -f $TYP_FILE".char" ]; then
    python ../../tools/segment/segment_bert.py < $TYP_FILE> $TYP_FILE".char"  # 分字
fi


if [ ! -d $RESULT_DIR ]; then
  mkdir -p $RESULT_DIR
fi
OUTPUT_FILE=$RESULT_DIR"/nlpcc_test.output"

echo "Generating..."
SECONDS=0
CUDA_VISIBLE_DEVICES=$CUDA_DEVICE python predict.py --model_path $MODEL_PATH\
                  --weights_name $PRETRAIN_WEIGHTS_DIR\
                  --vocab_path $VOCAB_PATH\
                  --input_file $INPUT_FILE".char"\
                  --exp_file $EXP_FILE".char"\
                  --nogold_file $NOG_FILE".char"\
                  --type_file $TYP_FILE".char"\
                  --output_file $OUTPUT_FILE --log

echo "Generating Finish!"
duration=$SECONDS
echo "$(($duration / 60)) minutes and $(($duration % 60)) seconds elapsed."