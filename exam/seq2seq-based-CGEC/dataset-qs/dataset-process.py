import random

file_path = 'hsk_small_input.txt'
sr_file = 'src_some.txt'
target_file = 'target_some.txt'

# 读取 same_sent.txt 文件的内容
with open('../../../prompt_project_hsk_small/hsk_preprocess/same_sent.txt', 'r', encoding='utf-8') as same_sent_file:
    same_sent_lines = same_sent_file.readlines()

# 读取 hsk_small_input.txt 文件的内容
with open('hsk_small_input.txt', 'r', encoding='utf-8') as input_file:
    input_lines = input_file.readlines()

# 计算每个文件的行数和要插入的行数
same_sent_count = len(same_sent_lines)
input_count = len(input_lines)
total_count = same_sent_count + input_count

# 计算每个插入点的间隔
interval = input_count // same_sent_count
print("interval: ",interval)

# 计算每个插入点的偏移量
offsets = [i * interval for i in range(same_sent_count)]

# 执行插入操作
output_lines = []
same_sent_index = 0
input_index = 0
offset_index = 0
while same_sent_index < same_sent_count and input_index < input_count:
    if input_index == offsets[offset_index]:
        output_lines.append(same_sent_lines[same_sent_index])
        same_sent_index += 1
        offset_index += 1
    output_lines.append(input_lines[input_index])
    input_index += 1

# 将剩余的句子插入结果
output_lines.extend(same_sent_lines[same_sent_index:])
output_lines.extend(input_lines[input_index:])

for i in range(len(output_lines)):
    if not output_lines[i].endswith('\n'):
        output_lines[i] += '\n'

# 将结果写入 hsk_small_input_all.txt 文件
with open('hsk_small_input_all.txt', 'w', encoding='utf-8') as output_file:
    output_file.writelines(output_lines)

print("Sentences inserted and saved in hsk_small_input_all.txt.")    
with open('hsk_small_input_all.txt', 'r', encoding='utf-8') as same_sent_file:
    same_sent_lines = same_sent_file.readlines()
    print(len(same_sent_lines))

print("Sentences inserted and saved.")


with open(file_path, 'r') as file, \
        open(sr_file, 'w') as sr_output, \
        open(target_file, 'w') as target_output:
    for line in file:
        sentences = line.strip().split('\t')
        if len(sentences) >= 2:
            sr_output.write(sentences[0] + '\n')
            target_output.write(sentences[1] + '\n')
        else:
            print("error")