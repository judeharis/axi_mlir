import copy


def printn(string):
    print(string, end="")


def bracketed_list(lis):
    printn("(")
    for i, ele in enumerate(lis):
        if i == 0:
            printn(ele + ",")
        elif i == len(lis) - 1:
            printn(ele)
        else:
            printn(ele + ",")
    printn(")")


def sbracketed_list(lis):
    s = "("
    for i, ele in enumerate(lis):
        ele = str(ele)
        if i == 0:
            s += ele + ","
        elif i == len(lis) - 1:
            s += " " + ele
        else:
            s += " " + ele + ","
    s += ")"
    return s


def list_print(lis):
    print(" [")
    for ele in lis:
        print("  " + str(ele) + ",")
    printn(" ]")


class cmap:
    typename = ""
    l1 = []
    l2 = []

    def __init__(self, l1, l2, typename=None):
        self.l1 = l1
        self.l2 = l2
        if typename is not None:
            self.typename = typename + "_"

    def __str__(self):
        s = ""
        s += self.typename + "map<"
        s += sbracketed_list(self.l1)
        s += " -> "
        s += sbracketed_list(self.l2)
        s += ">"
        return s
    
    def __repr__(self):
        return str(self)



class dma:
    addr = 0
    iaddr = 0
    isize = 0
    oaddr = 0
    osize = 0

    # def __init__(self, addr, iaddr, isize, oaddr, osize):
    #     self.addr = addr
    #     self.iaddr = iaddr
    #     self.isize = isize
    #     self.oaddr = oaddr
    #     self.osize = osize

    def __init__(self, config):
        self.addr = config[0]
        self.iaddr = config[1]
        self.isize = config[2]
        self.oaddr = config[3]
        self.osize = config[4]

    def __str__(self):
        s = "dmaAddress = " + str(self.addr) + "\n"
        s += "dmaInputAddress = " + str(self.iaddr) + "\n"
        s += "dmaInputBufferSize = " + str(self.isize) + "\n"
        s += "dmaOutputAddress = " + str(self.oaddr) + "\n"
        s += "dmaOutputBufferSize = " + str(self.osize)
        return s

    # def __str__(self):
    #     s = " {\n"
    #     s += "  dmaAddress = " + str(self.addr) + ",\n"
    #     s += "  dmaInputAddress = " + str(self.iaddr) + ",\n"
    #     s += "  dmaInputBufferSize = " + str(self.isize) + ",\n"
    #     s += "  dmaOutputAddress = " + str(self.oaddr) + ",\n"
    #     s += "  dmaOutputBufferSize = " + str(self.osize) + ",\n"
    #     s += "}"
    #     return s


def atri_print(atri):
    atri_name = list(atri)[0]
    atri_val = atri[list(atri)[0]]
    printn(" " + atri_name + " = ")

    if type(atri_val) is list:
        list_print(atri_val)
    else:
        printn(atri_val)

    print(",")



def trait_print(output_matmul_trait):
    print("#matmul_trait = {")
    for atributes in output_matmul_trait:
        atri_print(atributes)


def atri_cmd_print(atri):
    atri_name = list(atri)[0]
    atri_val = atri[list(atri)[0]]
    ret =""
    if not (atri_name=="dma_init_config"):
        ret+=str(atri_name) + "="
    ret+=str(atri_val) + "\n"
    return ret



def trait_cmd_print(output_matmul_trait):
    ret=""
    for atributes in output_matmul_trait:
        ret += atri_cmd_print(atributes)
    return ret

def listtobracketed(a):
    a = str(a)
    a = a.replace("[", "(")
    a = a.replace("]", ")")
    a = a.replace("'", "")
    return a


def flatten(j, lis):
    if not isinstance(j, list):
        return j
    if len(j) == 0:
        return lis
    for i in j:
        if isinstance(i, list):
            lis = flatten(i, lis)
        else:
            lis.append(i)
    return lis


def expand(root, dele):
    ret = []
    for i in dele:
        k = copy.deepcopy(root)
        k.append(i)
        ret.append(k)
    return ret


def rdcompress(fd, dlist, root):
    root = []
    for i, d in enumerate(dlist):
        dele = fd[d]
        if len(dele) > 1:
            root = expand(root, dele)
        else:
            root.append(dele[0][0])
    return root


def ncompress(fd):
    dlist = list(fd.keys())
    return rdcompress(fd, dlist, [])

def findleastopcodesDF(opcode_flows):
    res = []
    cmin=1000
    for i in opcode_flows:
        if cmin > len(i):
            cmin = len(i)
            res = i
    return res
