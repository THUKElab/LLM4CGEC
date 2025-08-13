file_path = 'data_underprocess.txt'
sr_file = 'src.txt'
explanation_file = 'explanation.txt'
target_file = 'target.txt'
type_file = 'type.txt'
gold_file = 'target-gold.txt'

import json

# 读取 JSON 文件中的数据
with open('/vepfs/qinshang/z-explanation-result/hsk-small/hsk_small_nogold_qwen_turbo_process_fin.json', 'r') as json_file:
    data = json.load(json_file)

# 写入处理后的数据到文本文件
with open('data_underprocess.txt', 'w') as txt_file:
    for entry in data:
        error_sentence = entry.get('error_sentence')
        description = entry.get('description')
        correct_sentence = entry.get('correct_sentence')
        error_type = entry.get('error_type')
        target_sentence = entry.get('target_sentence')

        if error_sentence and description and correct_sentence and error_type and target_sentence:
            line = f"{error_sentence}\t{description}\t{correct_sentence}\t{error_type}\t{target_sentence}\n"
            txt_file.write(line)

with open(file_path, 'r') as file, \
        open(sr_file, 'w') as sr_output, \
        open(explanation_file, 'w') as explanation_output, \
        open(target_file, 'w') as target_output, \
        open(type_file, 'w') as type_output, \
        open(gold_file, 'w') as gold_output:
    for line in file:
        sentences = line.strip().split('\t')
        if len(sentences) >= 3:
            #print(sentences)
            sr_output.write(sentences[0] + '\n')
            explanation_output.write(sentences[1] + '\n')
            target_output.write(sentences[2] + '\n')
            type_output.write(sentences[3] + '\n')
            gold_output.write(sentences[4] + '\n')
        else:
            print("error")