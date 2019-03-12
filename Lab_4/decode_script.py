
'''
Filename: /Users/DanielTong/Library/Mobile Documents/com~apple~CloudDocs/Study/CPEN311/CPEN311_Lab_Assignment/Lab_4/decode_script.py
Path: /Users/DanielTong/Library/Mobile Documents/com~apple~CloudDocs/Study/CPEN311/CPEN311_Lab_Assignment/Lab_4
Created Date: Monday, March 11th 2019, 3:26:22 pm
Author: DanielTong

'''
def find_secrect_code(i):  
    if (i % 3 == 0):
        result = 0
    elif (i % 3 == 1):
        result = 2
    else :
        result = 73
    
    return result
    
def initilize_memory (memory_list):
    i = 0
    for i in range(256):
        memory_list.append(i)
    print(memory_list)
    return memory_list

def second_for_loop_algorithm (memory_list):
    j = 0
    log_file = open('log.txt', 'a')
    for i in range(256):
        j = ( j + memory_list[i] + find_secrect_code(i)) % 256
        temp = memory_list[i]
        memory_list[i] = memory_list[j] #s[i] = s[j]
        memory_list[j] = temp           #s[j] = s[i]
        
        log_file.write("%s %s\n" %(i, list(map(hex, memory_list))))
        print(memory_list)
    return memory_list


if __name__ == '__main__':
    memory_list = []
    memory_list = initilize_memory(memory_list)
    memory_list = second_for_loop_algorithm(memory_list)
    