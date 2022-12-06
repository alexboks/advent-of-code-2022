#%%
with open("inputs\\day5.txt") as f:
    inputs = f.read().splitlines()
# %%
from collections import defaultdict, deque
from typing import Any


def parse_boxes(f: list[str]):
    box_dict: Any = defaultdict(deque)
    box_lines = []
    for ln, l in enumerate(f):
        if l.strip()[0] == "1":
            stop_line = ln
            break
        else:
            box_lines.append(l)
    for b in box_lines:
        for idx, i in enumerate(range(1, 37, 4)):
            if b[i] == " ":
                continue
            else:
                box_dict[idx + 1].append(b[i])
    instructions = f[stop_line + 2 :]
    return box_dict, instructions


box_dict, instructions = parse_boxes(inputs)

#%%


def part_1():
    p1_box = box_dict.copy()
    # p1_box = {1: deque(["N", "Z"]), 2: deque(["D", "C", "M"]), 3: deque(["P"])}
    # instructions = [
    #     "move 1 from 2 to 1",
    #     "move 3 from 1 to 3",
    #     "move 2 from 2 to 1",
    #     "move 1 from 1 to 2",
    # ]
    for instruction in instructions:
        inst_list = instruction.split(" ")
        num_to_move = int(inst_list[1])
        from_ = int(inst_list[3])
        to_ = int(inst_list[5])
        for _ in range(num_to_move):
            p1_box[to_].appendleft(p1_box[from_].popleft())

    return "".join([p1_box[i][0] for i in range(1, 10)])


part_1()
# %%
def part_2():
    p2_box = box_dict.copy()
    for instruction in instructions:
        inst_list = instruction.split(" ")
        num_to_move = int(inst_list[1])
        from_ = int(inst_list[3])
        to_ = int(inst_list[5])
        temp_deque = deque()
        for _ in range(num_to_move):
            temp_deque.append(p2_box[from_].popleft())
        for _ in range(num_to_move):
            p2_box[to_].appendleft(temp_deque.pop())
    return "".join([p2_box[i][0] for i in range(1, 10)])


part_2()
# %%
