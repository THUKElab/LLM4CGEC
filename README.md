# LLM4CGEC: Rethinking the Roles of Large Language Models in Chinese Grammatical Error Correction

-----

The repository contains the codes and data for our ACL 2025 Industry Track paper: [Rethinking the Roles of Large Language Models in Chinese Grammatical Error Correction](https://aclanthology.org/2025.acl-industry.39)

This paper proposes **EXAM** (EXplanation-AugMented training) and **SEE** (SEmantic-incorporated Evaluation) frameworks to better leverage LLMs in the CGEC task, enhancing small models through explanation-augmented training and enabling semantic-aware evaluation.

## Features

* We introduce EXAM to extract error types, references, and explanations from LLMs to enhance small CGEC models.
* We propose SEE to utilize LLMs as evaluators for more flexible and human-aligned CGEC evaluation.
* Our framework is model-agnostic and works with both Seq2Seq and Seq2Edit architectures.

## Requirements and Installation
Python version >= 3.10

```bash
git clone https://github.com/THUKElab/LLM4CGEC.git
cd LLM4CGEC

# Seq2Edit environment
conda create -n llm4cgec-seq2edit python=3.10.14
conda activate llm4cgec-seq2edit
pip install -r requirements_seq2edit.txt

# Seq2Seq environment
conda create -n llm4cgec-seq2seq python=3.10.14
conda activate llm4cgec-seq2seq
pip install -r requirements_seq2seq.txt
```

## Usage

----
```perl
LLM4CGEC
├── exam/
│   ├── seq2edit-based-CGEC/   # Seq2Edit CGEC models (GECToR)
│   └── seq2seq-based-CGEC/    # Seq2Seq CGEC models (BART, mT5)
├── scorers/                   # ChERRANT evaluation toolkit
├── tools/                     # Data preprocessing and segmentation
├── see/                     	 # LLMs as evaluators

```

## Citation

```bibtex
@inproceedings{li2025rethinking,
  title={Rethinking the Roles of Large Language Models in Chinese Grammatical Error Correction},
  author={Li, Yinghui and Qin, Shang and Ye, Jingheng and Huang, Haojing and Li, Yangning and Guo, Shu-Yu and Qin, Libo and Hu, Xuming and Jiang, Wenhao and Zheng, Hai-Tao and Yu, Philip S.},
  booktitle={Proceedings of the 63rd Annual Meeting of the Association for Computational Linguistics (Volume 6: Industry Track)},
  year={2025},
  pages={553--567}
}

```

