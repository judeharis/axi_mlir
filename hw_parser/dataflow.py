from enum import Enum
import copy


class cmdtype(Enum):
    NULL = 0
    SEND = 1
    COMPUTE = 2
    RECV = 3

    def __str__(self):
        if self == cmdtype.SEND:
            return "SEND"
        if self == cmdtype.COMPUTE:
            return "COMPUTE"
        if self == cmdtype.RECV:
            return "RECV"

        return "NULL"


class cmd:
    cmdtype
    data_id = None

    def __init__(self, data_id, cmdname):
        self.data_id = data_id
        self.cmdtype = cmdname

    def __str__(self):
        s = str(self.cmdtype) + "(" + str(self.data_id) + ")"
        return s

    def __repr__(self):
        return str(self)

    def __eq__(self, other):
        if isinstance(other, cmd):
            return self.cmdtype == other.cmdtype and self.data_id == other.data_id
        return False


class cmdBinNode:
    def __init__(self, cur, remaining):
        self.cur = cur
        if len(remaining) > 0:
            self.left = cmdBinNode(remaining[0], remaining[1:])
            self.right = cmdBinNode(remaining[0], remaining[1:])
        else:
            self.left = None
            self.right = None


def allPaths(node):
    if node:
        if not node.left and not node.right:  # Leaf
            yield [node.cur]
        else:
            yield from ([node.cur] + arr for arr in allPaths(node.left))
            yield from ([node.cur] + [arr] for arr in allPaths(node.right))


def createInputIDMap(acc):
    InputIDMap = {}
    for i, inp in enumerate(acc["input_data"]):
        InputIDMap[i] = inp
    return InputIDMap


def createOutputIDMap(acc):
    OutputIDMap = {}
    for i, inp in enumerate(acc["output_data"]):
        OutputIDMap[i] = inp
    return OutputIDMap


def createIOIDMap(acc):
    DataIDMap = {}
    IDDatamap = {}
    InputIDMap = {}
    for i, inp in enumerate(acc["input_data"]):
        InputIDMap[i] = inp
        DataIDMap[inp] = i
        IDDatamap[i] = inp

    OutputIDMap = {}
    for i, inp in enumerate(acc["output_data"]):
        OutputIDMap[i + len(acc["input_data"])] = inp
        DataIDMap[inp] = i + len(acc["input_data"])
        IDDatamap[i + len(acc["input_data"])] = inp
    return InputIDMap, OutputIDMap, DataIDMap,IDDatamap


def createCMDfromString(cmdstring, cmddata, DataIDMap):
    data_id = DataIDMap[cmddata]
    stringtocmd = {
        "READ": cmdtype.SEND,
        "COMPUTE": cmdtype.COMPUTE,
        "SEND": cmdtype.RECV,
    }
    return cmd(data_id, stringtocmd[cmdstring])


def createShortString(cmdstring, cmddata, DataIDMap):
    stringtocmd = {
        "READ": "s",
        "COMPUTE": "c",
        "SEND": "r",
    }
    return stringtocmd[cmdstring] + str(cmddata)


def createSInstructionList(acc, DataIDMap):
    ins_set_cmd = {}
    ins_set = acc["ISA"]["opcodes"]
    for ins in ins_set:
        insd = ""
        for idx, cmds in enumerate(ins_set[ins]):
            for cmd in cmds:
                insd += createShortString(cmd, cmds[cmd]["data"], DataIDMap)
            if len(ins_set[ins]) != idx + 1:
                insd += "_"
        ins_set_cmd[int(ins)] = insd
    return ins_set_cmd


def varlisttostringcmds(final, lis, sInstructionList):
    for i in final:
        if isinstance(i, list):
            lis.append(varlisttostringcmds(i, [], sInstructionList))
        else:
            lis.append(sInstructionList[i])
    return lis


def createInstructionList(acc, DataIDMap):
    ins_set_cmd = {}
    ins_set = acc["ISA"]["opcodes"]
    for ins in ins_set:
        insd = []
        for cmds in ins_set[ins]:
            for cmd in cmds:
                insd.append(createCMDfromString(cmd, cmds[cmd]["data"], DataIDMap))
        ins_set_cmd[int(ins)] = insd
    return ins_set_cmd


def dataRelatedOpcodes(InstructionList, DataIDMap):
    opcode_per_data = {}
    for data in DataIDMap.keys():
        opcodes = []
        for opcode, ins in InstructionList.items():
            if len(ins) > 0:
                for qcmd in ins:
                    if DataIDMap[data] == qcmd.data_id:
                        opcodes.append(opcode)
                        break
        opcode_per_data[DataIDMap[data]] = opcodes
    return opcode_per_data


def createOrderVariations(cmdlist):
    if len(cmdlist) > 1:
        tree = cmdBinNode(cmdlist[0], cmdlist[1:])
        g = allPaths(tree)
        return list(g)
    else:
        return cmdlist


##########################################
##########################################


def createAllVariations(InputIDMap, OutputIDMap):
    icmdlist = []
    ocmdlist = []
    for inp in InputIDMap:
        icmdlist.append(cmd(inp, cmdtype.SEND))
    for out in OutputIDMap:
        ocmdlist.append(cmd(out, cmdtype.SEND))
        ocmdlist.append(cmd(out, cmdtype.COMPUTE))
        ocmdlist.append(cmd(out, cmdtype.RECV))
    return icmdlist, ocmdlist


def createNoStationary(icmdlist, ocmdlist):
    variationlist = []
    for inc in icmdlist:
        cur_variationlist = [inc]
        remaining_list = icmdlist[:]
        remaining_list.remove(inc)

        for inc2 in remaining_list:
            cur_variationlist.append(inc2)

        for outc in ocmdlist:
            if outc.cmdtype != cmdtype.SEND and outc.cmdtype != cmdtype.RECV:
                cur_variationlist.append(outc)

        for outc in ocmdlist:
            if outc.cmdtype != cmdtype.SEND and outc.cmdtype != cmdtype.COMPUTE:
                cur_variationlist.append(outc)
        variationlist.append(cur_variationlist)

    return variationlist


def createInputStationary(icmdlist, ocmdlist):
    variationlist = []
    for inc in icmdlist:
        cur_variationlist = [inc]
        remaining_list = icmdlist[:]
        remaining_list.remove(inc)

        inner_variationlist = []
        for inc2 in remaining_list:
            inner_variationlist.append(inc2)

        for outc in ocmdlist:
            if outc.cmdtype != cmdtype.SEND and outc.cmdtype != cmdtype.RECV:
                inner_variationlist.append(outc)

        for outc in ocmdlist:
            if outc.cmdtype != cmdtype.SEND and outc.cmdtype != cmdtype.COMPUTE:
                inner_variationlist.append(outc)

        cur_variationlist.append(inner_variationlist)
        variationlist.append(cur_variationlist)

    return variationlist


def createOutputStationary(icmdlist, ocmdlist):
    variationlists = []
    rcmdlist = [ocmd for ocmd in ocmdlist if ocmd.cmdtype == cmdtype.RECV]
    for rcmd in rcmdlist:
        cur_variationlist = []
        remaining_list = icmdlist[:]
        inner_variationlist = []

        # Add input sends
        for inc in remaining_list:
            inner_variationlist.append(inc)

        # Add compute
        for outc in ocmdlist:
            if outc.cmdtype == cmdtype.COMPUTE:
                inner_variationlist.append(outc)

        cur_variationlist.append(inner_variationlist)
        # cur_variationlist.append("+")
        cur_variationlist.append(rcmd)
        variationlists.append(cur_variationlist)
    return variationlists


# def getfirstListID(lis):
#     for idx, i in enumerate(lis):
#         if isinstance(i, list):
#             return idx
#     return len(lis)


def getfirstListID(lis):
    for idx, i in enumerate(lis):
        if isinstance(i, list):
            return idx
    return -1


def checkForNone(lis):
    for i in lis:
        if isinstance(i, list) and checkForNone(i):
            return True
        elif None == i:
            return True
    return False


def insMatchCMDList(cmdlist, ilist):
    if cmdlist == []:
        return [None]
    for code, ins in ilist.items():
        # print("checking:" + str(cmdlist) , "cur: " + str(ins))
        if ins == cmdlist:
            return [code]
    return [None]


# def getCMDList(orderVariation,ilist):
#     if isinstance(orderVariation, list) and(len(orderVariation)>1):
#         cmdsinvarlist = orderVariation[:getfirstListID(orderVariation)]
#         remainingvarlist = orderVariation[getfirstListID(orderVariation):]
#         matched = insMatchCMDList(cmdsinvarlist,ilist)
#         remaining=[]
#         if(len(remainingvarlist)>0):
#             remaining = getCMDList(remainingvarlist,ilist)
#         if len(remaining) > 0:
#             matched.append(remaining)
#         return matched
#     elif isinstance(orderVariation, list) and(len(orderVariation)==1):
#         return getCMDList(orderVariation[0],ilist)
#     else:
#         return insMatchCMDList(orderVariation,ilist)


def getCMDList(orderVariation, ilist):
    if isinstance(orderVariation, list):
        firstlistid = getfirstListID(orderVariation)
        if firstlistid == -1:
            return insMatchCMDList(orderVariation, ilist)
        else:
            cmdsinvarlist = orderVariation[:firstlistid]
            firstlist = orderVariation[firstlistid]
            remainingvarlist = orderVariation[firstlistid + 1 :]
            matched = insMatchCMDList(cmdsinvarlist, ilist)
            matched.append(insMatchCMDList(firstlist, ilist))
            if len(remainingvarlist) > 0:
                matched.append(getCMDList(remainingvarlist, ilist))
            return matched
    else:
        return insMatchCMDList(orderVariation, ilist)


def insMatchVarList(opcodelist, cmdsinvarlist, InstructionList):
    for code, ins in InstructionList.items():
        copcodelist = []
        inslen = len(ins)
        varllen = len(cmdsinvarlist)
        if inslen == 0:
            continue
        if ins == cmdsinvarlist:
            opcodelist.append([code])
            continue
        elif inslen < varllen:
            if ins == cmdsinvarlist[:inslen]:
                copcodelist.append(code)
                copcodelist = insMatchVarList(
                    copcodelist, cmdsinvarlist[inslen:], InstructionList
                )
                opcodelist.append(copcodelist)
    return opcodelist


# def varlistToOpcodes(opcodelist, variationlist, InstructionList, d, fd):
#     if len(variationlist) == 0:
#         return (opcodelist, fd)

#     if isinstance(variationlist[0], list):
#         (nopcodelist, fd) = varlistToOpcodes(
#             [], variationlist[0], InstructionList, d+1, fd)
#         opcodelist.append(nopcodelist)
#         (opcodelist, fd) = varlistToOpcodes(
#             opcodelist, variationlist[1:], InstructionList, d+1, fd)
#     else:
#         cmdsinvarlist = variationlist[:getfirstListID(variationlist)]
#         remainingvarlist = variationlist[getfirstListID(variationlist):]
#         opcodelist = insMatchVarList(
#             opcodelist, cmdsinvarlist, InstructionList)
#         # print(cmdsinvarlist , "opcodelist:" ,opcodelist)
#         fd[d] = copy.deepcopy(opcodelist)
#         (opcodelist, fd) = varlistToOpcodes(
#             opcodelist, remainingvarlist, InstructionList, d+1, fd)
#     return (opcodelist, fd)


def varlistToOpcodes(opcodelist, variationlist, InstructionList, d, fd):
    if len(variationlist) == 0:
        return (opcodelist, fd)

    if isinstance(variationlist[0], list):
        (nopcodelist, fd) = varlistToOpcodes(
            [], variationlist[0], InstructionList, d + 1, fd
        )
        opcodelist.append(nopcodelist)
        (opcodelist, fd) = varlistToOpcodes(
            opcodelist, variationlist[1:], InstructionList, d + 1, fd
        )
    else:
        cmdsinvarlist = variationlist[: getfirstListID(variationlist)]
        remainingvarlist = variationlist[getfirstListID(variationlist) :]
        opcodelist = insMatchVarList(opcodelist, cmdsinvarlist, InstructionList)
        # print(cmdsinvarlist , "opcodelist:" ,opcodelist)
        fd[d] = copy.deepcopy(opcodelist)
        (opcodelist, fd) = varlistToOpcodes(
            opcodelist, remainingvarlist, InstructionList, d + 1, fd
        )
    return (opcodelist, fd)
