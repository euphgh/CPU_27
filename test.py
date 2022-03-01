# import re
# s="""assign pp[0] =  ({34{(code0==3'd0)||(code0==3'd7)}} & 34'b0) |
#                 ({34{(code0==3'd1)||(code0==3'd2)}} & x_plus)|
#                 ({34{(code0==3'd3)}} & x_plus_2)|
#                 ({34{(code0==3'd4)}} & x_minum_2)|
#                 ({34{(code0==3'd5)||(code0==3'd6)}} & x_plus);"""
# f1=re.finditer('(\d+)',s)
# temp = ""
# n = 0
# last = 0
# for x in f1: #x是匹配对象
#     temp = temp + s[last:x.span()[0]] + "{" + "{}".format(n) +"}"
#     last = x.span()[1]
#     n = n + 1
# temp = "print(\"" + temp + s[last:] +"\".format(i,2*i+1,2*i-1))"
# print(temp)
# for i in range(1,17):
#     exec(temp)
for i in range(6):
    s="wire [48:0] pp{0}_4;".format(i)
    print(s)