# Step 1. Data preprocessing
DATA_DIR=./exp_data/hsk_only_erroneous
mkdir -p $DATA_DIR

TRAIN_SRC_FILE=./dataset-qs/src.txt  # 每行一个病句
TRAIN_TGT_FILE=./dataset-qs/target-gold.txt  # 每行一个正确句子，和病句一一对应
TRAIN_EXL_FILE=./dataset-qs/explanation.txt
TRAIN_NOG_FILE=./dataset-qs/target.txt
TRAIN_TYP_FILE=./dataset-qs/type.txt
if [ ! -f $DATA_DIR"/train.json" ]; then
    python ./utils.py $TRAIN_SRC_FILE $TRAIN_EXL_FILE $TRAIN_TGT_FILE $TRAIN_NOG_FILE $TRAIN_TYP_FILE $DATA_DIR"/train.json"
fi

# Step 2. Training
SEED=2024
PRETRAIN_MODEL=../../mengzi-T5-mt
MODEL_DIR=./exps/hsk-smal-qwen-T5-fewshot-nogold-target-hsk-small-2-type
TASK_NAME=gec
CUDA_DEVICE=2

mkdir -p $MODEL_DIR/$TASK_NAME/run_$SEED/src_bak
cp ./pipeline.sh $MODEL_DIR/$TASK_NAME/run_$SEED/src_bak
cp train.py $MODEL_DIR/$TASK_NAME/run_$SEED/src_bak
cp predict.py $MODEL_DIR/$TASK_NAME/run_$SEED/src_bak

#CUDA_VISIBLE_DEVICES=$CUDA_DEVICE python -u train.py \
#    --do_train \
#    --model_path $PRETRAIN_MODEL \
#    --save_path $MODEL_DIR \
#    --task $TASK_NAME \
#    --data_dir $DATA_DIR \
#    --seed $SEED \

#Step 3. Inference
MODEL_PATH=./exps/hsk-smal-qwen-T5-fewshot-nogold-target-hsk-small-2-type/gec/run_$SEED
RESULT_DIR=$MODEL_PATH/results
mkdir -p $RESULT_DIR
INPUT_FILE=./nacgec_gpt3_turbo_nogold_simple_fin_input.txt # 输入文件（无需分字）
OUTPUT_FILE=$RESULT_DIR"/hsk-smal-nacgec-qwen-T5-fewshot-nogold-target-hsk-small-2-type.output" # 输出文件

echo "Generating..."
SECONDS=0
CUDA_VISIBLE_DEVICES=$CUDA_DEVICE python -u predict.py \
    --model_path $MODEL_PATH \
    --input_path $INPUT_FILE \
    --output_path $OUTPUT_FILE ;

echo "Generating Finish!"
duration=$SECONDS
echo "$(($duration / 60)) minutes and $(($duration % 60)) seconds elapsed."